import 'package:flutter/material.dart';
import 'package:climate/screens/loading_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:climate/services/location.dart';

class DarkMode with ChangeNotifier {
  static bool _darkMode = true;

  ThemeData current() {
    return _darkMode ? ThemeData.dark() : ThemeData.light();
  }

  bool currentbool() {
    return _darkMode;
  }

  void toggleMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }
}

void main() {
  return runApp(ChangeNotifierProvider(create: (_) => DarkMode(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DarkMode _mode = Provider.of<DarkMode>(context);
    return MaterialApp(
      theme: _mode.current(),
      home: LoadingScreen(),
    );
  }
}
