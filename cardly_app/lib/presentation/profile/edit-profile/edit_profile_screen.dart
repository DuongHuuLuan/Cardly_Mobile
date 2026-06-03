import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:cardly_app/presentation/profile/edit-profile/widgets/edit_profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  static const routerName = "/edit-profile";
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final AuthCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<AuthCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<EditProfileContentState>();

    return Scaffold(
      appBar: AppAppBar(
        title: "Edit profile",
        titleStyle: AppTextStyles.heading3,
        leadingType: AppBarLeading.back,
        onLeadingPressed: () => context.pop(context),
      ),

      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return EditProfileContent(key: formKey, user: state.user);
        },
      ),
      bottomNavigationBar: AppElevatedButton(
        label: "Save changes",
        backgroundColor: AppColor.primary,
        labelStyle: AppTextStyles.bodyLarge.copyWith(color: AppColor.white),
        onPressed: () {
          final content = formKey.currentState;
          if (!content!.formKey.currentState!.validate()) return;
          final user = cubit.state.user;
          if (user == null) return;

          final updated = content.buildUpdatedUser(user);
          cubit.updateUser(updated);
          context.pop(context);
        },
      ).paddingAll(20),
    );
  }
}
