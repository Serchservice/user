import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ChatRoomLoading extends StatelessWidget {
  const ChatRoomLoading({super.key});

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
                decoration: const BoxDecoration(shape: BoxShape.circle, color: CommonColors.shimmerHigh),
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
              decoration: const BoxDecoration(shape: BoxShape.circle, color: CommonColors.shimmerHigh),
            ),
          ),
          const SizedBox(width: 3),
          LoadingShimmer(
            content: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: CommonColors.shimmerHigh),
            ),
          ),
          const SizedBox(width: 3),
          LoadingShimmer(
            content: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: CommonColors.shimmerHigh),
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
                return ChatRoomLoadingMessageCard(isNotUser: index == 2 || index == 4 || index == 6);
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
}