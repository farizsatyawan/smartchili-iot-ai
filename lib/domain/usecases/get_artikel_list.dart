import '../entities/artikel.dart';
import '../repositories/artikel_repository.dart';

class GetArtikelList {
  final ArtikelRepository repository;

  GetArtikelList(this.repository);

  Future<List<Artikel>> call({String? kategori}) {
    if (kategori != null && kategori != 'Semua') {
      return repository.getArtikelByKategori(kategori);
    }
    return repository.getArtikelList();
  }
}