import 'package:flutter/material.dart';

class Eventcard extends StatelessWidget {
  final bool isPast;
  final child;
  const Eventcard({super.key, required this.isPast, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isPast ? Colors.deepPurple : Colors.deepPurple.shade300,
          borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.all(30),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Bus Stop',
            style: TextStyle(
                fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            'time',
            style: TextStyle(fontSize: 20, color: Colors.white),
          )
        ],
      ),
    );
  }
}
