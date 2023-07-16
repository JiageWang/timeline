import 'package:flutter/material.dart';
import 'package:timeline/timeline/widget/timeline_item.dart';

import 'timeline/timeline.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    print("home, ${DateTime(2010, 1, 2)}");

    return Scaffold(
      body: Timeline(items: [
        TimelineItem(dateTime: DateTime(2010, 1, 2), child: Container(height: 100, color: Colors.red,)),
        TimelineItem(dateTime: DateTime(2010, 1, 5), child: Container(height: 100, color: Colors.red,)),
        TimelineItem(dateTime: DateTime(2010, 1, 8), child: Container(height: 100, color: Colors.red,)),
        TimelineItem(dateTime: DateTime(2010, 1, 19), child: Container(height: 100, color: Colors.red,)),
      ]),
    );
  }
}
