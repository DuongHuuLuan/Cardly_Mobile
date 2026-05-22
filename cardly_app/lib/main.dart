import 'package:cardly_app/injection_container.dart';
import 'package:cardly_app/core/theme/app_theme.dart';
import 'package:cardly_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await init();
  runApp(const CardlyApp());
}

class CardlyApp extends StatelessWidget {
  const CardlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
