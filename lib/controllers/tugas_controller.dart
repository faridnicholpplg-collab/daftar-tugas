import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../models/tugas_model.dart';

class TugasController extends ChangeNotifier {
	final List<Tugas> _daftarTugas = [];
	bool _isLoading = true;
	String? _errorMessage;

	List<Tugas> get daftarTugas => List.unmodifiable(_daftarTugas);
	bool get isLoading => _isLoading;
	String? get errorMessage => _errorMessage;
	int get jumlahBelumSelesai =>
			_daftarTugas.where((tugas) => !tugas.selesai).length;

	Future<void> muatTugas() async {
		_isLoading = true;
		_errorMessage = null;
		notifyListeners();

		try {
			final isiJson = await rootBundle.loadString('assets/data/tugas.json');
			final data = jsonDecode(isiJson) as List<dynamic>;
			_daftarTugas
				..clear()
				..addAll(
					data.map(
						(item) => Tugas.fromJson(item as Map<String, dynamic>),
					),
				);
		} catch (error) {
			_errorMessage = 'Daftar tugas tidak dapat dimuat: $error';
		} finally {
			_isLoading = false;
			notifyListeners();
		}
	}

	void tambahTugas({required String judul, required String mapel}) {
		final idBaru = _daftarTugas.isEmpty
				? 1
				: _daftarTugas.map((tugas) => tugas.id).reduce((a, b) => a > b ? a : b) + 1;

		_daftarTugas.insert(
			0,
			Tugas(id: idBaru, judul: judul, mapel: mapel, selesai: false),
		);
		notifyListeners();
	}

	void ubahStatus(Tugas tugas, bool selesai) {
		final index = _daftarTugas.indexWhere((item) => item.id == tugas.id);
		if (index == -1) return;

		_daftarTugas[index] = _daftarTugas[index].copyWith(selesai: selesai);
		notifyListeners();
	}
}
