import '../entities/artikel.dart';

abstract class ArtikelRepository {
  Future<List<Artikel>> getArtikelList();
  Future<Artikel?> getArtikelById(String id);
  Future<List<Artikel>> getArtikelByKategori(String kategori);
}