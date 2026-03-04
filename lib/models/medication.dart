import 'package:bluepills/models/frequency.dart';
import 'package:bluepills/models/medication_log.dart';
import 'frequency_pattern.dart';

/// Represents a medication entry in the BluePills application.
///
/// This model stores all information about a medication including its name,
/// dosage, frequency, and reminder time. It also includes sync metadata for
/// optional BlueSky synchronization.
class Medication {
  /// The local database ID of the medication.
  int? id;

  /// The name of the medication.
  String name;

  /// The dosage information (e.g., "100mg", "2 tablets").
  String dosage;

  /// The current stock of the medication.
  int quantity;

  /// The frequency of medication.
  Frequency frequency;

  /// The structured frequency pattern for the medication.
  FrequencyPattern? frequencyPattern;

  /// The time when the medication reminder should be triggered.
  DateTime reminderTime;

  /// The remote ID from the BlueSky server (used when sync is enabled).
  String? remoteId;

  /// The timestamp of the last successful sync with BlueSky.
  DateTime? lastSynced;

  /// Flag indicating whether this medication needs to be synced with BlueSky.
  bool needsSync;

  /// The timestamp when this medication was first created.
  DateTime createdAt;

  /// The timestamp when this medication was last updated.
  DateTime updatedAt;

  /// The expiration date of the medication (optional).
  DateTime? expirationDate;

  /// Creates a new [Medication] instance.
  ///
  /// All fields except [id], [remoteId], [lastSynced], [createdAt], [updatedAt],
  /// and [expirationDate] are required. The [createdAt] and [updatedAt]
  /// timestamps are automatically set to the current time if not provided.
  Medication({
    this.id,
    required this.name,
    required this.dosage,
    required this.quantity,
    required this.frequency,
    this.frequencyPattern,
    required this.reminderTime,
    this.remoteId,
    this.lastSynced,
    this.needsSync = true,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.expirationDate,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Converts this medication to a Map suitable for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'quantity': quantity,
      'frequency': frequency.index,
      'frequencyPatternType': frequencyPattern?.type.index,
      'frequencyPatternDaysOfWeek': frequencyPattern?.daysOfWeek.join(','),
      'frequencyPatternIntervalDays': frequencyPattern?.intervalDays,
      'frequencyPatternTimesPerDay': frequencyPattern?.timesPerDay,
      'frequencyPatternSpecificTimes': frequencyPattern?.specificTimes
          .map((t) => t.toIso8601String())
          .join(','),
      'reminderTime': reminderTime.toIso8601String(),
      'remoteId': remoteId,
      'lastSynced': lastSynced?.toIso8601String(),
      'needsSync': needsSync ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'expirationDate': expirationDate?.toIso8601String(),
    };
  }

  /// Creates a [Medication] instance from a database Map.
  factory Medication.fromMap(Map<String, dynamic> map) {
    // Helper to safely parse integers from likely String or Int sources
    int parseInt(dynamic value, [int defaultValue = 0]) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    FrequencyPattern? pattern;
    if (map['frequencyPatternType'] != null) {
      pattern = FrequencyPattern(
        type: FrequencyType.values[parseInt(map['frequencyPatternType'])],
        daysOfWeek:
            map['frequencyPatternDaysOfWeek'] != null &&
                map['frequencyPatternDaysOfWeek'].toString().isNotEmpty
            ? map['frequencyPatternDaysOfWeek']
                  .toString()
                  .split(',')
                  .map((e) => parseInt(e))
                  .toList()
            : [],
        intervalDays: map['frequencyPatternIntervalDays'] != null
            ? parseInt(map['frequencyPatternIntervalDays'])
            : null,
        timesPerDay: parseInt(map['frequencyPatternTimesPerDay'], 1),
        specificTimes:
            map['frequencyPatternSpecificTimes'] != null &&
                map['frequencyPatternSpecificTimes'].toString().isNotEmpty
            ? map['frequencyPatternSpecificTimes']
                  .toString()
                  .split(',')
                  .map((e) => DateTime.parse(e))
                  .toList()
            : [],
      );
    }

    return Medication(
      id: map['id'], // ID should ideally be allowed to be null or int
      name: map['name'],
      dosage: map['dosage'],
      quantity: parseInt(map['quantity']),
      frequency: Frequency.values[parseInt(map['frequency'])],
      frequencyPattern: pattern,
      reminderTime: map['reminderTime'] != null
          ? DateTime.parse(map['reminderTime'])
          : DateTime.now(),
      remoteId: map['remoteId'],
      lastSynced: map['lastSynced'] != null
          ? DateTime.parse(map['lastSynced'])
          : null,
      needsSync:
          map['needsSync'] == 1 ||
          map['needsSync'] == '1', // Handle potential string "1"
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      expirationDate: map['expirationDate'] != null
          ? DateTime.parse(map['expirationDate'])
          : null,
    );
  }

