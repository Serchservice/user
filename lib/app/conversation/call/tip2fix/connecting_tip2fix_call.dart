import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ConnectingTip2FixCall extends StatelessWidget {
  final ActiveCallResponse call;
  const ConnectingTip2FixCall({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      shouldOverride: true,
      backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
      child: Center(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  LinearProgressIndicator(color: Theme.of(context).primaryColor),
                  const SizedBox(height: 20),
                  SText(
                    text: "Wait a moment while we connect your call...",
                    size: Sizing.font(15),
                    color: CommonColors.hint,
                  ),
                  const SizedBox(height: 50),
                  Stack(
                    children: [
                      Avatar(radius: 70, avatar: call.avatar),
                      Positioned(
                          right: 5,
                          bottom: 0,
                          child: Avatar(radius: 13, avatar: call.image)
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SText(
                    text: "Tip2Fix with ${call.name}",
                    size: Sizing.font(18),
                    color: Theme.of(context).primaryColor,
                  ),
                  SText(
                    text: call.category,
                    size: Sizing.font(14),
                    color: Theme.of(context).primaryColorLight,
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              right: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: 230,
                  width: 160,
                  padding: EdgeInsets.all(Sizing.space(16)),
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  child: Column(
                    children: [
                      Avatar(radius: 70, avatar: Database.auth.avatar),
                      const Expanded(child: SizedBox(height: 20)),
                      SText.center(
                        text: Database.auth.name,
                        size: Sizing.font(14),
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}