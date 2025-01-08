import 'package:user/library.dart';
import 'package:flutter/material.dart';

class MultiFactorCodeView extends StatelessWidget {
  const MultiFactorCodeView({
    super.key,
    required this.controller,
  });

  final MultiFactorController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizing.space(16)),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(24)
      ),
      child: Column(
        children: [
          SText(
            text: "Tap on a code to copy",
            color: Theme.of(context).primaryColorLight,
            size: Sizing.font(12),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisExtent: 40,
              mainAxisSpacing: 10
            ),
            shrinkWrap: true,
            itemCount: controller.state.codes.length,
            itemBuilder: (context, index) {
              final code = controller.state.codes[index];
              return MultiFactorCodeItem(code: code);
            },
          ),
        ],
      ),
    );
  }
}