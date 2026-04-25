import '../../../core/constants/dummy_data.dart';
import '../../../domain/entities/artikel.dart';

class DummyArtikelDatasource {
  Future<List<Artikel>> getArtikelList() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.artikelList;
  }

  Future<Artikel?> getArtikelById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return DummyData.artikelList.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Artikel>> getArtikelByKategori(String kategori) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.artikelList
        .where((a) => a.kategori == kategori)
        .toList();
  }
}