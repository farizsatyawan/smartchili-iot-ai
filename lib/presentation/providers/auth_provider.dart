import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AppAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn =
      GoogleSignIn();

  bool _loading = false;

  bool get loading => _loading;

  User? get user => _auth.currentUser;

  // =============================
  // CLOUDINARY CONFIG
  // =============================
  static const String cloudName =
      'dbbwtu9om';

  static const String uploadPreset =
      'smartchili';

  // =============================
  // LOGIN EMAIL
  // =============================
  Future<void> loginEmail(
    String email,
    String password,
  ) async {
    try {
      _loading = true;

      notifyListeners();

      await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception(
          'User tidak ditemukan',
        );
      } else if (e.code ==
          'wrong-password') {
        throw Exception(
          'Password salah',
        );
      } else {
        throw Exception(
          e.message,
        );
      }
    } finally {
      _loading = false;

      notifyListeners();
    }
  }

  // =============================
  // REGISTER EMAIL
  // =============================
  Future<void> registerEmail(
    String nama,
    String email,
    String password,
    String alamatKebun,
  ) async {
    try {
      _loading = true;

      notifyListeners();

      final userCredential =
          await _auth
              .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user =
          userCredential.user;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({
        'nama': nama,

        'email': email,

        'alamatKebun': alamatKebun,

        'mulaiTanam': '',

        'photoUrl': '',

        'createdAt':
            FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      if (e.code ==
          'email-already-in-use') {
        throw Exception(
          'Email sudah terdaftar',
        );
      } else if (e.code ==
          'weak-password') {
        throw Exception(
          'Password minimal 6 karakter',
        );
      } else if (e.code ==
          'invalid-email') {
        throw Exception(
          'Format email tidak valid',
        );
      } else {
        throw Exception(
          e.message,
        );
      }
    } finally {
      _loading = false;

      notifyListeners();
    }
  }

  // =============================
  // LOGIN GOOGLE
  // =============================
  Future<void> loginGoogle() async {
    try {
      _loading = true;

      notifyListeners();

      final GoogleSignInAccount?
          googleUser =
          await _googleSignIn.signIn();

      if (googleUser == null) {
        _loading = false;

        notifyListeners();

        return;
      }

      final GoogleSignInAuthentication
          googleAuth =
          await googleUser.authentication;

      final credential =
          GoogleAuthProvider.credential(
        accessToken:
            googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _auth
              .signInWithCredential(
        credential,
      );

      final user =
          userCredential.user;

      final doc =
          await FirebaseFirestore
              .instance
              .collection('users')
              .doc(user!.uid)
              .get();

      // =============================
      // USER BARU GOOGLE
      // =============================
      if (!doc.exists) {
        await FirebaseFirestore
            .instance
            .collection('users')
            .doc(user.uid)
            .set({
          // 🔥 nama kosong dulu
          'nama': '',

          'email': user.email,

          // 🔥 alamat kosong dulu
          'alamatKebun': '',

          'mulaiTanam': '',

          // 🔥 default avatar app
          'photoUrl': '',

          'createdAt':
              FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint(
        "Google login error: $e",
      );

      throw Exception(
        "Gagal login Google",
      );
    } finally {
      _loading = false;

      notifyListeners();
    }
  }

  // =============================
  // GET USER DATA
  // =============================
  Future<Map<String, dynamic>?>
      getUserData() async {
    try {
      final user =
          _auth.currentUser;

      if (user == null) return null;

      final doc =
          await FirebaseFirestore
              .instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (!doc.exists) return null;

      return doc.data();
    } catch (e) {
      debugPrint(
        "Get user error: $e",
      );

      return null;
    }
  }

  // =============================
  // UPLOAD CLOUDINARY
  // =============================
  Future<String?>
      uploadImageToCloudinary(
    File imageFile,
  ) async {
    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request =
          http.MultipartRequest(
        'POST',
        url,
      );

      request.fields['upload_preset'] =
          uploadPreset;

      request.files.add(
        await http.MultipartFile
            .fromPath(
          'file',
          imageFile.path,
        ),
      );

      final response =
          await request.send();

      if (response.statusCode == 200) {
        final responseData =
            await response.stream
                .bytesToString();

        final data =
            jsonDecode(responseData);

        return data['secure_url'];
      } else {
        debugPrint(
          'Cloudinary upload failed: ${response.statusCode}',
        );

        return null;
      }
    } catch (e) {
      debugPrint(
        "Cloudinary error: $e",
      );

      return null;
    }
  }

  // =============================
  // UPDATE PROFILE
  // =============================
  Future<void> updateProfile({
    required String nama,
    required String alamat,
    required String mulaiTanam,
    File? imageFile,
  }) async {
    try {
      final user =
          _auth.currentUser;

      if (user == null) return;

      String? photoUrl;

      // =============================
      // UPLOAD FOTO
      // =============================
      if (imageFile != null) {
        photoUrl =
            await uploadImageToCloudinary(
          imageFile,
        );

        if (photoUrl == null) {
          throw Exception(
            "Upload foto gagal",
          );
        }
      }

      // =============================
      // UPDATE FIRESTORE
      // =============================
      await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .update({
        'nama': nama,

        'alamatKebun': alamat,

        'mulaiTanam': mulaiTanam,

        if (photoUrl != null)
          'photoUrl': photoUrl,
      });
    } catch (e) {
      debugPrint(
        "Update profile error: $e",
      );

      throw Exception(
        "Gagal update profile",
      );
    }
  }

  // =============================
  // UPDATE FOTO
  // =============================
  Future<void> updatePhotoUrl(
    String photoUrl,
  ) async {
    try {
      final user =
          _auth.currentUser;

      if (user == null) return;

      await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .update({
        'photoUrl': photoUrl,
      });
    } catch (e) {
      debugPrint(
        "Update photo error: $e",
      );

      throw Exception(
        "Gagal update foto",
      );
    }
  }

  // =============================
  // UPDATE ALAMAT
  // =============================
  Future<void>
      updateAlamatKebun(
    String alamat,
  ) async {
    try {
      final user =
          _auth.currentUser;

      if (user == null) return;

      await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .update({
        'alamatKebun': alamat,
      });
    } catch (e) {
      debugPrint(
        "Update alamat error: $e",
      );

      throw Exception(
        "Gagal update alamat",
      );
    }
  }

  // =============================
  // LOGOUT
  // =============================

  Future<void> logout() async {
    try {

      // logout google
      await _googleSignIn.signOut();

      // disconnect akun google
      await _googleSignIn.disconnect();

    } catch (e) {

      debugPrint(
        "Google disconnect error: $e",
      );
    }

    // logout firebase
    await _auth.signOut();

    notifyListeners();
  }
}