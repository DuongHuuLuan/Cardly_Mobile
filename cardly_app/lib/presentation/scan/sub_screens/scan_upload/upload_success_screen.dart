import 'package:cardly_app/core/theme/app_color.dart';
import 'package:cardly_app/core/theme/text_style.dart';
import 'package:cardly_app/core/utils/navigation_exp.dart';
import 'package:cardly_app/core/utils/widget_padding.dart';
import 'package:cardly_app/core/utils/widget_pop_scope.dart';
import 'package:cardly_app/core/widgets/app_appbar.dart';
import 'package:cardly_app/core/widgets/app_elevated_button.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadSuccessScreen extends StatefulWidget {
  static const routerName = "scan-upload-success";

  const UploadSuccessScreen({super.key});
  @override
  State<UploadSuccessScreen> createState() => _UploadSuccessScreenState();
}

class _UploadSuccessScreenState extends State<UploadSuccessScreen> {
  late final ScanCubit _scanCubit;

  @override
  void initState() {
    super.initState();
    _scanCubit = context.read<ScanCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: "Success",
        leadingType: AppBarLeading.close,
        onLeadingPressed: () => context.goToHome(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.greyLight,
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withValues(alpha: 0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: AppColor.black87,
                        size: 40,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 25,
                  right: 30,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColor.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black87,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.gpp_good_outlined,
                      color: AppColor.black87,
                      size: 20,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 30,
                  child: Icon(
                    Icons.auto_awesome_sharp,
                    color: AppColor.black87,
                    size: 25,
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 25,
                  child: Icon(
                    Icons.star_border_purple500_sharp,
                    color: AppColor.secondary,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Scan Successful!', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text(
              '${_documents.length} document${_documents.length > 1 ? 's' : ''} scanned successfully',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColor.greyDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            ..._documents.map((doc) => _DocumentResultTile(document: doc)),
            const SizedBox(height: 24),
            AppElevatedButton(
              label: _documents.length > 1 ? 'View Documents' : 'View Document',
              onPressed: () {
                context.goToScanDocumentDetail(_documents);
              },
              labelColor: AppColor.white,
            ),
            const SizedBox(height: 12),
            Text('Redirecting to home...', style: AppTextStyles.caption),
            const SizedBox(height: 4),
            Text(
              'End-to-end encrypted with AES-256',
              style: AppTextStyles.caption.copyWith(color: AppColor.grey),
            ),
          ],
        ).paddingAll(24),
      ),
    ).canPop(false);
  }

  List<ScannedDocument> get _documents => _scanCubit.state.scannedDocuments;
}

class _DocumentResultTile extends StatelessWidget {
  final ScannedDocument document;
  const _DocumentResultTile({required this.document});

  @override
  Widget build(BuildContext context) {
    final d = document as BusinessCardDocument;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.primary.withValues(alpha: 0.07),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.badge_outlined, color: AppColor.black87),
        ),
        title: Text(
          d.card.fullName ?? 'Unknown',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColor.black87),
        ),
        subtitle: Text(
          d.card.company ?? d.card.jobTitle ?? 'Business Card',
          style: AppTextStyles.bodySmall.copyWith(color: AppColor.greyDark),
        ),
      ),
    );
  }
}
