// 앱이 정상적으로 뜨고 하단 탭이 그려지는지 확인하는 기본 테스트.
// main()을 거치지 않으므로 Firebase는 초기화되지 않고, 챗봇 화면도 열지 않는다.
// 다만 각 탭이 SharedPreferences를 읽으므로 테스트용 저장소를 미리 넣어 준다.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:it_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('앱 실행 시 하단 네비게이션 탭이 모두 보인다', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('주거'), findsWidgets);
    expect(find.text('자산'), findsWidgets);
    expect(find.text('취업'), findsWidgets);
    expect(find.text('더보기'), findsWidgets);
  });
}
