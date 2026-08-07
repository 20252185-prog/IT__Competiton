// 앱이 정상적으로 뜨고 하단 탭이 그려지는지 확인하는 기본 테스트.
// Firebase는 테스트 환경에서 초기화되지 않으므로 MyApp 위젯만 직접 띄운다.

import 'package:flutter_test/flutter_test.dart';

import 'package:it_app/main.dart';

void main() {
  testWidgets('앱 실행 시 하단 네비게이션 탭이 모두 보인다', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('주거'), findsWidgets);
    expect(find.text('자산'), findsWidgets);
    expect(find.text('취업'), findsWidgets);
    expect(find.text('더보기'), findsWidgets);
  });
}
