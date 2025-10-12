import 'package:flutter/material.dart';

class OperatingHoursWidget extends StatefulWidget {
  final List<String> operatingDays;
  final TimeOfDay openingTime;
  final TimeOfDay closingTime;
  final Function(List<String>) onOperatingDaysChanged;
  final Function(TimeOfDay) onOpeningTimeChanged;
  final Function(TimeOfDay) onClosingTimeChanged;

  const OperatingHoursWidget({
    Key? key,
    required this.operatingDays,
    required this.openingTime,
    required this.closingTime,
    required this.onOperatingDaysChanged,
    required this.onOpeningTimeChanged,
    required this.onClosingTimeChanged,
  }) : super(key: key);

  @override
  State<OperatingHoursWidget> createState() => _OperatingHoursWidgetState();
}

class _OperatingHoursWidgetState extends State<OperatingHoursWidget> {
  final List<String> _allDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  void _toggleDay(String day) {
    final newDays = List<String>.from(widget.operatingDays);
    if (newDays.contains(day)) {
      newDays.remove(day);
    } else {
      newDays.add(day);
    }
    widget.onOperatingDaysChanged(newDays);
  }

  Future<void> _selectOpeningTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.openingTime,
    );
    if (picked != null) {
      widget.onOpeningTimeChanged(picked);
    }
  }

  Future<void> _selectClosingTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.closingTime,
    );
    if (picked != null) {
      widget.onClosingTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Operating Hours',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),

            // Days Selection
            const Text(
              'Operating Days:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allDays.map((day) {
                final isSelected = widget.operatingDays.contains(day);
                return FilterChip(
                  label: Text(day),
                  selected: isSelected,
                  onSelected: (_) => _toggleDay(day),
                  selectedColor: Colors.blue[100],
                  checkmarkColor: Colors.blue,
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Time Selection
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Opening Time:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: _selectOpeningTime,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.black87,
                        ),
                        child: Text(
                          '${widget.openingTime.format(context)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Closing Time:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: _selectClosingTime,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.black87,
                        ),
                        child: Text(
                          '${widget.closingTime.format(context)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}