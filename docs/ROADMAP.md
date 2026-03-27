# Development Roadmap - BluePills

## Current Product State

### ✅ Implemented
- [x] Medication CRUD (add, edit, delete) with dosage, quantity, and frequency
- [x] Enhanced schedules (specific weekdays, every N days, pattern summary)
- [x] Today's Medications dashboard with taken/due/missed status and quick actions
- [x] Inventory tracking with low-stock warnings and dedicated filters
- [x] Reminder infrastructure with notification actions (Take, Snooze)
- [x] Expiration tracking with badges, filters, and sorting
- [x] Expiration notifications at 30/7/0 day milestones
- [x] Storage location field with predefined locations
- [x] As-needed (PRN) medication support
- [x] Adherence calendar and aggregate adherence metrics
- [x] Export/import and backup foundations
- [x] Multi-language support (EN/FI/SV/DE/ES)

### ⚠️ In Progress / Needs Validation
- [ ] Reminder flow: reschedule next occurrence after action completion
- [ ] Reminder behavior verified on physical Android device
- [ ] Expiration notification scheduling verified end-to-end

### ❌ Not Yet Implemented
- [ ] Search medications by name
- [ ] Group multiple expiring medications into one notification
- [ ] PRN enhancements ("last taken" summary, usage frequency trends)
- [ ] Custom storage location entry and location-based filtering
- [ ] Adherence export (CSV/PDF) and trend visualizations
- [ ] Advanced varying dose rules (different doses by day/time)

---

## Next Release Scope (Recommended)

### Release Focus: Reminder reliability + discoverability

1. Reminder completion reliability
- [ ] Implement robust "next occurrence" rescheduling logic
- [ ] Verify action behavior for Take and Snooze across app states

2. Notification quality
- [ ] Group multiple expiring medications into a single daily digest notification
- [ ] Add/confirm tests for expiration notification scheduling

3. Medication findability
- [ ] Add search by medication name to main list/dashboard

4. PRN usability quick win
- [ ] Show "last taken" relative text for PRN medications

---

## Phase Plan

### Phase 1 - Core routine reliability (current)
- Reminders consistently fire and recover after interaction
- Expiration reminders remain accurate after edits/imports/deletes

### Phase 2 - Day-to-day usability
- Fast search and filtering for active/low stock/expiring medications
- Better PRN-specific context and history summaries

### Phase 3 - Advanced adherence and dosing
- Trend views and export for adherence reporting
- Flexible varying dose schedules for complex therapies

---

## Prioritization Framework

When choosing work, prioritize items that:

1. Directly help users take the right medication at the right time
2. Reduce missed doses, stockouts, and expiration-related risk
3. Improve confidence in reminders/notifications on real devices
4. Deliver clear user value with low implementation risk
5. Build reusable foundations for future sync and analytics features

---

## Outcome Targets

### Near-term
- Reminder actions are reliable on physical devices
- Users can quickly find medications with name search
- Expiration reminders are concise and non-spammy

### Mid-term
- Users can understand adherence trends over time
- PRN usage patterns become visible and actionable
- Complex dosing workflows are supported without manual workarounds
