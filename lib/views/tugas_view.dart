import 'package:flutter/material.dart';

import '../controllers/tugas_controller.dart';
import '../models/tugas_model.dart';

class TugasView extends StatefulWidget {
	const TugasView({super.key});

	@override
	State<TugasView> createState() => _TugasViewState();
}

class _TugasViewState extends State<TugasView> {
	final TugasController _controller = TugasController();
	final TextEditingController _judulController = TextEditingController();
	final TextEditingController _mapelController = TextEditingController();

	@override
	void initState() {
		super.initState();
		_controller.muatTugas();
	}

	@override
	void dispose() {
		_controller.dispose();
		_judulController.dispose();
		_mapelController.dispose();
		super.dispose();
	}

	void _tambahTugas() {
		final judul = _judulController.text.trim();
		final mapel = _mapelController.text.trim();
		if (judul.isEmpty || mapel.isEmpty) return;

		_controller.tambahTugas(judul: judul, mapel: mapel);
		_judulController.clear();
		_mapelController.clear();
		FocusScope.of(context).unfocus();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text(
					'Ruang Tugas',
					style: TextStyle(fontWeight: FontWeight.w700),
				),
			),
			body: SafeArea(
				child: AnimatedBuilder(
					animation: _controller,
					builder: (context, _) {
						return Center(
							child: ConstrainedBox(
								constraints: const BoxConstraints(maxWidth: 720),
								child: ListView(
									padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
									children: [
										_buildSummary(context),
										const SizedBox(height: 24),
										_buildForm(context),
										const SizedBox(height: 28),
										Row(
											children: [
												Text(
													'Semua tugas',
													style: Theme.of(context).textTheme.titleLarge?.copyWith(
																fontWeight: FontWeight.w700,
																color: const Color(0xFF18312C),
															),
												),
												const Spacer(),
												Text(
													'${_controller.daftarTugas.length} item',
													style: Theme.of(context).textTheme.bodyMedium?.copyWith(
																color: const Color(0xFF64736D),
															),
												),
											],
										),
										const SizedBox(height: 12),
										if (_controller.isLoading)
											const Padding(
												padding: EdgeInsets.all(32),
												child: Center(child: CircularProgressIndicator()),
											)
										else if (_controller.errorMessage != null)
											_buildError(context)
										else if (_controller.daftarTugas.isEmpty)
											_buildEmptyState(context)
										else
											..._controller.daftarTugas.map(_buildTaskTile),
									],
								),
							),
						);
					},
				),
			),
		);
	}

	Widget _buildSummary(BuildContext context) {
		final belumSelesai = _controller.jumlahBelumSelesai;
		return Container(
			padding: const EdgeInsets.all(20),
			decoration: BoxDecoration(
				color: const Color(0xFFE2F0E9),
				borderRadius: BorderRadius.circular(16),
			),
			child: Row(
				children: [
					Container(
						width: 48,
						height: 48,
						decoration: BoxDecoration(
							  color: const Color(0x1A176B5B),
							borderRadius: BorderRadius.circular(14),
						),
						child: const Icon(Icons.checklist_rounded, color: Color(0xFF176B5B)),
					),
					const SizedBox(width: 14),
					Expanded(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text(
									'Tugas yang perlu diselesaikan',
									style: Theme.of(context).textTheme.bodyMedium?.copyWith(
												color: const Color(0xFF3D5A50),
											),
								),
								const SizedBox(height: 3),
								Text(
									'$belumSelesai belum selesai',
									style: Theme.of(context).textTheme.titleLarge?.copyWith(
												fontWeight: FontWeight.w700,
												color: const Color(0xFF18312C),
											),
								),
							],
						),
					),
				],
			),
		);
	}

	Widget _buildForm(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				Text(
					'Tambah tugas',
					style: Theme.of(context).textTheme.titleMedium?.copyWith(
								fontWeight: FontWeight.w700,
								color: const Color(0xFF18312C),
							),
				),
				const SizedBox(height: 12),
				TextField(
					controller: _judulController,
					textInputAction: TextInputAction.next,
					decoration: const InputDecoration(
						labelText: 'Nama tugas',
						hintText: 'Contoh: Buat aplikasi kasir',
						prefixIcon: Icon(Icons.edit_note_rounded),
					),
					onSubmitted: (_) => FocusScope.of(context).nextFocus(),
				),
				const SizedBox(height: 10),
				Row(
					children: [
						Expanded(
							child: TextField(
								controller: _mapelController,
								textInputAction: TextInputAction.done,
								decoration: const InputDecoration(
									labelText: 'Mata pelajaran',
									hintText: 'Contoh: Basis Data',
									prefixIcon: Icon(Icons.menu_book_rounded),
								),
								onSubmitted: (_) => _tambahTugas(),
							),
						),
						const SizedBox(width: 10),
						SizedBox(
							height: 56,
							child: FilledButton.icon(
								onPressed: _tambahTugas,
								icon: const Icon(Icons.add_rounded),
								label: const Text('Tambah'),
							),
						),
					],
				),
			],
		);
	}

	Widget _buildTaskTile(Tugas tugas) {
		return Container(
			margin: const EdgeInsets.only(bottom: 9),
			decoration: BoxDecoration(
				color: Colors.white,
				border: Border.all(color: const Color(0xFFE4E9E5)),
				borderRadius: BorderRadius.circular(12),
			),
			child: CheckboxListTile(
				value: tugas.selesai,
				onChanged: (value) => _controller.ubahStatus(tugas, value ?? false),
				controlAffinity: ListTileControlAffinity.leading,
				activeColor: const Color(0xFF176B5B),
				title: Text(
					tugas.judul,
					style: TextStyle(
						fontWeight: FontWeight.w600,
						decoration: tugas.selesai ? TextDecoration.lineThrough : null,
						color: tugas.selesai ? const Color(0xFF87938D) : const Color(0xFF253A34),
					),
				),
				subtitle: Text(tugas.mapel),
				contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
			),
		);
	}

	Widget _buildError(BuildContext context) {
		return Column(
			children: [
				Text(_controller.errorMessage!, textAlign: TextAlign.center),
				const SizedBox(height: 8),
				TextButton.icon(
					onPressed: _controller.muatTugas,
					icon: const Icon(Icons.refresh_rounded),
					label: const Text('Coba lagi'),
				),
			],
		);
	}

	Widget _buildEmptyState(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.symmetric(vertical: 28),
			child: Text(
				'Belum ada tugas. Tambahkan tugas pertamamu di atas.',
				textAlign: TextAlign.center,
				style: Theme.of(context).textTheme.bodyMedium?.copyWith(
							color: const Color(0xFF64736D),
						),
			),
		);
	}
}
