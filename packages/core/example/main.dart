import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String html = "Hello World!";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widget from HTML (core)',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Widget from HTML (core)'),
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                onChanged: (value) => setState(() => html = value),
                decoration: const InputDecoration(
                  hintText: 'Enter HTML here',
                ),
              ),
              HtmlWidget(html),
            ],
          ),
        ),
      ),
    );
  }
}
