import '../../domain/entities/artikel.dart';
import '../../domain/repositories/artikel_repository.dart';
import '../datasources/local/dummy_artikel_datasource.dart';

class ArtikelRepositoryImpl implements ArtikelRepository {
  final DummyArtikelDatasource _datasource;

  ArtikelRepositoryImpl({DummyArtikelDatasource? datasource})
      : _datasource = datasource ?? DummyArtikelDatasource();

  @override
  Future<List<Artikel>> getArtikelList() => _datasource.getArtikelList();

  @override
  Future<Artikel?> getArtikelById(String id) =>
      _datasource.getArtikelById(id);

  @override
  Future<List<Artikel>> getArtikelByKategori(String kategori) =>
      _datasource.getArtikelByKategori(kategori);
}