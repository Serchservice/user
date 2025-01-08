import 'package:user/library.dart';
import 'package:flutter/material.dart';

class MultiFactorCodeItem extends StatelessWidget {
  const MultiFactorCodeItem({super.key, required this.code});

  final MfaRecoveryCodeResponse code;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Material(
          color: code.isUsed ? Theme.of(context).primaryColor : Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            onTap: () => CommonUtility.copy(code.code),
            child: Padding(
              padding: EdgeInsets.all(Sizing.space(4)),
              child: SText(
                text: code.code,
                decoration: code.isUsed ? TextDecoration.lineThrough : null,
                color: code.isUsed ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).primaryColorLight,
              )
            ),
          ),
        ),
      ),
    );
  }
}