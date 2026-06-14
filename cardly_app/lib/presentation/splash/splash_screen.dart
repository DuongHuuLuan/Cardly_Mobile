import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/widgets/ripple_wave.dart';
import 'package:cardly_app/domain/usecase/deep_link/clear_pending_deep_link_usecase.dart';
import 'package:cardly_app/domain/usecase/deep_link/resolve_pending_deep_link_usecase.dart';
import 'package:cardly_app/injection_container.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  static const routerName = "/splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    context.read<AuthCubit>().getUser();
  }

  Future<void> _resolveDeepLink() async {
    final resolveUsecase = getIt<ResolvePendingDeepLinkUsecase>();
    final clearUsecase = getIt<ClearPendingDeepLinkUsecase>();
    final result = await resolveUsecase.call();
    if (!mounted) return;

    result.fold((_) => context.goToHome(), (link) {
      if (link != null) {
        clearUsecase.call();
        context.go(link.router);
      } else {
        context.goToHome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          _resolveDeepLink();
        } else if (state.status == AuthStatus.unauthenticated) {
          context.goToOnboarding();
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.primary,
        body: Center(
          child: RippleWave(color: AppColor.white, size: screenWidth * 0.5),
        ),
      ),
    );
  }
}
