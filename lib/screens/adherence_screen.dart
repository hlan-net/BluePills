/// Adherence tracking screen for medication compliance monitoring.
///
/// This library provides the UI for viewing medication adherence statistics
/// with calendar visualization and percentage calculations for different time periods.
library;

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/medication_log.dart';
import 'package:bluepills/models/medication.dart';
import 'package:bluepills/l10n/app_localizations.dart';

/// A stateful widget that displays the medication adherence tracking screen.
///
/// Shows a calendar with markers for days when medications were taken
/// and displays adherence statistics for the last 7 and 30 days.
class AdherenceScreen extends StatefulWidget {
  const AdherenceScreen({super.key});

  @override
  State<AdherenceScreen> createState() => _AdherenceScreenState();
}

/// State class for the adherence screen.
///
/// Manages calendar state, medication data, and adherence calculations
/// for displaying compliance statistics and visual indicators.
class _AdherenceScreenState extends State<AdherenceScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Future<List<dynamic>> _data;
  List<Medication> _allMedications = [];
  List<MedicationLog> _allLogs = [];

  @override
  void initState() {
    super.initState();
    _data = _fetchAllData();
  }

  /// Fetches all medications and medication logs from the database.
  ///
  /// Returns a list containing medications and logs for adherence calculations.
  Future<List<dynamic>> _fetchAllData() async {
    final medications = await DatabaseHelper().getMedications();
    final logs = await DatabaseHelper().getAllLogs();
    setState(() {
      _allMedications = medications;
      _allLogs = logs;
    });
    return [medications, logs];
  }

  /// Calculates adherence percentage for a given time period.
  ///
  /// Compares the number of doses taken against expected doses based on
  /// medication frequency patterns. Returns a percentage from 0 to 100.
  double _calculateAdherence(Duration duration) {
    final now = DateTime.now();
    final startDate = now.subtract(duration);
    int expectedDoses = 0;
    int takenDoses = 0;

    for (final medication in _allMedications) {
      if (medication.frequencyPattern != null) {
        for (int i = 0; i < duration.inDays; i++) {
          final day = startDate.add(Duration(days: i));
          if (medication.frequencyPattern!.shouldTakeOnDate(
            day,
            medication.createdAt,
          )) {
            expectedDoses += medication.frequencyPattern!.timesPerDay;
          }
        }
      }
    }

    takenDoses = _allLogs
        .where(
          (log) =>
              log.timestamp.isAfter(startDate) && log.timestamp.isBefore(now),
        )
        .length;

    if (expectedDoses == 0) {
      return 100.0;
    }

    return (takenDoses / expectedDoses) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.medicationAdherence)),
      body: FutureBuilder<List<dynamic>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(localizations.noDataAvailable));
          }

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    final logsOnDay = _allLogs
                        .where((log) => isSameDay(log.timestamp, date))
                        .toList();
                    if (logsOnDay.isNotEmpty) {
                      return Positioned(
                        bottom: 1,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      localizations.adherenceStatistics,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAdherenceCard(
                          localizations.last7Days,
                          _calculateAdherence(const Duration(days: 7)),
                        ),
                        _buildAdherenceCard(
                          localizations.last30Days,
                          _calculateAdherence(const Duration(days: 30)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Builds a card widget displaying adherence statistics.
  ///
  /// Shows the title and percentage with color-coded indicators based on
  /// the adherence level (green for high, orange for medium, red for low).
  Widget _buildAdherenceCard(String title, double percentage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: _getAdherenceColor(percentage),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the appropriate color for the adherence percentage.
  ///
  /// Returns green for 90%+, orange for 70-89%, and red for below 70%.
  Color _getAdherenceColor(double percentage) {
    if (percentage >= 90) {
      return Colors.green;
    } else if (percentage >= 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
