import 'package:aphrodite/pages/login.dart';
import 'package:aphrodite/utilitities/theme.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppTheme>(
          create: (context) => AppTheme(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}


class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: context.watch<AppTheme>().currentTheme,
      home: const LoginForm(),
    );
  }
}