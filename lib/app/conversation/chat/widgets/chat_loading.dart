import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ChatLoading extends StatelessWidget {
  const ChatLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        titleSpacing: 3,
        title: LoadingShimmer(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: CommonColors.shimmerHigh
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: CommonColors.shimmerHigh
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: CommonColors.shimmerHigh
                      ),
                    ),
                  ]
                )
              )
            ]
          ),
        ),
        actions: [
          const SizedBox(width: 20),
          LoadingShimmer(
            content: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CommonColors.shimmerHigh
              ),
            ),
          ),
          const SizedBox(width: 3),
          LoadingShimmer(
            content: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CommonColors.shimmerHigh
              ),
            ),
          ),
          const SizedBox(width: 3),
          LoadingShimmer(
            content: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CommonColors.shimmerHigh
              ),
            ),
          ),
          const SizedBox(width: 3),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildBubble(
                  context: context,
                  isNotUser: index == 2 || index == 4 || index == 6
                );
              }
            )
          ),
          LoadingShimmer(
            content: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: CommonColors.shimmerHigh
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: CommonColors.shimmerHigh
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBubble({required BuildContext context, required bool isNotUser}) {
    return LoadingShimmer(
      content: Bubble(
        color: isNotUser
          ? CommonColors.darkTheme2
          : CommonColors.hint,
        nip: isNotUser
          ? BubbleNip.leftTop
          : BubbleNip.rightTop,
        margin: isNotUser
          ? const BubbleEdges.only(left: 10, bottom: 6)
          : const BubbleEdges.only(right: 7, bottom: 6),
        radius: const Radius.circular(10),
        alignment: isNotUser
          ? Alignment.topLeft
          : Alignment.topRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.7,
          ),
          child: SizedBox(
            height: 70,
            width: MediaQuery.sizeOf(context).width * 0.7,
          )
        )
      ),
    );
  }
}