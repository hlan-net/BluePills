/// Represents a frequency pattern for medication scheduling.
///
/// This model supports complex medication schedules including:
/// - Daily medications
/// - Specific days of the week
/// - Custom intervals (every N days)
/// - Multiple times per day
class FrequencyPattern {
  /// Type of frequency pattern
  final FrequencyType type;

  /// Days of the week when medication should be taken (1=Monday, 7=Sunday)
  /// Used when type is SPECIFIC_DAYS
  final List<int> daysOfWeek;

  /// Interval in days for EVERY_N_DAYS pattern
  final int? intervalDays;

  /// Number of times per day to take the medication
  final int timesPerDay;

  /// Specific times during the day when medication should be taken
  final List<DateTime> specificTimes;

  FrequencyPattern({
    required this.type,
    this.daysOfWeek = const [],
    this.intervalDays,
    this.timesPerDay = 1,
    this.specificTimes = const [],
  });

  /// Creates a daily frequency pattern
  factory FrequencyPattern.daily({
    int timesPerDay = 1,
    List<DateTime> specificTimes = const [],
  }) {
    return FrequencyPattern(
      type: FrequencyType.daily,
      timesPerDay: timesPerDay,
      specificTimes: specificTimes,
    );
  }

  /// Creates a specific days of week pattern
  factory FrequencyPattern.specificDays({
    required List<int> daysOfWeek,
    int timesPerDay = 1,
    List<DateTime> specificTimes = const [],
  }) {
    return FrequencyPattern(
      type: FrequencyType.specificDays,
      daysOfWeek: daysOfWeek,
      timesPerDay: timesPerDay,
      specificTimes: specificTimes,
    );
  }

  /// Creates an every N days pattern
  factory FrequencyPattern.everyNDays({
    required int days,
    int timesPerDay = 1,
    List<DateTime> specificTimes = const [],
  }) {
    return FrequencyPattern(
      type: FrequencyType.everyNDays,
      intervalDays: days,
      timesPerDay: timesPerDay,
      specificTimes: specificTimes,
    );
  }

  /// Converts this pattern to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'type': type.index,
      'daysOfWeek': daysOfWeek.join(','),
      'intervalDays': intervalDays,
      'timesPerDay': timesPerDay,
      'specificTimes': specificTimes.map((t) => t.toIso8601String()).join(','),
    };
  }

  /// Creates a FrequencyPattern from a database Map
  factory FrequencyPattern.fromMap(Map<String, dynamic> map) {
    return FrequencyPattern(
      type: FrequencyType.values[map['type'] ?? 0],
      daysOfWeek:
          map['daysOfWeek'] != null && map['daysOfWeek'].toString().isNotEmpty
          ? map['daysOfWeek']
                .toString()
                .split(',')
                .map((e) => int.parse(e))
                .toList()
          : [],
      intervalDays: map['intervalDays'],
      timesPerDay: map['timesPerDay'] ?? 1,
      specificTimes:
          map['specificTimes'] != null &&
              map['specificTimes'].toString().isNotEmpty
          ? map['specificTimes']
                .toString()
                .split(',')
                .map((e) => DateTime.parse(e))
                .toList()
          : [],
    );
  }

  /// Returns a human-readable description of this frequency pattern
  String toReadableString() {
    switch (type) {
      case FrequencyType.daily:
        if (timesPerDay == 1) {
          return 'Once daily';
        } else {
          return '$timesPerDay times daily';
        }
      case FrequencyType.specificDays:
        final dayNames = daysOfWeek.map((d) => _getDayName(d)).join(', ');
        if (timesPerDay == 1) {
          return 'On $dayNames';
        } else {
          return '$timesPerDay times on $dayNames';
        }
      case FrequencyType.everyNDays:
        if (intervalDays == 1) {
          return 'Every day';
        } else {
          return 'Every $intervalDays days';
        }
      case FrequencyType.asNeeded:
        return 'As needed';
    }
  }

  String _getDayName(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }

  /// Checks if medication should be taken on a given date
  bool shouldTakeOnDate(DateTime date) {
    switch (type) {
      case FrequencyType.daily:
        return true;
      case FrequencyType.specificDays:
        return daysOfWeek.contains(date.weekday);
      case FrequencyType.everyNDays:
        // This would need a start date reference for proper calculation
        return true; // Simplified for now
      case FrequencyType.asNeeded:
        return false;
    }
  }
}

/// Types of frequency patterns
enum FrequencyType {
  /// Every day
  daily,

  /// Specific days of the week (e.g., Monday, Wednesday, Friday)
  specificDays,

  /// Every N days (e.g., every 2 days, every 3 days)
  everyNDays,

  /// As needed (no schedule)
  asNeeded,
}
