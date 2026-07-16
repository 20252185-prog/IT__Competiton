import { useState } from "react";
import {
  Home,
  Briefcase,
  PiggyBank,
  MoreHorizontal,
  ChevronRight,
  ChevronDown,
  CheckSquare,
  Square,
  FileText,
  BookOpen,
  AlertCircle,
  HelpCircle,
  TrendingUp,
  Gift,
  ClipboardList,
  Search,
  User,
  Settings,
  Phone,
  Plus,
  X,
  Check,
  Shield,
  Star,
  MessageCircle,
  Send,
  Bot,
} from "lucide-react";

type Tab = "housing" | "assets" | "employment" | "more";

// ─── Housing data ───────────────────────────────────────────────
const contractTips = [
  { id: 1, title: "계약 전 등기부등본 확인", desc: "근저당권, 압류, 가처분 등 권리관계를 반드시 확인하세요.", tag: "필수" },
  { id: 2, title: "전입신고 + 확정일자 받기", desc: "계약 후 14일 이내 전입신고, 주민센터에서 확정일자 도장을 받으면 보증금 보호.", tag: "필수" },
  { id: 3, title: "특약사항 꼼꼼히 체크", desc: "도배·장판 교체, 시설 수리 책임 범위를 계약서에 명시하세요.", tag: "권장" },
  { id: 4, title: "중개수수료 상한액 확인", desc: "보증금·월세 금액에 따라 법정 최대 수수료가 다릅니다. 초과 요구 시 거부 가능.", tag: "참고" },
  { id: 5, title: "임대인 신분 확인", desc: "계약 시 임대인의 신분증과 등기부등본상 소유자가 동일한지 대조하세요.", tag: "필수" },
];

const checklistItems = [
  { id: 1, text: "햇빛과 채광 확인 (남향 여부)" },
  { id: 2, text: "수압·온수 직접 테스트" },
  { id: 3, text: "벽면·천장 곰팡이 및 누수 흔적" },
  { id: 4, text: "콘센트 위치와 개수 확인" },
  { id: 5, text: "방음 상태 확인 (이웃 소음)" },
  { id: 6, text: "관리비 항목 및 금액 확인" },
  { id: 7, text: "주차 공간 및 자전거 보관" },
  { id: 8, text: "쓰레기 분리수거 방법 확인" },
  { id: 9, text: "엘리베이터 유무 (층수 고려)" },
  { id: 10, text: "인근 편의시설 (편의점, 마트, 병원)" },
];

const troubleshootingItems = [
  { id: 1, icon: "💧", title: "수도 누수 발생", steps: ["관할 지역 상수도사업본부(120)에 신고", "임대인에게 즉시 연락 후 문자/카톡으로 증거 남기기", "수리 완료 시 영수증 보관"] },
  { id: 2, icon: "❄️", title: "보일러·난방 고장", steps: ["임대인에게 즉시 연락", "제조사 AS센터 번호 확인 (보일러 본체에 스티커)", "겨울철 동파 방지는 임차인 관리 의무"] },
  { id: 3, icon: "🔐", title: "열쇠·도어락 분실", steps: ["임시 잠금 서비스 (동네 열쇠방 또는 119)", "임대인 동의 후 교체 비용 협의", "교체 영수증 보관 후 퇴실 시 정산"] },
  { id: 4, icon: "🪲", title: "해충·바퀴벌레 출몰", steps: ["관할 구청 방역팀 무료 방제 신청 가능", "자체 방역 후에도 재발 시 임대인과 비용 협의", "입주 전 상태를 사진으로 기록해두기"] },
];

const housingTerms = [
  { term: "전세", def: "보증금을 맡기고 월세 없이 거주하는 방식. 계약 종료 시 보증금 반환." },
  { term: "월세", def: "매달 일정 금액을 집주인에게 지불하는 방식." },
  { term: "반전세", def: "전세에서 일부를 월세로 전환한 혼합 방식." },
  { term: "관리비", def: "건물 유지·관리에 드는 비용. 공용전기·수도·청소비 등 포함." },
  { term: "중개수수료", def: "부동산 중개업자에게 지불하는 수수료. 법정 상한이 있음." },
  { term: "확정일자", def: "임대차 계약서에 주민센터가 날짜를 확인해주는 제도. 보증금 보호." },
  { term: "전입신고", def: "새 주소지를 주민센터에 신고하는 것. 법적 거주지 확정." },
  { term: "근저당", def: "집에 설정된 대출 담보. 경매 시 보증금보다 먼저 변제될 수 있음." },
];

// ─── Assets data ────────────────────────────────────────────────
const cheongyakSteps = [
  { step: "01", title: "청약통장 개설", desc: "주택청약종합저축 — 만 19세 이상 누구나 개설 가능. 1인 1계좌.", highlight: true },
  { step: "02", title: "납입 횟수 쌓기", desc: "매월 2만~50만 원 납입. 공공주택은 납입 횟수, 민영주택은 납입금액이 중요." },
  { step: "03", title: "청약 자격 확인", desc: "무주택 여부, 세대원 수, 소득 기준을 청약홈(www.applyhome.co.kr)에서 확인." },
  { step: "04", title: "분양 공고 확인", desc: "청약홈 공고 확인 후 청약 일정, 분양가, 타입 비교." },
  { step: "05", title: "청약 신청", desc: "모바일 또는 은행 창구에서 청약 신청. 당첨 시 계약금 준비." },
  { step: "06", title: "당첨 후 대출 준비", desc: "디딤돌 대출, 버팀목 대출 등 정부 저금리 상품 확인." },
];

