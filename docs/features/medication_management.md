# User Story: Medication Management

## Description
As a user, I want to manage my list of medications so that I can keep track of what I need to take.
I want to be able to add new medications with details like name, dosage, and quantity.
I also want to edit existing medications if my prescription changes, and delete medications I no longer take.

## Acceptance Criteria
1.  **Add Medication**:
    *   User can add a new medication via a form.
    *   Required fields: Name, Dosage, Quantity, Frequency.
    *   Optional fields: Reminder Time.
2.  **Edit Medication**:
    *   User can edit details of an existing medication.
    *   Changes are saved to the local database.
    *   If sync is enabled, changes are marked for synchronization.
3.  **Delete Medication**:
    *   User can delete a medication.
    *   Deletion removes the medication from the local database.
    *   If sync is enabled, the deletion is propagated to the remote server.
4.  **View List**:
    *   User can view a list of all added medications.
    *   List shows summary info (Name, Dosage, Quantity).
5.  **Frequency Options**:
    *   User can select simple frequencies (e.g., Daily, Weekly).
    *   User can configure complex frequency patterns (e.g., specific days of week, interval days).

## Technical Notes
*   **Models**: `Medication` class in `lib/models/medication.dart`.
*   **Database**: `medications` table in SQLite (Mobile/Desktop) or JSON in LocalStorage (Web).
*   **Screens**:
    *   `MedicationListScreen` (Main list).
    *   `MedicationFormScreen` (Add/Edit form).
    *   `MedicationDetailsScreen` (View details).
*   **State Management**: `setState` in screens, data access via `DatabaseHelper`.
