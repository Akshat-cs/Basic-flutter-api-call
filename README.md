# classico

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

import 'dart:convert'; // Add this import for jsonDecode

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
const HomeScreen({Key? key}) : super(key: key);

@override
State<HomeScreen> createState() => \_HomeScreenState();
}

class \_HomeScreenState extends State<HomeScreen> {
List<dynamic> users = [];

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Rest Api call'),
),
body: ListView.builder(
itemCount: users.length,
itemBuilder: (context, index) {
final user = users[index];
final name = user['name']['first'];
final email = user['email'];
return ListTile(
leading: CircleAvatar(child: Text('${index + 1}')),
title: Text(name),
subtitle: Text(email),
);
},
),
floatingActionButton: FloatingActionButton(
onPressed: fetchUsers,
child: Icon(Icons.refresh),
),
);
}

void fetchUsers() async {
print('fetchUsers called');
const url = 'https://randomuser.me/api/?results=10';
final uri = Uri.parse(url);
final response = await http.get(uri);
final body = response.body;
final json = jsonDecode(body); // Fixed jsonDecode
setState(() {
users = json['results'];
});
print('fetchUsers Completed');
}
}
