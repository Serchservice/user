import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/library.dart';

class RouteNavigator {
  static Future<void> callNumber(String phoneNumber) async {
    await launchUrl(Uri(scheme: 'tel', path: phoneNumber));
  }

  static Future<void> openLink({Uri? uri, String? url}) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      uri ?? Uri.parse(url!),
      mode: LaunchMode.externalNonBrowserApplication
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(uri ?? Uri.parse(url!), mode: LaunchMode.inAppWebView,);
    }
  }

  static Future<void> mail(String mailAddress) async {
    await launchUrl(Uri(scheme: "mailto", path: mailAddress));
  }

  static Future<T?>? openWeb<T>({
    required String header,
    required String url,
    Map<String, String>? params,
    Object? arguments
  }) async {
    Map<String, String> parameters = {
      "header": header,
      "url": url,
    };
    if(params != null && params.isNotEmpty) {
      params.forEach((key, value) {
        parameters.putIfAbsent(key, () => value);
      });
    }

    return Navigate.to(
      WebLayout.route,
      parameters: parameters,
      arguments: arguments
    );
  }

  /// For Gallery Parameter: {"isVideo": "false", "title": "Pick Your Avatar", "isChat": "false", "receiver": "12345"}
  /// For Camera Parameters: {"mode": "chat", "to": "Frank", "to_id": "1234", "callback_url": "/home"}
  static void openMedia({
    required Function(SelectedMedia) onReceived,
    required String route,
    Map<String, String>? galleryParam,
    Map<String, String>? cameraParam
  }) {
    List<ButtonView> options = [
      ButtonView(
        icon: Icons.photo_library_rounded,
        header: "Gallery",
        index: 0
      ),
      ButtonView(
        index: 1,
        icon: Icons.photo_camera_back_rounded,
        header: "Camera"
      )
    ];
    Navigate.bottomSheet(
      sheet: CurvedBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options.map((option) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: NavigatorButton(
                header: option.header,
                prefixIcon: option.icon,
                onPressed: () async {
                  SelectedMedia result;
                  if(option.index == 0) {
                    result = await Navigate.to(GalleryLayout.route, parameters: galleryParam);
                  } else {
                    result = await Navigate.to(CameraLayout.route, parameters: cameraParam);
                  }
                  onReceived.call(result);
                  return;
                }
              ),
            );
          }).toList(),
        )
      ),
      route: route
    );
  }

  /// TODO:: Add call and chat router
}