const governmentPolicies = [
  { id: 1, tag: "주거", color: "bg-blue-100 text-blue-800", title: "청년 월세 한시 특별지원", desc: "만 19~34세, 월 최대 20만 원씩 최대 12개월 지원.", deadline: "연중 접수" },
  { id: 2, tag: "금융", color: "bg-green-100 text-green-800", title: "청년희망적금", desc: "연 최대 9.3% 금리 혜택. 만기 시 정부 저축장려금 지급.", deadline: "선착순 마감" },
  { id: 3, tag: "주거", color: "bg-blue-100 text-blue-800", title: "버팀목 전세자금 대출", desc: "중소기업 취업청년 연 1.2% 초저금리. 최대 1억 원.", deadline: "연중" },
  { id: 4, tag: "취업", color: "bg-purple-100 text-purple-800", title: "청년내일채움공제", desc: "2년 근속 시 1,200만 원 목돈 마련. 청년·기업·정부 공동 적립.", deadline: "연중" },
  { id: 5, tag: "복지", color: "bg-orange-100 text-orange-800", title: "국민건강보험 지역가입자 감면", desc: "소득 없는 청년 피부양자 자격 유지 또는 보험료 경감.", deadline: "연중" },
  { id: 6, tag: "교육", color: "bg-yellow-100 text-yellow-800", title: "국가장학금 (한국장학재단)", desc: "소득분위별 최대 전액 지원. 매 학기 신청.", deadline: "학기별 신청" },
];

// ─── Employment data ─────────────────────────────────────────────
const contractGuideItems = [
  { id: 1, title: "근로계약서는 반드시 서면으로", desc: "구두 계약은 분쟁 시 증명 불가. 계약서 사본은 내가 보관해야 합니다.", important: true },
  { id: 2, title: "4대 보험 가입 여부 확인", desc: "국민연금, 건강보험, 고용보험, 산재보험. 10인 미만 사업장도 의무 가입.", important: true },
  { id: 3, title: "임금 항목 세부 확인", desc: "기본급, 수당, 상여금 등 항목별 금액이 명시되어야 합니다." },
  { id: 4, title: "근로시간 및 휴게시간", desc: "주 40시간 + 연장수당. 4시간 근무 시 30분, 8시간 시 1시간 휴게." },
  { id: 5, title: "수습 기간과 급여", desc: "수습 3개월은 최저임금의 90%까지 지급 가능 (단, 단순노무직 제외)." },
  { id: 6, title: "퇴직금 규정", desc: "1년 이상 근무, 주 15시간 이상 시 퇴직금 발생. 퇴직 후 14일 이내 지급." },
];

const jobCategories = [
  { id: 1, icon: "💻", name: "IT·개발", sites: ["사람인", "원티드", "점핏"], tip: "포트폴리오 필수. GitHub 관리 중요." },
  { id: 2, icon: "📊", name: "경영·사무", sites: ["잡코리아", "사람인", "공공기관채용"], tip: "엑셀, 한컴오피스 자격증 우대." },
  { id: 3, icon: "🎨", name: "디자인·크리에이티브", sites: ["원티드", "크몽", "사람인"], tip: "포트폴리오 사이트 필수. 툴 숙련도 강조." },
  { id: 4, icon: "🏥", name: "의료·복지", sites: ["복지넷", "사람인", "워크넷"], tip: "자격증 종류와 경력 중심 지원." },
  { id: 5, icon: "🍳", name: "외식·서비스", sites: ["알바몬", "알바천국", "사람인"], tip: "초단기부터 정규직까지. 시급 꼭 확인." },
  { id: 6, icon: "🏗️", name: "건설·생산", sites: ["워크넷", "고용24", "사람인"], tip: "기능사 이상 자격증 보유 시 우대." },
];

// ─── Emergency contacts ──────────────────────────────────────────
const defaultContacts = [
  { id: 1, name: "경찰", number: "112", category: "긴급", color: "bg-red-100 text-red-700" },
  { id: 2, name: "소방·구급", number: "119", category: "긴급", color: "bg-red-100 text-red-700" },
  { id: 3, name: "생활민원 (다산콜)", number: "120", category: "생활", color: "bg-blue-100 text-blue-700" },
  { id: 4, name: "근로복지공단", number: "1588-0075", category: "취업", color: "bg-purple-100 text-purple-700" },
  { id: 5, name: "주거복지재단", number: "1600-0777", category: "주거", color: "bg-green-100 text-green-700" },
  { id: 6, name: "청년도약계좌 콜센터", number: "1397", category: "금융", color: "bg-yellow-100 text-yellow-700" },
];

// ─── Small reusable components ───────────────────────────────────
function SectionHeader({ title, subtitle }: { title: string; subtitle?: string }) {
  return (
    <div className="mb-4">
      <h2 className="text-lg font-semibold text-foreground">{title}</h2>
      {subtitle && <p className="text-sm text-muted-foreground mt-0.5">{subtitle}</p>}
    </div>
  );
}

