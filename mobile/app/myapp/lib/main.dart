import 'package:flutter/material.dart';
import 'package:myapp/screens/test_theme/login.dart' show LoginScreen;
import 'screens/test_theme/test_appbar.dart';
import 'screens/test_theme/test_bottomsheet.dart';
import 'screens/test_theme/test_button.dart';
import 'screens/test_theme/test_checkbox.dart';
import 'screens/test_theme/test_formfield.dart';
import 'screens/test_theme/test_showdialog.dart';
import 'screens/test_theme/test_text.dart';
import 'utils/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
