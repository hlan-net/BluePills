import 'package:flutter/material.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/database/database_helper.dart';

/// Screen for adding stock to an existing medication.
///
/// This screen provides a form where users can enter a quantity to add to their
/// existing medication stock. The quantity is validated to ensure it's a positive
/// integer, and the medication's total quantity is updated in the database.
///
/// When the stock is successfully added, the screen returns `true` to the previous
/// screen, allowing it to refresh and display the updated quantity.
class AddStockScreen extends StatefulWidget {
  /// The medication to add stock for.
  final Medication medication;

  /// Creates an [AddStockScreen] for the given [medication].
  const AddStockScreen({super.key, required this.medication});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _saveStock() async {
    if (_formKey.currentState!.validate()) {
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final updatedMedication = widget.medication.copyWith(
        quantity: widget.medication.quantity + quantity,
      );
      await DatabaseHelper().updateMedication(updatedMedication);
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Stock for ${widget.medication.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveStock,
                child: const Text('Save Stock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
