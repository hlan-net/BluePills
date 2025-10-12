# Development Roadmap - BluePills

## Current State Analysis

### ✅ Already Implemented
- [x] Medication entry (name, dosage, quantity)
- [x] Basic frequency patterns (Once Daily, Twice Daily, etc.)
- [x] Inventory tracking (quantity decrements when logged)
- [x] Speed Dial FAB (New Medication, Log Dose, Set Reminder actions)
- [x] Database infrastructure (DatabaseHelper, SQLite)
- [x] Notification system infrastructure (NotificationHelper)
- [x] Basic list view of medications
- [x] Delete medications
- [x] Update medication quantities (Add Stock)

### ⚠️ Partially Implemented
- [ ] Prescription patterns (basic frequency dropdown exists, but limited)
- [ ] Daily medication taking (can log, but no "today's medications" view)
- [ ] Inventory warnings (tracks quantity but no low-stock warnings)

### ❌ Not Yet Implemented
- [ ] Complex prescription patterns (specific days, varying doses)
- [ ] Today's medications dashboard
- [ ] Reminder configuration and triggering
- [ ] Adherence history and tracking
- [ ] Expiration date tracking
- [ ] Storage location tracking
- [ ] As-needed (PRN) medication type
- [ ] Calendar/history view

---

## Recommended Development Priority

### Phase 1: Complete Matti's Core Needs (US-001) 🎯 HIGH PRIORITY

#### 1.1 Today's Medications Dashboard (2-3 days)
**Why:** Matti needs to see what to take TODAY, not just a full list
**Impact:** Makes the app immediately useful for daily routine

**Features:**
- [ ] Home screen shows "Today's Medications" section
- [ ] List medications due today based on schedule
- [ ] Show which ones already taken vs. still needed
- [ ] Visual status: ✓ Taken, ⏰ Due, ⚠️ Missed
- [ ] Quick "Take All" button for morning routine

**Technical:**
- Add `shouldTakeToday()` method to Medication model
- Add `isTakenToday()` check against medication logs
- Create TodayMedicationsWidget
- Update main screen layout

**User Story:** US-001 Acceptance Criteria #3

---

#### 1.2 Enhanced Prescription Patterns (3-4 days)
**Why:** Matti has complex schedules (daily + Mon/Thu extra, weekdays only)
**Impact:** Accurately reflects doctor's instructions

**Features:**
- [ ] "Specific Days" pattern - select Mon, Tue, Wed, Thu, Fri, Sat, Sun
- [ ] Visual day selector (buttons or chips)
- [ ] Pattern summary text (e.g., "Mon, Tue, Wed, Thu, Fri")
- [ ] Save pattern to database
- [ ] Use pattern to determine "should take today"

**Technical:**
- Extend Medication model with `scheduleDays` (JSON or bit flags)
- Update MedicationFormScreen with day selector UI
- Implement schedule matching logic
- Database migration for new fields

**User Story:** US-001 Acceptance Criteria #2

---

#### 1.3 Low Stock Warnings (1 day)
**Why:** Matti needs to know when to refill prescriptions
**Impact:** Prevents running out of medications

**Features:**
- [ ] Calculate "days of supply" based on schedule
- [ ] Show ⚠️ warning badge when < 7 days left
- [ ] Show 🔴 critical badge when < 3 days left
- [ ] Banner on home screen for low-stock medications

**Technical:**
- Add `getDaysOfSupply()` calculation
- Add warning indicators to medication cards
- Create low-stock filter/section
- Consider schedule frequency in calculation

**User Story:** US-001 Acceptance Criteria #5

---

#### 1.4 Basic Reminders (2-3 days)
**Why:** Matti shouldn't have to remember - app should remind him
**Impact:** Core value proposition of medication management

**Features:**
- [ ] Set reminder time for each medication
- [ ] Schedule daily notifications based on prescription pattern
- [ ] Show medication name in notification
- [ ] "Take" action button in notification
- [ ] Snooze option (15 min, 30 min, 1 hour)

**Technical:**
- Add `reminderTime` field to Medication model
- Use existing NotificationHelper to schedule
- Handle notification actions (take, snooze)
- Reschedule for next occurrence

**User Story:** US-001 Acceptance Criteria #4

---

### Phase 2: Jukka's Essential Needs (US-002) 🎯 MEDIUM PRIORITY

#### 2.1 Expiration Date Tracking (2 days)
**Why:** Jukka's primary concern is expired medications
**Impact:** Expands user base to occasional medication users

**Features:**
- [ ] Add expiration date field to medication form
- [ ] Show "Expires in X days" on medication card
- [ ] Color-coded expiration status (green/yellow/orange/red)
- [ ] Filter to show expiring/expired medications
- [ ] Sort by expiration date

**Technical:**
- Add `expirationDate` field to Medication model
- Calculate days until expiration
- Add expiration badge to medication cards
- Database migration

**User Story:** US-002 Acceptance Criteria #1

---

#### 2.2 Expiration Notifications (1-2 days)
**Why:** Proactive warnings prevent discovering expired meds when needed
**Impact:** Key value for Jukka persona

**Features:**
- [ ] Notification 30 days before expiration
- [ ] Notification 7 days before expiration
- [ ] Notification on expiration day
- [ ] Group multiple expiring medications in one notification

**Technical:**
- Schedule expiration notifications when adding/updating medication
- Calculate notification dates
- Use NotificationHelper for scheduling

