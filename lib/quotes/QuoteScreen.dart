import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  List<String> quotes = [
    "The secret of getting ahead is getting started. – Mark Twain",
    "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
    "Believe you can and you're halfway there. – Theodore Roosevelt",
    "Don't watch the clock; do what it does. Keep going. – Sam Levenson",
    "Act as if what you do makes a difference. It does. – William James",
    "Focus on being productive instead of busy. – Tim Ferriss",
    "Do what you can, with what you have, where you are. – Theodore Roosevelt",
    "Efficiency is doing things right; effectiveness is doing the right things. – Peter Drucker",
    "If you spend too much time thinking about a thing, you’ll never get it done. – Bruce Lee",
    "Small deeds done are better than great deeds planned. – Peter Marshall",
    "Creativity is intelligence having fun. – Albert Einstein",
    "Do one thing every day that scares you. – Eleanor Roosevelt",
    "Innovation distinguishes between a leader and a follower. – Steve Jobs",
    "An idea that is not dangerous is unworthy of being called an idea at all. – Oscar Wilde",
    "Simplicity is the ultimate sophistication. – Leonardo da Vinci"
  ];

  String currentQuote = "";
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _changeQuote();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _changeQuote();
    });
  }

  void _changeQuote() {
    final random = Random();
    setState(() {
      currentQuote = quotes[random.nextInt(quotes.length)];
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Auto-Changing Quotes")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentQuote,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Text(
                "Quote changes every 5 seconds...",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
