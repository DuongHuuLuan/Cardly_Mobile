import 'package:cardly_app/core/widgets/app_alert_dialog.dart';
import 'package:cardly_app/presentation/auth/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SessionExpiredScreen extends StatefulWidget {
  static const routerName = '/session-expired';
  const SessionExpiredScreen({super.key});
  @override
  State<SessionExpiredScreen> createState() => _SessionExpiredScreenState();
}

class _SessionExpiredScreenState extends State<SessionExpiredScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showDialog());
  }

  Future<void> _showDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppAlertDialog(
        title: "Session Expired",
        message: "Your session has expired. Please login again.",
        buttonLabel: "OK",
        icon: Icons.timer_off_outlined,
        onConfirm: () {
          Navigator.pop(ctx);
          context.go(LoginPage.routerName);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}
