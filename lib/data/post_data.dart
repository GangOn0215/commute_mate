import 'package:commute_mate/models/post.dart';

class PostData {
  /// 유일한 인스턴스를 미리 생성
  static final PostData _instance = PostData._internal();
  // 팩토리 생성자 ( 기존 인스턴스를 반환 )
  factory PostData() {
    return _instance;
  }
  // 내부 생성자 ( 외부에서 호출 불가 )
  PostData._internal();

  // 더미 게시물 데이터
  final List<Post> posts = [
    Post(
      id: '1',
      userName: 'pizza_lover_kim',
      title: '오늘 처음으로 홈메이드 피자 만들어봤어요 🍕',
      content:
          '도우부터 직접 만들었는데 생각보다 어렵지 않더라고요! 토핑은 페퍼로니, 버섯, 올리브 넣었습니다. 다음엔 불고기 피자 도전해볼게요 ㅎㅎ',
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Post(
      id: '2',
      userName: 'dev_john',
      title: 'Flutter 공부 시작한 지 한 달 됐습니다',
      content:
          '백엔드 개발자인데 앱 개발도 해보고 싶어서 시작했어요. Hot Reload 기능이 진짜 편하네요. 첫 앱 출시가 목표입니다!',
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
    ),
    Post(
      id: '3',
      userName: 'travel_jane',
      title: '제주도 3박4일 여행 다녀왔어요 ✈️',
      content:
          '성산일출봉에서 본 일출이 정말 감동적이었습니다. 흑돼지 백반도 맛있었고, 카페 투어도 재밌었어요. 사진 너무 많이 찍어서 정리가 힘들어요 ㅋㅋ',
      createdAt: DateTime.now().subtract(Duration(hours: 8)),
    ),
    Post(
      id: '4',
      userName: 'fitness_mike',
      title: '오랜만에 운동 시작했는데 온몸이 아파요 😭',
      content:
          '작심삼일이 될까 걱정되지만 이번엔 꼭 3개월은 해보려고요. PT 끊었는데 트레이너님이 너무 빡세게 시켜서... 그래도 뿌듯합니다!',
      createdAt: DateTime.now().subtract(Duration(hours: 12)),
    ),
    Post(
      id: '5',
      userName: 'cat_mom_emily',
      title: '고양이가 새벽 3시에 날 깨워요',
      content:
          '밥그릇이 비었다고 야옹야옹 울어대는데 정말 잠이 안 와요. 자동급식기 사는 게 나을까요? 집사 분들 조언 부탁드립니다 🐱',
      createdAt: DateTime.now().subtract(Duration(hours: 15)),
    ),
    Post(
      id: '6',
      userName: 'drama_addict',
      title: '요즘 핫한 드라마 추천 좀 해주세요',
      content: '넷플릭스 구독했는데 뭘 봐야 할지 모르겠어요. 스릴러나 미스터리 장르 좋아합니다. 코멘트로 추천 부탁드려요!',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    Post(
      id: '7',
      userName: 'fresh_graduate',
      title: '드디어 첫 월급 받았습니다! 🎉',
      content:
          '신입으로 입사한 지 한 달 만에 첫 급여 받았어요. 부모님께 용돈 드리고, 저축도 시작할 예정입니다. 뿌듯하네요 ㅎㅎ',
      createdAt: DateTime.now().subtract(Duration(days: 1, hours: 3)),
    ),
    Post(
      id: '8',
      userName: 'healthy_lifestyle',
      title: '다이어트 한 달 만에 5kg 감량 성공!',
      content:
          '간헐적 단식이랑 운동 병행했어요. 저녁은 샐러드만 먹고, 아침 점심은 자유롭게 먹었습니다. 목표까지 10kg 남았어요 파이팅!',
      createdAt: DateTime.now().subtract(Duration(days: 1, hours: 8)),
    ),
    Post(
      id: '9',
      userName: 'coffee_dreamer',
      title: '혼자 카페 창업 준비 중입니다',
      content:
          '직장 다니다가 꿈을 이루기 위해 퇴사했어요. 바리스타 자격증도 땄고, 이제 인테리어 준비 중입니다. 응원 부탁드려요 ☕',
      createdAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    Post(
      id: '10',
      userName: 'bookworm_alice',
      title: '책 읽는 습관 만들기 도전 중',
      content:
          '올해 목표가 50권 읽기인데 아직 10권밖에 못 읽었어요. 요즘 읽고 있는 책은 "아몬드"입니다. 여러분은 몇 권 읽으셨나요?',
      createdAt: DateTime.now().subtract(Duration(days: 2, hours: 5)),
    ),
    Post(
      id: '11',
      userName: 'puppy_parent',
      title: '강아지 입양 고민 중이에요 🐕',
      content: '혼자 사는데 강아지 키우기 괜찮을까요? 낮에는 출근해야 해서 걱정이 됩니다. 경험 있으신 분들 조언 부탁드려요!',
      createdAt: DateTime.now().subtract(Duration(days: 2, hours: 10)),
    ),
    Post(
      id: '12',
      userName: 'tokyo_wanderer',
      title: '일본 여행 가고 싶다...',
      content:
          '도쿄 교토 오사카 다 가보고 싶은데 언제쯤 갈 수 있을까요. 여행 자금 모으는 중입니다. 일본 여행 꿀팁 있으면 공유 부탁드려요!',
      createdAt: DateTime.now().subtract(Duration(days: 3)),
    ),
  ];

  // 아이디로 게시물 찾기
  Post? findById(String id) {
    try {
      return posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }

  // 제목으로 게시물 검색
  List<Post> searchByTitle(String query) {
    return posts
        .where((post) => post.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
