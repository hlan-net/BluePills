# User Story: Medication Logging

## Description
As a user, I want to log when I take a dose of my medication so that I can track my adherence and avoid missing or doubling doses.
I want to see a quick overview of what I have taken today.

## Acceptance Criteria
1.  **Log Dose**:
    *   User can mark a medication as "taken" for the current time.
    *   Logging a dose decrements the medication quantity (stock).
    *   A record is created in the `medication_logs` table.
2.  **Today's Overview**:
    *   Home screen displays a "Today's Medications" section.
    *   Shows which medications have been taken today and which are pending.
    *   Visual indicators (e.g., checkmark vs. clock icon).
3.  **History**:
    *   User can view the last taken time for a medication.
    *   (Implicit) Logs are stored permanently for potential future history/analytics features.

## Technical Notes
*   **Models**: `MedicationLog` class in `lib/models/medication_log.dart`.
*   **Database**: `medication_logs` table.
    *   Columns: `id`, `medicationId`, `timestamp`.
*   **Logic**:
    *   `DatabaseHelper.insertMedicationLog()` to save a log.
    *   `DatabaseHelper.getMedicationLogsForToday()` to filter logs for the current day.
    *   `DatabaseHelper.updateMedication()` to update quantity.
