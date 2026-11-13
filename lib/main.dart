import 'package:flutter/material.dart';

import 'views/tugas_view.dart';

void main() {
	runApp(const DaftarTugasApp());
}

class DaftarTugasApp extends StatelessWidget {
	const DaftarTugasApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Daftar Tugas',
			debugShowCheckedModeBanner: false,
			theme: ThemeData(
				useMaterial3: true,
				colorScheme: ColorScheme.fromSeed(
					seedColor: const Color(0xFF176B5B),
					surface: const Color(0xFFF7F8F5),
				),
				scaffoldBackgroundColor: const Color(0xFFF7F8F5),
				appBarTheme: const AppBarTheme(
					backgroundColor: Color(0xFFF7F8F5),
					foregroundColor: Color(0xFF18312C),
					elevation: 0,
				),
				inputDecorationTheme: InputDecorationTheme(
					filled: true,
					fillColor: Colors.white,
					border: OutlineInputBorder(
						borderRadius: BorderRadius.circular(12),
						borderSide: const BorderSide(color: Color(0xFFDCE3DE)),
					),
					enabledBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular(12),
						borderSide: const BorderSide(color: Color(0xFFDCE3DE)),
					),
					focusedBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular(12),
						borderSide: const BorderSide(color: Color(0xFF176B5B), width: 1.5),
					),
				),
			),
			home: const TugasView(),
		);
	}
}
