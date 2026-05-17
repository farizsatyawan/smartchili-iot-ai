import 'package:cloud_firestore/cloud_firestore.dart';

/// Entity untuk artikel edukasi
class Artikel {
  final String id;
  final String emoji;
  final String judul;
  final String ringkasan;
  final String kategori;
  final int warnaKategori;
  final String kontenLengkap;

  // 🔥 TAMBAHAN BARU
  final String image;
  final String? externalUrl;

  const Artikel({
    required this.id,
    required this.emoji,
    required this.judul,
    required this.ringkasan,
    required this.kategori,
    required this.warnaKategori,
    required this.kontenLengkap,
    required this.image,
    this.externalUrl,
  });

  /// 🔥 Factory dari Firestore
  factory Artikel.fromFirestore(Map<String, dynamic> data, String id) {
    final content = (data['content'] ?? '').toString();

    return Artikel(
      id: id,
      emoji: '🌶', // bisa kamu kembangkan nanti
      judul: data['title'] ?? '',
      ringkasan: content.length > 100
          ? '${content.substring(0, 100)}...'
          : content,
      kategori: data['category'] ?? 'Umum',
      warnaKategori: 0xFFE57373,
      kontenLengkap: content,

      // 🔥 INI YANG BIKIN ERROR KAMU HILANG
      image: data['image'] ?? '',
      externalUrl: data['externalUrl'],
    );
  }

  Artikel copyWith({
    String? id,
    String? emoji,
    String? judul,
    String? ringkasan,
    String? kategori,
    int? warnaKategori,
    String? waktuBaca,
    String? kontenLengkap,
    String? image,
    String? externalUrl,
  }) {
    return Artikel(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      judul: judul ?? this.judul,
      ringkasan: ringkasan ?? this.ringkasan,
      kategori: kategori ?? this.kategori,
      warnaKategori: warnaKategori ?? this.warnaKategori,
      kontenLengkap: kontenLengkap ?? this.kontenLengkap,
      image: image ?? this.image,
      externalUrl: externalUrl ?? this.externalUrl,
    );
  }

  @override
  String toString() {
    return 'Artikel(id: $id, judul: $judul, kategori: $kategori)';
  }
}