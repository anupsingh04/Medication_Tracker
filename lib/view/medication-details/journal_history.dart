import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JournalHistoryWidget extends StatefulWidget {
  const JournalHistoryWidget({Key? key}) : super(key: key);

  @override
  _JournalHistoryWidgetState createState() => _JournalHistoryWidgetState();
}

class _JournalHistoryWidgetState extends State<JournalHistoryWidget> {
  DateTime selectedDate = DateTime.now();

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sample Timeline UI
            _buildTimelineItem(
              time: "08:00 AM",
              medName: "Benzonatate",
              status: "Taken",
              statusColor: const Color(0xFFD1EBDE),
              textColor: const Color(0xFF2E7D32),
            ),
            _buildTimelineItem(
              time: "10:30 AM",
              medName: "Panadol",
              status: "Skipped",
              statusColor: const Color(0xFFEAC4D5),
              textColor: const Color(0xFFC62828),
            ),
            _buildTimelineItem(
              time: "01:00 PM",
              medName: "Vitamin C",
              status: "Taken",
              statusColor: const Color(0xFFD1EBDE),
              textColor: const Color(0xFF2E7D32),
            ),
            _buildTimelineItem(
              time: "08:00 PM",
              medName: "Antibiotics",
              status: "Pending",
              statusColor: const Color(0xFFFFF3E0),
              textColor: const Color(0xFFEF6C00),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String time,
    required String medName,
    required String status,
    required Color statusColor,
    required Color textColor,
    bool isLast = false,
  }) {
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
                height: 80, // Adjust height based on content
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
                  status == "Taken"
                      ? Icons.check_circle_outline
                      : status == "Skipped"
                          ? Icons.cancel_outlined
                          : Icons.access_time,
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
