import 'package:flutter/material.dart';
import 'package:user/library.dart';

class SkillSearchItem extends StatelessWidget {
  const SkillSearchItem({
    super.key,
    required this.skill,
    this.onTap,
    this.showRemove = false,
    this.needPadding = false
  });

  final Specialization skill;
  final bool showRemove;
  final bool needPadding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: needPadding
            ? const EdgeInsets.symmetric(horizontal: 16)
            : EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText(
                      text: skill.special,
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor
                    ),
                    SText(
                      text: skill.category,
                      size: Sizing.font(10),
                      color: Theme.of(context).primaryColorLight
                    ),
                    if(showRemove) ...[
                      SText(
                        text: "Tap to remove",
                        size: Sizing.font(10),
                        color: Theme.of(context).primaryColorLight
                      ),
                    ]
                  ],
                )
              ),
              CategoryImage(
                image: skill.image,
                width: 60,
                height: 60
              )
            ],
          ),
        ),
      ),
    );
  }
}