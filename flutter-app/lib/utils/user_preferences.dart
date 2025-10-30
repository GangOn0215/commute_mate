import 'dart:convert';

import 'package:commute_mate/models/kakao_user.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // 저장할 때 사용할 키 이름
  static const String _keyUser = 'kakao_user';

  static Future<void> saveUser(KakaoUser user) async {
    // 1. SharedPreferences 인스턴스 가져오기
    final prefs = await SharedPreferences.getInstance();

    final userMap = user.toJson();

    final userJson = jsonEncode(userMap);

    await prefs.setString(_keyUser, userJson);
  }

  static Future<KakaoUser?> loadUser() async {
    /// 1. SharedPreferences에서 문자열 가져오기
    /// 2. 문자열 → JSON (Map)으로 변환
    /// 3. JSON → KakaoUser 객체로 변환
    /// 4. 반환
    ///

    // 1. SharedPreferences 인스턴스 가져오기
    final prefs = await SharedPreferences.getInstance();

    var userJson = prefs.getString(_keyUser);

    // 3. 저장된 데이터가 없으면?
    if (userJson == null) {
      // null 체크!
      print('❌ 저장된 사용자 정보 없음');
      return null; // null 반환
    }

    // 문자열 + JSON ( MAP )
    var userMap = jsonDecode(userJson);

    // 여기에서 에러가 발생합니다.
    /// 에러 원인은 kakao 에서 instance.me() 로 가져왔을때, json 의 형태와 제가 임의로
    /// toJson으로 바꿔서 로컬스토리지에 저장 했기 때문에 당연히 그걸 다시 가져 왔으니, fromJson에 넣으면
    /// 에러가 나던 것 입니다.
    ///
    ///    >>> fromJson <<<
    ///
    //     id: json["id"],
    //     nickname: json["properties"]["nickname"],
    //     profileImage: json["properties"]["profile_image"],
    //     email: json["kakao_account"]?["email"],
    //     connectedAt: json["connected_at"] != null ? DateTime.parse(json["connected_at"]) : null,

    //     >>> toJson <<<
    //
    //    "id": id,
    //    "nickname": nickname,
    //    "profile_image": profileImage,
    //    "email": email,
    //    "connected_at": connectedAt?.toIso8601String(),
    //

    // final user = KakaoUser.fromJson(userMap);
    final user = KakaoUser.fromLocalJson(userMap);

    return user;
  }

  static Future<void> removeUser() async {
    // 1. SharedPreferences 인스턴스 가져오기
    final prefs = await SharedPreferences.getInstance();

    prefs.remove(_keyUser);

    await UserApi.instance.logout();
  }
}
