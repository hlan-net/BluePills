import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:bluepills/database/database_helper.dart';
import 'package:bluepills/models/medication_log.dart';
import 'package:bluepills/models/medication.dart';

class AdherenceScreen extends StatefulWidget {
  const AdherenceScreen({super.key});

  @override
  State<AdherenceScreen> createState() => _AdherenceScreenState();
}

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

  Future<List<dynamic>> _fetchAllData() async {
    final medications = await DatabaseHelper().getMedications();
    final logs = await DatabaseHelper().getAllLogs();
    setState(() {
      _allMedications = medications;
      _allLogs = logs;
    });
    return [medications, logs];
  }

  double _calculateAdherence(Duration duration) {
    final now = DateTime.now();
    final startDate = now.subtract(duration);
    int expectedDoses = 0;
    int takenDoses = 0;

    for (final medication in _allMedications) {
      if (medication.frequencyPattern != null) {
        for (int i = 0; i < duration.inDays; i++) {
          final day = startDate.add(Duration(days: i));
          if (medication.frequencyPattern!.shouldTakeOnDate(day, medication.createdAt)) {
            expectedDoses += medication.frequencyPattern!.timesPerDay;
          }
        }
      }
    }

    takenDoses = _allLogs
        .where((log) =>
            log.timestamp.isAfter(startDate) && log.timestamp.isBefore(now))
        .length;

    if (expectedDoses == 0) {
      return 100.0;
    }

    return (takenDoses / expectedDoses) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Adherence'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
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
                      'Adherence Statistics',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAdherenceCard(
                            'Last 7 Days', _calculateAdherence(const Duration(days: 7))),
                        _buildAdherenceCard(
                            'Last 30 Days', _calculateAdherence(const Duration(days: 30))),
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
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: _getAdherenceColor(percentage)),
            ),
          ],
        ),
      ),
    );
  }

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
