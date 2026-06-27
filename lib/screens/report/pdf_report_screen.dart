import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';

class PdfReportScreen extends StatelessWidget {
  const PdfReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'BACK',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xs,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  const AppSectionHeader(
                    title: 'FORENSIC REPORT',
                    subtitle: 'Official PDF Documentation',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // PDF Preview Card (Simulating white paper document sheet)
                  const _PdfPreviewCard(),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Download PDF (Primary Button)
                  AppPrimaryButton(
                    label: 'DOWNLOAD PDF',
                    onPressed: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Downloading report PDF... (Simulation)'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.surfaceElevated,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Share Report (Outlined Button)
                  SizedBox(
                    height: 58,
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border, width: 1.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                      icon: const Icon(Icons.share_rounded, size: 20),
                      label: const Text('SHARE REPORT'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sharing forensic report... (Simulation)'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.surfaceElevated,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Back to Profile (Text Button)
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.settings.name == '/profile');
                    },
                    child: const Text('Back to Profile'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PdfPreviewCard extends StatelessWidget {
  const _PdfPreviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Letterhead Header
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.gavel_rounded,
                  color: Colors.black87,
                  size: 28,
                ),
                const SizedBox(height: 6),
                Text(
                  'NARCOTICS CONTROL BOARD',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'GOVERNMENT OF SRI LANKA',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'FORENSIC ANALYTICAL REPORT',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 1.5,
                  width: 120,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Details Grid/List
          _buildPdfRow('Report ID', 'REP-2026-98124'),
          _buildPdfRow('Officer Name', 'Officer ABC Perera'),
          _buildPdfRow('Date and Time', '2026-06-27 18:36:31'),
          const SizedBox(height: 12),
          const Divider(color: Colors.black12, height: 1, thickness: 1),
          const SizedBox(height: 12),
          _buildPdfRow('Predicted Substance', 'Heroin (Diacetylmorphine)', isBold: true),
          _buildPdfRow('Confidence Percentage', '94.7%', isBold: true),
          _buildPdfRow('Risk Level', 'HIGH RISK', isBold: true, textColor: Colors.red[800]),
          const SizedBox(height: 12),
          const Divider(color: Colors.black12, height: 1, thickness: 1),
          const SizedBox(height: 12),
          _buildPdfRow('Legal Reference', 'Poisons, Opium, and Dangerous Drugs Ordinance (Act No. 17 of 1929), Section 54'),
          _buildPdfRow('Location', 'Colombo, Sri Lanka (6.9271° N, 79.8612° E)'),
          
          const SizedBox(height: 36),
          
          // Signatures placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1.0,
                    width: 90,
                    color: Colors.black38,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Officer Signature',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'BIOMETRIC LOCK',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Secured digitally',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPdfRow(String label, String value, {bool isBold = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              color: textColor ?? Colors.black87,
              fontSize: 12,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
