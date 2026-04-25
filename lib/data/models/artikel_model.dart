import '../../domain/entities/artikel.dart';

class ArtikelModel extends Artikel {
  const ArtikelModel({
    required super.id,
    required super.emoji,
    required super.judul,
    required super.ringkasan,
    required super.kategori,
    required super.warnaKategori,
    required super.waktuBaca,
    super.kontenLengkap,
  });

  factory ArtikelModel.fromJson(Map<String, dynamic> json) {
    return ArtikelModel(
      id: json['id'] as String,
      emoji: json['emoji'] as String,
      judul: json['judul'] as String,
      ringkasan: json['ringkasan'] as String,
      kategori: json['kategori'] as String,
      warnaKategori: json['warna_kategori'] as int,
      waktuBaca: json['waktu_baca'] as String,
      kontenLengkap: json['konten_lengkap'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'emoji': emoji,
        'judul': judul,
        'ringkasan': ringkasan,
        'kategori': kategori,
        'warna_kategori': warnaKategori,
        'waktu_baca': waktuBaca,
        'konten_lengkap': kontenLengkap,
      };

  factory ArtikelModel.fromEntity(Artikel artikel) {
    return ArtikelModel(
      id: artikel.id,
      emoji: artikel.emoji,
      judul: artikel.judul,
      ringkasan: artikel.ringkasan,
      kategori: artikel.kategori,
      warnaKategori: artikel.warnaKategori,
      waktuBaca: artikel.waktuBaca,
      kontenLengkap: artikel.kontenLengkap,
    );
  }
}