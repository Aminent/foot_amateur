import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'services/token_storage.dart';
import 'state/auth_controller.dart';
import 'theme/app_theme.dart';
import 'ui/home_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthController _auth;

  @override
  void initState() {
    super.initState();
    _auth = AuthController(TokenStorage());
    _auth.bootstrap();
  }

  @override
  void dispose() {
    _auth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foot Amateur Mobile',
      theme: AppTheme.buildTheme(),
      home: HomeRouter(auth: _auth),
      debugShowCheckedModeBanner: false,
    );
  }
}
