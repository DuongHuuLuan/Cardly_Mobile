import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_state.dart';
import 'package:cardly_app/presentation/contact/view/contact_add/widgets/add_contact_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ContactAddScreen extends StatefulWidget {
  const ContactAddScreen({super.key});
  @override
  State<ContactAddScreen> createState() => _ContactAddScreenState();
}

class _ContactAddScreenState extends State<ContactAddScreen> {
  final _formKey = GlobalKey<ContactFormState>();

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ContactCubit>().save(_formKey.currentState!.data);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactCubit, ContactState>(
      listenWhen: (p, c) =>
          p.status == ContactStatus.saving && c.status == ContactStatus.loaded,
      listener: (_, __) => context.go('/contact'),
      builder: (context, state) => Scaffold(
        appBar: AppAppBar(
          title: "Add contact",
          leadingType: AppBarLeading.close,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              ContactForm(key: _formKey),
              if (state.status == ContactStatus.failure &&
                  state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    state.errorMessage!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColor.error,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: AppElevatedButton(
                  label: "Save contact",
                  labelStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColor.white,
                  ),
                  onPressed: _onSave,
                  isLoading: state.status == ContactStatus.saving,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
