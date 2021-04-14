import 'package:se_len_den/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:se_len_den/Screens/root.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return ThemeSwitcher();
      },
      child: ThemedMaterialApp(),
    );
  }
}

class ThemedMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeSwitcher>();
    return MaterialApp(
      theme: theme.getTheme(),
      debugShowCheckedModeBanner: false,
      title: 'LenDen',
      home: Scaffold(resizeToAvoidBottomInset: true, body: Root()),
    );
  }
}
