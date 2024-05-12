import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class AppUpdatesLayout extends GetResponsiveView<AppUpdatesController> {
  static const String route = "/centre/app/updates";
  AppUpdatesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Update Log",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: ListView.builder(
        itemCount: controller.updates.length,
        itemBuilder: (context, index) {
          return AppUpdateBox(update: controller.updates[index]);
        }
      )
    );
  }
}

class AppUpdateBox extends StatelessWidget {
  final UpdateLogView update;
  const AppUpdateBox({super.key, required this.update});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Expandable(
        mainColor: Theme.of(context).splashColor,
        header: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SText(
              text: update.date,
              size: Sizing.font(12),
              color: CommonColors.hint
            ),
            const SizedBox(height: 5),
            SText(
              text: update.header,
              size: Sizing.font(16),
              color: Theme.of(context).primaryColor,
              weight: FontWeight.bold
            ),
          ]
        ),
        content: Column(
          children: [
            const SizedBox(height: 10),
            Column(
              children: update.content.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle_rounded,
                      size: Sizing.font(6),
                      color: CommonColors.hint
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: SText(
                        text: item,
                        color: CommonColors.hint,
                        size: Sizing.font(14)
                      )
                    )
                  ]
                ),
              )).toList()
            ),
          ],
        ),
      ),
    );
  }
}

class Expandable extends StatefulWidget {
  final Widget header;
  final Widget content;
  final Color mainColor;
  const Expandable({
    super.key,
    required this.header,
    required this.content,
    required this.mainColor,
  });

  @override
  State<Expandable> createState() => _ExpandableState();
}


class _ExpandableState extends State<Expandable> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Material(
        color: widget.mainColor,
        child: Container(
          padding: EdgeInsets.all(Sizing.space(12)),
          child: InkWell(
            onTap: _toggleExpanded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: _toggleExpanded,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: widget.header),
                      Icon(
                        _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                        color: Theme.of(context).primaryColor
                      ),
                    ],
                  ),
                ),
                SizeTransition(
                  sizeFactor: _animation,
                  child: widget.content
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}