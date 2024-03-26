import 'package:bus_finder/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeline extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  const MyTimeline(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
            color: isPast ? Colors.deepPurple : Colors.deepPurple.shade300),
        indicatorStyle: IndicatorStyle(
            width: 30,
            color: isPast ? Colors.deepPurple : Colors.deepPurple.shade300,
            iconStyle: IconStyle(
                iconData: Icons.done_rounded,
                color: isPast ? Colors.white : Colors.deepPurple.shade300)),
        endChild: Eventcard(
          isPast: isPast,
        ),
      ),
    );
  }
}
