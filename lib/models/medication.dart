
class Medication {
  int? id;
  String name;
  String dosage;
  String frequency;
  DateTime reminderTime;

  Medication({
    this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.reminderTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'reminderTime': reminderTime.toIso8601String(),
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      frequency: map['frequency'],
      reminderTime: DateTime.parse(map['reminderTime']),
    );
  }
}
