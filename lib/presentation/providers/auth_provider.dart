import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AppAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _loading = false;

  bool get loading => _loading;
  User? get user => _auth.currentUser;

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

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('User tidak ditemukan');
      } else if (e.code == 'wrong-password') {
        throw Exception('Password salah');
      } else {
        throw Exception(e.message);
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // =============================
  // REGISTER EMAIL + FIRESTORE
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
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({
        'nama': nama,
        'email': email,
        'alamatKebun': alamatKebun,

        // 🔥 mulai tanam default kosong
        'mulaiTanam': '',

        // 🔥 default foto kosong
        'photoUrl': '',

        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email sudah terdaftar');
      } else if (e.code == 'weak-password') {
        throw Exception('Password minimal 6 karakter');
      } else if (e.code == 'invalid-email') {
        throw Exception('Format email tidak valid');
      } else {
        throw Exception(e.message);
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

      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn();

      if (googleUser == null) {
        _loading = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      // 🔥 kalau user baru
      if (!doc.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'nama': user.displayName ?? 'Petani Cabai',
          'email': user.email,
          'alamatKebun': '',

          // 🔥 mulai tanam default kosong
          'mulaiTanam': '',

          // 🔥 foto google
          'photoUrl': user.photoURL ?? '',

          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint("Google login error: $e");
      throw Exception("Gagal login Google");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // =============================
  // GET USER DATA
  // =============================
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final user = _auth.currentUser;

      if (user == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) return null;

      return doc.data();
    } catch (e) {
      debugPrint("Get user error: $e");
      return null;
    }
  }

  // =============================
  // UPDATE PROFILE + FOTO
  // =============================
  Future<void> updateProfile({
    required String nama,
    required String alamat,
    required String mulaiTanam,
    File? imageFile,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null) return;

      String? photoUrl;

      // =============================
      // UPLOAD FOTO
      // =============================
      if (imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_photos')
            .child('${user.uid}.jpg');

        await ref.putFile(imageFile);

        photoUrl = await ref.getDownloadURL();
      }

      // =============================
      // UPDATE FIRESTORE
      // =============================
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'nama': nama,
        'alamatKebun': alamat,
        'mulaiTanam': mulaiTanam,

        if (photoUrl != null) 'photoUrl': photoUrl,
      });
    } catch (e) {
      debugPrint("Update profile error: $e");
      throw Exception("Gagal update profile");
    }
  }

  // =============================
  // UPDATE FOTO PROFILE
  // =============================
  Future<void> updatePhotoUrl(String photoUrl) async {
    try {
      final user = _auth.currentUser;

      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'photoUrl': photoUrl,
      });
    } catch (e) {
      debugPrint("Update photo error: $e");
      throw Exception("Gagal update foto");
    }
  }

  // =============================
  // UPDATE ALAMAT
  // =============================
  Future<void> updateAlamatKebun(String alamat) async {
    try {
      final user = _auth.currentUser;

      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'alamatKebun': alamat,
      });
    } catch (e) {
      debugPrint("Update alamat error: $e");
      throw Exception("Gagal update alamat");
    }
  }

  // =============================
  // LOGOUT
  // =============================
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }
}