  /// Creates a copy of this medication with optional field updates.
  ///
  /// Any field that is provided will replace the existing value.
  /// Fields that are not provided will retain their current values.
  Medication copyWith({
    int? id,
    String? name,
    String? dosage,
    int? quantity,
    Frequency? frequency,
    FrequencyPattern? frequencyPattern,
    DateTime? reminderTime,
    String? remoteId,
    DateTime? lastSynced,
    bool? needsSync,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? expirationDate = _sentinel,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      quantity: quantity ?? this.quantity,
      frequency: frequency ?? this.frequency,
      frequencyPattern: frequencyPattern ?? this.frequencyPattern,
      reminderTime: reminderTime ?? this.reminderTime,
      remoteId: remoteId ?? this.remoteId,
      lastSynced: lastSynced ?? this.lastSynced,
      needsSync: needsSync ?? this.needsSync,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expirationDate:
          expirationDate == _sentinel
              ? this.expirationDate
              : expirationDate as DateTime?,
    );
  }

  static const Object _sentinel = Object();

  /// Marks this medication as updated and needing synchronization.
  ///
  /// Updates the [updatedAt] timestamp to the current time and sets
  /// [needsSync] to true.
  void markAsUpdated() {
    updatedAt = DateTime.now();
    needsSync = true;
  }

  /// Determines if the medication should be taken today based on its schedule.
  ///
  /// This method checks the `frequencyPattern` first. If it exists, it uses
  /// the `shouldTakeOnDate` logic. Otherwise, it falls back to the simple
  /// `frequency` enum.
  bool shouldTakeToday() {
    final today = DateTime.now();

    if (frequencyPattern != null) {
      return frequencyPattern!.shouldTakeOnDate(today, createdAt);
    }

    switch (frequency) {
      case Frequency.onceDaily:
      case Frequency.twiceDaily:
      case Frequency.threeTimesDaily:
        return true;
      case Frequency.asNeeded:
        return false;
    }
  }

  /// Checks if all required doses have been taken today.
  ///
  /// For multi-dose medications (e.g., twiceDaily), returns true only when
  /// the required number of doses have been logged today.
  bool isTakenToday(List<MedicationLog> logs) {
    final required = requiredDosesPerDay;
    if (required <= 0) return false;
    return dosesTakenToday(logs) >= required;
  }

  /// Helper to check if two DateTimes are on the same calendar day.
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Returns the number of doses required per day based on frequency.
  int get requiredDosesPerDay {
    if (frequencyPattern != null) {
      return frequencyPattern!.timesPerDay;
    }
    switch (frequency) {
      case Frequency.onceDaily:
        return 1;
      case Frequency.twiceDaily:
        return 2;
      case Frequency.threeTimesDaily:
        return 3;
      case Frequency.asNeeded:
        return 0;
    }
  }

  /// Returns the number of doses still needed today.
  int dosesRemainingToday(List<MedicationLog> logs) {
    final required = requiredDosesPerDay;
    if (required <= 0) return 0;
    return (required - dosesTakenToday(logs)).clamp(0, required);
  }

  /// Returns how many doses have been taken today.
  int dosesTakenToday(List<MedicationLog> logs) {
    final today = DateTime.now();
    return logs
        .where(
          (log) => log.medicationId == id && _isSameDay(log.timestamp, today),
        )
        .length;
  }

  /// Calculates the estimated number of days the current supply will last.
  int getDaysOfSupply() {
    if (frequencyPattern == null) {
      // Fall back to simple Frequency enum
      switch (frequency) {
        case Frequency.onceDaily:
          return quantity;
        case Frequency.twiceDaily:
          return (quantity / 2).floor();
        case Frequency.threeTimesDaily:
          return (quantity / 3).floor();
        case Frequency.asNeeded:
          return 9999;
      }
    }

    final pattern = frequencyPattern!;
    if (pattern.type == FrequencyType.asNeeded || pattern.timesPerDay <= 0) {
      return 9999;
    }

    switch (pattern.type) {
      case FrequencyType.daily:
        return (quantity / pattern.timesPerDay).floor();
      case FrequencyType.specificDays:
        if (pattern.daysOfWeek.isEmpty) {
          return 9999;
        }
        final dosesPerWeek = pattern.daysOfWeek.length * pattern.timesPerDay;
        final weeksOfSupply = (quantity / dosesPerWeek).floor();
        final remainingDoses = quantity % dosesPerWeek;
        // Approximate remaining days
        final remainingDays = (remainingDoses / pattern.timesPerDay).ceil();
        return (weeksOfSupply * 7) + remainingDays;
      case FrequencyType.everyNDays:
        if (pattern.intervalDays == null || pattern.intervalDays! <= 0) {
          return 9999;
        }
        final cycles = (quantity / pattern.timesPerDay).floor();
        return cycles * pattern.intervalDays!;
      case FrequencyType.asNeeded:
        return 9999;
    }
  }

  /// Calculates the number of days until the medication expires.
  ///
  /// Returns null if no expiration date is set.
  /// Returns 0 or negative if already expired.
  int? getDaysUntilExpiration() {
    if (expirationDate == null) return null;
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final startOfExpiration = DateTime(
      expirationDate!.year,
      expirationDate!.month,
      expirationDate!.day,
    );
    return startOfExpiration.difference(startOfToday).inDays;
  }
}
