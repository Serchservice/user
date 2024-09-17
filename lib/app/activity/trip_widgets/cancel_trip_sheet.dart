import 'package:flutter/material.dart';
import 'package:user/library.dart';

class CancelTripSheet extends StatefulWidget {
  final String trip;
  final bool isInvite;
  final bool isShared;
  final Function(List<TripResponse>, bool) onSuccess;

  const CancelTripSheet({
    super.key,
    required this.trip,
    required this.onSuccess,
    required this.isInvite,
    this.isShared = false
  });

  static void open({
    required String trip,
    required bool isInvite,
    required Function(List<TripResponse>, bool) onSuccess,
    bool isShared = false
  }) {
    Navigate.bottomSheet(
      sheet: CancelTripSheet(trip: trip, onSuccess: onSuccess, isInvite: isInvite, isShared: isShared),
      route: "/activity/request/trip/cancel?id=$trip",
      isScrollable: true
    );
  }

  @override
  State<CancelTripSheet> createState() => _CancelTripSheetState();
}

class _CancelTripSheetState extends State<CancelTripSheet> {
  bool isCancelling = false;
  final TextEditingController _controller = TextEditingController();

  final ConnectService _connect = Connect(useToken: Database.isUserActive);

  void cancel() async {
    setState(() {
      isCancelling = true;
    });

    if(widget.isShared) {
      var response = await _connect.delete(
        endpoint: "/trip/shared/cancel",
        body: {
          "trip": widget.trip,
          "reason": _controller.text,
          "guest": Database.isUserActive ? "" : Database.guest.id,
          "link_id": Database.isUserActive ? "" : Database.preference.active
        }
      );

      setState(() {
        isCancelling = false;
      });

      if(response.isSuccessful) {
        notify.success(message: response.message);
        widget.onSuccess.call([], false);
        Navigate.back();
      } else {
        notify.error(message: response.message);
      }
    } else if(widget.isInvite) {
      var response = await _connect.delete(
        endpoint: "/trip/invite/cancel",
        body: {
          "trip": widget.trip,
          "reason": _controller.text,
          "guest": Database.isUserActive ? "" : Database.guest.id,
          "link_id": Database.isUserActive ? "" : Database.preference.active
        }
      );

      setState(() {
        isCancelling = false;
      });

      if(response.isSuccessful) {
        notify.success(message: response.message);
        widget.onSuccess.call([], true);
        Navigate.back();
      } else {
        notify.error(message: response.message);
      }
    } else {
      var response = await _connect.patch(
        endpoint: "/trip/cancel",
        body: {
          "trip": widget.trip,
          "reason": _controller.text,
          "guest": Database.isUserActive ? "" : Database.guest.id,
          "link_id": Database.isUserActive ? "" : Database.preference.active
        }
      );

      setState(() {
        isCancelling = false;
      });

      if(response.isSuccessful) {
        notify.success(message: response.message);
        List<dynamic> data = response.data;
        List<TripResponse> list = data.map((d) => TripResponse.fromJson(d)).toList();
        widget.onSuccess.call(list, true);
        Navigate.back();
      } else {
        notify.error(message: response.message);
      }
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
                      text: "Cancel Trip Request",
                      size: Sizing.font(16),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                    SText(
                      text: "Help us understand why you want to cancel this trip request",
                      size: Sizing.font(12),
                      color: Theme.of(context).primaryColorLight
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Field(
                padding: const EdgeInsets.all(8),
                hintText: "Cancellation Reason (Optional)",
                keyboard: TextInputType.text,
                controller: _controller,
                isBig: true,
                needLabel: true,
                labelColor: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 50),
              LoadingButton(
                text: "Cancel trip",
                borderRadius: 24,
                padding: EdgeInsets.all(Sizing.space(12)),
                textSize: Sizing.font(14),
                width: MediaQuery.of(context).size.width,
                onClick: cancel,
                buttonColor: CommonColors.error,
                textColor: CommonColors.lightTheme,
                loading: isCancelling,
              )
            ],
          )
        ],
      )
    );
  }
}