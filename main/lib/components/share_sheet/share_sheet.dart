import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ShareSheet extends StatelessWidget {
  const ShareSheet({
    super.key,
    required this.link,
    required this.caption,
    this.code = ""
  });

  final String link;
  final String code;
  final String caption;

  static void open({required String link, String code = "", required String caption}) {
    Get.bottomSheet(
      ShareSheet(link: link, caption: caption, code: code),
      backgroundColor: Colors.transparent,
      settings: const RouteSettings(name: "/share")
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 7,
            margin: EdgeInsets.only(top: Sizing.space(10)),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10)
            )
          ),
          SizedBox(
            height: 180,
            child: GridView.builder(
              itemCount: ShareSheetButton.options.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.2
              ),
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final share = ShareSheetButton.options[index];
                final String data = link.isNotEmpty ? link : code;

                return ShareSheetButton(share: share, message: "$caption\n\n$link", data: data);
              }
            ),
          ),
        ],
      ),
    );
  }
}