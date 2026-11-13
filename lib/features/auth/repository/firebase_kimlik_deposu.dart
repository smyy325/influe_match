import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/error/firebase_hata_cozucu.dart';
import '../../../core/error/sonuc.dart';
import '../models/kullanici_modeli.dart';
import 'kimlik_deposu.dart';

class FirebaseKimlikDeposu implements IKimlikDeposu {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final _kullaniciKontrolcu = StreamController<KullaniciModeli?>.broadcast();
  KullaniciModeli? _aktifKullanici;

  FirebaseKimlikDeposu({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _auth.authStateChanges().listen(_authStateDegisti);
  }

  Future<void> _authStateDegisti(User? firebaseUser) async {
    if (firebaseUser == null) {
      if (_aktifKullanici == null || !_aktifKullanici!.id.startsWith('yerel_')) {
        _kullaniciKontrolcu.add(_aktifKullanici = null);
      }
      return;
    }
    _aktifKullanici = await _firestoreKullaniciGetir(firebaseUser.uid) ??
        KullaniciModeli(id: firebaseUser.uid, adSoyad: firebaseUser.displayName ?? (firebaseUser.email?.split('@').first ?? 'Kullanıcı'), email: firebaseUser.email ?? '', rol: Rol.influencer);
    _kullaniciKontrolcu.add(_aktifKullanici);
  }

  Future<KullaniciModeli?> _firestoreKullaniciGetir(String uid) async {
    try {
      final doc = await _firestore.collection('kullanicilar').doc(uid).get().timeout(const Duration(seconds: 3));
      if (doc.exists && doc.data() != null) return KullaniciModeli.fromMap(doc.data()!);
    } catch (_) {}
    return null;
  }

  @override
  Stream<KullaniciModeli?> get kullaniciAkisi => _kullaniciKontrolcu.stream;

  @override
  Future<KullaniciModeli?> mevcutKullaniciyiGetir() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final kayitli = await _firestoreKullaniciGetir(user.uid);
    if (kayitli != null) return _aktifKullanici = kayitli;
    return _aktifKullanici ??= KullaniciModeli(id: user.uid, adSoyad: user.displayName ?? (user.email?.split('@').first ?? 'Kullanıcı'), email: user.email ?? '', rol: Rol.influencer);
  }

  @override
  Future<Sonuc<KullaniciModeli>> girisYap(String email, String sifre) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email.trim(), password: sifre);
      final uid = cred.user!.uid;
      final kayitli = await _firestoreKullaniciGetir(uid);
      if (kayitli != null) {
        _kullaniciKontrolcu.add(_aktifKullanici = kayitli);
        return Basari(kayitli);
      }
      _aktifKullanici = KullaniciModeli(id: uid, adSoyad: cred.user?.displayName ?? email.split('@').first, email: email, rol: Rol.influencer);
      _firestore.collection('kullanicilar').doc(uid).set(_aktifKullanici!.toMap(), SetOptions(merge: true)).catchError((_) {});
      _kullaniciKontrolcu.add(_aktifKullanici);
      return Basari(_aktifKullanici!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'internal-error' || e.code == 'configuration-not-found') {
        _kullaniciKontrolcu.add(_aktifKullanici = KullaniciModeli(id: 'yerel_${DateTime.now().millisecondsSinceEpoch}', adSoyad: email.split('@').first, email: email, rol: Rol.influencer));
        return Basari(_aktifKullanici!);
      }
      return Hata(FirebaseHataCozucu.cevir(e.code, e.message));
    } catch (e) {
      return Hata('Giriş hatası: $e');
    }
  }

  @override
  Future<Sonuc<KullaniciModeli>> kayitOl({required String adSoyad, required String email, required String sifre, required Rol rol}) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: sifre);
      final uid = cred.user!.uid;
      cred.user?.updateDisplayName(adSoyad).catchError((_) {});
      _aktifKullanici = KullaniciModeli(id: uid, adSoyad: adSoyad, email: email, rol: rol);
      _firestore.collection('kullanicilar').doc(uid).set(_aktifKullanici!.toMap()).timeout(const Duration(milliseconds: 1500)).catchError((_) {});
      _kullaniciKontrolcu.add(_aktifKullanici);
      return Basari(_aktifKullanici!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'internal-error' || e.code == 'configuration-not-found') {
        _kullaniciKontrolcu.add(_aktifKullanici = KullaniciModeli(id: 'yerel_${DateTime.now().millisecondsSinceEpoch}', adSoyad: adSoyad, email: email, rol: rol));
        return Basari(_aktifKullanici!);
      }
      return Hata(FirebaseHataCozucu.cevir(e.code, e.message));
    } catch (e) {
      return Hata('Kayıt hatası: $e');
    }
  }

  @override
  Future<Sonuc<void>> cikisYap() async {
    try { await _auth.signOut(); } catch (_) {}
    _kullaniciKontrolcu.add(_aktifKullanici = null);
    return const Basari(null);
  }

  @override
  Future<Sonuc<KullaniciModeli>> profilGuncelle(KullaniciModeli guncel) async {
    final user = _auth.currentUser;
    final docId = user?.uid ?? (guncel.id.isNotEmpty ? guncel.id : 'kullanici');
    final sonKullanici = guncel.copyWith(id: docId);
    try {
      await _firestore.collection('kullanicilar').doc(docId).set(sonKullanici.toMap(), SetOptions(merge: true)).timeout(const Duration(seconds: 4));
    } catch (_) {}
    if (user != null && sonKullanici.adSoyad.isNotEmpty) user.updateDisplayName(sonKullanici.adSoyad).catchError((_) {});
    _kullaniciKontrolcu.add(_aktifKullanici = sonKullanici);
    return Basari(sonKullanici);
  }

  @override
  Future<Sonuc<void>> hesabiSil() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _firestore.collection('kullanicilar').doc(user.uid).delete().catchError((_) {});
        await user.delete();
      }
    } catch (_) {}
    _kullaniciKontrolcu.add(_aktifKullanici = null);
    return const Basari(null);
  }

  @override
  Future<Sonuc<KullaniciModeli>> rolDegistir() async {
    if (_aktifKullanici == null) return const Hata('Aktif kullanıcı bulunamadı.');
    return profilGuncelle(_aktifKullanici!.copyWith(rol: _aktifKullanici!.rol == Rol.marka ? Rol.influencer : Rol.marka));
  }

  @override
  Future<Sonuc<void>> sifreSifirlamaEpostasiGonder(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const Basari(null);
    } on FirebaseAuthException catch (e) {
      return Hata(FirebaseHataCozucu.cevir(e.code, e.message));
    } catch (e) {
      return Hata('Şifre sıfırlama hatası: $e');
    }
  }
}
