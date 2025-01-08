import 'package:flutter/material.dart';
import 'package:user/library.dart';

class WalletTransactionItem extends StatelessWidget {
  final Transaction transaction;

  const WalletTransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        onTap: () => WalletTransactionView.open(transaction: transaction),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Transform.rotate(
                angle: transaction.isIncoming ? -30 : 0,
                child: Icon(
                  Icons.arrow_outward_rounded,
                  color: transaction.isIncoming
                    ? CommonColors.green
                    : CommonColors.error,
                  size: 45
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SText(
                            text: transaction.type,
                            size: Sizing.font(14),
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            flow: TextOverflow.clip
                          ),
                        ),
                        const SizedBox(width: 10),
                        SText(
                          text: transaction.amount,
                          size: Sizing.font(14),
                          weight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SText(
                            text: transaction.recipient,
                            size: Sizing.font(14),
                            color: Theme.of(context).primaryColor,
                            flow: TextOverflow.ellipsis
                          ),
                        ),
                        const SizedBox(width: 10),
                        SText(
                          text: transaction.label,
                          size: Sizing.font(12),
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(Sizing.space(4)),
                      decoration: BoxDecoration(
                        color: background(transaction.status),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: SText(
                        text: transaction.status,
                        color: text(transaction.status),
                        size: Sizing.font(12),
                        weight: FontWeight.bold
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  Color background(String status) {
    switch (status.toLowerCase()) {
      case 'successful':
        return Colors.greenAccent;
      case 'pending':
        return Colors.yellowAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  Color text(String status) {
    switch (status.toLowerCase()) {
      case 'successful':
        return Colors.green[900] ?? Colors.black12;
      case 'pending':
        return Colors.yellow[900] ?? Colors.black12;
      default:
        return Colors.orange[900] ?? Colors.black12;
    }
  }
}