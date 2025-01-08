import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityRequestedTripViewProblem extends StatelessWidget {
  final ActivityRequestedTripViewController controller;

  const ActivityRequestedTripViewProblem({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      TripResponse selected = controller.state.trip.value;

      if(selected.problem.isNotEmpty) {
        return Container(
          padding: EdgeInsets.all(Sizing.space(12)),
          color: Theme.of(context).colorScheme.surface,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText(
                text: 'Problem Description',
                size: Sizing.font(14),
                weight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
              const SizedBox(height: 10),
              SText(
                text: selected.problem,
                size: Sizing.font(14),
                color: Theme.of(context).primaryColor
              ),
            ]
          ),
        );
      } else if(selected.audio.isNotEmpty) {
        return Container(
          padding: EdgeInsets.all(Sizing.space(12)),
          color: Theme.of(context).colorScheme.surface,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              SText(
                text: 'Problem Description',
                size: Sizing.font(14),
                weight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
              const SizedBox(height: 10),
              MediaPlayer(audio: selected.audio)
            ]
          ),
        );
      } else {
        return Container(
          padding: EdgeInsets.all(Sizing.space(12)),
          color: Theme.of(context).colorScheme.surface,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText(
                text: 'Problem Description',
                size: Sizing.font(14),
                weight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
              const SizedBox(height: 10),
              SText(
                text: "This request was made based on the discussion you had with the provider involved."
                    " Waiting for the response to start trip.",
                size: Sizing.font(14),
                color: Theme.of(context).primaryColor
              ),
            ]
          ),
        );
      }
    });
  }
}