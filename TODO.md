# TODO List - BluePills Development

## 🔴 Critical / Next Sprint

### Today's Medications Dashboard (US-001) - 2-3 days
- [ ] Create `shouldTakeToday()` method in Medication model
- [ ] Create `isTakenToday()` check against medication logs  
- [ ] Design TodayMedicationsWidget
- [ ] Add "Today's Medications" section to home screen
- [ ] Show taken vs. due status with icons (✓ Taken, ⏰ Due, ⚠️ Missed)
- [ ] Add "Take All" quick action button
- [ ] Update main screen layout to prioritize today's meds
- [ ] Test with multiple medications scheduled for today

### Enhanced Prescription Patterns (US-001) - 3-4 days
- [ ] Add `scheduleDays` field to Medication model (JSON or bit flags)
- [ ] Create database migration for new field
- [ ] Design day selector UI (Mon, Tue, Wed, Thu, Fri, Sat, Sun buttons)
- [ ] Implement day selector in MedicationFormScreen
- [ ] Add pattern summary text display (e.g., "Mon, Tue, Wed, Thu, Fri")
- [ ] Update `shouldTakeToday()` to use schedule pattern
- [ ] Save and load schedule pattern from database
- [ ] Test weekday-only pattern (Adenuric use case)
- [ ] Test multiple selected days pattern

### Low Stock Warnings (US-001) - 1 day
- [ ] Implement `getDaysOfSupply()` calculation
- [ ] Consider schedule frequency in calculation
- [ ] Add warning badges to medication cards (⚠️ < 7 days, 🔴 < 3 days)
- [ ] Create low-stock filter/section on home screen
- [ ] Add banner notification for critical low stock
- [ ] Test with different frequencies and quantities

### Basic Reminders (US-001) - 2-3 days
- [ ] Add `reminderTime` field to Medication model
- [ ] Create database migration
- [ ] Add time picker to medication form
- [ ] Schedule notifications using NotificationHelper
- [ ] Handle daily reminder scheduling based on pattern
- [ ] Implement "Take" action in notification
- [ ] Implement "Snooze" action (15 min, 30 min, 1 hour)
- [ ] Handle notification when app is closed
- [ ] Reschedule for next occurrence
- [ ] Test reminder on actual device

---

## 🟡 Important / Phase 2

### Expiration Date Tracking (US-002) - 2 days
- [ ] Add `expirationDate` field to Medication model
- [ ] Create database migration
- [ ] Add date picker to medication form
- [ ] Implement days until expiration calculation
- [ ] Add expiration status badge to medication cards
- [ ] Color-code by status (green > 60d, yellow 30-60d, orange 7-30d, red < 7d or expired)
- [ ] Create "Expiring Soon" filter
- [ ] Create "Expired" filter
- [ ] Sort medications by expiration date
- [ ] Show "Expires in X days" text

### Expiration Notifications (US-002) - 1-2 days
- [ ] Schedule notification 30 days before expiration
- [ ] Schedule notification 7 days before expiration
- [ ] Schedule notification on expiration day
- [ ] Group multiple expiring medications in one notification
- [ ] Update notifications when expiration date changes
- [ ] Cancel notifications when medication deleted
- [ ] Test notification scheduling

### Storage Location (US-002) - 1 day
- [ ] Add `storageLocation` field to Medication model
- [ ] Create database migration
- [ ] Add location dropdown to medication form
- [ ] Add predefined locations: Medicine Cabinet, Bedroom, Kitchen, Car, Office, Purse/Bag
- [ ] Allow custom location entry
- [ ] Show location badge/icon on medication cards
- [ ] Add filter by location
- [ ] Test location search and filtering

### As-Needed (PRN) Flag (US-002) - 1 day
- [ ] Add `isAsNeeded` boolean field to Medication model
- [ ] Create database migration
- [ ] Add "As-Needed (PRN)" toggle to medication form
- [ ] Exclude PRN medications from "Today's Medications"
- [ ] Show "Last taken: X days ago" for PRN medications
- [ ] Track usage frequency for PRN medications
- [ ] Add "As-Needed" filter to medication list
- [ ] Test PRN logging workflow

---

## 🟢 Nice to Have / Phase 3

### Adherence Tracking (US-001, US-004)
- [ ] Design calendar view UI
- [ ] Show taken/missed doses on calendar
- [ ] Calculate adherence percentage (7 days, 30 days, all time)
- [ ] Show adherence trends over time
- [ ] Add missed dose logging (retroactive)
- [ ] Export adherence data to CSV
- [ ] Export adherence data to PDF
- [ ] Display adherence per medication

### Improved Medication Form UX
- [ ] Add medication name auto-suggest
- [ ] Improve dosage input (number + unit dropdown)
- [ ] Add better form validation with helpful messages
- [ ] Add "Save & Add Another" button
- [ ] Show form progress indicator
- [ ] Add help text/tooltips for complex fields

### Search and Filters
- [ ] Add search bar to home screen
- [ ] Implement medication name search
- [ ] Add filter chips: All, Active, As-needed, Low Stock, Expiring
- [ ] Add sort options: Name, Expiration, Quantity, Recently Added
- [ ] Save user's preferred filter/sort settings
- [ ] Highlight search results

### Varying Dose Support (Advanced)
- [ ] Design multiple schedule rules UI
- [ ] Support different quantities on different days
- [ ] Display weekly schedule view
- [ ] Handle complex dosing (e.g., 1 pill + 0.5 pill on specific days)
- [ ] Test with Thyroxine use case (daily + Mon/Thu extra)

---

