import 'package:flutter/material.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/screens/add_stock_screen.dart';
import 'package:bluepills/database/database_helper.dart';

/// Screen displaying detailed information about a specific medication.
///
/// This screen shows all the details of a medication including its name, dosage,
/// frequency, and current stock quantity. It provides a button to navigate to
/// the [AddStockScreen] where users can add more stock to the medication.
///
/// The screen automatically refreshes the medication data when returning from
/// the add stock screen to display the updated quantity.
class MedicationDetailsScreen extends StatefulWidget {
  /// The medication to display details for.
  final Medication medication;

  /// Creates a [MedicationDetailsScreen] for the given [medication].
  const MedicationDetailsScreen({super.key, required this.medication});

  @override
  State<MedicationDetailsScreen> createState() =>
      _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState extends State<MedicationDetailsScreen> {
  late Medication _medication;
  bool _wasUpdated = false;

  @override
  void initState() {
    super.initState();
    _medication = widget.medication;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _wasUpdated);
        return false;
      },
      child: Scaffold(
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
                        _wasUpdated = true;
                      });
                    }
                  }
                },
                child: const Text('Add Stock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
