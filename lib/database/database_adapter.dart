import 'package:bluepills/models/medication.dart';

abstract class DatabaseAdapter {
  Future<void> init();
  Future<int> insertMedication(Medication medication);
  Future<List<Medication>> getMedications();
  Future<int> updateMedication(Medication medication);
  Future<int> deleteMedication(int id);
}
