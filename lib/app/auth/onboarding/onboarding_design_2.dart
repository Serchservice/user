import 'package:flutter/material.dart';
import 'package:user/library.dart';

class OnboardingDesign2 extends StatefulWidget {
  final PageController onboardPageController;
  final Duration moveDuration;
  final Curve moveCurve;

  const OnboardingDesign2({
    super.key,
    required this.onboardPageController,
    required this.moveDuration,
    required this.moveCurve
  });

  @override
  State<OnboardingDesign2> createState() => _OnboardingDesign2State();
}

class _OnboardingDesign2State extends State<OnboardingDesign2> {
  final List<String> words = [
    "Share Provider",
    "Recommend",
    "Be secured",
    "Enjoy comfort",
    "Chat",
    "Tip2Fix",
    "Video call",
    "Bookmark your favorite"
  ];

  int currentWordIndex = 0;

  @override
  void initState() {
    super.initState();

    if(mounted) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    if(currentWordIndex < words.length - 1) {
      Future.delayed(const Duration(seconds: 2), () {
        if(mounted) {
          setState(() {
            currentWordIndex = (currentWordIndex + 1) % words.length;
            _startAnimation();
          });
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        if(mounted) {
          setState(() {
            currentWordIndex = (currentWordIndex + 1) % words.length;
          });
        }
      });
      try {
        Future.delayed(const Duration(milliseconds: 2000), () {
          widget.onboardPageController.animateToPage(
            0,
            duration: widget.moveDuration,
            curve: widget.moveCurve
          );
        });
      } catch (e) {
        //
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LineHeader(
          header: "Your one-stop search",
          footer: "Access and request any service of your choice"
        ),
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              Image.asset(
                Media.onboard2,
                width: MediaQuery.sizeOf(context).width,
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                switchInCurve: Curves.bounceIn,
                child: SText(
                  text: "${words[currentWordIndex]}.",
                  key: ValueKey<int>(currentWordIndex),
                  size: Sizing.font(32),
                  color: Theme.of(context).primaryColor
                )
              ),
            ],
          ),
        ),
      ],
    );
  }
}