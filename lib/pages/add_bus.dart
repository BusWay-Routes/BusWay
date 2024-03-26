import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBusses extends StatefulWidget {
  const AddBusses({super.key});

  @override
  State<AddBusses> createState() => _AddBussesState();
}

class _AddBussesState extends State<AddBusses> {
  DateTime parseTimeString(String time) {
    final timeMatch = RegExp(r'^(\d{1,2}):(\d{1,2})$').firstMatch(time);
    final hour = int.parse(timeMatch!.group(1)!);
    final minute = int.parse(timeMatch.group(2)!);

    return DateTime.utc(DateTime.now().year, 1, 1, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bus Data'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            addBusData();
          },
          child: Text('Add Bus Data'),
        ),
      ),
    );
  }

  //the arrivalTime is stored as 'arrivalTime:  2024-01-01 07:30:00.000Z'. i want it in format of 'arrivalTime': '07:30'

  void addBusData() async {
    // Example stops data including City A and City B
    List<Map<String, dynamic>> stops = [
      {'name': 'City A', 'arrivalTime': '07:30'},
      {'name': 'Stop A', 'arrivalTime': '08:00'},
      {'name': 'Stop B', 'arrivalTime': '09:00'},
      {'name': 'Stop C', 'arrivalTime': '10:30'},
      {'name': 'Stop D', 'arrivalTime': '12:00'},
      {'name': 'Stop E', 'arrivalTime': '13:30'},
      {'name': 'Stop F', 'arrivalTime': '15:00'},
      {'name': 'Stop G', 'arrivalTime': '16:30'},
      {'name': 'City B', 'arrivalTime': '18:00'},
    ]
        .map((s) => {
              ...s,
              'arrivalTime': parseTimeString(s['arrivalTime']!)
                  .toString(), // Convert DateTime to String
            })
        .toList();

    // Sort stops by arrival time
    stops.sort((a, b) => a['arrivalTime'].compareTo(b['arrivalTime']));

    // Get the time slots
    List<Map<String, dynamic>> busData = getTimeSlots(stops);

    // Extracting timeslot name from the first entry in busData
    String timeslot = busData.first['name'].split(' ').last;

    // Constructing the final bus data
    Map<String, dynamic> finalBusData = {
      'timeslot': timeslot,
      'from': busData.first['from'],
      'to': busData.first['to'],
    };

    // Add bus data to Firestore
    DocumentReference busRef =
        FirebaseFirestore.instance.collection('buses').doc('bus002');
    await busRef.set(finalBusData);

    // Add stops data
    await addStopsData(busRef, stops);
  }

  List<Map<String, dynamic>> getTimeSlots(List<Map<String, dynamic>> stops) {
    List<Map<String, dynamic>> timeSlots = [];

    // Get the hour of the arrival time at the "from" stop
    int fromHour =
        int.parse(stops.first['arrivalTime']!.split(' ')[1].substring(0, 2));

    for (int i = 0; i < stops.length - 1; i++) {
      String startTime = stops[i]['arrivalTime']!;
      String endTime = stops[i + 1]['arrivalTime']!;
      String slotName = getTimeSlotName(
          fromHour, int.parse(startTime.split(' ')[1].substring(0, 2)));
      timeSlots.add({
        'name': slotName,
        'startTime': startTime.split(' ')[1],
        'endTime': endTime.split(' ')[1],
        'stops': [
          stops[i],
          stops[i + 1],
        ],
      });
    }

    // Update busData with the first and last stops along with the slotName
    int fromIndex = 0;
    int toIndex = stops.length - 1;
    String busName =
        '${stops[fromIndex]['name']} - ${stops[toIndex]['name']} (${getTimeSlotName(DateTime.parse(stops[0]['arrivalTime']!).hour, DateTime.parse(stops[stops.length - 1]['arrivalTime']!).hour)})';
    return [
      {'name': busName, 'from': stops[fromIndex], 'to': stops[toIndex]},
      ...timeSlots,
    ];
  }

  String getTimeSlotName(int fromHour, int startHour) {
    if ((fromHour >= 6 && fromHour < 12) ||
        (startHour >= 6 && startHour < 12)) {
      return 'Morning'; // 6AM - 12PM
    } else if ((fromHour >= 12 && fromHour < 16) ||
        (startHour >= 12 && startHour < 16)) {
      return 'Afternoon'; // 12PM - 4PM
    } else if ((fromHour >= 16 && fromHour < 20) ||
        (startHour >= 16 && startHour < 20)) {
      return 'Evening'; // 4PM - 8PM
    } else if ((fromHour >= 20 || fromHour < 2) ||
        (startHour >= 20 || startHour < 2)) {
      return 'Night'; // 8PM - 2AM
    } else {
      return 'Dawn'; // 2AM - 6AM
    }
  }

  Future<void> addStopsData(
      DocumentReference busRef, List<Map<String, dynamic>> stops) async {
    // Add each stop to the subcollection
    CollectionReference stopsCollection = busRef.collection('stops');
    for (int i = 0; i < stops.length; i++) {
      await stopsCollection.doc('stop${i + 1}').set(stops[i]);
    }
  }
}
