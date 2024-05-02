import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ReferralProgramSheet extends StatelessWidget {
  final ReferralProgram program;
  final Function() onContinue;
  const ReferralProgramSheet({super.key, required this.program, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      padding: EdgeInsets.zero,
      safeArea: true,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            _buildCloseButton(context),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 7,
                  margin: EdgeInsets.only(top: Sizing.space(10)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(Sizing.space(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      Container(
                        padding: EdgeInsets.all(Sizing.space(9)),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(24)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.view_timeline_rounded,
                                  color: CommonColors.hint,
                                  size: 20
                                ),
                                const SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: SText(
                                    text: "REWARD",
                                    color: CommonColors.hint,
                                    size: Sizing.font(12),
                                  ),
                                ),
                              ]
                            ),
                            _buildTransactionHeader(context),
                            _buildDivider(context),
                            const SizedBox(height: 20),
                            SText.center(
                              text: "Referral Details",
                              color: CommonColors.hint,
                              size: Sizing.font(16),
                            ),
                            _buildDivider(context),
                            Padding(
                              padding: EdgeInsets.only(bottom: Sizing.space(15)),
                              child: SText(
                                autoSize: false,
                                text: program.data.description,
                                color: Theme.of(context).primaryColor,
                                size: Sizing.font(15),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: Sizing.space(15)),
                              child: SText(
                                autoSize: false,
                                text: "This shows how ${program.name} makes extra bonus from referrals.",
                                color: CommonColors.yellow,
                                size: Sizing.font(15),
                              ),
                            ),
                            Table(
                              children: [
                                _buildDetailTile(
                                  context: context,
                                  header: "Credit per reward",
                                  detail: "${program.data.credits}"
                                ),
                                _buildDetailTile(
                                  context: context,
                                  header: "Credits Received",
                                  detail: CommonUtility.getAmount("${program.data.credits}")
                                ),
                                _buildDetailTile(
                                  context: context,
                                  header: "Role",
                                  detail: program.role
                                ),
                                _buildDetailTile(
                                  context: context,
                                  header: "Code",
                                  detail: program.data.referralCode
                                ),
                                _buildDetailTile(
                                  context: context,
                                  header: "Link",
                                  detail: program.data.referLink
                                ),
                              ]
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(Sizing.space(15)),
                  child: Center(
                    child: LoadingButton(
                      text: "Continue with signup",
                      borderRadius: 24,
                      width: MediaQuery.of(context).size.width,
                      textSize: Sizing.font(14),
                      buttonColor: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).scaffoldBackgroundColor,
                      onClick: () {
                        onContinue.call();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      )
    );
  }

  TableRow _buildDetailTile({required String header, required String detail, required BuildContext context}) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Sizing.space(15)),
          child: SText(
            autoSize: false,
            text: header,
            color: Theme.of(context).primaryColor,
            size: Sizing.font(15),
            weight: FontWeight.bold
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: Sizing.space(15)),
          child: SText(
            autoSize: false,
            text: detail,
            color: Theme.of(context).primaryColor,
            size: Sizing.font(15),
          ),
        ),
      ]
    );
  }

  Row _buildTransactionHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: SText(
            text: program.data.reward,
            color: Theme.of(context).primaryColor,
            size: Sizing.font(18),
            weight: FontWeight.bold
          ),
        ),
      ]
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Avatar.large(avatar: program.avatar),
          const SizedBox(height: 10),
          SText.center(
            text: program.name,
            color: Theme.of(context).primaryColor,
            size: Sizing.font(18),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Positioned _buildCloseButton(BuildContext context) {
    return Positioned(
      left: 10,
      top: 10,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(50),
        child: IconButton(
          onPressed: () => Navigate.back(),
          splashRadius: 25,
          tooltip: "Close",
          icon: Icon(
            Icons.close,
            color: Theme.of(context).primaryColor
          )
        ),
      )
    );
  }

  Column _buildDivider(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 1.5,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)
          )
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}