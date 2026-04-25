import '../../domain/entities/sensor_data.dart';
import '../../domain/entities/hama_result.dart';
import '../../domain/entities/artikel.dart';

class DummyData {
  DummyData._();

  // ── Sensor ──────────────────────────────────────────
  static SensorData get sensorData => SensorData(
        suhu: 28.5,
        kelembapanUdara: 72.0,
        kelembapanTanah: 65.0,
        statusTanaman: 'Sehat',
        lastUpdated: '13:42 WIB',
        isOnline: true,
      );

  // Chart data 24 jam
  static List<double> get suhuChart => [
        26, 25.5, 25, 24.8, 25, 26, 27.5, 29, 30.5, 31, 30,
        29.5, 28.5, 28, 27.5, 28, 28.5, 29, 28.5, 28, 27, 26.5, 26, 25.8,
      ];

  static List<double> get kelembapanUdaraChart => [
        70, 71, 72, 73, 72, 71, 68, 65, 62, 60, 63,
        67, 72, 73, 74, 73, 72, 70, 72, 73, 74, 73, 71, 70,
      ];

  static List<double> get kelembapanTanahChart => [
        65, 64, 63, 62, 61, 60, 58, 55, 52, 50, 53,
        57, 62, 64, 65, 66, 65, 64, 65, 66, 67, 65, 64, 63,
      ];

  // ── AI Result ────────────────────────────────────────
  static HamaResult get hamaResult => HamaResult(
        kondisiDaun: 'Keriting',
        jenisHama: 'Trips',
        confidence: 87.4,
        levelRisiko: RisikoLevel.high,
        mitigasi:
            'Semprot insektisida berbahan aktif abamektin atau spinosad. '
            'Pasang perangkap kuning di sekitar tanaman untuk memantau populasi trips.',
      );

  // ── Artikel ──────────────────────────────────────────
  static List<Artikel> get artikelList => [
        Artikel(
          id: '1',
          emoji: '🌶',
          judul: 'Cara Menanam Cabe yang Benar',
          ringkasan:
              'Panduan lengkap dari persiapan media tanam, pembibitan, hingga teknik menanam cabe yang optimal untuk hasil panen maksimal.',
          kategori: 'Budidaya',
          warnaKategori: 0xFFE53935,
          waktuBaca: '5 menit baca',
        ),
        Artikel(
          id: '2',
          emoji: '🐛',
          judul: 'Mengatasi Hama Trips pada Cabe',
          ringkasan:
              'Trips adalah hama kecil yang merusak daun cabe. Pelajari cara identifikasi dan penanganan efektif menggunakan insektisida organik.',
          kategori: 'Hama & Penyakit',
          warnaKategori: 0xFFFBC02D,
          waktuBaca: '4 menit baca',
        ),
        Artikel(
          id: '3',
          emoji: '🍂',
          judul: 'Penyakit Bercak Daun Cercospora',
          ringkasan:
              'Cercospora menyebabkan bercak coklat pada daun cabe. Kenali gejala awal dan langkah pengendalian dengan fungisida yang tepat.',
          kategori: 'Penyakit',
          warnaKategori: 0xFF8D6E63,
          waktuBaca: '6 menit baca',
        ),
        Artikel(
          id: '4',
          emoji: '💧',
          judul: 'Manajemen Penyiraman Optimal',
          ringkasan:
              'Teknik penyiraman yang tepat sangat menentukan kualitas tanaman cabe. Pelajari frekuensi, waktu, dan metode irigasi terbaik.',
          kategori: 'Perawatan',
          warnaKategori: 0xFF1565C0,
          waktuBaca: '3 menit baca',
        ),
        Artikel(
          id: '5',
          emoji: '🌱',
          judul: 'Pemupukan Cabe: NPK & Organik',
          ringkasan:
              'Pupuk yang tepat dapat meningkatkan hasil panen hingga 40%. Pelajari komposisi NPK ideal dan kapan beralih ke pupuk organik.',
          kategori: 'Nutrisi',
          warnaKategori: 0xFF2E7D32,
          waktuBaca: '7 menit baca',
        ),
        Artikel(
          id: '6',
          emoji: '🌤',
          judul: 'Pengaruh Cuaca terhadap Pertumbuhan',
          ringkasan:
              'Suhu dan kelembapan ideal untuk cabe berkisar 25-30°C dengan RH 70-80%. Pelajari cara adaptasi di berbagai kondisi iklim.',
          kategori: 'Lingkungan',
          warnaKategori: 0xFFF57C00,
          waktuBaca: '5 menit baca',
        ),
      ];

  // ── Profile ──────────────────────────────────────────
  static Map<String, String> get profileData => {
        'nama': 'Budi Santoso',
        'lokasi': 'Kebun Makmur Jaya, Jawa Tengah',
        'luasKebun': '500 m²',
        'varietas': 'Cabe Merah TM-999',
        'mulaiTanam': '10 Jan 2024',
        'totalScan': '47',
        'totalArtikel': '12',
        'hariAktif': '30',
      };

  static const List<String> kategoriEdukasi = [
    'Semua',
    'Budidaya',
    'Hama & Penyakit',
    'Perawatan',
    'Nutrisi',
    'Lingkungan',
  ];
}