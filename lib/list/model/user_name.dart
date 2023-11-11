import 'dart:convert';

UserName userNameFromJson(String str) => UserName.fromJson(json.decode(str));

String userNameToJson(UserName data) => json.encode(data.toJson());

class UserName {
  List<DataList> dataList;

  UserName({
    required this.dataList,
  });

  factory UserName.fromJson(Map<String, dynamic> json) => UserName(
        dataList: List<DataList>.from(
            json["data_list"].map((x) => DataList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data_list": List<dynamic>.from(dataList.map((x) => x.toJson())),
      };
}

class DataList {
  String imageUrl;
  String name;
  String indexLetter;

  DataList({
    required this.imageUrl,
    required this.name,
    required this.indexLetter,
  });

  factory DataList.fromJson(Map<String, dynamic> json) => DataList(
        imageUrl: json["imageUrl"],
        name: json["name"],
        indexLetter: json["indexLetter"],
      );

  Map<String, dynamic> toJson() => {
        "imageUrl": imageUrl,
        "name": name,
        "indexLetter": indexLetter,
      };
}
