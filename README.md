# 📱 사회초년생 맞춤형 자립 지원 플랫폼

사회에 첫발을 내딛는 청년 및 사회초년생을 위한 **주거·자산·취업 통합 가이드 모바일 애플리케이션(android)**입니다.

---

## 🚀 주요 기능 (Features)

### 🏠 주거

* 기본 용어 설명
* 방 구하기 체크리스트
* 트러블슈팅 가이드
* 계약서 팁

### 💰 자산

* 청약 가이드
* 확인해야 할 정부 지원금

### 💼 취업

* 근로계약서 가이드
* 주요 구직 사이트

### 🤖 AI 챗봇

* Google Gemini 기반 AI 챗봇
* 주거·자산·취업 관련 맞춤형 질의응답
* 청년 정책 및 자립 정보 안내

### 📱 더보기

* 비상 연락처 제공
* 사용자 연락처 추가 및 관리

---

## 🛠 Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend & Platform:** Firebase
- **AI Model / API:** Google Gemini Developer API
- **Design & Tools:** Figma, GitHub, VS Code
- **Test Device:** Samsung Galaxy Tab (Android)

---

 ## 📁 프로젝트 구조

```text
lib/
├── constants/             # 앱 공통 디자인 상수
│   └── colors.dart
├── models/                # 앱 데이터 및 모델
│   └── app_data.dart
├── screens/               # 주요 화면
│   ├── assets_tab.dart
│   ├── chatbot_screen.dart
│   ├── employment_tab.dart
│   ├── housing_tab.dart
│   ├── main_screen.dart
│   └── more_tab.dart
├── widgets/               # 재사용 가능한 UI 컴포넌트
│   ├── accordion_item.dart
│   ├── app_card.dart
│   ├── back_button.dart
│   ├── grid_menu_card.dart
│   ├── section_header.dart
│   └── tag_badge.dart
├── firebase_options.dart  # Firebase 프로젝트 설정
└── main.dart              # 앱 진입점
```

---

## 👥 Members & Roles

| Member | Main Role | Responsibilities |
| --- | --- | --- |
| 👑 **황세원**<br>`SW313131` | Project Leader | • 팀 리딩 및 프로젝트 총괄<br>• 서비스 기획 및 발표/문서 작성<br>• Figma UI/UX 디자인 및 자료 조사<br>• 앱 콘텐츠 검수 및 자료 정확성·오류 확인 |
| **윤서연**<br>`20252192-maker` | Frontend Developer | • Flutter 프론트엔드 전반 UI/UX 및 기능 개발<br>• Flutter 코드 구조 개선 및 기능별 모듈화 (화면·상수·데이터·위젯 분리)<br>• Gemini API 연동 보조<br>• Figma UI/UX 디자인 및 서비스 기획·자료 조사 |
| **안예원**<br>`20252185-prog` | AI / Technical Developer | • Firebase 및 Gemini API 연동 구축<br>• GitHub 레포지토리 관리 및 Flutter 개발 지원<br>• Figma 디자인 및 자료 조사 |
| **김유진**<br>`yj2157` | Planner / UI·UX Designer | • 서비스 핵심 아이디어 기획 및 Figma 디자인<br>• Flutter 더보기 비상연락처 탭 UI 개발 및 기능 보완<br>• 관련 자료 조사 및 서비스 컨셉 수립 |
---



## 📌 Project Status

✅ **Completed**

* Flutter 기반의 모바일 앱 UI 및 주요 가이드 기능을 모두 구현하였습니다.
* **Firebase AI Logic**을 연동하여 **Google Gemini Developer API** 기반의 맞춤형 AI 챗봇 기능을 완성하였습니다.
* Samsung Galaxy Tab 실기기 환경에서 개발 및 최종 테스트를 진행하였습니다.

| 주거 탭 메인 화면 | 자산 탭 메인 화면 |
| :---: | :---: |
| <img src="https://github.com/user-attachments/assets/c94543aa-9912-4168-9802-81eb39b5f2fd" width="350"> | <img src="https://github.com/user-attachments/assets/4a0ee8b1-e1ed-4f2b-a299-b981fc0c1025" width="350"> |
| **취업 탭 (주요 구직 사이트 안내)** | **Gemini AI 챗봇 시연 화면** |
| <img src="https://github.com/user-attachments/assets/73e6fb66-5f7f-4429-85a0-39f2c3f347de" width="350"> | <img src="https://github.com/user-attachments/assets/16331f58-0733-4101-a4e8-7557e6729236" width="350"> |





