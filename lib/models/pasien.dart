class Pasien {
  final int? id;
  final String nama;
  final String? tanggalLahir;
  final String? noHp;
  final String? alamat;
  final String? hpht;
  final String? keterangan;

  Pasien({
    this.id,
    required this.nama,
    this.tanggalLahir,
    this.noHp,
    this.alamat,
    this.hpht,
    this.keterangan,
  });

  factory Pasien.fromJson(Map<String, dynamic> json) {
    return Pasien(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      nama: json['nama']?.toString() ?? '',
      tanggalLahir: json['tanggal_lahir']?.toString(),
      noHp: json['no_hp']?.toString(),
      alamat: json['alamat']?.toString(),
      hpht: json['hpht']?.toString(),
      keterangan: json['keterangan']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama': nama,
      'tanggal_lahir': tanggalLahir,
      'no_hp': noHp,
      'alamat': alamat,
      'hpht': hpht,
      'keterangan': keterangan,
    };
  }
}