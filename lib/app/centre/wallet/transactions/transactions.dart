import 'package:flutter/material.dart';
import 'package:user/library.dart';

class Transactions extends StatelessWidget {
  static String get route => "/centre/wallet/transactions";

  final List<TransactionGroup> groups;
  const Transactions({super.key, required this.groups});

  static void open({required List<TransactionGroup> groups}) => Navigate.bottomSheet(
    sheet: Transactions(groups: groups),
    route: "/centre/wallet/transactions",
    isScrollable: true
  );

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Transaction History",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    if(groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Opacity(
              opacity: 0.2,
              child: CategoryImage(
                image: Media.wallet,
                width: 250
              ),
            ),
            const SizedBox(height: 6),
            SText(
              text: "No transactions",
              color: Theme.of(context).primaryColorDark,
              size: Sizing.font(16)
            ),
          ],
        )
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: groups.length,
        itemBuilder: (context, index) {
          TransactionGroup group = groups[index];
          return Expandable(
            header: SText(
              text: group.label,
              size: Sizing.font(14),
              color:Theme.of(context).primaryColor
            ),
            content: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: group.transactions.length,
              itemBuilder: (context, index) => TransactionBox(transaction: group.transactions[index]),
            )
          );
        },
      );
    }
  }
}