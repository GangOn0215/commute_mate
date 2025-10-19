import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoUser {
  final int id; // 카카오 고유 아이디
  final String nickname; // 카카오 닉네임
  final String? profileImage; // 카카오 이미지
  final String? email; // 카카오 이메일
  final DateTime? connectedAt; // 카카오 연결일시
  OAuthToken? token; //  토큰

  KakaoUser({
    required this.id,
    required this.nickname,
    this.profileImage,
    this.email,
    this.connectedAt,
    this.token,
  });

  /// fromJson은 현업에서도, flutter에서 굉장히 많이 쓰임
  ///
  ///

  // fromJson으로 json 파일 담아와서 현 KakaoUser에 대입시켜주기
  factory KakaoUser.fromJson(Map<String, dynamic> json) {
    return KakaoUser(
      id: json["id"],
      nickname: json["properties"]["nickname"],
      profileImage: json["properties"]["profile_image"],
      email: json["kakao_account"]?["email"],
      connectedAt: json["connected_at"] != null
          ? DateTime.parse(json["connected_at"])
          : null,
    );
  }

  factory KakaoUser.fromLocalJson(Map<String, dynamic> json) {
    return KakaoUser(
      id: json["id"],
      nickname: json["nickname"],
      profileImage: json["profileImage"],
      email: json["email"],
      connectedAt: json["connectedAt"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nickname": nickname,
      "profile_image": profileImage,
      "email": email,
      "connected_at": connectedAt?.toIso8601String(),
    };
  }

  void setToken(OAuthToken token) {
    this.token = token;
  }
}
