import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/sensor_validator.dart';
import '../providers/sensor_provider.dart';
import '../widgets/sensor_card.dart';
import '../widgets/line_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SensorProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverPadding(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildStatusRow(context, provider),
                    const SizedBox(height: 14),
                    _buildSensorGrid(context, provider),
                    const SizedBox(height: 18),
                    _buildChartCard(context, provider),
                    const SizedBox(height: 18),
                    _buildScanButton(context),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 130,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primaryDark,
      actions: [],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientPrimary,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text('🌶', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        AppStrings.appName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.circle,
                          color: Color(0xFF69F0AE), size: 8),
                      const SizedBox(width: 6),
                      Text(
                        '${AppStrings.appSubtitle} • ${AppStrings.online}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Status Row ──────────────────────────────────────────────
  Widget _buildStatusRow(BuildContext context, SensorProvider provider) {
    return Row(
      children: [
        Icon(Icons.access_time_rounded,
            size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          '${AppStrings.lastUpdated} '
'${provider.sensorData?.lastUpdated != null
    ? DateFormatter.formatFromIso(provider.sensorData!.lastUpdated)
    : '-'}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const Spacer(),
      _RealtimeBadge(
        isOnline: provider.sensorData?.lastUpdated != null &&
            DateTime.now()
                    .difference(DateTime.parse(provider.sensorData!.lastUpdated))
                    .inMinutes <
                1,
      ),
      ],
    );
  }

  // ── Sensor Grid 2x2 ─────────────────────────────────────────
  Widget _buildSensorGrid(BuildContext context, SensorProvider provider) {
    if (provider.isLoading) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final data = provider.sensorData;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: AppSizes.sensorCardRatio,
      children: [
        SensorCard(
          icon: '🌡',
          label: AppStrings.sensorSuhu,
          value: data != null
              ? '${data.suhu.toStringAsFixed(1)}°C'
              : '--',
          subLabel: data != null
              ? SensorValidator.getSuhuStatus(data.suhu)
              : '--',
          statusColor: data != null
              ? SensorValidator.getSuhuColor(data.suhu)
              : AppColors.success,
          gradient: AppColors.gradientSuhu,
        ),
        SensorCard(
          icon: '💧',
          label: AppStrings.sensorKelembapanUdara,
          value: data != null
              ? '${data.kelembapanUdara.toInt()}%'
              : '--',
          subLabel: data != null
              ? SensorValidator.getKelembapanUdaraStatus(
                  data.kelembapanUdara)
              : '--',
          statusColor: data != null
              ? SensorValidator.getKelembapanUdaraColor(
                  data.kelembapanUdara)
              : AppColors.success,
          gradient: AppColors.gradientUdara,
        ),
        SensorCard(
          icon: '🌱',
          label: AppStrings.sensorKelembapanTanah,
          value: data != null
              ? '${data.kelembapanTanah.toInt()}%'
              : '--',
          subLabel: data != null
              ? SensorValidator.getKelembapanTanahStatus(
                  data.kelembapanTanah)
              : '--',
          statusColor: data != null
              ? SensorValidator.getKelembapanTanahColor(
                  data.kelembapanTanah)
              : AppColors.success,
          gradient: AppColors.gradientTanah,
        ),
        SensorCard(
          icon: '🌿',
          label: "Status Pompa",
          value: data?.statusTanaman ?? '--',
          subLabel: data?.statusTanaman == "Pompa ON"
              ? "Sedang menyiram tanaman"
              : "Tanah dalam kondisi stabil",
          statusColor: data?.statusTanaman == "Pompa ON"
              ? Colors.orange
              : AppColors.success,
          gradient: AppColors.gradientStatus,
        ),
      ],
    );
  }

  // ── Chart Card ──────────────────────────────────────────────
  Widget _buildChartCard(BuildContext context, SensorProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              const Icon(Icons.show_chart_rounded,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                AppStrings.monitoringTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                AppStrings.chart24Jam,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Toggle buttons
          Row(
            children: [
              ChartToggleButton(
                label: 'Suhu',
                isActive: provider.selectedChart == 0,
                activeColor: AppColors.chartSuhu,
                onTap: () => provider.selectChart(0),
              ),
              const SizedBox(width: 8),
              ChartToggleButton(
                label: 'Udara',
                isActive: provider.selectedChart == 1,
                activeColor: AppColors.chartKelembapanUdara,
                onTap: () => provider.selectChart(1),
              ),
              const SizedBox(width: 8),
              ChartToggleButton(
                label: 'Tanah',
                isActive: provider.selectedChart == 2,
                activeColor: AppColors.chartKelembapanTanah,
                onTap: () => provider.selectChart(2),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chart
          SizedBox(
            height: AppSizes.chartHeight,
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary, strokeWidth: 2))
                : LineChartWidget(
                    data: provider.currentChartData,
                    color: _getChartColor(provider.selectedChart),
                  ),
          ),
          const SizedBox(height: 8),

          // X-axis labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['00:00', '06:00', '12:00', '18:00', '23:00']
                .map((t) => Text(t,
                    style: TextStyle(
                        fontSize: 10, color: Colors.grey.shade500)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Color _getChartColor(int index) {
    switch (index) {
      case 1:
        return AppColors.chartKelembapanUdara;
      case 2:
        return AppColors.chartKelembapanTanah;
      default:
        return AppColors.chartSuhu;
    }
  }

  // ── Scan Button ─────────────────────────────────────────────
  Widget _buildScanButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
        label: const Text(
          AppStrings.scanButtonLabel,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
          elevation: 4,
          shadowColor: AppColors.primary.withOpacity(0.4),
        ),
      ),
    );
  }
}

// ── Realtime Badge ───────────────────────────────────────────
class _RealtimeBadge extends StatelessWidget {
  final bool isOnline;

  const _RealtimeBadge({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isOnline ? AppColors.success : Colors.grey)
            .withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isOnline ? AppColors.success : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            AppStrings.realtimeLabel,
            style: TextStyle(
              fontSize: 11,
              color: isOnline ? AppColors.success : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}