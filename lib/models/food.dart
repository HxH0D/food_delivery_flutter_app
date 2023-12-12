// To parse this JSON data, do
//
//     final food = foodFromJson(jsonString);

import 'dart:convert';

Food foodFromJson(String str) => Food.fromJson(json.decode(str));

String foodToJson(Food data) => json.encode(data.toJson());

class Food {
  final List<Yemekler>? yemekler;
  final int? success;

  Food({
    this.yemekler,
    this.success,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    yemekler: json["yemekler"] == null ? [] : List<Yemekler>.from(json["yemekler"]!.map((x) => Yemekler.fromJson(x))),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "yemekler": yemekler == null ? [] : List<dynamic>.from(yemekler!.map((x) => x.toJson())),
    "success": success,
  };
}

class Yemekler {
  final String? yemekId;
  final String? yemekAdi;
  final String? yemekResimAdi;
  final String? yemekFiyat;
  final bool? isFavorite;


  Yemekler({
    this.yemekId,
    this.yemekAdi,
    this.yemekResimAdi,
    this.yemekFiyat,
    this.isFavorite,

  });

  factory Yemekler.fromJson(Map<String, dynamic> json) => Yemekler(
    yemekId: json["yemek_id"],
    yemekAdi: json["yemek_adi"],
    yemekResimAdi: json["yemek_resim_adi"],
    yemekFiyat: json["yemek_fiyat"],
  );

  Map<String, dynamic> toJson() => {
    "yemek_id": yemekId,
    "yemek_adi": yemekAdi,
    "yemek_resim_adi": yemekResimAdi,
    "yemek_fiyat": yemekFiyat,
  };
}
