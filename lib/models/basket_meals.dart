// To parse this JSON data, do
//
//     final sepetYemekler = sepetYemeklerFromJson(jsonString);

import 'dart:convert';

BasketMeals sepetYemeklerFromJson(String str) => BasketMeals.fromJson(json.decode(str));

String sepetYemeklerToJson(BasketMeals data) => json.encode(data.toJson());

class BasketMeals {
  final List<BasketMeal>? sepetYemekler;
  final int? success;

  BasketMeals({
    this.sepetYemekler,
    this.success,
  });

  factory BasketMeals.fromJson(Map<String, dynamic> json) => BasketMeals(
    sepetYemekler: json["sepet_yemekler"] == null ? [] : List<BasketMeal>.from(json["sepet_yemekler"]!.map((x) => BasketMeal.fromJson(x))),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "sepet_yemekler": sepetYemekler == null ? [] : List<dynamic>.from(sepetYemekler!.map((x) => x.toJson())),
    "success": success,
  };
}

class BasketMeal {
  final String? sepetYemekId;
  final String? yemekAdi;
  final String? yemekResimAdi;
  final String? yemekFiyat;
  final String? yemekSiparisAdet;
  final String? kullaniciAdi;

  BasketMeal({
    this.sepetYemekId,
    this.yemekAdi,
    this.yemekResimAdi,
    this.yemekFiyat,
    this.yemekSiparisAdet,
    this.kullaniciAdi,
  });

  factory BasketMeal.fromJson(Map<String, dynamic> json) => BasketMeal(
    sepetYemekId: json["sepet_yemek_id"],
    yemekAdi: json["yemek_adi"],
    yemekResimAdi: json["yemek_resim_adi"],
    yemekFiyat: json["yemek_fiyat"],
    yemekSiparisAdet: json["yemek_siparis_adet"],
    kullaniciAdi: json["kullanici_adi"],
  );

  Map<String, dynamic> toJson() => {
    "sepet_yemek_id": sepetYemekId,
    "yemek_adi": yemekAdi,
    "yemek_resim_adi": yemekResimAdi,
    "yemek_fiyat": yemekFiyat,
    "yemek_siparis_adet": yemekSiparisAdet,
    "kullanici_adi": kullaniciAdi,
  };
}
