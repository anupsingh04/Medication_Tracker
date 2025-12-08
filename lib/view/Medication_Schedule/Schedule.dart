import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controller/medication_service.dart';
import '../../model/medication.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  // Calendar
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  final DateTime _firstDay = DateTime.utc(2000, 1, 1);
  final DateTime _lastDay = DateTime.utc(2030, 31, 31);
  DateTime _selectedDay = DateTime.now();

  List<MedicationScheduleItem> _scheduleItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSchedule(_selectedDay);
  }

  Future<void> _fetchSchedule(DateTime date) async {
    setState(() {
      _isLoading = true;
    });
    List<MedicationScheduleItem> items = await MedicationService().getDueMedications(date);
    setState(() {
      _scheduleItems = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Medication Schedule',
            style: GoogleFonts.fredoka(
                fontSize: 28,
                fontWeight: FontWeight.normal,
                color: Colors.black)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _fetchSchedule(selectedDay);
              }
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
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF809BCE),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: const Color(0xFF809BCE).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _scheduleItems.isEmpty
                ? Center(
                    child: Text(
                      "No medications scheduled for this day.",
                      style: GoogleFonts.signikaNegative(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _scheduleItems.length,
                    itemBuilder: (context, index) {
                      return _buildScheduleCard(_scheduleItems[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(MedicationScheduleItem item) {
    Color statusColor;
    switch(item.status) {
      case 'Taken': statusColor = Colors.green; break;
      case 'Skipped': statusColor = Colors.red; break;
      case 'Snoozed': statusColor = Colors.orange; break;
      default: statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Time Section
            Container(
              padding: const EdgeInsets.all(16),
              width: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF809BCE).withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  item.time,
                  style: GoogleFonts.signikaNegative(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF809BCE),
                  ),
                ),
              ),
            ),
            // Divider
            Container(width: 1, color: Colors.grey.shade200),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.medication.medName,
                      style: GoogleFonts.signikaNegative(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.medication.dosage ?? ''} ${item.medication.dosageUnit ?? ''}',
                      style: GoogleFonts.signikaNegative(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: statusColor),
                        const SizedBox(width: 5),
                        Text(
                          item.status,
                          style: GoogleFonts.signikaNegative(
                            fontSize: 14,
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
