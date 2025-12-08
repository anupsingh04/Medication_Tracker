import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controller/medication_service.dart';
import '../../model/medication.dart';

class JournalHistoryWidget extends StatefulWidget {
  const JournalHistoryWidget({Key? key}) : super(key: key);

  @override
  _JournalHistoryWidgetState createState() => _JournalHistoryWidgetState();
}

class _JournalHistoryWidgetState extends State<JournalHistoryWidget> {
  DateTime selectedDate = DateTime.now();
  List<MedicationScheduleItem> historyItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => isLoading = true);
    // Ensure we are comparing dates correctly without time component for the key logic inside service if needed,
    // but service handles it.
    List<MedicationScheduleItem> items = await MedicationService().getDueMedications(selectedDate);

    setState(() {
      historyItems = items;
      isLoading = false;
    });
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'History',
          style: GoogleFonts.fredoka(color: Colors.black, fontSize: 28),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                });
                _loadHistory();
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildDateHeader(),
          Expanded(
            child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : historyItems.isEmpty
                  ? Center(child: Text("No medications for this day.", style: GoogleFonts.signikaNegative(fontSize: 18, color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: historyItems.length,
                      itemBuilder: (context, index) {
                        final item = historyItems[index];
                        return _buildTimelineItem(
                          time: item.time,
                          medName: item.medication.medName,
                          status: item.status,
                          isLast: index == historyItems.length - 1,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => _changeDate(-1),
          ),
          Text(
            DateFormat('EEEE, MMM d').format(selectedDate),
            style: GoogleFonts.signikaNegative(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 20),
            onPressed: () => _changeDate(1),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String time,
    required String medName,
    required String status,
    bool isLast = false,
  }) {
    Color statusColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'Taken':
        statusColor = const Color(0xFFD1EBDE);
        textColor = const Color(0xFF2E7D32);
        icon = Icons.check_circle_outline;
        break;
      case 'Skipped':
        statusColor = const Color(0xFFEAC4D5);
        textColor = const Color(0xFFC62828);
        icon = Icons.cancel_outlined;
        break;
      case 'Snoozed':
        statusColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFEF6C00);
        icon = Icons.snooze;
        break;
      default: // Pending
        statusColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        icon = Icons.access_time;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Column
        SizedBox(
          width: 80,
          child: Text(
            time,
            style: GoogleFonts.signikaNegative(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        // Line & Dot
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                border: Border.all(color: textColor, width: 2),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 80,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medName,
                      style: GoogleFonts.signikaNegative(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status,
                      style: GoogleFonts.signikaNegative(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Icon(
                  icon,
                  color: textColor,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
