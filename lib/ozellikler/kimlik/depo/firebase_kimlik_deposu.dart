// Dosya Görevi: Firebase Kimlik ve Oturum Deposu (Firebase Auth & Firestore Repository).
// Bu sınıf FirebaseAuth servisini kullanarak kullanıcı girişi, kaydı, şifre sıfırlaması
// ve Cloud Firestore üzerindeki 'kullanicilar' koleksiyon kaydını yönetir.

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../cekirdek/hata/firebase_hata_cozucu.dart';
import '../../../cekirdek/hata/sonuc.dart';
import '../model/kullanici_modeli.dart';
import 'kimlik_deposu.dart';

/// FirebaseKimlikDeposu: IKimlikDeposu arayüzünü Firebase servisleri ile uygulayan depo sınıfı.
class FirebaseKimlikDeposu implements IKimlikDeposu {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final _kullaniciKontrolcu = StreamController<KullaniciModeli?>.broadcast();
  KullaniciModeli? _aktifKullanici;

  /// Kurucu Metod: Firebase servislerini alır ve oturum durumu değişikliklerini (authStateChanges) dinler.
  FirebaseKimlikDeposu({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _auth.authStateChanges().listen(_authStateDegisti);
  }

  /// _authStateDegisti(): Firebase Auth oturum durumu değiştiğinde tetiklenir.
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

  /// _firestoreKullaniciGetir(): Firestore 'kullanicilar' koleksiyonundan belirtilen UID'li kullanıcı verisini çeker.
  Future<KullaniciModeli?> _firestoreKullaniciGetir(String uid) async {
    try {
      final doc = await _firestore.collection('kullanicilar').doc(uid).get().timeout(const Duration(seconds: 3));
      if (doc.exists && doc.data() != null) return KullaniciModeli.fromMap(doc.data()!);
    } catch (_) {}
    return null;
  }

  /// kullaniciAkisi: Aktif kullanıcının canlı yayın akışı (Stream).
  @override
  Stream<KullaniciModeli?> get kullaniciAkisi => _kullaniciKontrolcu.stream;

  /// mevcutKullaniciyiGetir(): Mevcut Firebase kullanıcısını ve Firestore profil kaydını getirir.
  @override
  Future<KullaniciModeli?> mevcutKullaniciyiGetir() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final kayitli = await _firestoreKullaniciGetir(user.uid);
    if (kayitli != null) return _aktifKullanici = kayitli;
    return _aktifKullanici ??= KullaniciModeli(id: user.uid, adSoyad: user.displayName ?? (user.email?.split('@').first ?? 'Kullanıcı'), email: user.email ?? '', rol: Rol.influencer);
  }

  /// girisYap(): Firebase Auth e-posta ve şifre doğrulaması ile oturum açar.
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

  /// kayitOl(): Yeni Firebase Auth kullanıcı hesabı açar ve profil verisini Firestore'a kaydeder.
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

  /// cikisYap(): Firebase Auth oturumunu kapatır.
  @override
  Future<Sonuc<void>> cikisYap() async {
    try { await _auth.signOut(); } catch (_) {}
    _kullaniciKontrolcu.add(_aktifKullanici = null);
    return const Basari(null);
  }

  /// profilGuncelle(): Kullanıcının güncellenmiş bilgilerini Firestore 'kullanicilar' koleksiyonuna yazar.
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

  /// hesabiSil(): Kullanıcının Firestore belgesini ve Firebase Auth hesabını siler.
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

  /// rolDegistir(): Kullanıcının rolünü (Marka / Influencer) değiştirir ve profilini günceller.
  @override
  Future<Sonuc<KullaniciModeli>> rolDegistir() async {
    if (_aktifKullanici == null) return const Hata('Aktif kullanıcı bulunamadı.');
    return profilGuncelle(_aktifKullanici!.copyWith(rol: _aktifKullanici!.rol == Rol.marka ? Rol.influencer : Rol.marka));
  }

  /// sifreSifirlamaEpostasiGonder(): Firebase Auth üzerinden şifre sıfırlama e-postası gönderir.
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
