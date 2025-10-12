# New Application Flow Documentation

## Status: Work in Progress

This document outlines the proposed and partially implemented new user flow for the BluePills application, focusing on medication inventory management.

### New Application Flow

1.  **Main Screen (`MedicationListScreen`)**
    *   The application opens to a list of medications.
    *   Each item in the list displays the medication's name, dosage, frequency, and **quantity remaining**.
    *   A **"Take" button** is available for each medication. Tapping it decrements the quantity and logs the event.
    *   Users can **add** a new medication by tapping the `+` button, which navigates to the `MedicationFormScreen`.
    *   Tapping on a medication navigates the user to the **`MedicationDetailsScreen`**.
    *   The screen also provides access to the `SettingsScreen`.
    *   **Future (Planned):** Medications will be sorted by the "next dose to take".

2.  **Medication Form (`MedicationFormScreen`)**
    *   This screen is for creating and editing medications.
    *   It captures the following information:
        *   **Name:** The name of the medication.
        *   **Dosage:** The dosage of the medication.
        *   **Quantity:** The initial quantity of the medication (for new medications).
        *   **Frequency:** Now selected from a **predetermined list of choices** (e.g., "Once daily", "Twice daily") using a dropdown.
        *   **Reminder Time:** The time of day to receive a reminder notification.

3.  **Medication Details (`MedicationDetailsScreen`)**
    *   **New Screen:** This screen displays detailed information about a selected medication.
    *   It shows the medication's name, dosage, frequency, and the **current quantity remaining**.
    *   It includes an **"Add Stock" button** to navigate to the `AddStockScreen`.
    *   **Future (Planned):** Will display a history of when the medication was taken.
    *   **Future (Planned):** Will include an "Edit" button to go to `MedicationFormScreen` for editing.

4.  **Add Stock (`AddStockScreen`)**
    *   **New Screen:** This screen allows the user to record new stock for a medication.
    *   It captures:
        *   **Quantity:** The number of units being added.
        *   **Date Acquired:** The date the stock was acquired (defaults to today).
    *   Saving updates the medication's total quantity.

5.  **Settings (`SettingsScreen`)**
    *   Functionality remains unchanged (BlueSky sync, data import/export).

### Test Usage Description

To verify the functionality of the new user flow, follow these steps:

1.  **Launch the application** in an emulator or on a device.
2.  **Add a new medication:**
    *   Tap the `+` button on the `MedicationListScreen`.
    *   Enter a medication name, dosage, **initial quantity (e.g., 10)**, select a frequency from the dropdown, and set a reminder time.
    *   Save the medication.
    *   Verify that the new medication appears in the `MedicationListScreen` with the correct quantity.
3.  **Mark a dose as taken:**
    *   On the `MedicationListScreen`, tap the "Take" button next to the newly added medication.
    *   Verify that the displayed quantity for that medication decrements by 1.
4.  **View medication details and add stock:**
    *   Tap on the medication in the `MedicationListScreen` to navigate to the `MedicationDetailsScreen`.
    *   Verify that the details (dosage, frequency, quantity) are correct.
    *   Tap the "Add Stock" button.
    *   On the `AddStockScreen`, enter a quantity (e.g., 5) and save.
    *   Verify that you are returned to the `MedicationDetailsScreen` and the quantity has been updated (e.g., from 9 to 14).
5.  **Verify frequency selection:**
    *   Go back to the `MedicationFormScreen` (e.g., by adding a new medication or editing an existing one).
    *   Verify that the frequency input is now a dropdown with the predetermined choices.

This will cover the basic functionality of the new inventory management system.
