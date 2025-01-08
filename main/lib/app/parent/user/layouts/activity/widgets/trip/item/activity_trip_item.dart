import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ActivityTripItem extends StatefulWidget {
  final TripResponse trip;
  final Function(TripResponse)? onTap;
  final bool showStatus;
  final bool showShared;
  final bool showTimeline;

  const ActivityTripItem({
    super.key,
    required this.trip,
    this.onTap,
    this.showStatus = true,
    this.showShared = false,
    this.showTimeline = false
  });

  @override
  State<ActivityTripItem> createState() => _ActivityTripItemState();
}

class _ActivityTripItemState extends State<ActivityTripItem> {
  final ActivityTripItemController _controller = ActivityTripItemController();

  @override
  void initState() {
    _controller.init(widget.trip);
    setState(() {});

    super.initState();
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TripResponse>(
      stream: _controller.activity,
      key: Key(widget.trip.id),
      builder: (_, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
          TripResponse trip = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: InkWell(
                onTap: () => widget.onTap?.call(trip),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildBody(context, trip),
                )
              )
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, TripResponse data) {
    if(widget.showTimeline) {
      return ActivityTripItemContentWithTimeline(trip: data, showShared: widget.showShared, showStatus: widget.showStatus);
    } else {
      return ActivityTripItemContent(trip: data, showShared: widget.showShared, showStatus: widget.showStatus);
    }
  }
}