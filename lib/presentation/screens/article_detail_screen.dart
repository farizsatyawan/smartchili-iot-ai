import 'package:flutter/material.dart';
import '../../domain/entities/artikel.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Artikel artikel;

  const ArticleDetailScreen({
    super.key,
    required this.artikel,
  });

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Gagal membuka link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Artikel"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧾 TITLE
            Text(
              artikel.judul,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 8),

            // 📌 META
            Row(
              children: [
                Chip(
                  label: Text(artikel.kategori),
                ),
                const SizedBox(width: 8),
              ],
            ),

            const SizedBox(height: 16),

            // 🖼 IMAGE
            if (artikel.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(artikel.image),
              ),

            const SizedBox(height: 16),

            // 📖 CONTENT
            Text(
              artikel.kontenLengkap,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 24),

            // 🔗 BUTTON (kalau ada link)
            if (artikel.externalUrl != null &&
                artikel.externalUrl!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _openLink(artikel.externalUrl!),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text("Baca Selengkapnya"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}