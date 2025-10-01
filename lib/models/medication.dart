class Medication {
  int? id;
  String name;
  String dosage;
  String frequency;
  DateTime reminderTime;

  // Sync metadata
  String? remoteId;
  DateTime? lastSynced;
  bool needsSync;
  DateTime createdAt;
  DateTime updatedAt;

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

  void markAsUpdated() {
    updatedAt = DateTime.now();
    needsSync = true;
  }
}
