import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter/webview_flutter.dart';
import 'package:user/library.dart';

class WebController extends GetxController {
  WebController();
  final state = WebState();

  final _params = Get.arguments;
  final _param = Get.parameters;

  late final WebViewController controller;

  @override
  void onInit() {
    if(_params != null && _params[0] != null && _params[0] is Uri) {
      // final header = Uri()
    }

    state.response.value = _param["reference"] ?? "";
    state.route.value = _param["url"] ?? "";
    state.header.value = _param["header"] ?? "";

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            state.loadingPercentage.value = progress;
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            state.errorMessage.value = error.description;
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(state.route.value.isEmpty ? "https://serchservice.com" : state.route.value));
    super.onInit();
  }
}