/// Frequency selector widget for medication scheduling.
///
/// Provides an intuitive UI for selecting complex medication schedules
/// including specific days of the week and custom frequencies.
library;

import 'package:flutter/material.dart';
import 'package:bluepills/models/frequency_pattern.dart';

/// A widget that allows users to select frequency patterns for medications.
class FrequencySelector extends StatefulWidget {
  /// The initial frequency pattern to display
  final FrequencyPattern? initialPattern;

  /// Callback when frequency pattern changes
  final ValueChanged<FrequencyPattern> onPatternChanged;

  const FrequencySelector({
    super.key,
    this.initialPattern,
    required this.onPatternChanged,
  });

  @override
  State<FrequencySelector> createState() => _FrequencySelectorState();
}

class _FrequencySelectorState extends State<FrequencySelector> {
  late FrequencyType _selectedType;
  late Set<int> _selectedDays;
  late int _timesPerDay;
  late int _intervalDays;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialPattern?.type ?? FrequencyType.daily;
    _selectedDays = widget.initialPattern?.daysOfWeek.toSet() ?? {};
    _timesPerDay = widget.initialPattern?.timesPerDay ?? 1;
    _intervalDays = widget.initialPattern?.intervalDays ?? 1;
  }

  void _updatePattern() {
    FrequencyPattern pattern;
    switch (_selectedType) {
      case FrequencyType.daily:
        pattern = FrequencyPattern.daily(timesPerDay: _timesPerDay);
        break;
      case FrequencyType.specificDays:
        pattern = FrequencyPattern.specificDays(
          daysOfWeek: _selectedDays.toList()..sort(),
          timesPerDay: _timesPerDay,
        );
        break;
      case FrequencyType.everyNDays:
        pattern = FrequencyPattern.everyNDays(
          days: _intervalDays,
          timesPerDay: _timesPerDay,
        );
        break;
      case FrequencyType.asNeeded:
        pattern = FrequencyPattern(type: FrequencyType.asNeeded);
        break;
    }
    widget.onPatternChanged(pattern);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Frequency type selector
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Daily'),
              selected: _selectedType == FrequencyType.daily,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedType = FrequencyType.daily;
                    _updatePattern();
                  });
                }
              },
            ),
            ChoiceChip(
              label: const Text('Specific Days'),
              selected: _selectedType == FrequencyType.specificDays,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedType = FrequencyType.specificDays;
                    if (_selectedDays.isEmpty) {
                      _selectedDays = {1}; // Default to Monday
                    }
                    _updatePattern();
                  });
                }
              },
            ),
            ChoiceChip(
              label: const Text('Every N Days'),
              selected: _selectedType == FrequencyType.everyNDays,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedType = FrequencyType.everyNDays;
                    _updatePattern();
                  });
                }
              },
            ),
            ChoiceChip(
              label: const Text('As Needed'),
              selected: _selectedType == FrequencyType.asNeeded,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedType = FrequencyType.asNeeded;
                    _updatePattern();
                  });
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Day selector for specificDays
        if (_selectedType == FrequencyType.specificDays) ...[
          const Text(
            'Select days:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _DayChip(
                label: 'Mon',
                day: 1,
                isSelected: _selectedDays.contains(1),
                onToggle: (day, selected) {
                  setState(() {
                    if (selected) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                    _updatePattern();
                  });
                },
              ),
              _DayChip(
                label: 'Tue',
                day: 2,
                isSelected: _selectedDays.contains(2),
                onToggle: (day, selected) {
                  setState(() {
                    if (selected) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                    _updatePattern();
                  });
                },
              ),
              _DayChip(
                label: 'Wed',
                day: 3,
                isSelected: _selectedDays.contains(3),
                onToggle: (day, selected) {
                  setState(() {
                    if (selected) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                    _updatePattern();
                  });
                },
              ),
              _DayChip(
                label: 'Thu',
                day: 4,
                isSelected: _selectedDays.contains(4),
                onToggle: (day, selected) {
                  setState(() {
                    if (selected) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                    _updatePattern();
                  });
                },
              ),
              _DayChip(
                label: 'Fri',
                day: 5,
                isSelected: _selectedDays.contains(5),
                onToggle: (day, selected) {
                  setState(() {
                    if (selected) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                    _updatePattern();
                  });
                },
              ),
              _DayChip(
                label: 'Sat',
                day: 6,
                isSelected: _selectedDays.contains(6),
                onToggle: (day, selected) {
                  setState(() {
                    if (selected) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                    _updatePattern();
                  });
                },
              ),
              _DayChip(
                label: 'Sun',
                day: 7,
                isSelected: _selectedDays.contains(7),
                onToggle: (day, selected) {
                  setState(() {
                    if (selected) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                    _updatePattern();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Interval selector for everyNDays
        if (_selectedType == FrequencyType.everyNDays) ...[
          Row(
            children: [
              const Text('Every'),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: DropdownButton<int>(
                  value: _intervalDays,
                  isExpanded: true,
                  items: List.generate(14, (index) => index + 1)
                      .map(
                        (days) =>
                            DropdownMenuItem(value: days, child: Text('$days')),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _intervalDays = value;
                        _updatePattern();
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(_intervalDays == 1 ? 'day' : 'days'),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Times per day selector (not for asNeeded)
        if (_selectedType != FrequencyType.asNeeded) ...[
          Row(
            children: [
              const Text('Times per day:'),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: DropdownButton<int>(
                  value: _timesPerDay,
                  isExpanded: true,
                  items: List.generate(6, (index) => index + 1)
                      .map(
                        (times) => DropdownMenuItem(
                          value: times,
                          child: Text('$times'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _timesPerDay = value;
                        _updatePattern();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  final String label;
  final int day;
  final bool isSelected;
  final Function(int day, bool selected) onToggle;

  const _DayChip({
    required this.label,
    required this.day,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onToggle(day, selected),
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
