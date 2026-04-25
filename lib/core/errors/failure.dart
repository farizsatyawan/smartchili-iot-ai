abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Tidak ada koneksi internet']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Terjadi kesalahan pada server']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Data lokal tidak tersedia']);
}

class AIModelFailure extends Failure {
  const AIModelFailure([super.message = 'Model AI gagal memproses gambar']);
}

class SensorFailure extends Failure {
  const SensorFailure([super.message = 'Gagal membaca data sensor']);
}