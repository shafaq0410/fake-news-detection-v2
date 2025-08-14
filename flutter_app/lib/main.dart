import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fake News Detector',
      theme: ThemeData(fontFamily: 'Roboto'),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  bool _loading = false;
  String _prediction = '';
  String _confidence = '';
  String _snippet = '';

  Future<void> checkNews() async {
    final backendUrl = 'http://127.0.0.1:5000/predict';
    final body = json.encode({
      "text": _textController.text.isNotEmpty ? _textController.text : null,
      "url": _urlController.text.isNotEmpty ? _urlController.text : null
    });

    setState(() {
      _loading = true;
      _prediction = '';
      _confidence = '';
      _snippet = '';
    });

    try {
      final resp = await http.post(Uri.parse(backendUrl),
          headers: {"Content-Type": "application/json"}, body: body);
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        setState(() {
          _prediction = data['prediction'] ?? 'N/A';
          _confidence = data['confidence'] != null
              ? (data['confidence'] * 100).toStringAsFixed(2) + '%'
              : '';
          _snippet = data['text_snippet'] ?? '';
        });
      } else {
        setState(() {
          _prediction = 'Error: ' + resp.body;
        });
      }
    } catch (e) {
      setState(() {
        _prediction = 'Network error: ' + e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Stack(
              children: [
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/earth_bg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome to",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                      Text("Fake News Detector",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 320,
                        child: Text(
                          "Paste text or provide a URL and we'll check if it's real or fake news.",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(8)),
                    ),
                    child: Text(
                      "Exclusive",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),

            // Input Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: _textController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          labelText: 'Paste article text',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text("OR", style: AppTextStyles.label),
                      SizedBox(height: 12),
                      TextField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          labelText: 'Article URL',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : checkNews,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.indigo,
                          ),
                          child: _loading
                              ? CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2)
                              : Text("Check",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Result Card
            if (_prediction.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: _prediction.toLowerCase().contains('fake')
                      ? AppColors.cardFake
                      : AppColors.cardReal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Prediction: $_prediction",
                              style: _prediction.toLowerCase().contains('fake')
                                  ? AppTextStyles.resultFake
                                  : AppTextStyles.resultReal),
                          SizedBox(height: 8),
                          Text("Confidence: $_confidence",
                              style: AppTextStyles.label),
                          SizedBox(height: 8),
                          Text("Snippet:", style: AppTextStyles.label),
                          Text(_snippet, style: AppTextStyles.content),
                        ]),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
