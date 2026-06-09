import 'package:cardly_app/core/cubit/app_loading_cubit.dart';
import 'package:cardly_app/core/widgets/app_loading_overlay.dart';
import 'package:cardly_app/injection_container.dart';
import 'package:cardly_app/core/theme/app_theme.dart';
import 'package:cardly_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocProvider<AppLoadingCubit>(
      create: (_) => getIt<AppLoadingCubit>(),
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return AppLoadingOverlay(child: child ?? const SizedBox());
        },
      ),
    );
  }
}
