import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/main_shell.dart';

class InputKebunScreen extends StatefulWidget {
  const InputKebunScreen({super.key});

  @override
  State<InputKebunScreen> createState() =>
      _InputKebunScreenState();
}

class _InputKebunScreenState
    extends State<InputKebunScreen> {
  final namaController =
      TextEditingController();

  final alamatController =
      TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    namaController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lengkapi Profile"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Text(
              "Lengkapi data kebun kamu dulu 🌱",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Data ini digunakan untuk personalisasi aplikasi SmartChili",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 28),

            // =============================
            // NAMA
            // =============================
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
                prefixIcon:
                    Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 18),

            // =============================
            // ALAMAT
            // =============================
            TextField(
              controller: alamatController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Alamat Kebun",
                border: OutlineInputBorder(),
                prefixIcon:
                    Icon(Icons.location_on),
              ),
            ),

            const SizedBox(height: 28),

            // =============================
            // BUTTON
            // =============================
            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed:
                    loading ? null : _saveData,

                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                            CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Simpan",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================
  // SAVE DATA
  // =============================
  Future<void> _saveData() async {
    final nama =
        namaController.text.trim();

    final alamat =
        alamatController.text.trim();

    if (nama.isEmpty ||
        alamat.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Nama dan alamat wajib diisi",
          ),
        ),
      );

      return;
    }

    setState(() => loading = true);

    try {
      final user =
          FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception(
          "User tidak ditemukan",
        );
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'nama': nama,
        'email': user.email,
        'alamatKebun': alamat,

        // default
        'mulaiTanam': '',
        'photoUrl': '',

        'createdAt':
            FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const MainShell(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Gagal simpan data: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }
}