**User Story:** US-002 Acceptance Criteria #2

---

#### 2.3 Storage Location (1 day)
**Why:** Jukka stores medications in multiple places
**Impact:** Quick wins for Jukka's workflow

**Features:**
- [ ] Add storage location field (dropdown + custom)
- [ ] Predefined locations: "Medicine Cabinet", "Bedroom", "Kitchen", "Car", "Office", "Purse/Bag"
- [ ] Show location on medication card
- [ ] Filter by location

**Technical:**
- Add `storageLocation` string field to Medication model
- Create location dropdown in form
- Add location icon/badge to cards

**User Story:** US-002 Acceptance Criteria #3

---

#### 2.4 As-Needed (PRN) Flag (1 day)
**Why:** Differentiates scheduled vs. as-needed medications
**Impact:** Cleaner experience for both Matti and Jukka

**Features:**
- [ ] Toggle for "As-needed (PRN)" in medication form
- [ ] As-needed medications don't show in "Today's Medications"
- [ ] Show "Last taken: X days ago" for PRN medications
- [ ] Track usage frequency

**Technical:**
- Add `isAsNeeded` boolean to Medication model
- Modify today's medications logic to exclude PRN
- Show last taken date from logs

**User Story:** US-002 Acceptance Criteria #4

---

### Phase 3: Enhanced User Experience 🎯 LOWER PRIORITY

#### 3.1 Adherence Tracking & History (3-4 days)
**Why:** Matti wants to know if he forgot doses; Liisa wants statistics
**Impact:** Provides value over time, builds trust

**Features:**
- [ ] Calendar view showing taken/missed doses
- [ ] Adherence percentage (last 7 days, 30 days, all time)
- [ ] Missed dose tracking
- [ ] Medication history for each medication
- [ ] Export to CSV/PDF

**User Story:** US-001 Acceptance Criteria #6

---

#### 3.2 Improved Medication Form UX (1-2 days)
**Why:** Current form could be more intuitive
**Impact:** Easier onboarding, fewer errors

**Features:**
- [ ] Auto-suggest medication names
- [ ] Better dosage input (number + unit dropdown)
- [ ] Clear frequency pattern UI
- [ ] Form validation with helpful messages
- [ ] Save & Add Another button

---

#### 3.3 Search and Filters (1 day)
**Why:** As medication list grows, finding specific items gets harder
**Impact:** Scalability for users with many medications

**Features:**
- [ ] Search medications by name
- [ ] Filter: All, Active, As-needed, Low Stock, Expiring
- [ ] Sort: Name, Expiration, Quantity, Recently Added
- [ ] Quick filter chips on home screen

---

### Phase 4: Advanced Features (Future)

#### 4.1 Varying Dose Support
**Why:** Matti's Thyroxine case (daily + extra Mon/Thu)
**Impact:** Handles very complex prescriptions accurately

**Features:**
- [ ] Multiple schedule rules per medication
- [ ] Different quantities on different days
- [ ] Visual weekly schedule display

---

#### 4.2 Medication Interactions (Future)
**Why:** Safety feature
**Impact:** Prevents harmful combinations

---

#### 4.3 Photo/Barcode Entry (Future)
**Why:** Faster medication entry
**Impact:** Reduces friction

---

## Quick Wins (Can do in 1-2 days each)

These provide immediate value with minimal effort:

1. **✨ Today's Medications Dashboard** - Makes app useful for daily routine
2. **✨ Low Stock Warnings** - Prevents running out
3. **✨ Expiration Date Field** - Quick database field + UI addition
4. **✨ Storage Location Field** - Simple string field + dropdown
5. **✨ As-Needed (PRN) Flag** - Boolean field + logic update

---

## Recommended Next Sprint (2 weeks)

**Sprint Goal:** Make BluePills useful for Matti's daily medication routine

**Stories:**
1. Today's Medications Dashboard (HIGH)
2. Enhanced Prescription Patterns - Specific Days (HIGH)
3. Low Stock Warnings (MEDIUM)
4. Basic Reminders (HIGH)

**Expected Outcome:**
- Matti can see what to take each day
- Matti can set up his Adenuric (weekdays only) correctly
- Matti gets reminded to take medications
- Matti knows when to refill prescriptions

This completes the core loop for US-001 and makes the app genuinely useful for daily medication management.

---

## Decision Framework

When prioritizing, ask:

1. **Does it help Matti take medications correctly?** (Primary persona)
2. **Is it part of the daily routine?** (High frequency = high value)
3. **Does it prevent a problem?** (Missing doses, running out, expired meds)
4. **Is it a quick win?** (High value, low effort)
5. **Does it enable other features?** (Foundation for future work)

---

## Technical Debt to Address

- [ ] Database migration strategy for schema changes
- [ ] Error handling in medication logging
- [ ] Offline support verification
- [ ] Performance optimization for large medication lists
- [ ] Comprehensive unit tests for schedule logic

---

## Success Metrics

### Short-term (Next Sprint)
- Users can set up complex schedules (weekdays only, specific days)
- Users see "today's medications" on home screen
- Users receive daily reminders
- Users know when to refill (low stock warnings)

### Medium-term (Next Quarter)
- Users track medication adherence over time
- Users manage expiration dates
- Users rarely forget medications (high adherence %)
- Users successfully refill before running out

### Long-term (Next Year)
- Users trust the app for all medication management
- Users recommend to others with similar needs
- App handles edge cases gracefully
- High user retention (daily active users)
