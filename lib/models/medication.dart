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
  
  /// The frequency of medication (e.g., "twice daily", "every 8 hours").
  String frequency;
  
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

  /// Creates a new [Medication] instance.
  ///
  /// All fields except [id], [remoteId], [lastSynced], [createdAt], and [updatedAt]
  /// are required. The [createdAt] and [updatedAt] timestamps are automatically
  /// set to the current time if not provided.
  Medication({
    this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.reminderTime,
    this.remoteId,
    this.lastSynced,
    this.needsSync = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Converts this medication to a Map suitable for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'reminderTime': reminderTime.toIso8601String(),
      'remoteId': remoteId,
      'lastSynced': lastSynced?.toIso8601String(),
      'needsSync': needsSync ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Creates a [Medication] instance from a database Map.
  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      frequency: map['frequency'],
      reminderTime: map['reminderTime'] != null
          ? DateTime.parse(map['reminderTime'])
          : DateTime.now(),
      remoteId: map['remoteId'],
      lastSynced: map['lastSynced'] != null
          ? DateTime.parse(map['lastSynced'])
          : null,
      needsSync: map['needsSync'] == 1,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
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
    String? frequency,
    DateTime? reminderTime,
    String? remoteId,
    DateTime? lastSynced,
    bool? needsSync,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      reminderTime: reminderTime ?? this.reminderTime,
      remoteId: remoteId ?? this.remoteId,
      lastSynced: lastSynced ?? this.lastSynced,
      needsSync: needsSync ?? this.needsSync,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Marks this medication as updated and needing synchronization.
  ///
  /// Updates the [updatedAt] timestamp to the current time and sets
  /// [needsSync] to true.
  void markAsUpdated() {
    updatedAt = DateTime.now();
    needsSync = true;
  }
}
