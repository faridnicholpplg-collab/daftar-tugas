class Tugas {
	const Tugas({
		required this.id,
		required this.judul,
		required this.mapel,
		required this.selesai,
	});

	final int id;
	final String judul;
	final String mapel;
	final bool selesai;

	factory Tugas.fromJson(Map<String, dynamic> json) {
		return Tugas(
			id: json['id'] as int,
			judul: json['judul'] as String,
			mapel: json['mapel'] as String,
			selesai: json['selesai'] as bool,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'id': id,
			'judul': judul,
			'mapel': mapel,
			'selesai': selesai,
		};
	}

	Tugas copyWith({bool? selesai}) {
		return Tugas(
			id: id,
			judul: judul,
			mapel: mapel,
			selesai: selesai ?? this.selesai,
		);
	}
}
