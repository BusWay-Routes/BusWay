import 'package:bus_finder/widgets/timeline_tile.dart';
import 'package:flutter/material.dart';

class BusTimings extends StatelessWidget {
  const BusTimings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: Colors.deepPurple.shade200,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            MyTimeline(
              isFirst: true,
              isLast: false,
              isPast: true,
            ),
            MyTimeline(
              isFirst: false,
              isLast: false,
              isPast: true,
            ),
            MyTimeline(
              isFirst: false,
              isLast: false,
              isPast: false,
            ),
            MyTimeline(
              isFirst: false,
              isLast: true,
              isPast: false,
            )
          ],
        ),
      ),
    );
  }
}
