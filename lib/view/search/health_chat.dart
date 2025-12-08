import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthChatWidget extends StatefulWidget {
  const HealthChatWidget({Key? key}) : super(key: key);

  @override
  _HealthChatWidgetState createState() => _HealthChatWidgetState();
}

class _HealthChatWidgetState extends State<HealthChatWidget> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = []; // {'role': 'user'|'bot', 'text': '...'}
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add a welcome message
    _messages.add({
      'role': 'bot',
      'text': 'Hello! I am your Health Assistant. Ask me about symptoms, medications, or general health advice.'
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
    });
    _scrollToBottom();

    // Simulate AI delay
    Future.delayed(const Duration(seconds: 1), () {
      String response = _getBotResponse(text);
      if (mounted) {
        setState(() {
          _messages.add({'role': 'bot', 'text': response});
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool _isHealthRelated(String text) {
    text = text.toLowerCase();
    // Whitelist keywords
    List<String> healthKeywords = [
      'health', 'doctor', 'pain', 'headache', 'fever', 'medicine', 'pill', 'dose',
      'drug', 'symptom', 'sick', 'ill', 'hospital', 'nurse', 'medical', 'blood',
      'pressure', 'heart', 'stomach', 'ache', 'flu', 'cold', 'covid', 'vitamin',
      'diet', 'exercise', 'weight', 'body', 'swallow', 'throat', 'cough', 'sneeze',
      'diabetes', 'insulin', 'sugar', 'bone', 'fracture', 'burn', 'cut', 'bleed',
      'medimate', 'app', 'help', 'hi', 'hello' // Allow greetings to pass to default handler
    ];

    // Blacklist keywords (stronger filter)
    List<String> nonHealthKeywords = [
      'code', 'programming', 'python', 'java', 'finance', 'stock', 'money',
      'president', 'politics', 'movie', 'song', 'weather', 'sport', 'game',
      'math', 'history', 'geography'
    ];

    for (var word in nonHealthKeywords) {
      if (text.contains(word)) return false;
    }

    for (var word in healthKeywords) {
      if (text.contains(word)) return true;
    }

    // If no specific keyword, check length. If short generic query, might reject.
    // But let's reject by default to be safe "Health Bot Only".
    return false;
  }

  String _getBotResponse(String text) {
    if (!_isHealthRelated(text)) {
      return "I am a Health Bot. I can only answer health-related questions. Please ask about symptoms, medications, or general health advice.";
    }

    text = text.toLowerCase();

    if (text.contains('hi') || text.contains('hello')) {
      return "Hi there! How can I help with your health today?";
    }

    if (text.contains('headache')) {
      return "For a headache, stay hydrated and rest in a quiet, dark room. Common over-the-counter pain relievers like Paracetamol or Ibuprofen may help. If it persists, consult a doctor.";
    }
    if (text.contains('fever')) {
      return "A fever helps your body fight infections. Drink plenty of fluids. If your temperature exceeds 39°C (102°F) or lasts more than 3 days, seek medical attention.";
    }
    if (text.contains('dosage') || text.contains('how many')) {
      return "I cannot provide specific dosage instructions. Please check the medication label or consult your pharmacist/doctor.";
    }
    if (text.contains('swallow')) {
      return "If you have trouble swallowing pills, try the 'Pop Bottle' method or lean forward while swallowing. Crushing pills should only be done if the medication allows it.";
    }
    if (text.contains('cough')) {
      return "Stay hydrated. Warm tea with honey can soothe a throat. If the cough persists for more than a few weeks or you cough up blood, see a doctor.";
    }
    if (text.contains('stomach')) {
      return "Stomach aches can be caused by many things. Try to avoid solid foods for a few hours. Sip water or clear fluids. If pain is severe, go to the hospital.";
    }

    return "That sounds like a health concern. While I am an AI, I recommend monitoring your symptoms. If you feel unwell, please visit a clinic.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Bot', style: GoogleFonts.fredoka(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF809BCE) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isUser ? const Radius.circular(12) : Radius.zero,
                        bottomRight: isUser ? Radius.zero : const Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      msg['text']!,
                      style: GoogleFonts.signikaNegative(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Ask a health question...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF809BCE),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => _handleSubmitted(_textController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
