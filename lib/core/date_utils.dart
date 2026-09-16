/// Utilitas tanggal & kalender untuk aplikasi Klinik Bidan Sehati.
///
/// CATATAN AKURASI (baca sebelum dipakai di laporan/presentasi):
/// - Weton & neptu: aritmetika Julian Day Number, dikalibrasi ke
///   17 Agustus 1945 = Jumat Legi. Metode ini standar; nilai kalibrasi
///   sendiri sudah diverifikasi ke referensi tanggal kemerdekaan RI,
///   tapi disarankan cek ulang minimal 2-3 tanggal lain secara mandiri.
/// - Hijriah: kalender TABULAR (aritmetika sipil, epoch JDN 1948440),
///   BUKAN kalender Umm al-Qura resmi. Bisa berbeda 1 hari dari hasil
///   rukyat/hisab resmi. Algoritma ini perlu diverifikasi terhadap
///   tanggal referensi yang diketahui sebelum dipakai di laporan akhir.
/// - Tahun Saka Bali: pendekatan kasar (tahun Masehi dikurangi 78/79
///   tergantung bulan). Pergantian tahun Saka sesungguhnya jatuh saat
///   Nyepi (tanggal bervariasi tiap tahun) - butuh tabel referensi
///   resmi untuk akurasi penuh, bukan aritmetika sederhana.
/// - Wuku: siklus 210 hari, titik acuan BELUM diverifikasi ke sumber
///   otoritatif. Jangan tampilkan ke penguji tanpa verifikasi lebih
///   dulu, atau beri label eksplisit seperti di UI.
library;

class WetonResult {
  final String hari;
  final String pasaran;
  final int neptu;
  WetonResult(this.hari, this.pasaran, this.neptu);
}

class AgeBreakdown {
  final int tahun, bulan, hari, jam, menit, detik;
  AgeBreakdown(this.tahun, this.bulan, this.hari, this.jam, this.menit, this.detik);
}

class KalenderUtil {
  static const List<String> _hari = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu',
  ];
  static const List<String> _pasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];

  static const Map<String, int> _neptuHari = {
    'Minggu': 5, 'Senin': 4, 'Selasa': 3, 'Rabu': 7,
    'Kamis': 8, 'Jumat': 6, 'Sabtu': 9,
  };
  static const Map<String, int> _neptuPasaran = {
    'Legi': 5, 'Pahing': 9, 'Pon': 7, 'Wage': 4, 'Kliwon': 8,
  };

  static const List<String> _wuku = [
    'Sinta', 'Landep', 'Ukir', 'Kulantir', 'Taulu', 'Gumbreg', 'Wariga',
    'Warigadean', 'Julungwangi', 'Sungsang', 'Dungulan', 'Kuningan', 'Langkir',
    'Medangsia', 'Pujut', 'Pahang', 'Krulut', 'Merakih', 'Tambir',
    'Medangkungan', 'Matal', 'Uye', 'Menail', 'Prangbakat', 'Bala', 'Ugu',
    'Wayang', 'Kelawu', 'Dukut', 'Watugunung',
  ];
  // JDN untuk 17 Agustus 1945. BELUM diverifikasi ke sumber resmi wuku.
  static const int _wukuAnchorJdn = 2431685;

  static const List<String> _bulanHijri = [
    'Muharram', 'Safar', 'Rabiul Awal', 'Rabiul Akhir', 'Jumadil Awal',
    'Jumadil Akhir', 'Rajab', "Sya'ban", 'Ramadan', 'Syawal',
    "Dzulqa'dah", 'Dzulhijjah',
  ];

  /// Julian Day Number untuk kalender Gregorian.
  static int julianDayNumber(DateTime d) {
    final y = d.year, m = d.month, day = d.day;
    final a = ((14 - m) / 12).floor();
    final yy = y + 4800 - a;
    final mm = m + 12 * a - 3;
    return day +
        ((153 * mm + 2) / 5).floor() +
        365 * yy +
        (yy / 4).floor() -
        (yy / 100).floor() +
        (yy / 400).floor() -
        32045;
  }

  static WetonResult weton(DateTime d) {
    final j = julianDayNumber(d);
    final hari = _hari[((j % 7) + 7) % 7];
    final pasaran = _pasaran[((j % 5) + 5) % 5];
    final neptu = _neptuHari[hari]! + _neptuPasaran[pasaran]!;
    return WetonResult(hari, pasaran, neptu);
  }

  static int sakaYear(DateTime d) => d.month <= 2 ? d.year - 79 : d.year - 78;

  static String wuku(DateTime d) {
    final j = julianDayNumber(d);
    final idx = (((j - _wukuAnchorJdn) % 210) + 210) % 210;
    return _wuku[(idx / 7).floor()];
  }

  /// Konversi Hijriah dengan algoritma tabular (aritmetika sipil,
  /// epoch JDN 1948440). PERLU DIVERIFIKASI terhadap tanggal
  /// referensi sebelum dipakai untuk laporan akhir.
  static Map<String, int> hijriTabular(DateTime d) {
    final jd = julianDayNumber(d);
    var l = jd - 1948440 + 10632;
    final n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    final j = ((((10985 - l) / 5316).floor()) * (((50 * l) / 17719).floor())) +
        (((l / 5670).floor()) * (((43 * l) / 15238).floor()));
    l = l -
        (((30 - j) / 15).floor()) * (((17719 * j) / 50).floor()) -
        ((j / 16).floor()) * (((15238 * j) / 43).floor()) +
        29;
    final m = ((24 * l) / 709).floor();
    final day = l - ((709 * m) / 24).floor();
    final year = 30 * n + j - 30;
    return {'year': year, 'month': m, 'day': day};
  }

  static String hijriLabel(DateTime d) {
    final h = hijriTabular(d);
    final m = h['month']!.clamp(1, 12);
    return '${h['day']} ${_bulanHijri[m - 1]} ${h['year']} H';
  }

  /// HPL dengan rumus Naegele: HPHT + 7 hari - 3 bulan + 1 tahun.
  /// Hanya valid sebagai estimasi untuk siklus haid teratur 28 hari.
  static DateTime naegeleHpl(DateTime hpht) {
    final plus7 = hpht.add(const Duration(days: 7));
    var year = plus7.year + 1;
    var month = plus7.month - 3;
    if (month < 1) {
      month += 12;
      year -= 1;
    }
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = plus7.day > lastDay ? lastDay : plus7.day;
    return DateTime(year, month, day);
  }

  /// Selisih umur dengan pengurangan bersusun per satuan waktu
  /// (tahun -> bulan -> hari -> jam -> menit -> detik), BUKAN dengan
  /// membagi total milidetik - panjang bulan tidak tetap.
  static AgeBreakdown ageBreakdown(DateTime lahir, DateTime now) {
    var tahun = now.year - lahir.year;
    var bulan = now.month - lahir.month;
    var hari = now.day - lahir.day;
    var jam = now.hour - lahir.hour;
    var menit = now.minute - lahir.minute;
    var detik = now.second - lahir.second;

    if (detik < 0) {
      detik += 60;
      menit--;
    }
    if (menit < 0) {
      menit += 60;
      jam--;
    }
    if (jam < 0) {
      jam += 24;
      hari--;
    }
    if (hari < 0) {
      final prevMonthLastDay = DateTime(now.year, now.month, 0).day;
      hari += prevMonthLastDay;
      bulan--;
    }
    if (bulan < 0) {
      bulan += 12;
      tahun--;
    }
    return AgeBreakdown(tahun, bulan, hari, jam, menit, detik);
  }
}
