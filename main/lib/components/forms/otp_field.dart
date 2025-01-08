import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function(String) onCompleted;
  final bool isBox;
  final bool isFilled;
  final int length;

  const OtpField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onCompleted,
    required this.onChanged,
    this.isBox = true,
    this.length = 6,
    this.isFilled = false
  });

  static double height = 45;
  static double width = 60;
  static double fontSize = 20;

  @override
  Widget build(BuildContext context) {
    if(isFilled) {
      return _buildFilled(context);
    } else if(isBox) {
      return _buildBox(context);
    } else {
      return _buildBottom(context);
    }
  }

  Widget _buildBox(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: width,
      height: height,
      textStyle: TextStyle(fontSize: fontSize, color: Theme.of(context).primaryColor),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).primaryColor)
      ),
    );

    return Pinput(
      length: length,
      controller: controller,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      showCursor: true,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Theme.of(context).primaryColor, width: 2)
        ),
      ),
      onCompleted: (code) => onCompleted.call(code),
      onClipboardFound: (code) => onCompleted.call(code),
      onSubmitted: (code) => onCompleted.call(code),
      onChanged: (code) => onChanged.call(code),
    );
  }

  Widget _buildFilled(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: width,
      height: height,
      textStyle: TextStyle(fontSize: fontSize, color: Theme.of(context).primaryColor),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface
      ),
    );

    return Pinput(
      length: length,
      controller: controller,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      showCursor: true,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: Theme.of(context).primaryColor, width: 2)
        ),
      ),
      onCompleted: (code) => onCompleted.call(code),
      onClipboardFound: (code) => onCompleted.call(code),
      onSubmitted: (code) => onCompleted.call(code),
      onChanged: (code) => onChanged.call(code),
    );
  }

  Widget _buildBottom(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: width,
      height: height,
      textStyle: TextStyle(fontSize: fontSize, color: Theme.of(context).primaryColor),
      decoration: const BoxDecoration(),
    );

    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );

    return Pinput(
      length: length,
      pinAnimationType: PinAnimationType.slide,
      controller: controller,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      showCursor: true,
      cursor: cursor,
      preFilledWidget: preFilledWidget,
      onCompleted: (code) => onCompleted.call(code),
      onClipboardFound: (code) => onCompleted.call(code),
      onSubmitted: (code) => onCompleted.call(code),
      onChanged: (code) => onChanged.call(code),
    );
  }
}
