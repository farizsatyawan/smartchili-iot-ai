import 'package:flutter/material.dart';
import '../../domain/entities/hama_result.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class AIResultCard extends StatelessWidget {
  final HamaResult result;

  const AIResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;
    final risikoColor = result.levelRisiko.color;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: risikoColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: risikoColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────
          _buildHeader(risikoColor, textColor),

          // ── Result Rows ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _ResultRow(
                  icon: '🌿',
                  label: AppStrings.kondisiDaun,
                  value: result.kondisiDaun,
                  valueColor: AppColors.warning,
                ),
                const _Divider(),
                _ResultRow(
                  icon: '🐛',
                  label: AppStrings.jenisHama,
                  value: result.jenisHama,
                  valueColor: risikoColor,
                ),
                const _Divider(),

                // 🔥 FIXED CONFIDENCE
                _ConfidenceRow(
                  confidence: result.confidence,
                  color: AppColors.primary,
                ),

                const _Divider(),
                _ResultRow(
                  icon: '⚠️',
                  label: AppStrings.levelRisiko,
                  value: result.levelRisiko.shortLabel,
                  valueColor: risikoColor,
                ),
                const SizedBox(height: 14),

                // ── Mitigasi Box ──────────────────────────────
                _MitigasiBox(mitigasi: result.mitigasi),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color risikoColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            risikoColor.withOpacity(0.15),
            risikoColor.withOpacity(0.05),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: risikoColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.psychology_rounded,
                color: risikoColor, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.hasilAnalisis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: textColor,
                ),
              ),
              Text(
                AppStrings.cnnRF,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: risikoColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              result.levelRisiko.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================== RESULT ROW ==================
class _ResultRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color valueColor;

  const _ResultRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// ================== CONFIDENCE ROW ==================
class _ConfidenceRow extends StatelessWidget {
  final double confidence;
  final Color color;

  const _ConfidenceRow({required this.confidence, required this.color});

  @override
  Widget build(BuildContext context) {
    final percent = confidence * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text('📊', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  AppStrings.tingkatKeyakinan,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
            Text(
              '${percent.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: confidence, // 🔥 FIX
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

// ================== MITIGASI ==================
class _MitigasiBox extends StatelessWidget {
  final String mitigasi;

  const _MitigasiBox({required this.mitigasi});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('💡', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                AppStrings.rekomendasiMitigasi,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            mitigasi,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ================== DIVIDER ==================
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1),
    );
  }
}