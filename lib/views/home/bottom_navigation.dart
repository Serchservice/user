import 'package:flutter/material.dart';
import 'package:user/library.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({
    super.key,
    this.backgroundColor,
    required this.tabs,
    this.onTap
  });

  final Color? backgroundColor;
  final List<DynamicIconButtonView> tabs;
  final Function(int index)? onTap;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.tabs.map((tab) => Expanded(
          child: Material(
            color: _currentIndex == tab.index
              ? Theme.of(context).scaffoldBackgroundColor
              : widget.backgroundColor,
            child: InkWell(
              onTap: () => _onTabSelected(tab.index),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Sizing.space(9),
                  horizontal: Sizing.space(5)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _currentIndex == tab.index
                        ? tab.active
                        : tab.icon,
                      color: Theme.of(context).primaryColor
                    ),
                    SText(
                      text: tab.title,
                      size: Sizing.space(2),
                      weight: _currentIndex == tab.index
                        ? FontWeight.bold
                        : FontWeight.normal,
                      color: Theme.of(context).primaryColorLight,
                    )
                  ],
                ),
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }
}