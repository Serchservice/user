import 'package:flutter/material.dart';
import 'package:user/library.dart';

class QuotationSheet extends StatefulWidget {
  final String trip;
  final int? quotation;
  final Function(TripResponse) onSend;
  const QuotationSheet({super.key, required this.trip, this.quotation, required this.onSend});

  static void open({required String trip, int? quotation, required Function(TripResponse) onSend}) => Navigate.bottomSheet(
    sheet: QuotationSheet(trip: trip, quotation: quotation, onSend: onSend),
    route: "/activity/request/trip?id=$trip&quotation=$quotation",
    isScrollable: true
  );

  @override
  State<QuotationSheet> createState() => _QuotationSheetState();
}

class _QuotationSheetState extends State<QuotationSheet> {
  bool isSending = false;
  String amount = "0";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.addListener(() {
      if(_controller.text.isNotEmpty) {
        setState(() {
          amount = _controller.text;
        });
      }
    });

    super.initState();
  }

  final ConnectService _connect = Connect(useToken: Database.isUserActive);

  void send() async {
    setState(() {
      isSending = true;
    });

    var response = await _connect.post(
      endpoint: "/trip/invite/quote",
      body: {
        "quote_id": widget.quotation,
        "id": widget.trip,
        "amount": _controller.text,
        "guest": Database.isUserActive ? "" : Database.guest.id
      }
    );

    setState(() {
      isSending = false;
    });

    if(response.isSuccessful) {
      notify.success(message: response.message);
      widget.onSend.call(TripResponse.fromJson(response.data));
      Navigate.back();
    } else {
      notify.error(message: response.message);
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(Sizing.space(2)),
              margin: EdgeInsets.all(Sizing.space(6)),
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(16)
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    SText(
                      text: "Enter amount you think is suitable",
                      size: Sizing.font(16),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                    SText(
                      text: "Note: This does not include any material or property expenses, but strictly workmanship fees.",
                      size: Sizing.font(12),
                      color: Theme.of(context).primaryColorLight
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).scaffoldBackgroundColor
                ),
                padding: const EdgeInsets.all(8),
                child: SText(
                  text: CommonUtility.getAmount(amount),
                  size: Sizing.font(18),
                  weight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                )
              ),
              const SizedBox(height: 20),
              Field(
                padding: const EdgeInsets.all(8),
                hintText: "Amount",
                keyboard: TextInputType.number,
                controller: _controller,
              ),
              const SizedBox(height: 50),
              LoadingButton(
                text: "Send",
                borderRadius: 24,
                padding: EdgeInsets.all(Sizing.space(12)),
                textSize: Sizing.font(14),
                width: MediaQuery.of(context).size.width,
                onClick: send,
                buttonColor: CommonColors.darkTheme2,
                textColor: CommonColors.lightTheme,
                loading: isSending,
              )
            ],
          )
        ],
      )
    );
  }
}