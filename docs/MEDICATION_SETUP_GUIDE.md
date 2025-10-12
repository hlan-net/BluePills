# Setting Up Your Medications in BluePills

This guide walks you through setting up complex medication schedules in BluePills.

## Understanding Inventory Tracking

**Important:** The current app tracks inventory in whole units (pills). When you log a dose, it decrements by 1 pill. This works perfectly for most medications, but requires a workaround for split pills.

## Example 1: Thyroxine - Daily with Extra Half Pills

**Your Schedule:**
- Take 100mg pill every day (1 whole pill)
- Take additional 50mg (half pill) on Monday and Thursday
- All pills come from the same package of 100mg pills

**Actual Consumption:**
- 7 whole pills per week (daily dose)
- 1 additional pill per week (split for 2 half doses)
- **Total: 8 pills consumed per week**

### Setup Option A: Single Entry with Manual Adjustment (Recommended)

This approach keeps it simple and you manually track the split pills.

1. **Tap the + button** → **New Medication** (blue)
2. Fill in the form:
   - **Name:** Thyroxine
   - **Dosage:** 100mg (1 whole pill daily, + 0.5 pill Mon/Thu)
   - **Frequency:** Select "Once Daily" 
   - **Quantity:** Your current stock (e.g., 90 pills)

3. **Daily Usage:**
   - **Mon-Sun:** Tap "Log Dose" when you take your daily pill
   - **Monday & Thursday:** 
     - Take your regular whole pill (logged above)
     - Take the half pill (from a pill you split)
     - Manually adjust: Every other Mon/Thu, log an extra dose to account for the split pill you consumed

4. **Inventory Management:**
   - The app shows pills consumed
   - Every 2 weeks, you'll need to log 1 extra "dose" to account for the split pill consumed
   - This keeps your inventory accurate

**Pros:**
- ✅ Simple - only one medication entry
- ✅ Accurate weekly tracking with small manual adjustment
- ✅ Reflects your actual pill bottle

**Cons:**
- ⚠️ Requires remembering to log the extra dose periodically

### Setup Option B: Two Entries (Track Each Dose Separately)

This is the approach from the original guide - creates separate entries for easier reminder tracking.

1. **Entry 1: Thyroxine Daily Base**
   - Name: Thyroxine
   - Dosage: 100mg
   - Frequency: Once Daily
   - Quantity: 90

2. **Entry 2: Thyroxine Half Pill**
   - Name: Thyroxine (half)
   - Dosage: 50mg  
   - Frequency: Twice weekly (Mon, Thu)
   - Quantity: 90 (same bottle, but tracking separately)

3. **Daily Usage:**
   - Every day: Log "Thyroxine 100mg"
   - Monday & Thursday: Also log "Thyroxine (half) 50mg"

4. **Inventory Sync:**
   - When you add stock to one, add the same amount to the other
   - Both track from the same physical bottle
   - The totals won't perfectly match your physical count

**Pros:**
- ✅ Clear reminder separation
- ✅ Easy to see which doses to take each day

**Cons:**
- ⚠️ Two entries for the same physical medication
- ⚠️ Must manually keep quantities in sync when adding stock

### Setup Option C: Single Entry with Notes (Simplest)

1. **Tap + button** → **New Medication**
2. Fill in:
   - **Name:** Thyroxine  
   - **Dosage:** 100mg (+ half pill Mon/Thu)
   - **Frequency:** Once Daily
   - **Quantity:** 90

3. **Daily Usage:**
   - Take your pill(s) as scheduled
   - Log "Thyroxine" dose once daily
   - Keep note that Mon/Thu you take extra half
   - Every 2-3 weeks, manually adjust quantity down by 1-2 pills to account for splits

**Pros:**
- ✅ Simplest setup
- ✅ One entry, matches physical bottle

**Cons:**
- ⚠️ Must remember the Monday/Thursday schedule yourself
- ⚠️ Inventory will slowly drift (but easy to correct when refilling)

## Recommended Approach for Your Case

**Use Option A (Single Entry with Manual Adjustment):**

