class TimeSlot {
  String name;
  DateTime startTime;

  TimeSlot({
    required this.startTime,
  }) : name = generateSlotName(startTime);

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      startTime: DateTime.parse(map['startTime']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startTime': startTime.toIso8601String(),
    };
  }

  static String generateSlotName(DateTime startTime) {
    int startHour = startTime.hour;

    if (startHour >= 6) {
      return 'Morning'; // 6AM - 12PM
    } else if (startHour >= 12) {
      return 'Afternoon'; // 12PM - 4PM
    } else if (startHour >= 16) {
      return 'Evening'; // 4PM - 8PM
    } else if (startHour >= 20) {
      return 'Night'; // 8PM - 2AM
    } else {
      return 'Dawn'; // 2AM - 6AM
    }
  }
}
