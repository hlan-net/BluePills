import 'package:flutter/material.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/database/database_helper.dart';

class AddStockScreen extends StatefulWidget {
  final Medication medication;

  const AddStockScreen({super.key, required this.medication});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  late DateTime _dateAcquired;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _dateAcquired = DateTime.now();
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
