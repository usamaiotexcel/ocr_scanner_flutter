// To parse this JSON data, do
//
//     final copyRightedPdfData = copyRightedPdfDataFromJson(jsonString);

import 'dart:convert';

List<CopyRightedPdfData> copyRightedPdfDataFromJson(String str) =>
    List<CopyRightedPdfData>.from(
        json.decode(str).map((x) => CopyRightedPdfData.fromJson(x)));

String copyRightedPdfDataToJson(List<CopyRightedPdfData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CopyRightedPdfData {
  int id;
  String name;
  String file;

  CopyRightedPdfData({
    required this.id,
    required this.name,
    required this.file,
  });

  factory CopyRightedPdfData.fromJson(Map<String, dynamic> json) =>
      CopyRightedPdfData(
        id: json["id"],
        name: json["name"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "file": file,
      };
}
