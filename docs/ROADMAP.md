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
- [x] Today's medications dashboard (Matti's core need)
- [x] Enhanced prescription patterns (Specific Days, Every N Days)
- [x] Low stock warnings and banners
- [x] Expiration date tracking and color-coded badges
- [x] Basic reminder scheduling
- [x] Adherence tracking and calendar view
- [x] Main screen refactoring for better maintainability

### ⚠️ Partially Implemented
- [ ] Basic Reminders (Notification "Take" and "Snooze" actions)

### ❌ Not Yet Implemented
- [ ] Expiration Notifications (30/7/1 day warnings)
- [ ] Storage location tracking
- [ ] As-needed (PRN) medication type
- [ ] Search medications by name
- [ ] Varying dose support (Advanced)
- [ ] Data export to CSV/PDF

---

## Recommended Development Priority

### Phase 1: Complete Matti's Core Needs (US-001) 🎯 HIGH PRIORITY

#### 1.1 Today's Medications Dashboard (DONE)
#### 1.2 Enhanced Prescription Patterns (DONE)
#### 1.3 Low Stock Warnings (DONE)
#### 1.4 Basic Reminders (IN PROGRESS)
**Features:**
- [x] Set reminder time for each medication
- [x] Schedule daily notifications based on prescription pattern
- [x] Show medication name in notification
- [ ] "Take" action button in notification
- [ ] Snooze option (15 min, 30 min, 1 hour)

---

### Phase 2: Jukka's Essential Needs (US-002) 🎯 MEDIUM PRIORITY

#### 2.1 Expiration Date Tracking (DONE)
#### 2.2 Expiration Notifications (Next Up)
**Features:**
- [ ] Notification 30 days before expiration
- [ ] Notification 7 days before expiration
- [ ] Notification on expiration day
- [ ] Group multiple expiring medications in one notification

---

### Phase 3: Enhanced User Experience 🎯 LOWER PRIORITY

#### 3.1 Adherence Tracking & History (DONE)
#### 3.2 Improved Medication Form UX
#### 3.3 Search and Filters
- [x] Filter by Low Stock
- [x] Filter by Expiring Soon
- [ ] Search by Name

---

## Decision Framework

When prioritizing, ask:

1. **Does it help Matti take medications correctly?** (Primary persona)
2. **Is it part of the daily routine?** (High frequency = high value)
3. **Does it prevent a problem?** (Missing doses, running out, expired meds)
4. **Is it a quick win?** (High value, low effort)
5. **Does it enable other features?** (Foundation for future work)

---

## Success Metrics

### Short-term (Completed)
- Users can set up complex schedules (weekdays only, specific days)
- Users see "today's medications" on home screen
- Users receive daily reminders
- Users know when to refill (low stock warnings)

### Medium-term (Next Quarter)
- Users track medication adherence over time
- Users manage expiration dates
- Users rarely forget medications (high adherence %)
- Users successfully refill before running out