1. Create one "Thyroxine 100mg" entry
2. Set frequency to "Once Daily"  
3. Every day, log when you take your dose
4. On Monday and Thursday:
   - Log the daily dose as usual
   - Take your extra half pill (you've already split or split now)
5. **Every 2 weeks (every other Monday):** Log an extra dose to account for the full pill you consumed via splits
   - This keeps your inventory tracking accurate

**Monthly tracking:**
- 30 days = ~30 logged doses
- Plus 2 extra logged doses = 32 total logged
- Actual consumption: ~34-35 pills (30 daily + 4-5 from splits)
- Adjust when refilling to match actual count

## Example 2: Adenuric - Daily with Skip Days

**Your Schedule:**
- 80mg pill daily
- Skip two days per week
- Goal: Maintain consistent medication levels

### Setup Approach: Single Entry with Specific Days

1. **Tap the + button**
2. **Select "New Medication"**
3. Fill in the form:
   - **Name:** Adenuric
   - **Dosage:** 80mg
   - **Quantity:** (your current stock)

4. **For Frequency:**

   **If Advanced Frequency is available:**
   - Toggle **"Use Advanced Frequency"**: ON
   - **Pattern:** Specific Days
   - **Select Days:** Choose 5 days (skip 2 days)
   - **Times per day:** 1
   - **Reminder Time:** (e.g., 8:00 AM)
   
   **If only Simple Frequency:**
   - **Frequency:** Type "5 days per week - Mon-Fri"

5. **Tap "Save"**

### Recommended Day Selection for Adenuric

For steady medication levels, skip consecutive days:

**Option 1: Skip Weekend (Most Common)**
- Take: Mon, Tue, Wed, Thu, Fri
- Skip: Sat, Sun
- Benefit: Easy to remember (weekdays only)

**Option 2: Skip Mid-Week**
- Take: Mon, Tue, Thu, Fri, Sat
- Skip: Wed, Sun
- Benefit: More even spacing

**Option 3: Skip Evenly Spaced**
- Take: Mon, Tue, Wed, Fri, Sat
- Skip: Thu, Sun
- Benefit: Better distribution throughout week

## Using the App Daily

### Morning Routine

1. **Open BluePills app**
2. **Check your medication list** - medications due today are shown
3. **When you take a dose:**
   - Option A: Tap the medication, view details, tap "Take" button
   - Option B: Use the **"Log Dose"** quick action:
     - Tap the **+** button (bottom-right)
     - Tap the **green "Log Dose"** button
     - Select the medication from the list
     - Confirms the dose was taken

4. **The app automatically:**
   - ✅ Records the time you took it
   - ✅ Decrements your inventory by 1
   - ✅ Updates the quantity display

### Weekly Review

**Check your inventory:**
- Each medication card shows: "Quantity: X"
- When running low, add more stock:
  - Tap the medication
  - Tap "Add Stock"
  - Enter the quantity to add

### Adding Stock

When you refill your prescription:

1. **Tap the medication** in your list
2. **Tap "Add Stock"** button
3. **Enter quantity** (e.g., 90 for a 3-month supply)
4. **Tap "Save"**

## Advanced Tips

### Setting Up Reminders

If reminder functionality is available:
1. Tap the **+** button
2. Select **"Set Reminder"** (orange button)
3. Choose medication and time
4. The app will notify you when it's time to take your medication

### Viewing Medication History

- Tap any medication to see details
- View when you last took each dose
- Track your adherence over time

### Editing Medications

1. **Tap the medication** in your list
2. View the details screen
3. Look for an **Edit** button (usually top-right)
4. Make changes
5. **Save**

### Deleting Medications

1. **Long-press** the medication card
2. Select "Delete" from the menu
   
   OR
   
1. **Tap the red delete icon** on the medication card
2. Confirm deletion

## Troubleshooting

### "Advanced Frequency not available"

If you don't see the advanced frequency toggle, you can still manage your schedule:

**For Thyroxine:**
- Create one entry: "Thyroxine 100mg - Daily + 50mg Mon/Thu"
- Use notes field if available
- Manually track the extra doses

**For Adenuric:**
- Create entry: "Adenuric 80mg - Weekdays only"
- Set frequency to "5 days per week"

### Missed Doses

If you forget to log a dose:
- You can still log it later using "Log Dose"
- The system records the timestamp

### Running Out of Stock

When quantity reaches 0:
- The app will show quantity as 0
- You can still "take" doses, but inventory goes negative
- Add stock as soon as you refill

## Quick Reference Card

### Your Medication Schedule

**Morning (8:00 AM):**
- ☑️ Thyroxine 100mg (Daily)
  - Monday & Thursday: Take 1.5 pills total (1 whole + 0.5 from split pill)
  - Other days: Take 1 pill
- ☑️ Adenuric 80mg (Mon-Fri only)

**Actual Weekly Consumption:**
- Thyroxine 100mg: 8 pills (7 whole + 1 split for extras)
- Adenuric 80mg: 5 pills

**Monthly consumption (30 days):**
- Thyroxine 100mg: ~34 pills (includes splits)
- Adenuric 80mg: ~21-22 pills

**Notes:**
- Keep split Thyroxine half pills in a separate container or marked in the bottle
- When one half is used, split another pill for the next week

### App Quick Actions

| Action | Steps |
|--------|-------|
| Take medication | Tap + → Log Dose → Select medication |
| Add new medication | Tap + → New Medication → Fill form |
| Add stock | Tap medication → Add Stock → Enter amount |
| View history | Tap medication → View details |
| Set reminder | Tap + → Set Reminder → Choose medication |

## Next Steps

1. ✅ Set up your medications using this guide
2. ✅ Add your current stock quantities
3. ✅ Test logging a dose for each medication
4. ✅ Set up reminders (if available)
5. ✅ Use daily for a week to establish routine

## Need Help?

- Check the app's Settings for additional options
- Review the advanced frequency guide: `ADVANCED_FREQUENCY_GUIDE.md`
- The app saves all data locally - your privacy is protected
