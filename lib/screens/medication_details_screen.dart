import 'package:flutter/material.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/screens/add_stock_screen.dart';
import 'package:bluepills/database/database_helper.dart';

class MedicationDetailsScreen extends StatefulWidget {
  final Medication medication;

  const MedicationDetailsScreen({super.key, required this.medication});

  @override
  State<MedicationDetailsScreen> createState() =>
      _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState extends State<MedicationDetailsScreen> {
  late Medication _medication;

  @override
  void initState() {
    super.initState();
    _medication = widget.medication;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_medication.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dosage: ${_medication.dosage}'),
            const SizedBox(height: 8),
            Text('Frequency: ${_medication.frequency}'),
            const SizedBox(height: 8),
            Text('Quantity: ${_medication.quantity}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddStockScreen(medication: _medication),
                  ),
                );
                if (result == true) {
                  // Reload the medication from the database to get the updated quantity
                  final updatedMedication = await DatabaseHelper()
                      .getMedication(_medication.id!);
                  if (updatedMedication != null) {
                    setState(() {
                      _medication = updatedMedication;
                    });
                  }
                }
              },
              child: const Text('Add Stock'),
            ),
          ],
        ),
      ),
    );
  }
}
