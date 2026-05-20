import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../providers/scan_provider.dart';
import '../widgets/ai_result_card.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool isAuto = true;

  String selectedSuhu = "normal";
  String selectedKelembapan = "sedang";

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final initProvider =
        context.read<ScanProvider>();

    Future.microtask(() {
      initProvider.init();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🔬 ${AppStrings.scanTitle}',
        ),
      ),

      body: Consumer<ScanProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                // 🔥 PREVIEW GAMBAR
                _CameraPreview(
                  status: provider.status,
                  imagePath: provider.imagePath,
                ),

                const SizedBox(height: 16),

                _buildEnvironmentInput(
                  context,
                  isDark,
                ),

                const SizedBox(height: 16),

                _buildActionButtons(
                  context,
                  provider,
                ),

                const SizedBox(height: 20),

                if (provider.hasResult &&
                    provider.result != null)
                  AIResultCard(
                    result: provider.result!,
                  )
                else if (provider.isIdle)
                  _InfoBox(isDark: isDark),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================== ENV INPUT ==================
  Widget _buildEnvironmentInput(
    BuildContext context,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Container(
          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(16),

            color: isDark
                ? AppColors.darkCard
                : Colors.grey.shade100,
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              Text(
                "Mode Input Lingkungan",

                style: TextStyle(
                  fontWeight: FontWeight.w600,

                  color: isDark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),

              Switch(
                value: isAuto,

                onChanged: (val) {
                  setState(() {
                    isAuto = val;
                  });
                },

                activeColor:
                    AppColors.primary,
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        if (!isAuto)
          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(16),

              color: isDark
                  ? AppColors.darkCard
                  : Colors.white,

              border: Border.all(
                color: isDark
                    ? Colors.white12
                    : Colors.grey.shade300,
              ),
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  "Inputkan kondisi rata-rata 3 hari terakhir",

                  style: TextStyle(
                    color: isDark
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "Suhu",

                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : Colors.black87,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                DropdownButton<String>(
                  value: selectedSuhu,

                  isExpanded: true,

                  dropdownColor: isDark
                      ? AppColors.darkCard
                      : Colors.white,

                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : Colors.black87,
                  ),

                  items: [
                    "panas",
                    "normal",
                    "dingin"
                  ]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),

                  onChanged: (val) {
                    setState(() {
                      selectedSuhu = val!;
                    });
                  },
                ),

                const SizedBox(height: 12),

                Text(
                  "Kelembapan",

                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : Colors.black87,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                DropdownButton<String>(
                  value: selectedKelembapan,

                  isExpanded: true,

                  dropdownColor: isDark
                      ? AppColors.darkCard
                      : Colors.white,

                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : Colors.black87,
                  ),

                  items: [
                    "rendah",
                    "sedang",
                    "tinggi"
                  ]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),

                  onChanged: (val) {
                    setState(() {
                      selectedKelembapan =
                          val!;
                    });
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ================== BUTTON ==================
  Widget _buildActionButtons(
    BuildContext context,
    ScanProvider provider,
  ) {
    if (provider.hasResult) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: provider.reset,

              icon: const Icon(
                Icons.refresh_rounded,
                color: AppColors.primary,
              ),

              label: const Text(
                AppStrings.scanAgain,

                style: TextStyle(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},

              icon: const Icon(
                Icons.save_alt_rounded,
                color: Colors.white,
              ),

              label: const Text(
                AppStrings.scanSave,

                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 54,

      child: ElevatedButton.icon(
        onPressed: provider.isAnalyzing
            ? null
            : () async {
                final picker =
                    ImagePicker();

                // 🔥 POPUP PILIHAN
                final source =
                    await showModalBottomSheet<
                        ImageSource>(
                  context: context,

                  shape:
                      const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),

                  builder: (context) =>
                      SafeArea(
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,

                      children: [
                        const SizedBox(
                            height: 12),

                        const Text(
                          "Pilih Sumber Gambar",

                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                            height: 10),

                        ListTile(
                          leading: const Icon(
                            Icons
                                .camera_alt_rounded,
                          ),

                          title: const Text(
                            "Ambil dari Kamera",
                          ),

                          onTap: () =>
                              Navigator.pop(
                            context,
                            ImageSource.camera,
                          ),
                        ),

                        ListTile(
                          leading:
                              const Icon(
                            Icons
                                .photo_library_rounded,
                          ),

                          title: const Text(
                            "Pilih dari Gallery",
                          ),

                          onTap: () =>
                              Navigator.pop(
                            context,
                            ImageSource.gallery,
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                if (source == null) return;

                final pickedFile =
                    await picker.pickImage(
                  source: source,
                  imageQuality: 85,
                );

                if (pickedFile != null) {
                  provider.analyzeImage(
                    pickedFile.path,

                    suhu: isAuto
                        ? null
                        : selectedSuhu,

                    kelembapan: isAuto
                        ? null
                        : selectedKelembapan,
                  );
                }
              },

        icon: const Icon(
          Icons.camera_alt_rounded,
          color: Colors.white,
        ),

        label: const Text(
          "Scan Daun",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ================== CAMERA PREVIEW ==================
class _CameraPreview extends StatelessWidget {
  final ScanStatus status;
  final String? imagePath;

  const _CameraPreview({
    required this.status,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,

      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(20),

        child: Stack(
          fit: StackFit.expand,

          children: [
            if (imagePath != null)
              Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
              )
            else
              Container(
                decoration:
                    const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0D2137),
                      Color(0xFF1A3A1A),
                    ],
                  ),
                ),

                child: const Center(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),

            if (status ==
                ScanStatus.analyzing)
              Container(
                color:
                    Colors.black.withOpacity(
                  0.4,
                ),

                child: const Center(
                  child:
                      CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ================== INFO BOX ==================
class _InfoBox extends StatelessWidget {
  final bool isDark;

  const _InfoBox({
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color:
            AppColors.primary.withOpacity(
          0.08,
        ),

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              AppStrings.infoAI,

              style: TextStyle(
                fontSize: 12,

                color: isDark
                    ? Colors.white70
                    : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}