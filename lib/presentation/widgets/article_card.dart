import 'package:flutter/material.dart';
import '../../domain/entities/artikel.dart';

class ArticleCard extends StatelessWidget {
  final Artikel artikel;
  final VoidCallback? onTap;

  const ArticleCard({
    super.key,
    required this.artikel,
    this.onTap,
  });

  // 🔥 Emoji otomatis berdasarkan kategori
  String getKategoriEmoji(String kategori) {
    switch (kategori) {
      case 'Budidaya':
        return '🌱';

      case 'Hama & Penyakit':
        return '🐛';

      case 'Panen':
        return '🧺';

      default:
        return '🌶';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final warnaKategori = Color(artikel.warnaKategori);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // 🔥 Emoji thumbnail
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        warnaKategori.withOpacity(0.15),
                        warnaKategori.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: warnaKategori.withOpacity(0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      getKategoriEmoji(artikel.kategori),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // 🔥 Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔥 Badge kategori
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: warnaKategori.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              artikel.kategori,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: warnaKategori,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // 🔥 Judul
                      Text(
                        artikel.judul,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1C1C1C),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // 🔥 Ringkasan
                      Text(
                        artikel.ringkasan,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}