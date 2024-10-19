import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sdl_hackathon/app.dart';
import 'package:sdl_hackathon/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
