import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  TextEditingController _controller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  String _response = '';
  List<String> _messages = [];

  // Replace these with your own Watson credentials
  final String apiKey = 'YOUR_API_KEY';
  final String serviceUrl = 'YOUR_SERVICE_URL';
  final String assistantId = 'YOUR_ASSISTANT_ID'; // Your Watson Assistant ID

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage('en-US');
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
        });
        _sendMessageToWatson(result.recognizedWords);
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  Future<void> _sendMessageToWatson(String message) async {
    final url = Uri.parse('$serviceUrl/v1/workspaces/$assistantId/message?version=2021-06-14');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('apikey:$apiKey')),
      },
      body: json.encode({
        'input': {'text': message},
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final botResponse = responseBody['output']['text'][0];
      setState(() {
        _response = botResponse;
        _messages.add("User: $message");
        _messages.add("Bot: $_response");
      });
      _speakResponse(_response);
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  void _speakResponse(String message) async {
    await _flutterTts.speak(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _messages[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: index % 2 == 0 ? Colors.blue : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onSubmitted: (text) {
                      _sendMessageToWatson(text);
                      _controller.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessageToWatson(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
