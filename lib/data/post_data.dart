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

  final List<Post> posts = [
    Post(
      id: '1',
      userName: 'pizza_lover_kim',
      title: '오늘 처음으로 홈메이드 피자 만들어봤어요 🍕',
      content: '''
도우부터 직접 반죽하고 발효까지 했는데, 생각보다 어렵지 않더라고요!
오븐에서 노릇하게 구워지는 냄새가 너무 좋았어요.
토핑은 페퍼로니, 버섯, 올리브, 모짜렐라 듬뿍 올렸습니다.
식구들이 맛있다고 해서 정말 뿌듯했어요.
다음엔 불고기 피자나 고르곤졸라 피자에도 도전해볼 생각이에요 😋
''',
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
      likeCount: 124,
      commentCount: 8,
      readCount: 913,
    ),
    Post(
      id: '2',
      userName: 'dev_john',
      title: 'Flutter 공부 시작한 지 한 달 됐습니다',
      content: '''
백엔드 개발만 하다가 프론트엔드 쪽으로 관심이 생겨 Flutter를 배우기 시작했어요.
위젯 개념이 처음엔 낯설었지만, 구조를 이해하니 점점 재밌어지더군요.
Hot Reload는 정말 신세계입니다 — 수정 즉시 반영되니까 효율이 미쳤어요.
지금은 간단한 ToDo 앱을 완성했고, 다음엔 개인 프로젝트 앱에 도전하려고 합니다.
출시까지 꾸준히 달려볼게요! 🚀
''',
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
      likeCount: 256,
      commentCount: 14,
      readCount: 1789,
    ),
    Post(
      id: '3',
      userName: 'travel_jane',
      title: '제주도 3박 4일 여행 다녀왔어요 ✈️',
      content: '''
성산일출봉 일출은 정말 감동적이었어요. 아침부터 눈물이 핑 돌더라구요.
숙소 근처 해변에서 커피 마시며 하루를 시작하니 천국 같았어요.
흑돼지 백반, 고기국수, 딱새우까지 맛집 투어도 성공적!
오름 트래킹하면서 마주친 노을은 아직도 잊히지 않아요.
다음엔 가을 제주도로 다시 가볼 생각입니다 🌾
''',
      createdAt: DateTime.now().subtract(Duration(hours: 8)),
      likeCount: 411,
      commentCount: 32,
      readCount: 3210,
    ),
    Post(
      id: '4',
      userName: 'fitness_mike',
      title: '오랜만에 운동 시작했는데 온몸이 아파요 😭',
      content: '''
3개월 동안 쉬다가 다시 헬스장 등록했는데, 이틀째 근육통이 장난 아니네요.
PT 첫날부터 스쿼트, 데드리프트, 플랭크 풀세트라니... 트레이너님 너무 열정적이에요 😂
그래도 하루하루 몸이 변하는 게 느껴져서 보람 있습니다.
다음 달엔 인바디 결과로 달라진 수치를 공유할게요!
''',
      createdAt: DateTime.now().subtract(Duration(hours: 12)),
      likeCount: 189,
      commentCount: 19,
      readCount: 1276,
    ),
    Post(
      id: '5',
      userName: 'cat_mom_emily',
      title: '고양이가 새벽 3시에 날 깨워요 😿',
      content: '''
새벽만 되면 제 얼굴을 톡톡 치면서 깨우는 우리 고양이 미미...
밥그릇이 비었다고 야옹야옹 울어대는데, 이젠 자동급식기를 고민 중이에요.
그래도 새벽에 같이 눈 마주치면 너무 귀여워서 화가 안 나요.
집사 인생, 힘들지만 행복합니다 💕
''',
      createdAt: DateTime.now().subtract(Duration(hours: 15)),
      likeCount: 305,
      commentCount: 27,
      readCount: 2001,
    ),
    Post(
      id: '6',
      userName: 'drama_addict',
      title: '요즘 핫한 드라마 추천 좀 해주세요 🎬',
      content: '''
요즘 넷플릭스 정주행할 게 없어요.
스릴러나 미스터리 좋아하는데, 최근에 "마이데몬" 보고 꽤 재밌었어요.
비슷한 분위기의 드라마 아시는 분 추천 부탁드립니다!
긴장감 있고 몰입감 있는 작품이면 더 좋아요.
댓글로 인생작 공유해 주세요 🙏
''',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      likeCount: 72,
      commentCount: 16,
      readCount: 544,
    ),
    Post(
      id: '7',
      userName: 'fresh_graduate',
      title: '드디어 첫 월급 받았습니다! 🎉',
      content: '''
첫 직장, 첫 월급이라 감회가 새롭네요.
부모님께 용돈 드리고, 저축통장도 하나 만들었어요.
월급명세서 보는 순간 그동안의 고생이 스쳐갔습니다.
다음 목표는 여행 자금 모으기!
열심히 일해서 보답하는 사람이 되고 싶어요 🙌
''',
      createdAt: DateTime.now().subtract(Duration(days: 1, hours: 3)),
      likeCount: 622,
      commentCount: 41,
      readCount: 4789,
    ),
    Post(
      id: '8',
      userName: 'healthy_lifestyle',
      title: '다이어트 한 달 만에 5kg 감량 성공!',
      content: '''
간헐적 단식(16:8)과 주 3회 유산소 운동으로 한 달 동안 5kg 뺐어요!
처음엔 힘들었지만, 일주일 지나니 몸이 훨씬 가벼워졌어요.
저녁은 샐러드 위주, 아침은 단백질 쉐이크로 대체했습니다.
이제 목표까지 10kg 남았는데, 끝까지 가보려구요 💪
다들 다이어트는 꾸준함이 답이에요!
''',
      createdAt: DateTime.now().subtract(Duration(days: 1, hours: 8)),
      likeCount: 743,
      commentCount: 52,
      readCount: 6532,
    ),
    Post(
      id: '9',
      userName: 'coffee_dreamer',
      title: '혼자 카페 창업 준비 중입니다 ☕',
      content: '''
10년 다닌 회사를 퇴사하고 꿈이었던 카페를 준비하고 있어요.
지금은 인테리어 업체랑 미팅하면서 콘셉트를 잡는 중입니다.
바리스타 자격증도 따고, 메뉴 테스트도 매일 하고 있어요.
솔직히 두렵지만 후회는 없습니다.
“내 공간”을 만든다는 설렘이 너무 커요 🌿
''',
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      likeCount: 532,
      commentCount: 48,
      readCount: 4021,
    ),
    Post(
      id: '10',
      userName: 'bookworm_alice',
      title: '책 읽는 습관 만들기 도전 중 📚',
      content: '''
올해 목표가 50권인데 아직 10권밖에 못 읽었어요.
요즘은 자기계발서보다 소설 위주로 읽고 있습니다.
최근엔 “아몬드”, “불편한 편의점”을 읽었는데 여운이 길게 남더군요.
매일 자기 전 30분이라도 책을 펴보려고 노력 중이에요.
읽은 책 추천해 주실 분 계신가요?
''',
      createdAt: DateTime.now().subtract(Duration(days: 2, hours: 5)),
      likeCount: 204,
      commentCount: 23,
      readCount: 1637,
    ),
    Post(
      id: '11',
      userName: 'puppy_parent',
      title: '강아지 입양 고민 중이에요 🐕',
      content: '''
혼자 살고 있는데 강아지 키우는 게 가능할까 고민이에요.
낮에는 회사에 있어서 돌봐줄 시간이 부족할 것 같아요.
그래도 퇴근하고 반겨주는 상상만 해도 행복하네요.
혹시 혼자 반려견 키우는 분들 계시면 현실적인 조언 부탁드립니다 🙏
''',
      createdAt: DateTime.now().subtract(Duration(days: 2, hours: 10)),
      likeCount: 388,
      commentCount: 33,
      readCount: 2850,
    ),
    Post(
      id: '12',
      userName: 'tokyo_wanderer',
      title: '일본 여행 가고 싶다... 🇯🇵',
      content: '''
언젠가 꼭 도쿄, 교토, 오사카를 한 번에 여행하고 싶어요.
유튜브로 브이로그 보니까 벌써 가슴이 설레네요.
요즘엔 여행 자금 모으느라 커피도 줄이고 있습니다.
언제쯤 자유롭게 여행 갈 수 있을까요?
혹시 일본 여행 꿀팁 있으신 분, 추천 코스 공유해 주세요!
''',
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      likeCount: 279,
      commentCount: 21,
      readCount: 1720,
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
