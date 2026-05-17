import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentNama;
  final String currentAlamat;
  final String currentPhotoUrl;
  final String currentMulaiTanam;

  const EditProfileScreen({
    super.key,
    required this.currentNama,
    required this.currentAlamat,
    required this.currentPhotoUrl,
    required this.currentMulaiTanam,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  late TextEditingController namaController;
  late TextEditingController alamatController;
  late TextEditingController mulaiTanamController;

  bool loading = false;

  File? selectedImage;

  @override
  void initState() {
    super.initState();

    // 🔥 INIT FORMAT TANGGAL INDONESIA
    initializeDateFormatting('id_ID', null);

    namaController =
        TextEditingController(text: widget.currentNama);

    alamatController =
        TextEditingController(text: widget.currentAlamat);

    mulaiTanamController =
        TextEditingController(
      text: widget.currentMulaiTanam,
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    alamatController.dispose();
    mulaiTanamController.dispose();

    super.dispose();
  }

  // ==============================
  // PICK IMAGE
  // ==============================
  Future<void> pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  // ==============================
  // PICK DATE
  // ==============================
  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('id', 'ID'),
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(pickedDate);

      setState(() {
        mulaiTanamController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ==============================
            // FOTO PROFILE
            // ==============================
            Stack(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor:
                      Colors.green.shade100,
                  backgroundImage: selectedImage != null
                      ? FileImage(selectedImage!)
                      : (widget.currentPhotoUrl
                                  .isNotEmpty
                              ? NetworkImage(
                                  widget.currentPhotoUrl,
                                )
                              : null)
                          as ImageProvider?,
                  child: selectedImage == null &&
                          widget.currentPhotoUrl
                              .isEmpty
                      ? const Text(
                          '👨‍🌾',
                          style:
                              TextStyle(fontSize: 45),
                        )
                      : null,
                ),

                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ==============================
            // NAMA
            // ==============================
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 18),

            // ==============================
            // ALAMAT
            // ==============================
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

            const SizedBox(height: 18),

            // ==============================
            // MULAI TANAM
            // ==============================
            TextField(
              controller: mulaiTanamController,
              readOnly: true,
              onTap: pickDate,
              decoration: const InputDecoration(
                labelText: "Mulai Tanam",
                hintText:
                    "Pilih tanggal mulai tanam",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.eco),
                suffixIcon:
                    Icon(Icons.calendar_month),
              ),
            ),

            const SizedBox(height: 28),

            // ==============================
            // BUTTON
            // ==============================
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                    loading ? null : _handleSave,
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================
  // HANDLE SAVE
  // ==============================
  Future<void> _handleSave() async {
    final nama = namaController.text.trim();
    final alamat =
        alamatController.text.trim();
    final mulaiTanam =
        mulaiTanamController.text.trim();

    if (nama.isEmpty || alamat.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Nama dan alamat wajib diisi"),
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await context
          .read<AppAuthProvider>()
          .updateProfile(
            nama: nama,
            alamat: alamat,
            mulaiTanam: mulaiTanam,
            imageFile: selectedImage,
          );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }
}