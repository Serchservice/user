import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user/library.dart';

class OnboardingDesign1 extends StatefulWidget {
  final PageController onboardPageController;
  final Duration moveDuration;
  final Curve moveCurve;

  const OnboardingDesign1({
    super.key,
    required this.onboardPageController,
    required this.moveDuration,
    required this.moveCurve,
  });

  @override
  State<OnboardingDesign1> createState() => _OnboardingDesign1State();
}

class _OnboardingDesign1State extends State<OnboardingDesign1> {
  final String _targetText = "Request, Repair, Enjoy";
  String _displayedText = '';
  bool _showCursor = true;

  @override
  void initState() {
    super.initState();
    _startTypewriterAnimation();
    _startCursorAnimation();
  }

  void _startTypewriterAnimation() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (_displayedText.length < _targetText.length) {
        if(mounted) {
          setState(() {
            _displayedText = _targetText.substring(0, _displayedText.length + 1);
          });
        }
        _startTypewriterAnimation();
      } else {
        try {
          Future.delayed(const Duration(milliseconds: 2000), () {
            widget.onboardPageController.animateToPage(
              1,
              duration: widget.moveDuration,
              curve: widget.moveCurve
            );
          });
        } catch (e) {
          //
        }
      }
    });
  }

  void _startCursorAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if(mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
      }
      _startCursorAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = 28;
    Color color = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LineHeader(
          header: "You want it? We have it!",
          footer: "Don't stress, you can do it all with Serch"
        ),
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              Image.asset(
                Media.onboard1,
                width: MediaQuery.sizeOf(context).width,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SText(
                    text: _displayedText,
                    size: size,
                    color: color
                  ),
                  if (_showCursor)
                  SText(
                    text: "|",
                    size: size,
                    color: color
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}