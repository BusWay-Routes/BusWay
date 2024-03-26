import 'package:bus_finder/models/time_slot.dart';

class Bus {
  String id;
  String name;
  String from;
  String to;
  List<TimeSlot> timeSlots;
  List<Map<String, dynamic>> stops;

  Bus({
    required this.id,
    required this.name,
    required this.from,
    required this.to,
    required this.timeSlots,
    required this.stops,
  });

  factory Bus.fromMap(Map<String, dynamic> map) {
    return Bus(
      id: map['id'],
      name: map['name'],
      from: map['from'],
      to: map['to'],
      timeSlots: (map['timeSlots'] as List<dynamic>)
          .map((timeSlot) => TimeSlot.fromMap(timeSlot))
          .toList(),
      stops: (map['stops'] as List<dynamic>)
          .map((stop) => {
                'name': stop['name'],
                'arrivalTime': stop['arrivalTime'].toDate(),
              })
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'from': from,
      'to': to,
      'timeSlots': timeSlots.map((timeSlot) => timeSlot.toMap()).toList(),
      'stops': stops,
    };
  }
}
