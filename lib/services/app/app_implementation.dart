import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class AppImplementation implements AppService {
  final AppLinks _appLinks = AppLinks();

  final ExceptionService _exceptionService = ExceptionImplementation();
  final Connect _connect = Connect(useToken: false);

  Future<String> get ipAddress async {
    var networks = await NetworkInterface.list();
    if(networks.isNotEmpty) {
      var addresses = networks.first.addresses;
      if(addresses.isNotEmpty) {
        return addresses.first.address;
      }
    }
    return "";
  }

  @override
  void buildDeviceInformation({required Function(Device device) onSuccess}) async {
    DeviceInfoPlugin info = DeviceInfoPlugin();
    String ip = await ipAddress;
    Device device = Device.empty();
    device = device.copyWith(ipAddress: ip);

    if(Platform.isAndroid) {
      AndroidDeviceInfo android = await info.androidInfo;
      device = device.copyWith(
        sdk: android.version.sdkInt,
        id: android.id,
        name: android.model,
        host: android.host,
        platform: "Android"
      );
      onSuccess.call(device);
    } else if (Platform.isIOS) {
      IosDeviceInfo ios = await info.iosInfo;
      device = device.copyWith(
        id: ios.identifierForVendor,
        name: ios.utsname.machine,
        host: ios.utsname.nodename,
        platform: "iOS"
      );
      onSuccess.call(device);
    } else if(kIsWeb) {
      WebBrowserInfo web = await info.webBrowserInfo;
      device = device.copyWith(
        id: web.userAgent,
        name: web.browserName.name,
        host: web.appCodeName,
        platform: "Web"
      );
      onSuccess.call(device);
    } else if(Platform.isLinux) {
      LinuxDeviceInfo linux = await info.linuxInfo;
      device = device.copyWith(
        id: linux.id,
        name: linux.prettyName,
        host: linux.versionCodename,
        platform: "Linux"
      );
      onSuccess.call(device);
    } else if(Platform.isMacOS) {
      MacOsDeviceInfo macOs = await info.macOsInfo;
      device = device.copyWith(
        id: macOs.kernelVersion,
        name: macOs.model,
        host: macOs.hostName,
        platform: "MacOs"
      );
      onSuccess.call(device);
    } else if(Platform.isWindows) {
      WindowsDeviceInfo windows = await info.windowsInfo;
      device = device.copyWith(
        id: windows.deviceId,
        name: windows.productName,
        host: windows.computerName,
        platform: "Windows"
      );
      onSuccess.call(device);
    } else {
      throw SerchException("Platform not supported", isPlatformNotSupported: true);
    }
  }

  @override
  Future<StreamSubscription<Uri>> initializeDeepLink() async {
    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      Logger.log('getInitialAppLink: $appLink');
      openAppLink(appLink);
    }

    StreamSubscription<Uri> subscription = _appLinks.uriLinkStream.listen((uri) {
      Logger.log('onAppLink: $uri');
      openAppLink(uri);
    });
    return subscription;
  }

  @override
  void openAppLink(Uri uri) {
    Logger.log(uri.fragment);
  }

  @override
  void start() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Database.initialize();
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [
        SystemUiOverlay.bottom,
        SystemUiOverlay.top,
      ]
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
    _exceptionService.handleException();
    Get.updateLocale(const Locale('en'));
  }

  Future<List<Country>> countries() async {
    try {
      String json = await rootBundle.loadString('asset/common/countries.json');
      List<dynamic> data = jsonDecode(json);
      return data.map((country) => Country.fromJson(country)).toList();
    } on Exception catch (_) {
      return <Country>[];
    }
  }

  @override
  void getCountries({required Function(List<Country> countries) onSuccess}) async {
    try {
      var response = await _connect.get(endpoint: "/country/countries");
      ApiResponse res = ApiResponse.fromJson(response.data);
      List<dynamic> result = res.data;
      if(result.isNotEmpty) {
        List<Country> countries = result.map((e) => Country.fromJson(e)).toList();
        onSuccess.call(countries);
      } else {
        List<Country> countryList = await countries();
        onSuccess.call(countryList);
      }
    } on Exception catch (_) {
      List<Country> countryList = await countries();
      onSuccess.call(countryList);
    }
  }
}