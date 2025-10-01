# Finnish to English Translation for BluePills

This document demonstrates the translation from Finnish to English for the BluePills medication management app.

## Translation Mapping

| Finnish (Original) | English (Translation) |
|-------------------|----------------------|
| SinisetPillerit | BluePills |
| Minun lääkkeeni | My Medications |
| Lääkkeitä ei ole vielä lisätty. | No medications added yet. |
| Lisää lääke | Add Medication |
| Muokkaa lääkettä | Edit Medication |
| Lääkkeen nimi | Medication Name |
| Annostus | Dosage |
| Taajuus | Frequency |
| Muistutusaika | Reminder Time |
| Tallenna lääke | Save Medication |
| Syötä lääkkeen nimi | Please enter a medication name |
| Syötä annostus | Please enter the dosage |
| Syötä taajuus | Please enter the frequency |
| Virhe | Error |

## Implementation

The app now supports both Finnish and English languages, with English being the default (effectively "translating" from Finnish to English). The localization system allows users to switch between languages, and the Finnish translations have been provided and mapped to their English equivalents.

## Usage

The app is configured to use English by default, which serves as the translation target from the Finnish source text. All UI elements that were previously hardcoded in English now use the localization system, allowing for proper translation support.