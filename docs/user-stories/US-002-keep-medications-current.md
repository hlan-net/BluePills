# User Story: Keep As-Needed Medications Current

## Persona
**Jukka - The Infrequent Medication User**

## Epic
Medication Inventory Management

## Story
**As Jukka** (an infrequent medication user who doesn't take regular medications)  
**I want to** track medication expiration dates and storage locations  
**So that** when I need a medication, it's available and safe to use

## Business Value
- Prevents medication waste from expired items
- Ensures medications are effective when needed
- Reduces emergency situations (expired EpiPen, inhaler, etc.)
- Improves medicine cabinet organization
- Appeals to broader user base beyond chronic medication users

## Story Priority
**Medium** - Important for a significant user segment

## Story Points
8 (Medium-Large - requires expiration tracking, notifications, and storage management)

## Acceptance Criteria

### 1. Track Expiration Dates
- [ ] I can enter an expiration date for each medication
- [ ] I can see at a glance which medications are expiring soon
- [ ] I can see which medications have already expired
- [ ] The app shows "days until expiration" on medication cards
- [ ] I can sort/filter medications by expiration date

### 2. Expiration Notifications
- [ ] I receive notification 30 days before expiration
- [ ] I receive notification 7 days before expiration
- [ ] I receive notification on expiration day
- [ ] I can customize notification timing
- [ ] I can disable expiration notifications for specific medications

### 3. Storage Location Tracking
- [ ] I can specify where each medication is stored (e.g., "Medicine cabinet", "Car", "Office desk")
- [ ] I can quickly filter medications by location
- [ ] I can see storage location on the medication card
- [ ] I can create custom storage locations

### 4. As-Needed Medication Logging
- [ ] I can mark medications as "as-needed" (PRN)
- [ ] When I take an as-needed medication, I can log it
- [ ] The app shows when I last took each as-needed medication
- [ ] The app tracks how much is left (quantity)
- [ ] I don't get daily reminders for as-needed medications

### 5. Medicine Cabinet Overview
- [ ] I can see all medications in one view
- [ ] I can see which medications are expired/expiring
- [ ] I can see which medications are running low
- [ ] I can quickly add new medications
- [ ] I can easily remove/archive expired medications

### 6. Quick Medication Entry
- [ ] I can add medication by typing name
- [ ] I can scan barcode/take photo for quick entry (future)
- [ ] The app auto-fills common over-the-counter medications
- [ ] Entry form is simple and fast

## User Scenarios

### Scenario 1: Jukka Gets a Headache
**Given** Jukka has a headache and needs pain medication  
**When** he opens BluePills  
**Then** he can quickly search for "Ibuprofen"  
**And** see that it's in the "Medicine cabinet"  
**And** see it expires in 45 days (still good to use)  
**And** see he last took it 2 weeks ago  
**When** he takes 2 pills  
**Then** he logs the dose and quantity decrements by 2

### Scenario 2: Jukka Discovers Expired Medication
**Given** Jukka's allergy medication expired last month  
**When** he opens BluePills  
**Then** he sees a red warning badge on the medication  
**And** it's highlighted in the "Expired" section  
**When** he taps the medication  
**Then** he sees "Expired 32 days ago"  
**And** he can mark it for replacement or delete it

### Scenario 3: Proactive Expiration Warning
**Given** Jukka's emergency inhaler will expire in 6 days  
**When** the app checks expiration dates  
**Then** Jukka receives a notification: "Your Emergency Inhaler expires in 6 days"  
**And** when he opens the app, the inhaler is highlighted  
**And** he can set a reminder to get a new prescription

### Scenario 4: Spring Cleaning Medicine Cabinet
**Given** it's time for Jukka to clean out his medicine cabinet  
**When** he opens BluePills and goes to "All Medications"  
**Then** he can filter to show "Expired" medications  
**And** see all expired items highlighted in red  
**And** he can bulk-select and delete expired items  
**And** see which medications need replacement

### Scenario 5: Adding New Medication
**Given** Jukka just bought allergy medication for spring  
**When** he opens BluePills  
**Then** he taps + → New Medication  
**And** enters:
- Name: "Cetirizine"
- Dosage: "10mg"
- Quantity: 30 tablets
- Expiration: 2026-08-15
- Storage: "Medicine cabinet"
- Type: As-needed
**Then** the medication appears in his list with expiration countdown

### Scenario 6: Finding Medication in Emergency
**Given** Jukka is having an allergic reaction  
**When** he urgently opens BluePills  
**Then** he can search "allergy" or "Cetirizine"  
**And** immediately see: "Medicine cabinet - Expires in 120 days"  
**And** quickly find and take the medication

## Technical Considerations

### Data Model Extensions
```dart
class Medication {
  // Existing fields...
  DateTime? expirationDate;
  String? storageLocation;
  bool isAsNeeded; // PRN flag
  DateTime? lastTaken; // For as-needed tracking
}
```

### Expiration Calculation
- Calculate days until expiration
- Show visual indicators:
  - Green: > 60 days
  - Yellow: 30-60 days
  - Orange: 7-30 days
  - Red: < 7 days or expired

### Storage Locations
- Predefined options: "Medicine cabinet", "Bedroom", "Kitchen", "Car", "Office", "Purse/Bag"
- Allow custom locations
- Store as simple string field

### Notification System
- Schedule notifications at:
  - 30 days before expiration
  - 7 days before expiration
  - On expiration day
- Allow user to customize these intervals

### UI Enhancements
- Expiration badge on medication cards
- Color-coded expiration status
- Filter/sort by expiration date
- "Expired" section on home screen
- Storage location icon/text on cards

## Dependencies
- Notification system (already exists)
- Database schema update for new fields
- Date handling utilities

## Out of Scope (Future Stories)
- Barcode scanning for quick entry
- Photo recognition of medication labels
- Automatic expiration date extraction from photos
- Reminders to check medicine cabinet periodically
- Integration with pharmacy for expiration tracking
- Refill reminders based on usage patterns

## Definition of Done
- [ ] All acceptance criteria met
- [ ] Expiration date field added to medication model
- [ ] Storage location field added to medication model
- [ ] As-needed flag and last-taken date added
- [ ] Expiration notifications implemented
- [ ] UI shows expiration status clearly
- [ ] Filter/sort by expiration works
- [ ] Unit tests for expiration logic
- [ ] UI tests for expiration indicators
- [ ] Documentation updated
- [ ] Tested on Android emulator
- [ ] No critical bugs

## Implementation Notes

### Phase 1: Data Model (Quick Win)
- Add expiration_date, storage_location, is_as_needed, last_taken fields
- Update database schema
- Migration for existing data

### Phase 2: Basic UI (Quick Win)
- Add expiration date picker to medication form
- Add storage location dropdown to form
- Show expiration info on medication cards
- Show storage location on cards

### Phase 3: Expiration Logic
- Calculate days until expiration
- Color-code based on expiration status
- Add expiration section/filter to home screen

### Phase 4: Notifications
- Schedule expiration notifications
- Customize notification intervals
- Handle notification actions

## Related Stories
- [ ] US-006: Track expiration dates for all medications
- [ ] US-007: Organize medications by storage location
- [ ] US-008: Log as-needed medication usage
- [ ] US-009: Quick medication search and lookup

## Notes
- Jukka's needs complement Matti's - both personas benefit from expiration tracking
- Storage location is unique to Jukka but useful for all users
- As-needed logging is simpler than scheduled medication tracking
- This story makes the app useful for a broader audience