function Card({ children, className = "" }: { children: React.ReactNode; className?: string }) {
  return (
    <div className={`bg-card rounded-xl border border-border shadow-sm ${className}`}>
      {children}
    </div>
  );
}

function TagBadge({ text, variant = "default" }: { text: string; variant?: "default" | "required" | "recommended" | "info" }) {
  const styles = {
    default: "bg-secondary text-secondary-foreground",
    required: "bg-red-100 text-red-700",
    recommended: "bg-blue-100 text-blue-700",
    info: "bg-gray-100 text-gray-600",
  };
  return (
    <span className={`inline-block text-xs font-medium px-2 py-0.5 rounded-full ${styles[variant]}`}>
      {text}
    </span>
  );
}

// ─── Accordion ───────────────────────────────────────────────────
function Accordion({ title, children, defaultOpen = false }: { title: string; children: React.ReactNode; defaultOpen?: boolean }) {
  const [open, setOpen] = useState(defaultOpen);
  return (
    <div className="border border-border rounded-xl overflow-hidden bg-card">
      <button
        className="w-full flex items-center justify-between px-4 py-3.5 text-left font-medium text-foreground hover:bg-muted transition-colors"
        onClick={() => setOpen(!open)}
      >
        <span className="text-sm">{title}</span>
        <ChevronDown className={`w-4 h-4 text-muted-foreground transition-transform duration-200 ${open ? "rotate-180" : ""}`} />
      </button>
      {open && <div className="px-4 pb-4 pt-1 border-t border-border">{children}</div>}
    </div>
  );
}

