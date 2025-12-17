# User Story: Data Export & Import

## Description
As a user, I want to export my medication data to a file so that I can back it up manually or transfer it to another device. I also want to be able to import data from such a file.

## Acceptance Criteria
1.  **Export Data**:
    *   User can trigger an export from Settings.
    *   App generates a JSON file containing all medication data.
    *   User can save the file to their device (using system file picker/saver).
2.  **Import Data**:
    *   User can trigger an import from Settings.
    *   User selects a JSON file from their device.
    *   App parses the file and adds the medications to the local database.
    *   Imported medications are assigned new IDs to avoid conflicts.

## Technical Notes
*   **Packages**:
    *   `file_saver`: For saving exported files.
    *   `file_picker`: For selecting files to import.
*   **Services**:
    *   `ExportService`: Fetches data from DB, serializes to JSON, saves file.
    *   `ImportService`: Picks file, deserializes JSON, inserts into DB.
*   **Format**: JSON array of medication objects (matching `Medication.toMap()` structure).
