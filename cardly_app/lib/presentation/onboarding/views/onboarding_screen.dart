import 'package:cardly_app/core/constants/app_transition.dart';
import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_animated_switcher.dart';
import 'package:cardly_app/core/widgets/app_indicator.dart';
import 'package:cardly_app/core/widgets/onboarding_icon.dart';
import 'package:cardly_app/domain/Entities/onboarding.dart';
import 'package:cardly_app/presentation/auth/view/login_screen.dart';
import 'package:cardly_app/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:cardly_app/presentation/onboarding/cubit/onboarding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

extension OnboardingNavigation on BuildContext {
  void goToOnboarding() => go('/onboarding');
}

IconData _resolveIcon(String? name) {
  switch (name) {
    case 'qr_code_scanner':
      return Icons.center_focus_strong;
    case 'auto_awesome':
      return Icons.auto_awesome_outlined;
    case 'share':
      return Icons.share_outlined;
    default:
      return Icons.help_outline;
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next(List<Onboarding> data) {
    if (_page >= data.length - 1) {
      context.goToLogin();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is OnboardingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OnboardingError) {
            return Center(child: Text(state.message));
          }
          if (state is OnboardingLoaded) {
            final data = state.data;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Expanded(
                        child: PageView(
                          controller: _controller,
                          physics: const ClampingScrollPhysics(),
                          onPageChanged: (i) => setState(() => _page = i),
                          children: data
                              .map((item) => _buildPage(item))
                              .toList(),
                        ),
                      ),
                    ),
                    AppIndicator(
                      currentIndex: _page,
                      totalPages: data.length,
                      // showSkip: _page < data.length - 1,
                      showSkip: true,
                      onSkip: () => context.goToLogin(),
                      onBack: _page > 0
                          ? () => _controller.previousPage(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                            )
                          : null,
                      onNext: () => _next(data),
                      padding: const EdgeInsets.only(bottom: 16),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPage(Onboarding item) {
    return KeyedSubtree(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OnboardingIcon(icon: _resolveIcon(item.imageUrl)),
          const SizedBox(height: 48),
          Text(
            item.title,
            style: AppTextStyles.heading1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColor.grey,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
