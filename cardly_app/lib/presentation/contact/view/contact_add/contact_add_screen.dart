import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_state.dart';
import 'package:cardly_app/presentation/contact/view/contact_add/widgets/add_contact_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactAddScreen extends StatefulWidget {
  static const routerName = "/contact-add";

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
      listener: (_, __) => context.goToContact(),
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
                Text(
                  state.errorMessage!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.error,
                  ),
                ).paddingOnly(bottom: 20),
            ],
          ),
        ).paddingOnly(bottom: 20),
        bottomNavigationBar: AppElevatedButton(
          label: "Save contact",
          labelStyle: AppTextStyles.bodyLarge.copyWith(color: AppColor.white),
          onPressed: _onSave,
          isLoading: state.status == ContactStatus.saving,
        ).paddingOnly(bottom: 20, left: 20, right: 20),
      ),
    );
  }
}