## 🔧 Technical Debt & Improvements

### Database & Data
- [ ] Implement database migration strategy
- [ ] Add database version tracking
- [ ] Add data validation before insert/update
- [ ] Optimize queries for large medication lists
- [ ] Add database indices for common queries
- [ ] Implement data export/backup functionality

### Error Handling
- [ ] Add comprehensive error handling in medication logging
- [ ] Handle network errors gracefully (for future sync)
- [ ] Show user-friendly error messages
- [ ] Log errors for debugging
- [ ] Add crash reporting (optional, privacy-focused)

### Testing
- [ ] Write unit tests for Medication model
- [ ] Write unit tests for schedule logic (`shouldTakeToday()`)
- [ ] Write unit tests for adherence calculations
- [ ] Write integration tests for medication CRUD
- [ ] Write widget tests for critical screens
- [ ] Set up automated testing in CI/CD
- [ ] Add test coverage reporting

### Performance
- [ ] Profile app performance with large medication lists (100+)
- [ ] Optimize medication list rendering
- [ ] Implement lazy loading if needed
- [ ] Reduce app startup time
- [ ] Optimize database queries

### Code Quality
- [ ] Refactor main.dart (too large, split into separate files)
- [ ] Extract MedicationListScreen to separate file
- [ ] Create reusable UI components (MedicationCard, etc.)
- [ ] Improve code documentation
- [ ] Follow Flutter best practices
- [ ] Run dart analyze and fix warnings

---

## 📱 Platform & Build

### Android
- [ ] Test on multiple Android versions (API 21-34)
- [ ] Test on different screen sizes
- [ ] Optimize APK size
- [ ] Add proper app permissions documentation
- [ ] Test notification behavior across Android versions

### iOS (Future)
- [ ] Set up iOS build configuration
- [ ] Test on iOS devices
- [ ] Implement iOS-specific notifications
- [ ] Submit to App Store

### Web (Current)
- [ ] Test web version functionality
- [ ] Handle web-specific limitations (notifications)
- [ ] Optimize for desktop browsers
- [ ] Add PWA support

### Desktop (Linux/Windows/macOS)
- [ ] Test desktop versions
- [ ] Optimize UI for desktop (larger screens)
- [ ] Add keyboard shortcuts
- [ ] Package for distribution

---

## 📚 Documentation

### User Documentation
- [ ] Update QUICK_MEDICATION_SETUP.md with new features
- [ ] Create video tutorials (optional)
- [ ] Add FAQ section
- [ ] Create troubleshooting guide
- [ ] Document all notification settings

### Developer Documentation
- [ ] Document database schema
- [ ] Document API/model interfaces
- [ ] Add contribution guidelines
- [ ] Create architecture documentation
- [ ] Document build process

### App Store Assets
- [ ] Create app screenshots
- [ ] Write app description
- [ ] Create feature graphics
- [ ] Prepare privacy policy
- [ ] Prepare terms of service (if needed)

---

## 🎨 UI/UX Improvements

### Visual Design
- [ ] Create consistent color scheme
- [ ] Design app icon
- [ ] Create medication type icons
- [ ] Improve button styling
- [ ] Add animations and transitions
- [ ] Create empty states for all screens
- [ ] Design error states

### Accessibility
- [ ] Add screen reader support
- [ ] Ensure proper contrast ratios
- [ ] Add text scaling support
- [ ] Test with TalkBack/VoiceOver
- [ ] Add alternative text for images
- [ ] Implement keyboard navigation

### Localization
- [ ] Complete Finnish translations
- [ ] Add Swedish translations (optional)
- [ ] Test RTL languages support
- [ ] Localize date/time formats
- [ ] Localize number formats

---

## 🔮 Future Features (Post-MVP)

### Advanced Features
- [ ] Medication interaction checking
- [ ] Photo/barcode scanning for entry
- [ ] Voice commands for logging
- [ ] Wearable device integration
- [ ] Integration with health apps (Apple Health, Google Fit)
- [ ] Prescription refill reminders based on usage patterns
- [ ] Medication price tracking

### Analytics & Insights (Privacy-Focused)
- [ ] Medication adherence insights
- [ ] Best time to take medications analysis
- [ ] Usage patterns visualization
- [ ] Health trend correlation (optional)

### Sync & Backup (Optional)
- [ ] BlueSky sync implementation
- [ ] Local backup/restore
- [ ] Cloud backup (optional, encrypted)
- [ ] Device-to-device sync

---

## ✅ Completed (Reference)

- [x] Basic medication entry (name, dosage, quantity)
- [x] Simple frequency dropdown (Once Daily, Twice Daily, etc.)
- [x] Medication list view
- [x] Log dose functionality
- [x] Delete medications
- [x] Add stock functionality
- [x] Speed Dial FAB (New Medication, Log Dose, Set Reminder)
- [x] Database setup (SQLite)
- [x] Notification infrastructure
- [x] Basic inventory tracking

---

## 📋 Current Sprint Tasks

**Sprint Goal:** Enable Matti's daily medication routine

**In Progress:**
- [ ] Today's Medications Dashboard
- [ ] Enhanced Prescription Patterns

**Up Next:**
- [ ] Low Stock Warnings
- [ ] Basic Reminders

**Blocked:**
- None

---

## Notes

- Keep tasks small and focused (1-2 days max)
- Test each feature thoroughly before moving to next
- Update this TODO as features are completed
- Mark completed items with [x] and move to "Completed" section
- Prioritize based on user stories (US-001, US-002)
- Focus on Matti's needs first, then Jukka's

Last Updated: 2025-10-12
