// To parse this JSON data, do
//
//     final baoHanh = baoHanhFromJson(jsonString);

import 'dart:convert';

List<BaoHanh> baoHanhFromJson(String str) => List<BaoHanh>.from(json.decode(str).map((x) => BaoHanh.fromJson(x)));

String baoHanhToJson(List<BaoHanh> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BaoHanh {
    BaoHanh({
        this.serial,
        this.sanPham,
        this.thuongHieu,
        this.tenKhachHang,
        this.soDienThoai,
        this.email,
    });

    String serial;
    String sanPham;
    String thuongHieu;
    String tenKhachHang;
    String soDienThoai;
    String email;

    factory BaoHanh.fromJson(Map<String, dynamic> json) => BaoHanh(
        serial: json["serial"],
        sanPham: json["sanPham"],
        thuongHieu: json["thuongHieu"],
        tenKhachHang: json["tenKhachHang"],
        soDienThoai: json["soDienThoai"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "serial": serial,
        "sanPham": sanPham,
        "thuongHieu": thuongHieu,
        "tenKhachHang": tenKhachHang,
        "soDienThoai": soDienThoai,
        "email": email,
    };
}
