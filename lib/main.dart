import 'package:flutter/material.dart';
import 'package:shop/routes/route.dart' as route;

import 'database/dbhelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();
  await DatabaseHelper.instance.initializProducts();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(Object context) {
    return MaterialApp(
      onGenerateRoute: route.controller,
      initialRoute: route.loginpage,
      debugShowCheckedModeBanner: false,
    );
  }
}
