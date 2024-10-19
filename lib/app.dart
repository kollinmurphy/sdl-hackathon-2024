import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdl_hackathon/firebase.dart';
import 'package:sdl_hackathon/home_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initRootGame();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'SDL Hackathon',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(body: const HomePage()),
      ),
    );
  }
}
