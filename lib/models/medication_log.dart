/// Represents a log entry for a medication dose taken.
class MedicationLog {
  /// The local database ID of the log entry.
  int? id;

  /// The ID of the medication that was taken.
  int medicationId;

  /// The time when the dose was taken.
  DateTime timestamp;

  /// Creates a new [MedicationLog] instance.
  MedicationLog({
    this.id,
    required this.medicationId,
    required this.timestamp,
  });

  /// Converts this log entry to a Map suitable for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicationId': medicationId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Creates a [MedicationLog] instance from a database Map.
  factory MedicationLog.fromMap(Map<String, dynamic> map) {
    return MedicationLog(
      id: map['id'],
      medicationId: map['medicationId'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
