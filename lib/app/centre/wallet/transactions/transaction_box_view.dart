import 'package:flutter/material.dart';
import 'package:user/library.dart';

class TransactionBoxView extends StatelessWidget {
  final Transaction transaction;
  const TransactionBoxView({super.key, required this.transaction});

  static void open({required Transaction transaction}) => Navigate.bottomSheet(
    sheet: TransactionBoxView(transaction: transaction),
    route: "/centre/wallet/transactions/transaction/${transaction.data.id}",
    isScrollable: true
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CurvedBottomSheet(
          padding: EdgeInsets.zero,
          safeArea: true,
          margin: const EdgeInsets.all(10),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Center(
                child: SText(
                  text: transaction.data.header,
                  size: Sizing.font(18),
                  weight: FontWeight.bold,
                  color:Theme.of(context).primaryColor,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SText.center(
                    text: transaction.data.description,
                    size: Sizing.font(14),
                    color: CommonColors.hint,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50)
                      )
                    ),
                  ),
                  Expanded(child: DashedDivider(color: Theme.of(context).primaryColorDark)),
                  Container(
                    width: 10,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50)
                      )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText(
                      text: "Transaction Details",
                      size: Sizing.font(18),
                      weight: FontWeight.bold,
                      color:Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 10),
                    Table(
                      columnWidths: const {
                        0: FixedColumnWidth(120)
                      },
                      children: [
                        _buildTile(
                          context: context,
                          key: "Recipient Details",
                          value: transaction.recipient
                        ),
                        _buildTile(
                          context: context,
                          key: "Transaction Type",
                          value: transaction.type.replaceAll("_", " ")
                        ),
                        _buildTile(
                          context: context,
                          key: "Transaction Number",
                          value: transaction.data.id
                        ),
                        _buildTile(
                          context: context,
                          key: "Transaction Date",
                          value: transaction.data.date
                        ),
                        _buildTile(
                          context: context,
                          key: "Transaction Mode",
                          value: transaction.data.mode
                        ),
                        _buildTile(
                          context: context,
                          key: "Transaction Status",
                          value: transaction.status,
                          color: text(transaction.status)
                        ),
                        _buildTile(
                          context: context,
                          key: "Reference",
                          value: transaction.data.reference
                        ),
                        _buildTile(
                          context: context,
                          key: "Amount",
                          value: "${transaction.isIncoming ? '+' : '-'}${transaction.amount}",
                          color: transaction.isIncoming
                            ? CommonColors.green
                            : CommonColors.error,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ]
          )
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(Sizing.space(10)),
                decoration: BoxDecoration(
                  color: transaction.isIncoming
                    ? CommonColors.green
                    : CommonColors.error,
                    borderRadius: BorderRadius.circular(2)
                  // shape: BoxShape.circle
                ),
                child: Transform.rotate(
                  angle: transaction.isIncoming ? -30 : 0,
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    color: CommonColors.lightTheme,
                    size: 45
                  ),
                ),
              ),
            ],
          )
        )
      ],
    );
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

  TableRow _buildTile({required BuildContext context, required String key, required String value, Color? color}) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Sizing.space(6)),
          child: SText(
            autoSize: false,
            text: key,
            color: Theme.of(context).primaryColor,
            size: Sizing.font(12),
            weight: FontWeight.bold
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: Sizing.space(6)),
          child: SText(
            autoSize: false,
            text: value,
            weight: color != null ? FontWeight.bold : FontWeight.normal,
            color: color ?? Theme.of(context).primaryColor,
            size: Sizing.font(13),
          ),
        ),
      ]
    );
  }
}