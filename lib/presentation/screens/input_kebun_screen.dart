import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/main_shell.dart';

class InputKebunScreen extends StatefulWidget {
  const InputKebunScreen({super.key});

  @override
  State<InputKebunScreen> createState() => _InputKebunScreenState();
}

class _InputKebunScreenState extends State<InputKebunScreen> {
  final controller = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alamat Kebun")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Masukkan alamat kebun kamu dulu 🌱",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Alamat Kebun",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : _saveData,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan"),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 🔥 FUNCTION SIMPAN DATA (VERSI AMAN)
  Future<void> _saveData() async {
    if (controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alamat wajib diisi")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User tidak ditemukan");
      }

      print("🔥 START SAVE");

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'email': user.email,
        'alamatKebun': controller.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("🔥 SAVE SUCCESS");

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const MainShell(),
          ),
          (route) => false,
        );
      }

    } catch (e) {
      print("🔥 ERROR FIRESTORE: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal simpan data: $e")),
      );

      setState(() => loading = false); // 🔥 FIX PENTING
    }
  }
}