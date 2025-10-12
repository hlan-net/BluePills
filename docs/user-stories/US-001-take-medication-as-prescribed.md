# User Story: Take Medication as Prescribed

## Persona
**Matti - The Regular Medication Taker**

## Epic
Medication Management

## Story
**As Matti** (a regular medication taker with chronic conditions)  
**I want to** take my medications exactly as instructed by my doctor  
**So that** I maintain proper medication adherence and achieve the intended health outcomes without worrying about complex tracking

## Business Value
- Improves patient health outcomes through accurate medication compliance
- Reduces medication errors
- Provides peace of mind that medications are taken correctly
- Supports complex prescription patterns (varying doses, skip days, etc.)

## Story Priority
**High** - Core functionality for medication management app

## Story Points
13 (Large - requires prescription pattern support, reminders, and tracking)

## Acceptance Criteria

### 1. Enter Prescription Information
- [ ] I can enter my medication name
- [ ] I can specify the dosage amount (e.g., "100mg", "80mg")
- [ ] I can specify the pill form/strength (e.g., "100mg tablets")
- [ ] I can record my current stock/quantity

### 2. Complex Prescription Patterns
- [ ] I can set medications to be taken daily
- [ ] I can set medications to be taken on specific days of the week
- [ ] I can set medications to be skipped on specific days
- [ ] I can set different doses on different days (e.g., "1 pill daily + extra half pill Mon/Thu")
- [ ] I can see a clear weekly schedule view of what to take when

### 3. Daily Medication Taking
- [ ] I can see which medications I need to take today
- [ ] I can see what time(s) to take each medication
- [ ] I can mark a medication as taken with one tap
- [ ] The app shows me which medications I've already taken today
- [ ] The app shows me which medications I still need to take today

### 4. Reminders and Notifications
- [ ] I can set reminder times for each medication
- [ ] I receive notifications at the specified times
- [ ] Notifications tell me which medication to take
- [ ] I can snooze a reminder
- [ ] I can mark as taken directly from the notification

### 5. Inventory Management
- [ ] The app tracks how many pills I have left
- [ ] The app warns me when I'm running low (e.g., less than 7 days supply)
- [ ] I can easily add new pills when I refill my prescription
- [ ] The inventory count accounts for pills taken

### 6. Adherence Tracking
- [ ] I can see my adherence history (which doses I took/missed)
- [ ] I can see a calendar view of my medication taking
- [ ] I can see adherence percentage over time
- [ ] I can log a missed dose retroactively

## User Scenarios

### Scenario 1: Matti's Simple Daily Medication (Adenuric)
**Given** Matti has Adenuric 80mg prescribed once daily on weekdays  
**When** he enters the prescription details  
**Then** the app shows him to take it Mon-Fri at his chosen time  
**And** reminds him each weekday morning  
**And** doesn't bother him on weekends

### Scenario 2: Matti's Complex Varying Schedule (Thyroxine)
**Given** Matti has Thyroxine 100mg prescribed as: 1 pill daily + extra 0.5 pill on Mon/Thu  
**When** he sets up the medication  
**Then** the app shows him:
- Every day: Take 1 pill (100mg)
- Monday & Thursday: Take 1.5 pills (100mg + 50mg from split pill)
**And** reminds him of the extra half pill on Mon/Thu

### Scenario 3: Matti is Running Low on Medication
**Given** Matti has 5 pills left of Thyroxine  
**When** he opens the app  
**Then** he sees a clear warning that he's running low  
**And** he's prompted to refill his prescription before running out

### Scenario 4: Matti's Morning Routine - Logging Daily Medication
**Given** it's Monday morning and Matti needs to take Thyroxine and Adenuric  
**When** he opens the app  
**Then** he sees both medications listed clearly as "due today"  
**When** he takes them and taps "Log Dose"  
**Then** both are marked as taken with one action  
**And** his inventory decrements automatically  
**And** he gets visual confirmation

### Scenario 5: Matti Checks if He Took His Medication
**Given** it's afternoon and Matti can't remember if he took his morning medications  
**When** he opens the app  
**Then** he immediately sees which medications he took today  
**And** which ones (if any) he still needs to take

## Technical Considerations

### Data Model
- Medication entity with prescription pattern
- Dose log entity for tracking
- Schedule entity for complex patterns
- Reminder entity for notifications

### Prescription Pattern Types
1. **Fixed Daily** - Same every day
2. **Specific Weekdays** - Selected days of week
3. **Interval** - Every N days
4. **Variable Dose** - Different amounts on different days
5. **As Needed** - PRN medications

### UI Components Needed
- Medication entry form with prescription pattern builder
- Today's medications dashboard
- Calendar view for adherence
- Reminder configuration
- Quick dose logging

## Dependencies
- Notification system (already implemented: NotificationHelper)
- Database for medication and log storage (already implemented: DatabaseHelper)
- Date/time handling for schedules

## Out of Scope (Future Stories)
- Integration with pharmacy for auto-refill
- Sharing medication list with healthcare providers
- Medication interaction checking
- Photo capture of prescription labels
- Voice commands for logging doses

## Definition of Done
- [ ] All acceptance criteria met
- [ ] Unit tests written and passing
- [ ] Integration tests for prescription patterns
- [ ] UI responsive and accessible
- [ ] Documentation updated
- [ ] User guide created
- [ ] Code reviewed and merged
- [ ] Tested on Android emulator
- [ ] No critical bugs

## Notes
- Start with the complex prescription patterns from the real-world examples:
  - Thyroxine: Daily + extra half pill 2x/week
  - Adenuric: Weekdays only
- These patterns should guide the implementation
- Consider medication split pills from same package (inventory challenge)

## Related Stories
- [ ] US-002: Receive medication reminders at the right time
- [ ] US-003: Track medication adherence over time
- [ ] US-004: Manage multiple medications simultaneously
- [ ] US-005: Refill medications easily
