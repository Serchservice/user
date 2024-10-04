import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:user/library.dart';

class ReferralProgramSheet extends StatelessWidget {
  final ReferralProgram program;
  final Function()? onContinue;
  final bool showButton;
  const ReferralProgramSheet({
    super.key,
    required this.program,
    this.showButton = true,
    this.onContinue
  });

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      padding: EdgeInsets.zero,
      backgroundColor: showButton
        ? null
        : Colors.transparent,
      safeArea: true,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            if(showButton) ...[
              _buildCloseButton(context)
            ],
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(showButton) ...[
                  Container(
                      width: 70,
                      height: 4,
                      margin: EdgeInsets.only(top: Sizing.space(10)),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)
                      )
                  )
                ],
                Padding(
                  padding: EdgeInsets.all(Sizing.space(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(showButton) ...[
                        _buildHeader(context),
                      ],
                      Container(
                        padding: EdgeInsets.all(Sizing.space(9)),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(24)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SText.center(
                              text: showButton
                                  ? "Confirm that you are being referred by this account"
                                  : "Your referral program",
                              color: CommonColors.hint,
                              size: Sizing.font(16),
                            ),
                            _buildDivider(context),
                            Table(
                              columnWidths: const {
                                0: FixedColumnWidth(100),
                              },
                              children: [
                                _buildDetailTile(
                                    context: context,
                                    header: "Name",
                                    detail: program.name
                                ),
                                _buildDetailTile(
                                  context: context,
                                  header: "Role",
                                  detail: program.role
                                ),
                                _buildDetailTile(
                                  context: context,
                                  header: "Code",
                                  detail: program.referralCode
                                ),
                                _buildDetailTile(
                                  context: context,
                                  header: "Link",
                                  detail: program.referLink
                                ),
                              ]
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                ),
                if(showButton) ...[
                  Padding(
                    padding: EdgeInsets.all(Sizing.space(15)),
                    child: Center(
                      child: LoadingButton(
                        text: "Continue with signup",
                        borderRadius: 24,
                        width: MediaQuery.sizeOf(context).width,
                        textSize: Sizing.font(14),
                        buttonColor: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).scaffoldBackgroundColor,
                        onClick: () {
                          onContinue?.call();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  )
                ]
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
          child: SelectableLinkify(
            text: detail,
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: Sizing.font(15)),
            linkStyle: TextStyle(color: CommonColors.allday, fontSize: Sizing.font(15)),
            options: const LinkifyOptions(humanize: false),
            onOpen: (link) => RouteNavigator.openLink(url: link.url),
          )
        ),
      ]
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Avatar.large(avatar: program.avatar),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Positioned _buildCloseButton(BuildContext context) {
    return Positioned(
      left: 10,
      top: 10,
      child: SizedBox(
        height: 35,
        width: 35,
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(50),
          child: IconButton(
            onPressed: () => Navigate.back(),
            splashRadius: 25,
            tooltip: "Close",
            padding: const EdgeInsets.all(8),
            icon: Icon(
              Icons.close,
              size: 20,
              color: Theme.of(context).primaryColor
            )
          ),
        ),
      )
    );
  }

  Column _buildDivider(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.sizeOf(context).width,
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