// ─── HOUSING TAB ─────────────────────────────────────────────────
function HousingTab() {
  const [checkedItems, setCheckedItems] = useState<number[]>([]);
  const [activeSection, setActiveSection] = useState<string | null>(null);

  const toggleCheck = (id: number) => {
    setCheckedItems((prev) => prev.includes(id) ? prev.filter((i) => i !== id) : [...prev, id]);
  };

  const sections = [
    { id: "terms", icon: BookOpen, label: "기본 용어 설명", color: "text-purple-600 bg-purple-50" },
    { id: "checklist", icon: CheckSquare, label: "방 구하기 체크리스트", color: "text-green-600 bg-green-50" },
    { id: "trouble", icon: AlertCircle, label: "트러블슈팅 가이드", color: "text-orange-600 bg-orange-50" },
    { id: "contract", icon: FileText, label: "계약서 팁", color: "text-blue-600 bg-blue-50" },
  ];

  if (activeSection === "contract") {
    return (
      <div>
        <button onClick={() => setActiveSection(null)} className="flex items-center gap-1.5 text-sm text-accent font-medium mb-4">
          ← 주거
        </button>
        <SectionHeader title="월세 계약서 팁" subtitle="계약 전후 반드시 확인해야 할 체크포인트" />
        <div className="space-y-3">
          {contractTips.map((tip) => (
            <Card key={tip.id} className="p-4">
              <div className="flex items-start justify-between gap-3">
                <div className="flex-1">
                  <p className="font-medium text-sm text-foreground mb-1">{tip.title}</p>
                  <p className="text-xs text-muted-foreground leading-relaxed">{tip.desc}</p>
                </div>
                <TagBadge
                  text={tip.tag}
                  variant={tip.tag === "필수" ? "required" : tip.tag === "권장" ? "recommended" : "info"}
                />
              </div>
            </Card>
          ))}
        </div>
      </div>
    );
  }

  if (activeSection === "checklist") {
    const progress = checkedItems.length;
    return (
      <div>
        <button onClick={() => setActiveSection(null)} className="flex items-center gap-1.5 text-sm text-accent font-medium mb-4">
          ← 주거
        </button>
        <SectionHeader title="자취방 구하기 체크리스트" />
        <Card className="p-4 mb-4">
          <div className="flex items-center justify-between mb-2">
            <span className="text-sm font-medium text-foreground">{progress} / {checklistItems.length} 완료</span>
            <span className="text-xs text-muted-foreground">{Math.round((progress / checklistItems.length) * 100)}%</span>
          </div>
          <div className="w-full bg-muted rounded-full h-2">
            <div
              className="bg-accent h-2 rounded-full transition-all duration-300"
              style={{ width: `${(progress / checklistItems.length) * 100}%` }}
            />
          </div>
        </Card>
        <div className="space-y-2">
          {checklistItems.map((item) => {
            const checked = checkedItems.includes(item.id);
            return (
              <button
                key={item.id}
                onClick={() => toggleCheck(item.id)}
                className="w-full flex items-center gap-3 bg-card p-3.5 rounded-xl border border-border text-left hover:bg-muted transition-colors"
              >
                {checked ? (
                  <CheckSquare className="w-5 h-5 text-accent flex-shrink-0" />
                ) : (
                  <Square className="w-5 h-5 text-muted-foreground flex-shrink-0" />
                )}
                <span className={`text-sm ${checked ? "line-through text-muted-foreground" : "text-foreground"}`}>
                  {item.text}
                </span>
              </button>
            );
          })}
        </div>
      </div>
    );
  }

  if (activeSection === "trouble") {
    return (
      <div>
        <button onClick={() => setActiveSection(null)} className="flex items-center gap-1.5 text-sm text-accent font-medium mb-4">
          ← 주거
        </button>
        <SectionHeader title="트러블슈팅 가이드" subtitle="자취 중 자주 발생하는 문제와 대처법" />
        <div className="space-y-3">
          {troubleshootingItems.map((item) => (
            <Accordion key={item.id} title={`${item.icon} ${item.title}`}>
              <ol className="space-y-2 mt-2">
                {item.steps.map((step, i) => (
                  <li key={i} className="flex gap-2.5 text-sm text-foreground">
                    <span className="flex-shrink-0 w-5 h-5 rounded-full bg-accent text-white text-xs flex items-center justify-center font-medium">
                      {i + 1}
                    </span>
                    <span className="leading-relaxed">{step}</span>
                  </li>
                ))}
              </ol>
            </Accordion>
          ))}
        </div>
      </div>
    );
  }

  if (activeSection === "terms") {
    return (
      <div>
        <button onClick={() => setActiveSection(null)} className="flex items-center gap-1.5 text-sm text-accent font-medium mb-4">
          ← 주거
        </button>
        <SectionHeader title="자취 기본 용어" subtitle="헷갈리기 쉬운 부동산·임대차 용어 정리" />
        <div className="space-y-2.5">
          {housingTerms.map((item, i) => (
            <Card key={i} className="p-4">
              <p className="font-semibold text-sm text-accent mb-1">{item.term}</p>
              <p className="text-xs text-muted-foreground leading-relaxed">{item.def}</p>
            </Card>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="bg-primary rounded-2xl p-5 mb-5 text-white">
        <p className="text-xs font-medium opacity-70 mb-1 uppercase tracking-wide">주거 가이드</p>
        <h2 className="text-xl font-bold mb-1">혼자 살기, 처음이라도 괜찮아</h2>
        <p className="text-sm opacity-80">계약부터 생활까지 알아야 할 모든 것</p>
      </div>
      <div className="grid grid-cols-2 gap-3">
        {sections.map((sec) => (
          <button
            key={sec.id}
            onClick={() => setActiveSection(sec.id)}
            className="bg-card border border-border rounded-xl p-4 text-left hover:shadow-md transition-all active:scale-95"
          >
            <div className={`w-10 h-10 rounded-lg ${sec.color} flex items-center justify-center mb-3`}>
              <sec.icon className="w-5 h-5" />
            </div>
            <p className="text-sm font-semibold text-foreground leading-snug">{sec.label}</p>
            <ChevronRight className="w-4 h-4 text-muted-foreground mt-2" />
          </button>
        ))}
      </div>
    </div>
  );
}

// ─── ASSETS TAB ──────────────────────────────────────────────────
function AssetsTab() {
  const [activeSection, setActiveSection] = useState<string | null>(null);
  const [activeFilter, setActiveFilter] = useState("전체");
  const filters = ["전체", "주거", "금융", "취업", "복지", "교육"];

  if (activeSection === "cheongyak") {
    return (
      <div>
        <button onClick={() => setActiveSection(null)} className="flex items-center gap-1.5 text-sm text-accent font-medium mb-4">
          ← 자산
        </button>
        <SectionHeader title="청약 가이드" subtitle="내 집 마련 첫 걸음, 청약통장부터 시작" />
        <div className="space-y-3">
          {cheongyakSteps.map((step) => (
            <div key={step.step} className={`rounded-xl p-4 border ${step.highlight ? "bg-primary text-white border-primary" : "bg-card border-border"}`}>
              <div className="flex items-start gap-3">
                <span className={`text-xs font-bold font-mono flex-shrink-0 mt-0.5 ${step.highlight ? "text-white/60" : "text-muted-foreground"}`}>
                  STEP {step.step}
                </span>
                <div>
                  <p className={`font-semibold text-sm mb-1 ${step.highlight ? "text-white" : "text-foreground"}`}>{step.title}</p>
                  <p className={`text-xs leading-relaxed ${step.highlight ? "text-white/80" : "text-muted-foreground"}`}>{step.desc}</p>
                </div>
              </div>
            </div>
          ))}
        </div>
        <Card className="p-4 mt-4 border-blue-200 bg-blue-50">
          <div className="flex gap-2">
            <Shield className="w-4 h-4 text-blue-600 flex-shrink-0 mt-0.5" />
            <p className="text-xs text-blue-800 leading-relaxed">
              <strong>무주택 기간이 길수록 유리합니다.</strong> 청약 점수는 무주택 기간, 부양가족 수, 청약통장 가입 기간으로 결정됩니다.
            </p>
          </div>
        </Card>
      </div>
    );
  }

  if (activeSection === "policy") {
    const filtered = activeFilter === "전체"
      ? governmentPolicies
      : governmentPolicies.filter((p) => p.tag === activeFilter);

    return (
      <div>
        <button onClick={() => setActiveSection(null)} className="flex items-center gap-1.5 text-sm text-accent font-medium mb-4">
          ← 자산
        </button>
        <SectionHeader title="정부 지원 정책" subtitle="청년을 위한 지원금·혜택 모아보기" />
        <div className="flex gap-2 overflow-x-auto pb-2 mb-4" style={{ scrollbarWidth: "none" }}>
          {filters.map((f) => (
            <button
              key={f}
              onClick={() => setActiveFilter(f)}
              className={`flex-shrink-0 px-3 py-1.5 rounded-full text-xs font-medium transition-colors ${
                activeFilter === f ? "bg-primary text-white" : "bg-card border border-border text-muted-foreground"
              }`}
            >
              {f}
            </button>
          ))}
        </div>
        <div className="space-y-3">
          {filtered.map((policy) => (
            <Card key={policy.id} className="p-4">
              <div className="flex items-start justify-between gap-2 mb-2">
                <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${policy.color}`}>{policy.tag}</span>
                <span className="text-xs text-muted-foreground">{policy.deadline}</span>
              </div>
              <p className="font-semibold text-sm text-foreground mb-1">{policy.title}</p>
              <p className="text-xs text-muted-foreground leading-relaxed">{policy.desc}</p>
            </Card>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="bg-gradient-to-br from-[#1A3F6F] to-[#2468B2] rounded-2xl p-5 mb-5 text-white">
        <p className="text-xs font-medium opacity-70 mb-1 uppercase tracking-wide">자산 가이드</p>
        <h2 className="text-xl font-bold mb-1">지금 시작하면 늦지 않아</h2>
        <p className="text-sm opacity-80">청약부터 정부 혜택까지 똑똑하게 챙기기</p>
      </div>

      <div className="grid grid-cols-2 gap-3">
        {[
          { id: "cheongyak", icon: TrendingUp, label: "청약 가이드", color: "text-blue-600 bg-blue-50" },
          { id: "policy", icon: Gift, label: "정부 지원 정책 모아보기", color: "text-green-600 bg-green-50" },
        ].map((sec) => (
          <button
            key={sec.id}
            onClick={() => setActiveSection(sec.id)}
            className="bg-card border border-border rounded-xl p-4 text-left hover:shadow-md transition-all active:scale-95"
          >
            <div className={`w-10 h-10 rounded-lg ${sec.color} flex items-center justify-center mb-3`}>
              <sec.icon className="w-5 h-5" />
            </div>
            <p className="text-sm font-semibold text-foreground leading-snug">{sec.label}</p>
            <ChevronRight className="w-4 h-4 text-muted-foreground mt-2" />
          </button>
        ))}
      </div>
    </div>
  );
}

// ─── EMPLOYMENT TAB ──────────────────────────────────────────────
function EmploymentTab() {
  const [activeSection, setActiveSection] = useState<string | null>(null);

  if (activeSection === "contract") {
    return (
      <div>
        <button onClick={() => setActiveSection(null)} className="flex items-center gap-1.5 text-sm text-accent font-medium mb-4">
          ← 취업
        </button>
        <SectionHeader title="근로계약서 가이드" subtitle="서명 전, 이것만은 꼭 확인하세요" />
        <div className="space-y-3">
          {contractGuideItems.map((item) => (
            <Card key={item.id} className={`p-4 ${item.important ? "border-l-4 border-l-red-400" : ""}`}>
              <div className="flex items-start gap-3">
                {item.important ? (
                  <AlertCircle className="w-4 h-4 text-red-500 flex-shrink-0 mt-0.5" />
                ) : (
                  <Check className="w-4 h-4 text-green-500 flex-shrink-0 mt-0.5" />
                )}
                <div>
                  <p className="font-semibold text-sm text-foreground mb-1">{item.title}</p>
                  <p className="text-xs text-muted-foreground leading-relaxed">{item.desc}</p>
                </div>
              </div>
            </Card>
          ))}
        </div>
        <Card className="p-4 mt-4 border-orange-200 bg-orange-50">
          <p className="text-xs text-orange-800 font-medium mb-1">💡 이럴 때는 고용노동부에 신고하세요</p>
          <p className="text-xs text-orange-700 leading-relaxed">
            근로계약서 미작성, 임금 체불, 부당해고 시 고용노동부 (1350) 또는 고용24 앱에서 신고 가능합니다.
          </p>
        </Card>
      </div>
    );
  }

  if (activeSection === "jobs") {
    return (
      <div>
        <button onClick={() => setActiveSection(null)} className="flex items-center gap-1.5 text-sm text-accent font-medium mb-4">
          ← 취업
        </button>
        <SectionHeader title="직종별 취업 정보" subtitle="내게 맞는 직종을 찾아보세요" />
        <div className="space-y-3">
          {jobCategories.map((cat) => (
            <Card key={cat.id} className="p-4">
              <div className="flex items-start gap-3">
                <span className="text-2xl flex-shrink-0">{cat.icon}</span>
                <div className="flex-1">
                  <p className="font-semibold text-sm text-foreground mb-1">{cat.name}</p>
                  <p className="text-xs text-muted-foreground mb-2 leading-relaxed">{cat.tip}</p>
                  <div className="flex flex-wrap gap-1.5">
                    {cat.sites.map((site) => (
                      <span key={site} className="bg-secondary text-secondary-foreground text-xs px-2 py-0.5 rounded-full">
                        {site}
                      </span>
                    ))}
                  </div>
                </div>
              </div>
            </Card>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="bg-gradient-to-br from-[#1F3A5F] to-[#3B6EA5] rounded-2xl p-5 mb-5 text-white">
        <p className="text-xs font-medium opacity-70 mb-1 uppercase tracking-wide">취업 가이드</p>
        <h2 className="text-xl font-bold mb-1">내 권리는 내가 지킨다</h2>
        <p className="text-sm opacity-80">계약서부터 취업 채널까지 한 번에</p>
      </div>

      <div className="grid grid-cols-2 gap-3 mb-5">
        {[
          { id: "contract", icon: ClipboardList, label: "근로계약서 가이드", color: "text-red-500 bg-red-50" },
          { id: "jobs", icon: Search, label: "직종별 취업 모아보기", color: "text-purple-600 bg-purple-50" },
        ].map((sec) => (
          <button
            key={sec.id}
            onClick={() => setActiveSection(sec.id)}
            className="bg-card border border-border rounded-xl p-4 text-left hover:shadow-md transition-all active:scale-95"
          >
            <div className={`w-10 h-10 rounded-lg ${sec.color} flex items-center justify-center mb-3`}>
              <sec.icon className="w-5 h-5" />
            </div>
            <p className="text-sm font-semibold text-foreground leading-snug">{sec.label}</p>
            <ChevronRight className="w-4 h-4 text-muted-foreground mt-2" />
          </button>
        ))}
      </div>

      <div className="bg-card border border-border rounded-xl p-4">
        <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wide mb-3">주요 구직 사이트</p>
        <div className="space-y-1">
          {["사람인", "잡코리아", "원티드", "워크넷", "고용24", "링크드인"].map((name) => (
            <div key={name} className="flex items-center justify-between py-2.5 border-b border-border last:border-0">
              <span className="text-sm text-foreground">{name}</span>
              <ChevronRight className="w-4 h-4 text-muted-foreground" />
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// ─── MORE TAB ────────────────────────────────────────────────────
function MoreTab() {
  const [contacts, setContacts] = useState(defaultContacts);
  const [showAddForm, setShowAddForm] = useState(false);
  const [newContact, setNewContact] = useState({ name: "", number: "", category: "기타" });
  const [activeSection, setActiveSection] = useState<string | null>(null);

  const addContact = () => {
    if (!newContact.name || !newContact.number) return;
    setContacts((prev) => [
      ...prev,
      { id: Date.now(), ...newContact, color: "bg-gray-100 text-gray-700" },
    ]);
    setNewContact({ name: "", number: "", category: "기타" });
    setShowAddForm(false);
  };

  const removeContact = (id: number) => {
    setContacts((prev) => prev.filter((c) => c.id !== id));
  };

  if (activeSection === "contacts") {
    return (
      <div>
        <button onClick={() => setActiveSection(null)} className="flex items-center gap-1.5 text-sm text-accent font-medium mb-4">
          ← 더보기
        </button>
        <div className="flex items-center justify-between mb-4">
          <SectionHeader title="비상연락처" subtitle="긴급 상황 시 빠르게 연락하세요" />
          <button
            onClick={() => setShowAddForm(!showAddForm)}
            className="flex items-center gap-1.5 bg-primary text-white text-xs font-medium px-3 py-2 rounded-lg"
          >
            <Plus className="w-3.5 h-3.5" /> 추가
          </button>
        </div>

        {showAddForm && (
          <Card className="p-4 mb-4 border-accent">
            <p className="text-sm font-semibold text-foreground mb-3">새 연락처 추가</p>
            <div className="space-y-2.5">
              <input
                type="text"
                placeholder="이름 (예: 집주인)"
                value={newContact.name}
                onChange={(e) => setNewContact((p) => ({ ...p, name: e.target.value }))}
                className="w-full bg-input-background rounded-lg px-3 py-2.5 text-sm text-foreground placeholder:text-muted-foreground outline-none focus:ring-2 focus:ring-ring"
              />
              <input
                type="tel"
                placeholder="전화번호"
                value={newContact.number}
                onChange={(e) => setNewContact((p) => ({ ...p, number: e.target.value }))}
                className="w-full bg-input-background rounded-lg px-3 py-2.5 text-sm text-foreground placeholder:text-muted-foreground outline-none focus:ring-2 focus:ring-ring"
              />
              <select
                value={newContact.category}
                onChange={(e) => setNewContact((p) => ({ ...p, category: e.target.value }))}
                className="w-full bg-input-background rounded-lg px-3 py-2.5 text-sm text-foreground outline-none focus:ring-2 focus:ring-ring"
              >
                {["긴급", "주거", "취업", "금융", "복지", "기타"].map((c) => (
                  <option key={c} value={c}>{c}</option>
                ))}
              </select>
              <div className="flex gap-2">
                <button onClick={addContact} className="flex-1 bg-primary text-white py-2 rounded-lg text-sm font-medium">
                  저장
                </button>
                <button onClick={() => setShowAddForm(false)} className="flex-1 bg-muted text-muted-foreground py-2 rounded-lg text-sm font-medium">
                  취소
                </button>
              </div>
            </div>
          </Card>
        )}

        <div className="space-y-2">
          {contacts.map((contact) => (
            <div key={contact.id} className="bg-card border border-border rounded-xl px-4 py-3.5 flex items-center gap-3">
              <Phone className="w-4 h-4 text-muted-foreground flex-shrink-0" />
              <div className="flex-1 min-w-0">
                <p className="font-medium text-sm text-foreground">{contact.name}</p>
                <p className="text-xs text-muted-foreground">{contact.number}</p>
              </div>
              <span className={`text-xs font-medium px-2 py-0.5 rounded-full flex-shrink-0 ${contact.color}`}>
                {contact.category}
              </span>
              {contact.id > 6 && (
                <button onClick={() => removeContact(contact.id)} className="text-muted-foreground hover:text-red-500 transition-colors">
                  <X className="w-4 h-4" />
                </button>
              )}
            </div>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="space-y-2">
        <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wide mb-2 mt-1">기능</p>
        <button
          onClick={() => setActiveSection("contacts")}
          className="w-full bg-card border border-border rounded-xl px-4 py-3.5 flex items-center gap-3 text-left hover:bg-muted transition-colors"
        >
          <Phone className="w-4 h-4 text-muted-foreground" />
          <div className="flex-1">
            <span className="text-sm text-foreground">비상연락처</span>
          </div>
          <span className="bg-secondary text-secondary-foreground text-xs px-2 py-0.5 rounded-full">{contacts.length}개</span>
          <ChevronRight className="w-4 h-4 text-muted-foreground" />
        </button>

        <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wide mb-2 mt-4">앱 정보</p>
        <div className="bg-card border border-border rounded-xl px-4 py-3.5 flex items-center">
          <span className="text-sm text-foreground flex-1">공지사항</span>
          <ChevronRight className="w-4 h-4 text-muted-foreground" />
        </div>
      </div>
    </div>
  );
}

// ─── CHATBOT ─────────────────────────────────────────────────────
const botResponses: Record<string, string> = {
  default: "죄송해요, 조금 더 구체적으로 질문해 주시면 도움드릴게요 😊",
  계약: "월세 계약 시 꼭 확인할 것: ① 등기부등본 근저당 확인 ② 전입신고 + 확정일자 ③ 특약사항 기재. 계약서 사본은 반드시 보관하세요!",
  전입: "전입신고는 계약 후 14일 이내에 주민센터 또는 정부24(www.gov.kr)에서 온라인으로도 가능합니다. 전입신고와 동시에 확정일자를 받으면 보증금이 보호됩니다.",
  청약: "청약통장(주택청약종합저축)은 만 19세 이상 누구나 개설 가능합니다. 매월 2~50만 원 납입하며, 납입 횟수와 금액이 청약 당첨에 영향을 줍니다.",
  월세: "청년 월세 한시 특별지원을 통해 월 최대 20만 원, 최대 12개월 지원받을 수 있어요. 복지로(www.bokjiro.go.kr)에서 신청하세요.",
  근로: "근로계약서는 반드시 서면으로 받아야 합니다. 미작성 시 사업주는 500만 원 이하 벌금. 계약서에는 임금, 근로시간, 휴일, 4대보험 내용이 모두 포함돼야 해요.",
  퇴직금: "퇴직금은 1년 이상 근무 + 주 15시간 이상 조건을 충족하면 받을 수 있어요. 퇴직 후 14일 이내에 지급되어야 하며, 미지급 시 고용노동부(1350)에 신고 가능합니다.",
  보일러: "보일러 고장은 임대인에게 즉시 연락하고 문자로 증거를 남기세요. 겨울철 동파는 임차인 관리 의무이므로 외출 시 최소 5°C 이상 유지하세요.",
  지원금: "대표적인 청년 지원금: 청년 월세 지원(20만 원/월), 청년희망적금, 청년내일채움공제(2년 1,200만 원), 버팀목 전세대출. 자산 탭에서 전체 정책을 확인해 보세요!",
};

function getBotReply(input: string): string {
  const key = Object.keys(botResponses).find((k) => k !== "default" && input.includes(k));
  return key ? botResponses[key] : botResponses.default;
}

const quickQuestions = ["계약서 팁", "청약 방법", "월세 지원금", "퇴직금 조건"];

function ChatbotModal({ onClose }: { onClose: () => void }) {
  const [messages, setMessages] = useState([
    { from: "bot", text: "안녕하세요! 주거·자산·취업에 관해 궁금한 점을 물어보세요 😊" },
  ]);
  const [input, setInput] = useState("");
  const bottomRef = useState<HTMLDivElement | null>(null);

  const send = (text: string) => {
    if (!text.trim()) return;
    const userMsg = { from: "user", text };
    const botMsg = { from: "bot", text: getBotReply(text) };
    setMessages((prev) => [...prev, userMsg, botMsg]);
    setInput("");
  };

  return (
    <div className="absolute inset-0 z-50 flex flex-col bg-background rounded-[2rem] overflow-hidden">
      {/* Chat header */}
      <div className="flex items-center gap-3 px-5 py-4 border-b border-border bg-card flex-shrink-0">
        <div className="w-9 h-9 rounded-full bg-primary flex items-center justify-center">
          <Bot className="w-5 h-5 text-white" />
        </div>
        <div className="flex-1">
          <p className="font-semibold text-sm text-foreground">AI 도우미</p>
          <p className="text-xs text-green-500 font-medium">● 온라인</p>
        </div>
        <button onClick={onClose} className="w-8 h-8 rounded-full bg-muted flex items-center justify-center hover:bg-border transition-colors">
          <X className="w-4 h-4 text-muted-foreground" />
        </button>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto px-4 py-4 space-y-3" style={{ scrollbarWidth: "none" }}>
        {messages.map((msg, i) => (
          <div key={i} className={`flex gap-2 ${msg.from === "user" ? "justify-end" : "justify-start"}`}>
            {msg.from === "bot" && (
              <div className="w-7 h-7 rounded-full bg-primary flex items-center justify-center flex-shrink-0 mt-0.5">
                <Bot className="w-4 h-4 text-white" />
              </div>
            )}
            <div
              className={`max-w-[75%] px-3.5 py-2.5 rounded-2xl text-sm leading-relaxed ${
                msg.from === "user"
                  ? "bg-primary text-primary-foreground rounded-tr-sm"
                  : "bg-card border border-border text-foreground rounded-tl-sm"
              }`}
            >
              {msg.text}
            </div>
          </div>
        ))}
      </div>

      {/* Quick questions */}
      {messages.length <= 3 && (
        <div className="px-4 pb-2 flex gap-2 overflow-x-auto flex-shrink-0" style={{ scrollbarWidth: "none" }}>
          {quickQuestions.map((q) => (
            <button
              key={q}
              onClick={() => send(q)}
              className="flex-shrink-0 bg-secondary text-secondary-foreground text-xs font-medium px-3 py-1.5 rounded-full border border-border"
            >
              {q}
            </button>
          ))}
        </div>
      )}

      {/* Input */}
      <div className="flex-shrink-0 px-4 py-3 border-t border-border bg-card">
        <div className="flex items-center gap-2 bg-muted rounded-xl px-3 py-2">
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && send(input)}
            placeholder="질문을 입력하세요..."
            className="flex-1 bg-transparent text-sm text-foreground placeholder:text-muted-foreground outline-none"
          />
          <button
            onClick={() => send(input)}
            disabled={!input.trim()}
            className="w-7 h-7 rounded-full bg-primary flex items-center justify-center disabled:opacity-40 transition-opacity"
          >
            <Send className="w-3.5 h-3.5 text-white" />
          </button>
        </div>
      </div>
    </div>
  );
}

// ─── MAIN APP ────────────────────────────────────────────────────
export default function App() {
  const [activeTab, setActiveTab] = useState<Tab>("housing");
  const [chatOpen, setChatOpen] = useState(false);

  const tabs = [
    { id: "housing" as Tab, icon: Home, label: "주거" },
    { id: "assets" as Tab, icon: PiggyBank, label: "자산" },
    { id: "employment" as Tab, icon: Briefcase, label: "취업" },
    { id: "more" as Tab, icon: MoreHorizontal, label: "더보기" },
  ];

  const content: Record<Tab, React.ReactNode> = {
    housing: <HousingTab />,
    assets: <AssetsTab />,
    employment: <EmploymentTab />,
    more: <MoreTab />,
  };

  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-4">
      <div
        className="relative bg-background flex flex-col overflow-hidden shadow-2xl"
        style={{
          width: "min(100%, 390px)",
          height: "min(100vh, 844px)",
          borderRadius: "2rem",
          border: "1px solid var(--border)",
          fontFamily: "'Noto Sans KR', 'Inter', sans-serif",
        }}
      >
        {/* Header */}
        <div className="px-5 py-3 flex-shrink-0 border-b border-border">
          <h1 className="text-base font-bold text-foreground">
            {activeTab === "housing" && "주거"}
            {activeTab === "assets" && "자산"}
            {activeTab === "employment" && "취업"}
            {activeTab === "more" && "더보기"}
          </h1>
        </div>

        {/* Chatbot overlay */}
        {chatOpen && <ChatbotModal onClose={() => setChatOpen(false)} />}

        {/* Content */}
        <div className="flex-1 overflow-y-auto px-4 py-4" style={{ scrollbarWidth: "none" }}>
          {content[activeTab]}
          <div className="h-4" />
        </div>

        {/* Chatbot FAB */}
        {!chatOpen && (
          <button
            onClick={() => setChatOpen(true)}
            className="absolute bottom-20 right-4 z-40 w-13 h-13 rounded-full bg-primary shadow-lg flex items-center justify-center hover:scale-105 active:scale-95 transition-transform"
            style={{ width: "52px", height: "52px" }}
            aria-label="AI 도우미 열기"
          >
            <MessageCircle className="w-6 h-6 text-white" strokeWidth={2} />
          </button>
        )}

        {/* Bottom tab bar */}
        <div className="flex-shrink-0 border-t border-border bg-card px-2 pb-safe">
          <div className="flex">
            {tabs.map((tab) => {
              const active = activeTab === tab.id;
              return (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className="flex-1 flex flex-col items-center gap-1 py-3 transition-all"
                >
                  <tab.icon
                    className={`w-5 h-5 transition-colors ${active ? "text-primary" : "text-muted-foreground"}`}
                    strokeWidth={active ? 2.5 : 1.8}
                  />
                  <span
                    className={`text-[10px] font-medium transition-colors ${active ? "text-primary" : "text-muted-foreground"}`}
                  >
                    {tab.label}
                  </span>
                  {active && <div className="w-4 h-0.5 bg-primary rounded-full" />}
                </button>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
}
