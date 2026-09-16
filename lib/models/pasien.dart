class Pasien {
  final int? id;
  final String nama;
  final DateTime? tanggalLahir;
  final DateTime? hpht;
  final String? keterangan;

  Pasien({
    this.id,
    required this.nama,
    this.tanggalLahir,
    this.hpht,
    this.keterangan,
  });

  factory Pasien.fromJson(Map<String, dynamic> j) => Pasien(
        id: j['id'] is int ? j['id'] as int : int.tryParse('${j['id']}'),
        nama: j['nama'] ?? '',
        tanggalLahir:
            j['tanggal_lahir'] != null ? DateTime.tryParse(j['tanggal_lahir']) : null,
        hpht: j['hpht'] != null ? DateTime.tryParse(j['hpht']) : null,
        keterangan: j['keterangan'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nama': nama,
        'tanggal_lahir': tanggalLahir?.toIso8601String().split('T').first,
        'hpht': hpht?.toIso8601String().split('T').first,
        'keterangan': keterangan,
      };
}
