import 'package:flutter/material.dart';
import 'package:user/library.dart';

class WalletView extends StatelessWidget {
  final bool isLoading;
  final Wallet wallet;

  const WalletView({super.key, required this.isLoading, required this.wallet});

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return LoadingShimmer(
        content: Container(
          width: MediaQuery.sizeOf(context).width,
          margin: EdgeInsets.all(Sizing.space(15)),
          padding: const EdgeInsets.all(12.0),
          height: 200,
          decoration: BoxDecoration(
            color: CommonColors.shimmerHigh,
            borderRadius: BorderRadius.circular(12)
          )
        )
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(14),
        child: Container(
          padding: EdgeInsets.all(Sizing.space(12)),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: CommonColors.darkTheme2
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(Media.wallet, width: 30, height: 30),
                  const SizedBox(width: 8),
                  SText(
                    text: wallet.wallet,
                    size: Sizing.font(16),
                    weight: FontWeight.bold,
                    color: CommonColors.lightTheme
                  )
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: SText(
                  text: "Withdrawal Balance",
                  size: Sizing.font(16),
                  color: CommonColors.hint
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: SText(
                  text: wallet.balance,
                  size: Sizing.font(24),
                  weight: FontWeight.bold,
                  color: CommonColors.lightTheme
                ),
              ),
              const SizedBox(height: 10),
              SText(
                text: "Deposit",
                size: Sizing.font(14),
                color: CommonColors.hint
              ),
              const SizedBox(height: 5),
              SText(
                text: wallet.deposit,
                size: Sizing.font(14),
                weight: FontWeight.bold,
                color: CommonColors.lightTheme
              ),
              const SizedBox(height: 10),
              SText(
                text: "Uncleared Balance",
                size: Sizing.font(14),
                color: CommonColors.hint
              ),
              const SizedBox(height: 5),
              SText(
                text: wallet.uncleared,
                size: Sizing.font(14),
                weight: FontWeight.bold,
                color: CommonColors.lightTheme
              ),
            ],
          )
        ),
      );
    }
  }
}
