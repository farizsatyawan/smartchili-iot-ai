/// Pure Dart entity untuk artikel edukasi
class Artikel {
  final String id;
  final String emoji;
  final String judul;
  final String ringkasan;
  final String kategori;
  final int warnaKategori; // ARGB int agar pure Dart
  final String waktuBaca;
  final String? kontenLengkap;

  const Artikel({
    required this.id,
    required this.emoji,
    required this.judul,
    required this.ringkasan,
    required this.kategori,
    required this.warnaKategori,
    required this.waktuBaca,
    this.kontenLengkap,
  });

  Artikel copyWith({
    String? id,
    String? emoji,
    String? judul,
    String? ringkasan,
    String? kategori,
    int? warnaKategori,
    String? waktuBaca,
    String? kontenLengkap,
  }) {
    return Artikel(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      judul: judul ?? this.judul,
      ringkasan: ringkasan ?? this.ringkasan,
      kategori: kategori ?? this.kategori,
      warnaKategori: warnaKategori ?? this.warnaKategori,
      waktuBaca: waktuBaca ?? this.waktuBaca,
      kontenLengkap: kontenLengkap ?? this.kontenLengkap,
    );
  }

  @override
  String toString() => 'Artikel(id: $id, judul: $judul, kategori: $kategori)';
}