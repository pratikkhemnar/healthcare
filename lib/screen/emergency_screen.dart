import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// Kafka library for streaming data (example, but needs backend implementation)
// import 'dart:convert';
import 'package:http/http.dart' as http;

class EmergencyAlertsScreen extends StatefulWidget {
  @override
  _EmergencyAlertsScreenState createState() => _EmergencyAlertsScreenState();
}

class _EmergencyAlertsScreenState extends State<EmergencyAlertsScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<String> _alerts = []; // List to store incoming alerts

  @override
  void initState() {
    super.initState();

    // Initialize Firebase Messaging for push notifications
    _initializeFirebaseMessaging();
  }

  // Initialize Firebase Messaging for push notifications
  void _initializeFirebaseMessaging() async {
    // Request permission for iOS devices
    await _firebaseMessaging.requestPermission();

    // Handle incoming push notifications when app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming push notifications
      _handleIncomingAlert(message.data);
    });

    // For background and terminated state, use the following (in the main entry point):
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }

  // Background message handler for when app is terminated
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    // Handle the message here
    print("Background message received: ${message.data}");
  }

  // Handle incoming alert
  void _handleIncomingAlert(Map<String, dynamic> alert) {
    setState(() {
      String alertMessage = 'Alert: ${alert['message']} - Severity: ${alert['severity']}';
      _alerts.add(alertMessage);
    });

    // Send a push notification if severity is critical
    if (alert['severity'] == 'critical') {
      _sendPushNotification(alert);
    }
  }

  // Send push notification using IBM Push Notifications (via Firebase or IBM)
  void _sendPushNotification(Map<String, dynamic> alert) async {
    // Here you need to get the actual user device token
    String userDeviceToken = 'user-device-token'; // Replace this with actual token

    final response = await http.post(
      Uri.parse('https://your-ibm-push-notification-endpoint'),  // Replace with your push notification endpoint
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'notification': {
          'title': 'Critical Alert',
          'body': alert['message'],
        },
        'to': userDeviceToken, // Use the actual device token
      }),
    );

    if (response.statusCode == 200) {
      print('Push notification sent successfully!');
    } else {
      print('Failed to send push notification');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emergency Alerts')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _alerts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_alerts[index]),
                  tileColor: _alerts[index].contains('Severity: critical')
                      ? Colors.red
                      : Colors.yellow, // Categorize by severity
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
