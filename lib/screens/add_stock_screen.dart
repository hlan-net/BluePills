import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

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
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.addStockFor(widget.medication.name)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: localizations.quantity),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.pleaseEnterTheQuantity;
                  }
                  if (int.tryParse(value) == null) {
                    return localizations.pleaseEnterAValidNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveStock,
                child: Text(localizations.saveStock),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
