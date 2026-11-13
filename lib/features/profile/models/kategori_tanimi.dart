import 'package:flutter/material.dart';

class KategoriTanimi {
  final String baslik;
  final IconData ikon;
  final Color renk;

  const KategoriTanimi({
    required this.baslik,
    required this.ikon,
    required this.renk,
  });

  static const List<KategoriTanimi> tumKategoriler = [
    KategoriTanimi(baslik: 'Yemek & İçecek', ikon: Icons.restaurant_rounded, renk: Color(0xFFFFB74D)),
    KategoriTanimi(baslik: 'Güzellik & Bakım', ikon: Icons.face_rounded, renk: Color(0xFFF06292)),
    KategoriTanimi(baslik: 'Moda', ikon: Icons.checkroom_rounded, renk: Color(0xFFBA68C8)),
    KategoriTanimi(baslik: 'Anne & Bebek', ikon: Icons.child_care_rounded, renk: Color(0xFFFF8A65)),
    KategoriTanimi(baslik: 'Ev & Yaşam', ikon: Icons.home_rounded, renk: Color(0xFF7E57C2)),
    KategoriTanimi(baslik: 'Teknoloji', ikon: Icons.laptop_chromebook_rounded, renk: Color(0xFF42A5F5)),
    KategoriTanimi(baslik: 'Sağlık & Spor', ikon: Icons.fitness_center_rounded, renk: Color(0xFF26A69A)),
    KategoriTanimi(baslik: 'Otomotiv', ikon: Icons.directions_car_rounded, renk: Color(0xFFEF5350)),
    KategoriTanimi(baslik: 'Turizm & Mekan', ikon: Icons.flight_takeoff_rounded, renk: Color(0xFF29B6F6)),
    KategoriTanimi(baslik: 'Eğitim', ikon: Icons.school_rounded, renk: Color(0xFF5C6BC0)),
    KategoriTanimi(baslik: 'Pet', ikon: Icons.pets_rounded, renk: Color(0xFF66BB6A)),
    KategoriTanimi(baslik: 'Finans & Sigorta', ikon: Icons.attach_money_rounded, renk: Color(0xFF2E7D32)),
    KategoriTanimi(baslik: 'Kitap & Kırtasiye', ikon: Icons.menu_book_rounded, renk: Color(0xFFAB47BC)),
    KategoriTanimi(baslik: 'Müzik & Eğlence', ikon: Icons.sports_esports_rounded, renk: Color(0xFF26C6DA)),
    KategoriTanimi(baslik: 'Hobi & Sanat', ikon: Icons.palette_rounded, renk: Color(0xFFEC407A)),
    KategoriTanimi(baslik: 'Dijital İçerik & Medya', ikon: Icons.videocam_rounded, renk: Color(0xFF29B6F6)),
    KategoriTanimi(baslik: 'Evlilik & Organizasyon', ikon: Icons.celebration_rounded, renk: Color(0xFFF48FB1)),
    KategoriTanimi(baslik: 'Hizmet Sektörü', ikon: Icons.build_rounded, renk: Color(0xFF78909C)),
    KategoriTanimi(baslik: 'Bahçe & Outdoor', ikon: Icons.park_rounded, renk: Color(0xFF43A047)),
    KategoriTanimi(baslik: 'Lüks & Lifestyle', ikon: Icons.diamond_rounded, renk: Color(0xFFFFB300)),
  ];
}
