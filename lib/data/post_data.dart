class PostData {
  /// 유일한 인스턴스를 미리 생성
  static final PostData _instance = PostData._internal();
  // 팩토리 생성자 ( 기존 인스턴스를 반환 )
  factory PostData() {
    return _instance;
  }
  // 내부 생성자 ( 외부에서 호출 불가 )
  PostData._internal();
}
