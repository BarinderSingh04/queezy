import 'package:queezy/common/common.dart';

class AvatarModel {
  final String url;
  final String localPath;

  String get path => "$baseUrl$localPath";

  AvatarModel({required this.url, required this.localPath});

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(url: json['url'], localPath: json['localPath']);
  }
}
