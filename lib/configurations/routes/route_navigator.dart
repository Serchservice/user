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

  static void openChat({String roommate = "", bool removeRoute = false, ChatRoom? room}) {
    if(removeRoute) {
      Navigate.offTill(
          ChatLayout.route,
          ModalRoute.withName(HomeLayout.route),
          parameters: {"roommate": roommate}
      );
    } else if(room != null) {
      Navigate.to(
          ChatLayout.route,
          parameters: {"roommate": room.roommate, "room": room.room},
          arguments: {"room": room.toJson()}
      );
    } else {
      Navigate.to(
        ChatLayout.route,
        parameters: {"roommate": roommate}
      );
    }
  }

  static void openRequestAction({SerchCategory? category, required SerchCategory request}) {
    Navigate.to(
      RequestActionLayout.route,
      parameters: {"type": request.type, "category": request.category,},
      arguments: {"category": category?.toJson(), "request": request.toJson()}
    );
  }
  
  static void makeCall({
    bool removeCurrentRoute = true,
    required String name,
    required String avatar,
    required String user,
    required CallType type
  }) {
    ActiveCallResponse call = ActiveCallResponse.call(name: name, avatar: avatar, user: user, type: type);
    if(removeCurrentRoute) {
      Navigate.offTill(
        CallLayout.route,
        ModalRoute.withName(HomeLayout.route),
        parameters: {"user": user, "type": type.type},
        arguments: {"call": call.toJson(), "start": true, "answer": false}
      );
    } else {
      Navigate.to(
        CallLayout.route,
        parameters: {"user": user, "type": type.type},
        arguments: {"call": call.toJson(), "start": true, "answer": false}
      );
    }
  }

  static void answerCall({bool removeCurrentRoute = true, required ActiveCallResponse call}) {
    if(removeCurrentRoute) {
      Navigate.offTill(
        CallLayout.route,
        ModalRoute.withName(HomeLayout.route),
        parameters: {"user": call.user, "type": call.type.type},
        arguments: {"call": call.toJson(), "start": false, "answer": true}
      );
    } else {
      Navigate.to(
        CallLayout.route,
        parameters: {"user": call.user, "type": call.type.type},
        arguments: {"call": call.toJson(), "start": false, "answer": true}
      );
    }
  }

  static void goToCall({bool removeCurrentRoute = true, required ActiveCallResponse call}) {
    if(removeCurrentRoute) {
      Navigate.offTill(
        CallLayout.route,
        ModalRoute.withName(HomeLayout.route),
        parameters: {"user": call.user, "type": call.type.type},
        arguments: {"call": call.toJson(), "start": false, "answer": false}
      );
    } else {
      Navigate.to(
        CallLayout.route,
        parameters: {"user": call.user, "type": call.type.type},
        arguments: {"call": call.toJson(), "start": false, "answer": false}
      );
    }
  }
}