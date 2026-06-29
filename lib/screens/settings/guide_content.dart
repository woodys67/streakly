import '../../l10n/app_strings.dart';

class GuideContent {
  static String howToUse(AppStrings s) => _pick(s, _howToUse);
  static String createChallenge(AppStrings s) => _pick(s, _createChallenge);
  static String streakSystem(AppStrings s) => _pick(s, _streakSystem);
  static String streakRecovery(AppStrings s) => _pick(s, _streakRecovery);
  static String willpower(AppStrings s) => _pick(s, _willpower);
  static String badge(AppStrings s) => _pick(s, _badge);
  static String pauseTicket(AppStrings s) => _pick(s, _pauseTicket);

  static String _pick(AppStrings s, Map<String, String> map) {
    final lang = s.langCode;
    return map[lang] ?? map['ko']!;
  }

  // ─────────────────────────────────────────────────────────────
  // 사용법
  // ─────────────────────────────────────────────────────────────
  static const Map<String, String> _howToUse = {
    'ko': '''
## 기본 흐름

**챌린지 생성 → 매일 루틴 체크 → 스트릭 누적 → 의지력·레벨 성장 → 배지 획득**

---

## 화면 구성

| 탭 | 역할 |
|---|---|
| 🏠 홈 | 의지력 카드, 오늘의 루틴 목록 |
| 🚩 챌린지 | 진행 중인 챌린지 관리 및 달력 |
| 📊 기록 | 스트릭 레이스, 배지 컬렉션, 통계, 완료 챌린지 |
| 👤 프로필 | 계정, 구독, 앱 설정, 앱 가이드 |

---

## 오늘의 루틴 완료하기

1. 홈 화면에서 오늘 해야 할 루틴 카드를 확인합니다.
2. 카드 좌측의 **원형 버튼**을 눌러 완료 처리합니다.
3. 서브루틴이 있는 경우, 각 항목을 모두 체크해야 해당 날짜가 달성됩니다.
4. 완료된 카드는 **초록색 테두리**와 취소선으로 표시됩니다.

---

## 새 챌린지 시작하기

홈 화면 우측 하단의 **＋ 버튼**을 눌러 새 챌린지를 만들 수 있습니다.
''',
    'en': '''
## Basic Flow

**Create Challenge → Check Daily Routine → Build Streak → Grow Willpower & Level → Earn Badges**

---

## Screen Layout

| Tab | Role |
|---|---|
| 🏠 Home | Willpower card, today's routine list |
| 🚩 Challenges | Manage active challenges & calendar |
| 📊 Records | Streak Race, badge collection, stats, completed challenges |
| 👤 Profile | Account, subscription, app settings, app guide |

---

## Completing Today's Routine

1. Find your routine card on the Home screen.
2. Tap the **circle button** on the left to mark it done.
3. If sub-routines exist, check all of them to complete the day.
4. A completed card shows a **green border** and strikethrough text.

---

## Starting a New Challenge

Tap the **＋ button** in the bottom-right corner of the Home screen.
''',
    'ja': '''
## 基本の流れ

**チャレンジ作成 → 毎日ルーティンチェック → ストリーク積み上げ → 意志力・レベルアップ → バッジ獲得**

---

## 画面構成

| タブ | 役割 |
|---|---|
| 🏠 ホーム | 意志力カード、今日のルーティン一覧 |
| 🚩 チャレンジ | 進行中のチャレンジ管理・カレンダー |
| 📊 記録 | ストリークレース、バッジ、統計、完了チャレンジ |
| 👤 プロフィール | アカウント、サブスク、アプリ設定、ガイド |

---

## 今日のルーティンを完了する

1. ホーム画面で今日のルーティンカードを確認します。
2. カード左側の**円ボタン**をタップして完了します。
3. サブルーティンがある場合、すべてチェックするとその日が達成されます。
4. 完了カードは**緑色の枠**と取り消し線で表示されます。

---

## 新しいチャレンジを始める

ホーム画面右下の**＋ボタン**をタップします。
''',
    'zhCN': '''
## 基本流程

**创建挑战 → 每天打卡 → 积累连续 → 提升意志力和等级 → 获得徽章**

---

## 页面结构

| 标签 | 功能 |
|---|---|
| 🏠 主页 | 意志力卡片、今日任务列表 |
| 🚩 挑战 | 管理进行中的挑战和日历 |
| 📊 记录 | 连续竞赛、徽章收集、统计、已完成挑战 |
| 👤 个人资料 | 账户、订阅、应用设置、应用指南 |

---

## 完成今日任务

1. 在主页查看今日任务卡片。
2. 点击卡片左侧的**圆形按钮**标记完成。
3. 如有子任务，需全部完成才算当天达成。
4. 完成的卡片显示**绿色边框**和删除线。

---

## 开始新挑战

点击主页右下角的**＋按钮**。
''',
    'es': '''
## Flujo básico

**Crear reto → Marcar rutina diaria → Acumular racha → Aumentar fuerza de voluntad y nivel → Ganar insignias**

---

## Estructura de pantallas

| Pestaña | Función |
|---|---|
| 🏠 Inicio | Tarjeta de fuerza de voluntad, rutinas de hoy |
| 🚩 Retos | Gestionar retos activos y calendario |
| 📊 Registros | Carrera de rachas, insignias, estadísticas, retos completados |
| 👤 Perfil | Cuenta, suscripción, ajustes, guía |

---

## Completar la rutina de hoy

1. Encuentra tu tarjeta de rutina en la pantalla de Inicio.
2. Toca el **botón circular** de la izquierda para marcarla como hecha.
3. Si hay sub-retos, marca todos para completar el día.
4. Una tarjeta completada muestra un **borde verde** y texto tachado.

---

## Iniciar un nuevo reto

Toca el **botón ＋** en la esquina inferior derecha de la pantalla de Inicio.
''',
    'de': '''
## Grundlegender Ablauf

**Challenge erstellen → Tägliche Routine abhaken → Streak aufbauen → Willenskraft & Level steigern → Abzeichen verdienen**

---

## Bildschirmstruktur

| Tab | Funktion |
|---|---|
| 🏠 Startseite | Willenskraft-Karte, heutige Routinen |
| 🚩 Challenges | Aktive Challenges & Kalender verwalten |
| 📊 Aufzeichnungen | Streak-Rennen, Abzeichen, Statistiken, abgeschlossene Challenges |
| 👤 Profil | Konto, Abonnement, App-Einstellungen, Guide |

---

## Heutige Routine abschließen

1. Finde deine Routine-Karte auf der Startseite.
2. Tippe auf den **Kreisknopf** links, um sie als erledigt zu markieren.
3. Bei Sub-Routinen müssen alle Punkte abgehakt werden.
4. Eine erledigte Karte zeigt einen **grünen Rahmen** und durchgestrichenen Text.

---

## Eine neue Challenge starten

Tippe auf den **＋-Button** unten rechts auf der Startseite.
''',
    'pt': '''
## Fluxo básico

**Criar desafio → Marcar rotina diária → Acumular sequência → Aumentar força de vontade e nível → Ganhar medalhas**

---

## Estrutura das telas

| Aba | Função |
|---|---|
| 🏠 Início | Cartão de força de vontade, rotinas de hoje |
| 🚩 Desafios | Gerenciar desafios ativos e calendário |
| 📊 Registros | Corrida de sequências, medalhas, estatísticas, desafios concluídos |
| 👤 Perfil | Conta, assinatura, configurações, guia |

---

## Concluir a rotina de hoje

1. Encontre seu cartão de rotina na tela Início.
2. Toque no **botão circular** à esquerda para marcá-lo como feito.
3. Se houver sub-rotinas, marque todas para completar o dia.
4. Um cartão concluído mostra uma **borda verde** e texto riscado.

---

## Iniciar um novo desafio

Toque no **botão ＋** no canto inferior direito da tela Início.
''',
    'ru': '''
## Основной процесс

**Создать задачу → Отмечать ежедневно → Накапливать серию → Повышать силу воли и уровень → Зарабатывать значки**

---

## Структура экранов

| Вкладка | Функция |
|---|---|
| 🏠 Главная | Карточка силы воли, сегодняшние задачи |
| 🚩 Задачи | Управление активными задачами и календарь |
| 📊 Записи | Гонка серий, значки, статистика, завершённые задачи |
| 👤 Профиль | Аккаунт, подписка, настройки, руководство |

---

## Выполнение сегодняшней задачи

1. Найдите карточку задачи на главном экране.
2. Нажмите **круглую кнопку** слева, чтобы отметить выполнение.
3. Если есть подзадачи, отметьте все — тогда день засчитается.
4. Выполненная карточка отображается с **зелёной рамкой** и зачёркнутым текстом.

---

## Начать новую задачу

Нажмите кнопку **＋** в правом нижнем углу главного экрана.
''',
  };

  // ─────────────────────────────────────────────────────────────
  // 챌린지 만들기
  // ─────────────────────────────────────────────────────────────
  static const Map<String, String> _createChallenge = {
    'ko': '''
## 챌린지란?

특정 기간 동안 **매일 수행할 루틴**을 정의한 단위입니다.
챌린지를 만들면 시작일(당일)부터 목표 일수까지 매일 체크인하게 됩니다.

---

## 설정 항목

### 목표 일수

| 옵션 | 의미 |
|---|---|
| 7일 | 단기 시도, 새로운 루틴 테스트 |
| 14일 | 습관 형성 중간 단계 |
| 21일 | 습관 형성 기본 단위 |
| 직접 입력 | 28일 이상 장기 챌린지 |

> 💡 연구에 따르면 습관이 완전히 자리 잡기까지 평균 **66일**이 필요합니다.

### 서브루틴

하나의 챌린지를 여러 세부 항목으로 나눌 수 있습니다.

- **예시** — "아침 루틴" 챌린지 → 스트레칭 10분 / 물 한 잔 / 일기 쓰기
- 서브루틴이 있으면 **모든 항목을 완료해야** 해당 날짜가 달성됩니다.
- 각 서브루틴에 **개별 알림 시간**을 설정할 수 있습니다.

### 반복 요일

매일 반복 또는 특정 요일(월~일)만 선택할 수 있습니다.
지정된 요일에만 홈 화면에 루틴 카드가 표시됩니다.

### 알림 시간

루틴 수행 전 알림을 받을 시간을 설정합니다.
설정하지 않으면 알림이 발송되지 않습니다.

### 노트

챌린지에 대한 목표나 다짐을 자유롭게 입력합니다.

---

## 챌린지 시작일

챌린지는 **만든 날 당일**부터 Day 1로 시작됩니다.
''',
    'en': '''
## What is a Challenge?

A challenge defines a **routine to perform every day** for a set period.
It starts on the day you create it (Day 1) and runs until your target day.

---

## Settings

### Target Days

| Option | Meaning |
|---|---|
| 7 days | Short-term trial |
| 14 days | Mid-stage habit building |
| 21 days | Classic habit formation unit |
| Custom | 28+ day long-term challenge |

> 💡 Research shows it takes an average of **66 days** for a habit to fully form.

### Sub-routines

Break a challenge into smaller steps.

- **Example** — "Morning Routine": Stretch 10 min / Drink water / Write journal
- All sub-routines must be checked to count the day as complete.
- Each sub-routine can have its **own reminder time**.

### Repeat Days

Choose every day or specific weekdays (Mon–Sun).
The routine card only appears on selected days.

### Reminder Time

Set when to receive a reminder before your routine.
No notification is sent if left empty.
''',
    'ja': '''
## チャレンジとは？

設定した期間**毎日行うルーティン**を定義する単位です。
作成した当日（Day 1）から目標日数まで毎日チェックインします。

---

## 設定項目

### 目標日数

| オプション | 意味 |
|---|---|
| 7日 | 短期試行 |
| 14日 | 習慣形成の中間段階 |
| 21日 | 習慣形成の基本単位 |
| カスタム | 28日以上の長期チャレンジ |

### サブルーティン

1つのチャレンジを複数の細目に分けられます。

- **例** — 「朝のルーティン」→ストレッチ10分 / 水を1杯 / 日記
- サブルーティンがある場合、**すべて完了**でその日が達成されます。
- 各サブルーティンに**個別の通知時間**を設定できます。

### 繰り返し曜日

毎日または特定の曜日（月〜日）を選べます。

### 通知時間

ルーティン前に通知を受け取る時間を設定します。
''',
    'zhCN': '''
## 什么是挑战？

挑战是定义**每天执行的任务**的单位，从创建当天（第1天）开始到目标天数结束。

---

## 设置项目

### 目标天数

| 选项 | 含义 |
|---|---|
| 7天 | 短期尝试 |
| 14天 | 习惯养成中间阶段 |
| 21天 | 习惯养成基本单位 |
| 自定义 | 28天以上长期挑战 |

> 💡 研究表明，习惯完全养成平均需要 **66天**。

### 子任务

可将一个挑战分为多个细项。

- **示例** — "早晨例行"：伸展10分钟 / 喝水 / 写日记
- 有子任务时，**全部完成**才算当天达成。
- 每个子任务可设置**独立提醒时间**。

### 重复日期

可选择每天或特定工作日（周一~周日）。

### 提醒时间

设置任务前收到提醒的时间。
''',
    'es': '''
## ¿Qué es un reto?

Un reto define una **rutina para realizar cada día** durante un período establecido.
Comienza el día que lo creas (Día 1) y se extiende hasta el día objetivo.

---

## Configuración

### Días objetivo

| Opción | Significado |
|---|---|
| 7 días | Prueba de corto plazo |
| 14 días | Etapa intermedia de formación de hábitos |
| 21 días | Unidad clásica de formación de hábitos |
| Personalizado | Reto de largo plazo (28+ días) |

> 💡 Las investigaciones muestran que se necesitan en promedio **66 días** para consolidar un hábito.

### Sub-retos

Divide un reto en pasos más pequeños.

- **Ejemplo** — "Rutina matutina": Estirar 10 min / Beber agua / Escribir diario
- Todos los sub-retos deben marcarse para que el día cuente como completado.
- Cada sub-reto puede tener su **propio horario de recordatorio**.

### Días de repetición

Elige todos los días o días específicos de la semana (Lun–Dom).

### Hora de recordatorio

Establece cuándo recibir un recordatorio antes de tu rutina.
''',
    'de': '''
## Was ist eine Challenge?

Eine Challenge definiert eine **täglich durchzuführende Routine** für einen festgelegten Zeitraum.
Sie beginnt an dem Tag, an dem du sie erstellst (Tag 1), und läuft bis zum Zieltag.

---

## Einstellungen

### Zieltage

| Option | Bedeutung |
|---|---|
| 7 Tage | Kurzfristiger Test |
| 14 Tage | Mittlere Phase der Gewohnheitsbildung |
| 21 Tage | Klassische Einheit der Gewohnheitsbildung |
| Benutzerdefiniert | Langfristige Challenge (28+ Tage) |

> 💡 Forschungen zeigen, dass es durchschnittlich **66 Tage** dauert, bis sich eine Gewohnheit vollständig gefestigt hat.

### Sub-Routinen

Unterteile eine Challenge in kleinere Schritte.

- **Beispiel** — "Morgenroutine": 10 Min Dehnen / Wasser trinken / Tagebuch schreiben
- Alle Sub-Routinen müssen abgehakt werden, damit der Tag als abgeschlossen gilt.
- Jede Sub-Routine kann ihre **eigene Erinnerungszeit** haben.

### Wiederholungstage

Wähle täglich oder bestimmte Wochentage (Mo–So).

### Erinnerungszeit

Lege fest, wann du vor deiner Routine erinnert werden möchtest.
''',
    'pt': '''
## O que é um desafio?

Um desafio define uma **rotina para realizar todo dia** por um período definido.
Começa no dia que você o cria (Dia 1) e vai até o dia alvo.

---

## Configurações

### Dias alvo

| Opção | Significado |
|---|---|
| 7 dias | Tentativa de curto prazo |
| 14 dias | Etapa intermediária de formação de hábitos |
| 21 dias | Unidade clássica de formação de hábitos |
| Personalizado | Desafio de longo prazo (28+ dias) |

> 💡 Pesquisas mostram que leva em média **66 dias** para um hábito se consolidar completamente.

### Sub-rotinas

Divida um desafio em etapas menores.

- **Exemplo** — "Rotina matinal": Alongar 10 min / Beber água / Escrever diário
- Todas as sub-rotinas devem ser marcadas para que o dia seja contabilizado.
- Cada sub-rotina pode ter seu **próprio horário de lembrete**.

### Dias de repetição

Escolha todos os dias ou dias específicos da semana (Seg–Dom).

### Hora do lembrete

Defina quando receber um lembrete antes da sua rotina.
''',
    'ru': '''
## Что такое задача?

Задача определяет **ежедневно выполняемую рутину** на установленный период.
Начинается в день создания (День 1) и длится до целевого дня.

---

## Настройки

### Целевые дни

| Вариант | Значение |
|---|---|
| 7 дней | Краткосрочная проба |
| 14 дней | Средний этап формирования привычки |
| 21 день | Классическая единица формирования привычки |
| Своё | Долгосрочная задача (28+ дней) |

> 💡 Исследования показывают, что для полного формирования привычки в среднем требуется **66 дней**.

### Подзадачи

Разбейте задачу на более мелкие шаги.

- **Пример** — "Утренняя рутина": Растяжка 10 мин / Выпить воду / Написать дневник
- Все подзадачи должны быть выполнены, чтобы день засчитался.
- Каждая подзадача может иметь **своё время напоминания**.

### Дни повторения

Выберите каждый день или определённые дни недели (Пн–Вс).

### Время напоминания

Установите время получения напоминания перед выполнением рутины.
''',
  };

  // ─────────────────────────────────────────────────────────────
  // 스트릭 시스템
  // ─────────────────────────────────────────────────────────────
  static const Map<String, String> _streakSystem = {
    'ko': '''
## 스트릭이란?

루틴을 **연속으로 완료한 일수**입니다.
하루도 빠짐없이 이어가는 것이 핵심입니다.

---

## 계산 방식

오늘부터 역순으로 연속 완료된 날수를 계산합니다.

| 상황 | 스트릭 |
|---|---|
| Day 5·4·3 모두 완료 (오늘 Day 5) | **3** |
| 오늘(Day 5) 미완료, Day 4·3 완료 | **0** |
| 오늘(Day 5) 완료, Day 4 미완료 | **1** |

> ⚠️ 하루라도 빠지면 즉시 **0**으로 초기화됩니다.

---

## 총 스트릭 (기록 화면)

기록 화면의 **총 스트릭**은 모든 챌린지의 현재 스트릭 합산입니다.

- 누적 역사값이 아닌 **현재 상태의 합산**
- 스트릭이 끊기면 감소 → 실시간 모멘텀 지표
- 의지력(절대 감소 없음)과 역할이 다릅니다.

---

## 스트릭 마일스톤 배지

| 스트릭 | 배지 | 이름 | 희귀도 |
|---|---|---|---|
| 1일 | ![](assets/images/badges/streak_001.png) | 첫 불꽃 | Common |
| 3일 | ![](assets/images/badges/streak_002.png) | 불씨 | Common |
| 7일 | ![](assets/images/badges/streak_003.png) | 작은 불꽃 | Common |
| 14일 | ![](assets/images/badges/streak_004.png) | 모닥불 | Rare |
| 21일 | ![](assets/images/badges/streak_005.png) | 화톳불 | Rare |
| 30일 | ![](assets/images/badges/streak_006.png) | 용광로 | Epic |
| 50일 | ![](assets/images/badges/streak_007.png) | 불의 지배자 | Epic |
| 66일 | ![](assets/images/badges/streak_008.png) | 태양 | Epic |
| 100일 | ![](assets/images/badges/streak_009.png) | 영원한 불꽃 | Legendary |
''',
    'en': '''
## What is a Streak?

A streak is the **number of consecutive days** you've completed your routine.
Keeping it going every day is the core challenge.

---

## How It's Calculated

Counted backwards from today.

| Situation | Streak |
|---|---|
| Day 5·4·3 all done (today = Day 5) | **3** |
| Today (Day 5) missed, Day 4·3 done | **0** |
| Today (Day 5) done, Day 4 missed | **1** |

> ⚠️ Miss even one day and it resets to **0** immediately.

---

## Total Streaks (Records screen)

The **Total Streaks** card shows the sum of current streaks across all challenges.

- Not a cumulative history — a **live snapshot**
- Decreases when a streak breaks → real-time momentum indicator
- Different from Willpower, which never decreases.

---

## Streak Milestone Badges

| Streak | Badge | Name | Rarity |
|---|---|---|---|
| 1 day | ![](assets/images/badges/streak_001.png) | First Spark | Common |
| 3 days | ![](assets/images/badges/streak_002.png) | Ember | Common |
| 7 days | ![](assets/images/badges/streak_003.png) | Kindling | Common |
| 14 days | ![](assets/images/badges/streak_004.png) | Campfire | Rare |
| 21 days | ![](assets/images/badges/streak_005.png) | Bonfire | Rare |
| 30 days | ![](assets/images/badges/streak_006.png) | Furnace | Epic |
| 50 days | ![](assets/images/badges/streak_007.png) | Fire Lord | Epic |
| 66 days | ![](assets/images/badges/streak_008.png) | The Sun | Epic |
| 100 days | ![](assets/images/badges/streak_009.png) | Eternal Flame | Legendary |
''',
    'ja': '''
## ストリークとは？

ルーティンを**連続で完了した日数**です。一日も欠かさず続けることが重要です。

---

## 計算方法

今日から逆順に連続完了日数をカウントします。

| 状況 | ストリーク |
|---|---|
| Day 5·4·3 すべて完了（今日 Day 5）| **3** |
| 今日（Day 5）未完了、Day 4·3 完了 | **0** |
| 今日（Day 5）完了、Day 4 未完了 | **1** |

> ⚠️ 一日でも欠かすと即座に **0** にリセットされます。

---

## ストリークマイルストーンバッジ

| ストリーク | バッジ | 名前 | レアリティ |
|---|---|---|---|
| 1日 | ![](assets/images/badges/streak_001.png) | First Spark | Common |
| 3日 | ![](assets/images/badges/streak_002.png) | Ember | Common |
| 7日 | ![](assets/images/badges/streak_003.png) | Kindling | Common |
| 14日 | ![](assets/images/badges/streak_004.png) | Campfire | Rare |
| 21日 | ![](assets/images/badges/streak_005.png) | Bonfire | Rare |
| 30日 | ![](assets/images/badges/streak_006.png) | Furnace | Epic |
| 50日 | ![](assets/images/badges/streak_007.png) | Fire Lord | Epic |
| 66日 | ![](assets/images/badges/streak_008.png) | The Sun | Epic |
| 100日 | ![](assets/images/badges/streak_009.png) | Eternal Flame | Legendary |
''',
    'zhCN': '''
## 什么是连续？

连续是**每天完成任务的天数**，不能间断。

---

## 计算方式

从今天倒序计算连续完成天数。

| 情况 | 连续 |
|---|---|
| 第5·4·3天全部完成（今天第5天）| **3** |
| 今天（第5天）未完成，第4·3天完成 | **0** |
| 今天（第5天）完成，第4天未完成 | **1** |

> ⚠️ 哪怕漏一天，连续立即归 **0**。

---

## 连续里程碑徽章

| 连续 | 徽章 | 名称 | 稀有度 |
|---|---|---|---|
| 1天 | ![](assets/images/badges/streak_001.png) | 第一个火花 | Common |
| 3天 | ![](assets/images/badges/streak_002.png) | 余烬 | Common |
| 7天 | ![](assets/images/badges/streak_003.png) | 引火物 | Common |
| 14天 | ![](assets/images/badges/streak_004.png) | 篝火 | Rare |
| 21天 | ![](assets/images/badges/streak_005.png) | 营火 | Rare |
| 30天 | ![](assets/images/badges/streak_006.png) | 熔炉 | Epic |
| 50天 | ![](assets/images/badges/streak_007.png) | 火焰领主 | Epic |
| 66天 | ![](assets/images/badges/streak_008.png) | 太阳 | Epic |
| 100天 | ![](assets/images/badges/streak_009.png) | 永恒火焰 | Legendary |
''',
    'es': '''
## ¿Qué es una racha?

Una racha es el **número de días consecutivos** en que completaste tu rutina.
Mantenerla cada día es el desafío central.

---

## Cómo se calcula

Se cuenta hacia atrás desde hoy.

| Situación | Racha |
|---|---|
| Días 5·4·3 completados (hoy = Día 5) | **3** |
| Hoy (Día 5) no completado, Días 4·3 sí | **0** |
| Hoy (Día 5) completado, Día 4 no | **1** |

> ⚠️ Falla un solo día y se reinicia a **0** inmediatamente.

---

## Rachas totales (pantalla de Registros)

La tarjeta **Rachas Totales** muestra la suma de las rachas actuales de todos los retos.

- No es un historial acumulado — es una **instantánea en tiempo real**
- Disminuye cuando se rompe una racha → indicador de impulso
- A diferencia de la Fuerza de voluntad, que nunca disminuye.

---

## Insignias de hitos de racha

| Racha | Insignia | Nombre | Rareza |
|---|---|---|---|
| 1 día | ![](assets/images/badges/streak_001.png) | Primera Chispa | Common |
| 3 días | ![](assets/images/badges/streak_002.png) | Brasa | Common |
| 7 días | ![](assets/images/badges/streak_003.png) | Yesca | Common |
| 14 días | ![](assets/images/badges/streak_004.png) | Hoguera | Rare |
| 21 días | ![](assets/images/badges/streak_005.png) | Fogata | Rare |
| 30 días | ![](assets/images/badges/streak_006.png) | Horno | Epic |
| 50 días | ![](assets/images/badges/streak_007.png) | Señor del Fuego | Epic |
| 66 días | ![](assets/images/badges/streak_008.png) | El Sol | Epic |
| 100 días | ![](assets/images/badges/streak_009.png) | Llama Eterna | Legendary |
''',
    'de': '''
## Was ist ein Streak?

Ein Streak ist die **Anzahl der aufeinanderfolgenden Tage**, an denen du deine Routine abgeschlossen hast.
Ihn jeden Tag aufrechtzuerhalten ist die Kernherausforderung.

---

## Berechnung

Rückwärts von heute gezählt.

| Situation | Streak |
|---|---|
| Tag 5·4·3 alle erledigt (heute = Tag 5) | **3** |
| Heute (Tag 5) verpasst, Tag 4·3 erledigt | **0** |
| Heute (Tag 5) erledigt, Tag 4 verpasst | **1** |

> ⚠️ Verpasse auch nur einen Tag und er wird sofort auf **0** zurückgesetzt.

---

## Gesamtserien (Aufzeichnungen)

Die Karte **Gesamtserien** zeigt die Summe der aktuellen Streaks aller Challenges.

- Kein kumulativer Verlauf — eine **Live-Momentaufnahme**
- Sinkt, wenn ein Streak bricht → Echtzeit-Momentum-Indikator
- Anders als die Willenskraft, die nie sinkt.

---

## Streak-Meilenstein-Abzeichen

| Streak | Abzeichen | Name | Seltenheit |
|---|---|---|---|
| 1 Tag | ![](assets/images/badges/streak_001.png) | Erster Funke | Common |
| 3 Tage | ![](assets/images/badges/streak_002.png) | Glut | Common |
| 7 Tage | ![](assets/images/badges/streak_003.png) | Zunder | Common |
| 14 Tage | ![](assets/images/badges/streak_004.png) | Lagerfeuer | Rare |
| 21 Tage | ![](assets/images/badges/streak_005.png) | Freudenfeuer | Rare |
| 30 Tage | ![](assets/images/badges/streak_006.png) | Hochofen | Epic |
| 50 Tage | ![](assets/images/badges/streak_007.png) | Feuerherrscher | Epic |
| 66 Tage | ![](assets/images/badges/streak_008.png) | Die Sonne | Epic |
| 100 Tage | ![](assets/images/badges/streak_009.png) | Ewige Flamme | Legendary |
''',
    'pt': '''
## O que é uma sequência?

Uma sequência é o **número de dias consecutivos** em que você completou sua rotina.
Mantê-la todos os dias é o desafio central.

---

## Como é calculada

Contada de trás para frente a partir de hoje.

| Situação | Sequência |
|---|---|
| Dias 5·4·3 completos (hoje = Dia 5) | **3** |
| Hoje (Dia 5) não completo, Dias 4·3 sim | **0** |
| Hoje (Dia 5) completo, Dia 4 não | **1** |

> ⚠️ Perca um único dia e ela volta para **0** imediatamente.

---

## Sequências Totais (tela de Registros)

O cartão **Sequências Totais** mostra a soma das sequências atuais de todos os desafios.

- Não é um histórico acumulado — é uma **captura em tempo real**
- Diminui quando uma sequência é quebrada → indicador de impulso
- Diferente da Força de vontade, que nunca diminui.

---

## Insígnias de marcos de sequência

| Sequência | Insígnia | Nome | Raridade |
|---|---|---|---|
| 1 dia | ![](assets/images/badges/streak_001.png) | Primeira Faísca | Common |
| 3 dias | ![](assets/images/badges/streak_002.png) | Brasa | Common |
| 7 dias | ![](assets/images/badges/streak_003.png) | Isca | Common |
| 14 dias | ![](assets/images/badges/streak_004.png) | Fogueira | Rare |
| 21 dias | ![](assets/images/badges/streak_005.png) | Fogueira Grande | Rare |
| 30 dias | ![](assets/images/badges/streak_006.png) | Fornalha | Epic |
| 50 dias | ![](assets/images/badges/streak_007.png) | Senhor do Fogo | Epic |
| 66 dias | ![](assets/images/badges/streak_008.png) | O Sol | Epic |
| 100 dias | ![](assets/images/badges/streak_009.png) | Chama Eterna | Legendary |
''',
    'ru': '''
## Что такое серия?

Серия — это **количество последовательных дней** выполнения рутины.
Не прерывать её — главный вызов.

---

## Как рассчитывается

Считается от сегодняшнего дня назад.

| Ситуация | Серия |
|---|---|
| Дни 5·4·3 выполнены (сегодня = День 5) | **3** |
| Сегодня (День 5) пропущен, Дни 4·3 выполнены | **0** |
| Сегодня (День 5) выполнен, День 4 пропущен | **1** |

> ⚠️ Пропустите один день — серия мгновенно сбрасывается в **0**.

---

## Общие серии (экран Записей)

Карточка **Всего серий** показывает сумму текущих серий по всем задачам.

- Не накопительная история — **моментальный снимок**
- Уменьшается при разрыве серии → индикатор текущего импульса
- В отличие от силы воли, которая никогда не уменьшается.

---

## Значки за достижения серий

| Серия | Значок | Название | Редкость |
|---|---|---|---|
| 1 день | ![](assets/images/badges/streak_001.png) | Первая искра | Common |
| 3 дня | ![](assets/images/badges/streak_002.png) | Уголёк | Common |
| 7 дней | ![](assets/images/badges/streak_003.png) | Растопка | Common |
| 14 дней | ![](assets/images/badges/streak_004.png) | Костёр | Rare |
| 21 день | ![](assets/images/badges/streak_005.png) | Большой костёр | Rare |
| 30 дней | ![](assets/images/badges/streak_006.png) | Доменная печь | Epic |
| 50 дней | ![](assets/images/badges/streak_007.png) | Властелин огня | Epic |
| 66 дней | ![](assets/images/badges/streak_008.png) | Солнце | Epic |
| 100 дней | ![](assets/images/badges/streak_009.png) | Вечное пламя | Legendary |
''',
  };

  // ─────────────────────────────────────────────────────────────
  // 스트릭 복구
  // ─────────────────────────────────────────────────────────────
  static const Map<String, String> _streakRecovery = {
    'ko': '''
## 스트릭 복구란?

어제 루틴을 빠뜨렸을 때, **Pro 구독자가 스트릭을 즉시 되살리는** 기능입니다.
"어차피 끊겼으니 포기"라고 생각하지 말고 지속성을 유지하세요.

> 스트릭 복구는 **Pro 전용** 기능입니다.

---

## 복구 조건

1. 오늘 루틴을 아직 완료하지 않은 상태여야 합니다. (오늘 완료 시 복구 불가)
2. 복구 대상은 **직전 예정일** (반복 요일 기준)의 기록입니다. (예: 월,수,금 루틴의 경우 월요일을 놓쳤다면 수요일의 '오늘의 루틴'에서 월요일 기록을 복구할 수 있습니다.)
3. 복구 기한(다음 루틴 수행일)을 넘긴 스트릭은 복구할 수 없습니다. (예: 월,수,금 루틴의 경우 월요일을 놓쳤다면 금요일의 '오늘의 루틴'에서 월요일 기록을 복구할 수 없습니다.)
4. 챌린지당 **7일에 1회**로 사용 제한이 있습니다.

---

## 복구 방법

1. 홈 화면에서 오늘 **미완료** 상태인 루틴 카드를 확인합니다.
2. 카드 우측 하단의 **스트릭 복구** 버튼을 탭합니다.
3. 복구가 즉시 완료됩니다.

---

## 복구 버튼이 표시되지 않는 경우

- 오늘 루틴을 이미 완료한 경우
- 챌린지 Day 1인 경우 (어제가 없음)
- 어제가 이미 완료된 경우
- 해당 챌린지에서 **7일 이내** 이미 복구를 사용한 경우

---

''',
    'en': '''
## What is Streak Recovery?

When you miss yesterday's routine, **Pro subscribers can instantly restore their streak**.
Don't give up — keep your habit going.

> Streak Recovery is a **Pro-only** feature.

---

## Recovery Conditions

1. Today's routine must not yet be completed. (Recovery is unavailable once today is done)
2. The target of recovery is the **most recent scheduled day** (based on repeat days). (e.g., For a Mon/Wed/Fri routine, if Monday was missed, Monday's record can be recovered from Wednesday's 'Today's Routine'.)
3. Streaks past the deadline (the next scheduled day) cannot be recovered. (e.g., For a Mon/Wed/Fri routine, if Monday was missed, Monday's record cannot be recovered from Friday's 'Today's Routine'.)
4. Usage is limited to **once every 7 days** per challenge.

---

## How to Recover

1. Find the **incomplete** routine card on the Home screen.
2. Tap the **Recover Streak** button at the bottom-right of the card.
3. Recovery completes instantly.

---

## When the Button Doesn't Appear

- Today's routine is already complete
- It's Day 1 (no yesterday)
- Yesterday was already completed
- Recovery was used within the **last 7 days** for this challenge

---

''',
    'ja': '''
## ストリーク回復とは？

昨日のルーティンを逃したとき、**Proサブスクライバーがストリークを即座に復活させる**機能です。
「どうせ途切れたから諦める」と思わず、継続を続けましょう。

> ストリーク回復は **Pro専用**機能です。

---

## 回復条件

1. 今日のルーティンがまだ未完了の状態である必要があります。（今日完了すると回復不可）
2. 回復対象は**直近の予定日**（繰り返し曜日基準）の記録です。（例：月・水・金ルーティンで月曜を逃した場合、水曜の「今日のルーティン」から月曜の記録を回復できます。）
3. 期限（次のルーティン実施日）を過ぎたストリークは回復できません。（例：月・水・金ルーティンで月曜を逃した場合、金曜の「今日のルーティン」から月曜の記録は回復できません。）
4. チャレンジごとに**7日に1回**の使用制限があります。

---

## 回復方法

1. ホーム画面で今日**未完了**のルーティンカードを確認します。
2. カード右下の **ストリーク回復** ボタンをタップします。
3. 即座に回復が完了します。

---

## ボタンが表示されない場合

- 今日のルーティンが完了済みの場合
- Day 1の場合（昨日がない）
- 昨日がすでに完了済みの場合
- 同チャレンジで**7日以内**に回復を使用した場合

---

''',
    'zhCN': '''
## 什么是连续恢复？

当您漏掉昨天的任务时，**Pro订阅者可以立即恢复连续记录**。
不要"反正断了就放弃"，继续坚持吧。

> 连续恢复是 **Pro专属**功能。

---

## 恢复条件

1. 今天任务尚未完成才可使用。（今天完成后无法恢复）
2. 恢复对象为**最近一次预定日**（按重复日期计算）的记录。（例：周一、三、五任务，若周一未完成，可在周三的"今日任务"中恢复周一的记录。）
3. 超过恢复期限（下一次任务执行日）的连续记录无法恢复。（例：周一、三、五任务，若周一未完成，则无法在周五的"今日任务"中恢复周一的记录。）
4. 每个挑战限制**7天1次**使用。

---

## 恢复方法

1. 在主页找到今天**未完成**的任务卡片。
2. 点击卡片右下角的 **恢复连续** 按钮。
3. 立即完成恢复。

---

## 按钮不显示的情况

- 今天任务已完成
- 挑战第1天（没有昨天）
- 昨天已完成
- 该挑战**7天内**已使用过恢复

---

''',
    'es': '''
## ¿Qué es la recuperación de racha?

Cuando pierdes la rutina de ayer, los **suscriptores Pro pueden restaurar su racha al instante**.
No pienses "ya la rompí, para qué seguir" — ¡sigue adelante!

> La recuperación de racha es una función **exclusiva de Pro**.

---

## Condiciones de recuperación

1. La rutina de hoy aún no debe estar completada. (La recuperación no está disponible si ya completaste hoy)
2. El objetivo de recuperación es el registro del **día programado más reciente** (según días de repetición). (ej.: Para una rutina de Lun/Mié/Vie, si se perdió el lunes, el registro del lunes se puede recuperar desde la 'Rutina de hoy' del miércoles.)
3. Las rachas que superen el plazo (el siguiente día programado) no pueden recuperarse. (ej.: Para una rutina de Lun/Mié/Vie, si se perdió el lunes, el registro del lunes no puede recuperarse desde la 'Rutina de hoy' del viernes.)
4. El uso está limitado a **una vez cada 7 días** por reto.

---

## Cómo recuperar

1. Encuentra la tarjeta de rutina **incompleta** en la pantalla de Inicio.
2. Toca el botón **Recuperar racha** en la parte inferior derecha de la tarjeta.
3. La recuperación se completa al instante.

---

## Cuándo no aparece el botón

- La rutina de hoy ya está completada
- Es el Día 1 (no hay ayer)
- Ayer ya estaba completado
- La recuperación se usó en los **últimos 7 días** para este reto

---

''',
    'de': '''
## Was ist die Streak-Wiederherstellung?

Wenn du die gestrige Routine verpasst hast, können **Pro-Abonnenten ihren Streak sofort wiederherstellen**.
Denk nicht "Ich hab's eh schon verpasst" — mach einfach weiter!

> Streak-Wiederherstellung ist eine **Pro-exklusive** Funktion.

---

## Wiederherstellungsbedingungen

1. Die heutige Routine darf noch nicht abgeschlossen sein. (Wiederherstellung nicht möglich, wenn heute bereits erledigt)
2. Ziel der Wiederherstellung ist der Eintrag des **zuletzt geplanten Tages** (basierend auf Wiederholungstagen). (Bsp.: Bei einer Mo/Mi/Fr-Routine gilt: Wurde Montag verpasst, kann der Montag-Eintrag aus der 'Heutige Routine' am Mittwoch wiederhergestellt werden.)
3. Streaks, die die Frist (den nächsten geplanten Tag) überschritten haben, können nicht wiederhergestellt werden. (Bsp.: Bei einer Mo/Mi/Fr-Routine gilt: Wurde Montag verpasst, kann der Montag-Eintrag aus der 'Heutige Routine' am Freitag nicht wiederhergestellt werden.)
4. Die Nutzung ist auf **einmal alle 7 Tage** pro Challenge begrenzt.

---

## Wie man wiederherstellt

1. Finde die **unvollständige** Routine-Karte auf der Startseite.
2. Tippe auf den **Serie wiederherstellen**-Button unten rechts auf der Karte.
3. Die Wiederherstellung wird sofort abgeschlossen.

---

## Wann der Button nicht erscheint

- Die heutige Routine ist bereits abgeschlossen
- Es ist Tag 1 (kein Gestern)
- Gestern war bereits abgeschlossen
- Die Wiederherstellung wurde in den **letzten 7 Tagen** für diese Challenge verwendet

---

''',
    'pt': '''
## O que é a recuperação de sequência?

Quando você perde a rotina de ontem, **assinantes Pro podem restaurar sua sequência instantaneamente**.
Não desista pensando "já quebrei" — continue em frente!

> A recuperação de sequência é um recurso **exclusivo do Pro**.

---

## Condições de recuperação

1. A rotina de hoje ainda não deve estar concluída. (A recuperação não está disponível se hoje já foi concluído)
2. O alvo da recuperação é o registro do **dia programado mais recente** (com base nos dias de repetição). (ex.: Para uma rotina de Seg/Qua/Sex, se segunda foi perdida, o registro de segunda pode ser recuperado na 'Rotina de hoje' de quarta.)
3. Sequências que ultrapassaram o prazo (o próximo dia programado) não podem ser recuperadas. (ex.: Para uma rotina de Seg/Qua/Sex, se segunda foi perdida, o registro de segunda não pode ser recuperado na 'Rotina de hoje' de sexta.)
4. O uso é limitado a **uma vez a cada 7 dias** por desafio.

---

## Como recuperar

1. Encontre o cartão de rotina **incompleto** na tela Início.
2. Toque no botão **Recuperar sequência** no canto inferior direito do cartão.
3. A recuperação é concluída instantaneamente.

---

## Quando o botão não aparece

- A rotina de hoje já está concluída
- É o Dia 1 (não há ontem)
- Ontem já estava concluído
- A recuperação foi usada nos **últimos 7 dias** para este desafio

---

''',
    'ru': '''
## Что такое восстановление серии?

Если вы пропустили вчерашнюю рутину, **подписчики Pro могут мгновенно восстановить серию**.
Не думайте "всё равно уже прервал" — продолжайте!

> Восстановление серии — функция **только для Pro**.

---

## Условия восстановления

1. Сегодняшняя рутина ещё не должна быть выполнена. (Восстановление недоступно, если сегодня уже выполнено)
2. Объектом восстановления является запись **последнего запланированного дня** (по дням повторения). (Пример: для рутины Пн/Ср/Пт — если пропущен понедельник, запись понедельника можно восстановить из «Сегодняшней рутины» в среду.)
3. Серии, превысившие срок (следующий запланированный день), восстановить нельзя. (Пример: для рутины Пн/Ср/Пт — если пропущен понедельник, запись понедельника нельзя восстановить из «Сегодняшней рутины» в пятницу.)
4. Использование ограничено **раз в 7 дней** на задачу.

---

## Как восстановить

1. Найдите **невыполненную** карточку задачи на главном экране.
2. Нажмите кнопку **Восстановить серию** в правом нижнем углу карточки.
3. Восстановление завершается мгновенно.

---

## Когда кнопка не отображается

- Сегодняшняя рутина уже выполнена
- Это День 1 (нет вчера)
- Вчера уже было выполнено
- Восстановление использовалось в **последние 7 дней** для этой задачи

---

''',
  };

  // ─────────────────────────────────────────────────────────────
  // 의지력 & 레벨
  // ─────────────────────────────────────────────────────────────
  static const Map<String, String> _willpower = {
    'ko': '''
## 의지력이란?

루틴을 완료할 때마다 **+1**씩 쌓이는 누적 점수입니다.
**절대 줄어들지 않으며**, 스트릭 복구에 비용을 써도 표시값은 감소하지 않습니다.

---

## 레벨 & 티어 시스템

의지력이 쌓이면 **5단계 티어, 25개 레벨**로 성장합니다.

| 티어 | 레벨 | 의지력 범위 |
|---|---|---|
| 🌱 씨앗 | Lv.1 ~ 5 | 0 – 73 |
| 🌿 새싹 | Lv.6 ~ 10 | 74 – 209 |
| 🌳 성장 | Lv.11 ~ 15 | 210 – 409 |
| 🌸 결실 | Lv.16 ~ 20 | 410 – 673 |
| ⚡ 전설 | Lv.21 ~ 25 | 674 – 1000 |

---

## 레벨별 필요 의지력

| 레벨 | 필요 의지력 | 다음 레벨까지 |
|---|---|---|
| Lv.1 | 0 | +10 |
| Lv.2 | 10 | +12 |
| Lv.3 | 22 | +15 |
| Lv.4 | 37 | +17 |
| Lv.5 | 54 | +20 |
| Lv.6 | 74 | +22 |
| Lv.7 | 96 | +25 |
| Lv.8 | 121 | +27 |
| Lv.9 | 148 | +30 |
| Lv.10 | 178 | +32 |
| Lv.11 | 210 | +35 |
| Lv.12 | 245 | +37 |
| Lv.13 | 282 | +40 |
| Lv.14 | 322 | +43 |
| Lv.15 | 365 | +45 |
| Lv.16 | 410 | +48 |
| Lv.17 | 458 | +50 |
| Lv.18 | 508 | +53 |
| Lv.19 | 561 | +55 |
| Lv.20 | 616 | +58 |
| Lv.21 | 674 | +60 |
| Lv.22 | 734 | +63 |
| Lv.23 | 797 | +65 |
| Lv.24 | 862 | +68 |
| Lv.25 (MAX) | 930 | — |

---

## 의지력의 용도

- 홈 화면 스트릭 카드의 **레벨·진행 게이지** 표시 기준
- **스트릭 복구** 비용 차감 (3 소모)
- 레벨이 높을수록 복구에 쓸 수 있는 여유가 많아짐
''',
    'en': '''
## What is Willpower?

Willpower increases by **+1 every day** you complete a routine.
It **never decreases** — even spending it on streak recovery doesn't lower the displayed value.

---

## Level & Tier System

Willpower grows through **5 tiers and 25 levels**.

| Tier | Levels | Willpower Range |
|---|---|---|
| 🌱 Seed | Lv.1–5 | 0–73 |
| 🌿 Sprout | Lv.6–10 | 74–209 |
| 🌳 Growth | Lv.11–15 | 210–409 |
| 🌸 Fruition | Lv.16–20 | 410–673 |
| ⚡ Legend | Lv.21–25 | 674–1000 |

---

## Willpower Thresholds

| Level | Required | To Next |
|---|---|---|
| Lv.1 | 0 | +10 |
| Lv.5 | 54 | +20 |
| Lv.10 | 178 | +32 |
| Lv.15 | 365 | +45 |
| Lv.20 | 616 | +58 |
| Lv.25 (MAX) | 930 | — |

---

## Uses of Willpower

- Determines your **level and progress gauge** on the Home screen
- Pays for **streak recovery** (costs 3)
- Higher levels give you more buffer for recovery
''',
    'ja': '''
## 意志力とは？

ルーティンを完了するたびに **+1** 積み上がる累積スコアです。
**絶対に減らず**、ストリーク回復に使っても表示値は下がりません。

---

## レベル＆ティアシステム

意志力が増えると**5ティア、25レベル**で成長します。

| ティア | レベル | 意志力範囲 |
|---|---|---|
| 🌱 種 | Lv.1–5 | 0–73 |
| 🌿 芽 | Lv.6–10 | 74–209 |
| 🌳 成長 | Lv.11–15 | 210–409 |
| 🌸 実り | Lv.16–20 | 410–673 |
| ⚡ 伝説 | Lv.21–25 | 674–1000 |

---

## 意志力の用途

- ホーム画面の**レベル・進捗ゲージ**表示基準
- **ストリーク回復**コスト（3消費）
- レベルが高いほど回復に使える余裕が増える
''',
    'zhCN': '''
## 什么是意志力？

每天完成任务后意志力 **+1**，**永不减少**。

---

## 等级系统

意志力积累后，通过**5个阶段、25个等级**成长。

| 阶段 | 等级 | 意志力范围 |
|---|---|---|
| 🌱 种子 | Lv.1–5 | 0–73 |
| 🌿 嫩芽 | Lv.6–10 | 74–209 |
| 🌳 成长 | Lv.11–15 | 210–409 |
| 🌸 结实 | Lv.16–20 | 410–673 |
| ⚡ 传说 | Lv.21–25 | 674–1000 |

---

## 意志力的用途

- 主页**等级和进度条**的显示基准
- **连续恢复**费用（消耗3）
- 等级越高，可用于恢复的余量越多
''',
    'es': '''
## ¿Qué es la Fuerza de voluntad?

La fuerza de voluntad aumenta en **+1 cada día** que completas una rutina.
**Nunca disminuye** — ni siquiera gastándola en recuperación de racha.

---

## Sistema de nivel y nivel de rango

La fuerza de voluntad crece a través de **5 rangos y 25 niveles**.

| Rango | Niveles | Rango de fuerza de voluntad |
|---|---|---|
| 🌱 Semilla | Nv.1–5 | 0–73 |
| 🌿 Brote | Nv.6–10 | 74–209 |
| 🌳 Crecimiento | Nv.11–15 | 210–409 |
| 🌸 Fruto | Nv.16–20 | 410–673 |
| ⚡ Leyenda | Nv.21–25 | 674–1000 |

---

## Umbrales de fuerza de voluntad

| Nivel | Requerido | Al siguiente |
|---|---|---|
| Nv.1 | 0 | +10 |
| Nv.5 | 54 | +20 |
| Nv.10 | 178 | +32 |
| Nv.15 | 365 | +45 |
| Nv.20 | 616 | +58 |
| Nv.25 (MÁX) | 930 | — |

---

## Usos de la Fuerza de voluntad

- Determina tu **nivel y barra de progreso** en la pantalla de Inicio
- Paga la **recuperación de racha** (cuesta 3)
- Los niveles más altos dan más margen para la recuperación
''',
    'de': '''
## Was ist Willenskraft?

Willenskraft steigt um **+1 pro Tag**, an dem du eine Routine abschließt.
Sie **sinkt nie** — auch nicht, wenn du sie für die Streak-Wiederherstellung ausgibst.

---

## Level- und Tier-System

Willenskraft wächst durch **5 Tiers und 25 Level**.

| Tier | Level | Willenskraft-Bereich |
|---|---|---|
| 🌱 Keim | Lv.1–5 | 0–73 |
| 🌿 Sprössling | Lv.6–10 | 74–209 |
| 🌳 Wachstum | Lv.11–15 | 210–409 |
| 🌸 Frucht | Lv.16–20 | 410–673 |
| ⚡ Legende | Lv.21–25 | 674–1000 |

---

## Willenskraft-Schwellenwerte

| Level | Benötigt | Bis zum nächsten |
|---|---|---|
| Lv.1 | 0 | +10 |
| Lv.5 | 54 | +20 |
| Lv.10 | 178 | +32 |
| Lv.15 | 365 | +45 |
| Lv.20 | 616 | +58 |
| Lv.25 (MAX) | 930 | — |

---

## Verwendung der Willenskraft

- Bestimmt dein **Level und den Fortschrittsbalken** auf der Startseite
- Zahlt für die **Streak-Wiederherstellung** (kostet 3)
- Höhere Level geben mehr Spielraum für die Wiederherstellung
''',
    'pt': '''
## O que é Força de vontade?

A força de vontade aumenta em **+1 a cada dia** que você completa uma rotina.
**Nunca diminui** — nem mesmo gastando-a na recuperação de sequência.

---

## Sistema de nível e tier

A força de vontade cresce através de **5 tiers e 25 níveis**.

| Tier | Níveis | Faixa de força de vontade |
|---|---|---|
| 🌱 Semente | Nv.1–5 | 0–73 |
| 🌿 Broto | Nv.6–10 | 74–209 |
| 🌳 Crescimento | Nv.11–15 | 210–409 |
| 🌸 Fruto | Nv.16–20 | 410–673 |
| ⚡ Lenda | Nv.21–25 | 674–1000 |

---

## Limiares de força de vontade

| Nível | Necessário | Até o próximo |
|---|---|---|
| Nv.1 | 0 | +10 |
| Nv.5 | 54 | +20 |
| Nv.10 | 178 | +32 |
| Nv.15 | 365 | +45 |
| Nv.20 | 616 | +58 |
| Nv.25 (MÁX) | 930 | — |

---

## Usos da Força de vontade

- Determina seu **nível e barra de progresso** na tela Início
- Paga a **recuperação de sequência** (custa 3)
- Níveis mais altos dão mais margem para recuperação
''',
    'ru': '''
## Что такое сила воли?

Сила воли увеличивается на **+1 каждый день** выполнения рутины.
**Никогда не уменьшается** — даже при трате на восстановление серии.

---

## Система уровней и тиров

Сила воли растёт через **5 тиров и 25 уровней**.

| Тир | Уровни | Диапазон силы воли |
|---|---|---|
| 🌱 Семя | Ур.1–5 | 0–73 |
| 🌿 Росток | Ур.6–10 | 74–209 |
| 🌳 Рост | Ур.11–15 | 210–409 |
| 🌸 Плод | Ур.16–20 | 410–673 |
| ⚡ Легенда | Ур.21–25 | 674–1000 |

---

## Пороги силы воли

| Уровень | Требуется | До следующего |
|---|---|---|
| Ур.1 | 0 | +10 |
| Ур.5 | 54 | +20 |
| Ур.10 | 178 | +32 |
| Ур.15 | 365 | +45 |
| Ур.20 | 616 | +58 |
| Ур.25 (МАКС) | 930 | — |

---

## Применение силы воли

- Определяет **уровень и шкалу прогресса** на главном экране
- Оплачивает **восстановление серии** (стоит 3)
- Чем выше уровень, тем больше запас для восстановления
''',
  };

  // ─────────────────────────────────────────────────────────────
  // 배지 시스템
  // ─────────────────────────────────────────────────────────────
  static const Map<String, String> _badge = {
    'ko': '''
## 배지란?

다양한 조건을 달성하면 획득하는 **수집형 업적**입니다.
총 **50개 배지**가 준비되어 있으며, 기록 화면에서 전체를 확인할 수 있습니다.

---

## 희귀도

| 희귀도 | 설명 |
|---|---|
| ⚪ Common | 달성하기 쉬운 기본 배지 |
| 🔵 Rare | 꾸준함이 필요한 배지 |
| 🟣 Epic | 장기간의 노력이 필요한 배지 |
| 🟡 Legendary | 최고 난이도 배지 |
| 🔒 Secret | 조건이 숨겨진 시크릿 배지 |

---

## 카테고리

### 🔥 스트릭 (12개)
연속 달성 일수에 따라 획득합니다.
1일·3일·7일·14일·21일·30일·50일·66일·100일 마일스톤과 복구·재시작 관련 배지 포함.

### 🎯 챌린지 완주 (10개)
챌린지를 완료하면 획득합니다.
1회·3회·10회·25회 완료, 완료율 100% 달성, 28일 이상 챌린지 완주 등.

### ✏️ 기록 습관 (8개)
데일리 로그를 작성하면 획득합니다.
첫 기록, 7·21일 연속 작성, 누적 100·500개, 200자 이상 작성 등.

### ⏰ 시간 & 루틴 패턴 (8개)
체크인 시간 패턴에 따라 획득합니다.
새벽 6시 이전, 아침형 인간(9시 이전 21일), 야행성, 알림 시간 준수, 주말·평일 패턴 등.
시크릿 배지: 23:59 체크인, 1월 1일 체크인.

### ➕ 서브루틴 (6개)
서브루틴 관련 조건으로 획득합니다.
서브루틴 포함 챌린지 생성, 3개·5개 이상 포함 챌린지 완주, 2개 동시 진행 7일, 전체 100% 완료율 완주 등.

### 🤝 팀 챌린지 (6개, PRO 전용)
팀 챌린지 참가·리더·전원 완주 조건으로 획득합니다.

---

## 배지 확인 방법

하단 탭 **📊 기록** → 상단 배지 컬렉션 카드를 탭하면
획득한 배지와 미획득 배지 전체를 확인할 수 있습니다.

> 🔒 시크릿 배지는 획득 전까지 조건이 공개되지 않습니다.
''',
    'en': '''
## What are Badges?

Badges are **collectible achievements** earned by reaching milestones.
There are **50 badges** in total, viewable on the Records screen.

---

## Rarity

| Rarity | Description |
|---|---|
| ⚪ Common | Easy to earn basics |
| 🔵 Rare | Requires consistency |
| 🟣 Epic | Requires long-term effort |
| 🟡 Legendary | Highest difficulty |
| 🔒 Secret | Hidden condition |

---

## Categories

### 🔥 Streak (12)
Earned by maintaining streaks: 1, 3, 7, 14, 21, 30, 50, 66, 100 days, plus comeback badges.

### 🎯 Completion (10)
Earned by finishing challenges: 1, 3, 10, 25 completions; 100% success rate; 28+ day challenge.

### ✏️ Logging (8)
Earned by writing daily logs: first entry, 7/21-day streaks, 100/500 logs, 200+ character entry.

### ⏰ Timing (8)
Earned by check-in time patterns: before 6am, morning 21-day streak, night owl, punctual, weekend/weekday patterns.
Secret badges: 23:59 check-in, New Year's Day check-in.

### ➕ Sub-routines (6)
Earned by sub-routine milestones: first creation, 3/5+ sub-routines, dual challenge 7-day, 100% full sweep.

### 🤝 Team Challenge (6, PRO only)
Earned by participating in and completing team challenges.

---

## How to View Badges

Go to **📊 Records** tab → tap the Badge Collection card at the top.

> 🔒 Secret badge conditions are hidden until earned.
''',
    'ja': '''
## バッジとは？

様々な条件を達成すると獲得できる**コレクション型の実績**です。
合計**50個のバッジ**があり、記録画面で確認できます。

---

## レアリティ

| レアリティ | 説明 |
|---|---|
| ⚪ Common | 達成しやすい基本バッジ |
| 🔵 Rare | 継続が必要なバッジ |
| 🟣 Epic | 長期の努力が必要なバッジ |
| 🟡 Legendary | 最高難度バッジ |
| 🔒 Secret | 条件が隠されたシークレットバッジ |

---

## カテゴリ

**🔥 ストリーク（12個）** — 連続日数マイルストーンで獲得。
**🎯 完走（10個）** — チャレンジ完了数・完了率で獲得。
**✏️ 記録習慣（8個）** — デイリーログ作成で獲得。
**⏰ タイミング（8個）** — チェックイン時間パターンで獲得。
**➕ サブルーティン（6個）** — サブルーティン条件で獲得。
**🤝 チームチャレンジ（6個、PRO）** — チーム参加・完走で獲得。

---

## バッジの確認方法

**📊 記録**タブ → 上部のバッジコレクションカードをタップ。

> 🔒 シークレットバッジは獲得前に条件が公開されません。
''',
    'zhCN': '''
## 什么是徽章？

达成各种条件获得的**收集型成就**，共 **50个徽章**，可在记录页面查看。

---

## 稀有度

| 稀有度 | 说明 |
|---|---|
| ⚪ Common | 容易获得的基础徽章 |
| 🔵 Rare | 需要坚持的徽章 |
| 🟣 Epic | 需要长期努力的徽章 |
| 🟡 Legendary | 最高难度徽章 |
| 🔒 Secret | 条件隐藏的秘密徽章 |

---

## 类别

**🔥 连续（12个）** — 连续天数里程碑。
**🎯 完成（10个）** — 完成挑战次数和完成率。
**✏️ 记录习惯（8个）** — 写每日日志获得。
**⏰ 时间模式（8个）** — 打卡时间模式获得。
**➕ 子任务（6个）** — 子任务相关条件获得。
**🤝 团队挑战（6个，PRO）** — 参与团队挑战获得。

---

## 如何查看徽章

**📊 记录**标签 → 点击顶部徽章收集卡片。

> 🔒 秘密徽章获得前不会公开条件。
''',
    'es': '''
## ¿Qué son las insignias?

Las insignias son **logros coleccionables** que se obtienen al alcanzar hitos.
Hay **50 insignias** en total, visibles en la pantalla de Registros.

---

## Rareza

| Rareza | Descripción |
|---|---|
| ⚪ Common | Básicas, fáciles de ganar |
| 🔵 Rare | Requieren constancia |
| 🟣 Epic | Requieren esfuerzo a largo plazo |
| 🟡 Legendary | Mayor dificultad |
| 🔒 Secret | Condición oculta |

---

## Categorías

**🔥 Racha (12)** — Por mantener rachas: 1, 3, 7, 14, 21, 30, 50, 66, 100 días y más.

**🎯 Completado (10)** — Por terminar retos: 1, 3, 10, 25 completados; tasa del 100%; reto de 28+ días.

**✏️ Registro (8)** — Por escribir diarios: primera entrada, 7/21 días seguidos, 100/500 registros.

**⏰ Tiempo (8)** — Por patrones de check-in: antes de las 6am, 21 días matutinos, noctámbulo, fin de semana/días de semana.

**➕ Sub-retos (6)** — Por hitos de sub-retos: primera creación, 3/5+ sub-retos, tasa 100%.

**🤝 Reto en equipo (6, PRO)** — Por participar y completar retos en equipo.

---

## Cómo ver las insignias

Ve a la pestaña **📊 Registros** → toca la tarjeta de Colección de insignias.

> 🔒 Las condiciones de las insignias secretas están ocultas hasta que se ganen.
''',
    'de': '''
## Was sind Abzeichen?

Abzeichen sind **sammelbare Errungenschaften**, die durch das Erreichen von Meilensteinen verdient werden.
Es gibt insgesamt **50 Abzeichen**, die auf dem Bildschirm Aufzeichnungen angezeigt werden.

---

## Seltenheit

| Seltenheit | Beschreibung |
|---|---|
| ⚪ Common | Einfach zu verdienen |
| 🔵 Rare | Erfordert Beständigkeit |
| 🟣 Epic | Erfordert langfristigen Einsatz |
| 🟡 Legendary | Höchste Schwierigkeit |
| 🔒 Secret | Versteckte Bedingung |

---

## Kategorien

**🔥 Streak (12)** — Für das Aufrechterhalten von Streaks: 1, 3, 7, 14, 21, 30, 50, 66, 100 Tage usw.

**🎯 Abschluss (10)** — Für das Abschließen von Challenges: 1, 3, 10, 25 abgeschlossen; 100% Erfolgsrate; 28+ Tage Challenge.

**✏️ Aufzeichnung (8)** — Für das Schreiben von Tagebüchern: erster Eintrag, 7/21 Tage in Folge, 100/500 Einträge.

**⏰ Zeitpunkt (8)** — Für Check-in-Zeitmuster: vor 6 Uhr, 21 Morgen-Streaks, Nachteule, Wochenende/Wochentag.

**➕ Sub-Routinen (6)** — Für Sub-Routine-Meilensteine: erste Erstellung, 3/5+ Sub-Routinen, 100% Rate.

**🤝 Team Challenge (6, PRO)** — Für die Teilnahme und den Abschluss von Team-Challenges.

---

## Wie man Abzeichen ansieht

Gehe zum Tab **📊 Aufzeichnungen** → tippe auf die Abzeichen-Sammlungskarte.

> 🔒 Die Bedingungen für geheime Abzeichen sind verborgen, bis sie verdient werden.
''',
    'pt': '''
## O que são medalhas?

Medalhas são **conquistas colecionáveis** ganhas ao atingir marcos.
Há **50 medalhas** no total, visíveis na tela de Registros.

---

## Raridade

| Raridade | Descrição |
|---|---|
| ⚪ Common | Básicas, fáceis de ganhar |
| 🔵 Rare | Requerem consistência |
| 🟣 Epic | Requerem esforço de longo prazo |
| 🟡 Legendary | Maior dificuldade |
| 🔒 Secret | Condição oculta |

---

## Categorias

**🔥 Sequência (12)** — Por manter sequências: 1, 3, 7, 14, 21, 30, 50, 66, 100 dias e mais.

**🎯 Conclusão (10)** — Por terminar desafios: 1, 3, 10, 25 concluídos; taxa 100%; desafio de 28+ dias.

**✏️ Registro (8)** — Por escrever diários: primeira entrada, 7/21 dias seguidos, 100/500 entradas.

**⏰ Tempo (8)** — Por padrões de check-in: antes das 6h, 21 manhãs seguidas, coruja noturna, fim de semana/dias úteis.

**➕ Sub-rotinas (6)** — Por marcos de sub-rotinas: primeira criação, 3/5+ sub-rotinas, taxa 100%.

**🤝 Desafio em equipe (6, PRO)** — Por participar e completar desafios em equipe.

---

## Como ver as medalhas

Vá para a aba **📊 Registros** → toque no cartão Coleção de medalhas.

> 🔒 As condições das medalhas secretas ficam ocultas até serem ganhas.
''',
    'ru': '''
## Что такое значки?

Значки — это **коллекционные достижения**, зарабатываемые при достижении вех.
Всего **50 значков**, просмотреть их можно на экране Записей.

---

## Редкость

| Редкость | Описание |
|---|---|
| ⚪ Common | Базовые, легко получить |
| 🔵 Rare | Требуют постоянства |
| 🟣 Epic | Требуют долгосрочных усилий |
| 🟡 Legendary | Высшая сложность |
| 🔒 Secret | Скрытое условие |

---

## Категории

**🔥 Серии (12)** — За поддержание серий: 1, 3, 7, 14, 21, 30, 50, 66, 100 дней и более.

**🎯 Завершение (10)** — За выполнение задач: 1, 3, 10, 25 завершённых; 100% успех; задача 28+ дней.

**✏️ Записи (8)** — За ведение дневника: первая запись, 7/21 день подряд, 100/500 записей.

**⏰ Время (8)** — За паттерны отметок: до 6 утра, 21 утро подряд, ночная птица, выходные/будни.

**➕ Подзадачи (6)** — За вехи подзадач: первое создание, 3/5+ подзадач, 100% успех.

**🤝 Командная задача (6, PRO)** — За участие и завершение командных задач.

---

## Как просмотреть значки

Перейдите на вкладку **📊 Записи** → нажмите карточку Коллекция значков.

> 🔒 Условия секретных значков скрыты до их получения.
''',
  };

  // ─────────────────────────────────────────────────────────────
  // 일시정지
  // ─────────────────────────────────────────────────────────────
  static const Map<String, String> _pauseTicket = {
    'ko': '''
## 일시정지란?

휴가, 경조사 등 부득이한 사정으로 챌린지를 수행하기 어려운 기간을 **미리 지정**해두면, 해당 기간 동안 루틴을 하지 않아도 **스트릭이 끊기지 않는** 기능입니다.

> 일시정지는 **Pro 전용** 기능입니다.

---

## 동작 방식

- 정지 기간 중 루틴을 **수행하지 않아도** 스트릭이 유지됩니다.
- 정지 기간 중에도 루틴을 **수행할 수 있습니다** — 체크인 시 진행도가 올라갑니다.
- 스트릭 복구와 달리 **사전에** 기간을 설정하는 방식입니다.
- 정지 기간이 끝나면 다음 날부터 정상적으로 스트릭이 다시 계산됩니다.

---

## 사용 방법

1. 하단 탭 **🚩 챌린지** 화면으로 이동합니다.
2. **일시정지** 버튼을 탭합니다.
3. 정지할 기간(시작일 ~ 종료일)을 선택합니다.
4. 선택 완료 후 해당 기간에 일시정지가 적용됩니다.

---

## 정지 해제

정지 기간이 끝나기 전에 조기 해제할 수 있습니다.

1. 챌린지 화면에서 **"일시정지 중"** 배너를 확인합니다.
2. 배너 오른쪽의 **정지 해제** 버튼을 탭합니다.
3. 확인 다이얼로그에서 동의하면 즉시 해제됩니다.

---

## 스트릭 복구와의 차이

| 구분 | 일시정지 | 스트릭 복구 |
|---|---|---|
| 시점 | **사전** 설정 | **사후** 복구 |
| 방법 | Pro 전용 | Pro 즉시 복구 |
| 기간 | 여러 날 지정 가능 | 직전 하루만 |
| 제한 | 없음 | 챌린지당 7일 1회 |
''',
    'en': '''
## What is Pause?

Pause lets you **designate a period in advance** — such as a vacation or special occasion — during which your streak will **not break** even if you skip your routine.

> Pause is a **Pro-only** feature.

---

## How It Works

- Missing your routine during a pause **will not break your streak**.
- You **can still check in** during a pause — it counts toward your progress.
- Unlike streak recovery, this is set **in advance**.
- After the pause ends, the streak resumes normally from the next day.

---

## How to Use

1. Go to the **🚩 Challenge** tab.
2. Tap the **Pause** button.
3. Select your pause period (start date ~ end date).
4. The pause is applied immediately after selection.

---

## Ending a Pause Early

You can cancel a pause before it ends.

1. Find the **"Paused"** banner on the Challenge screen.
2. Tap the **End Pause** button on the right.
3. Confirm in the dialog — the pause ends immediately.

---

## Pause vs. Streak Recovery

| | Pause | Streak Recovery |
|---|---|---|
| Timing | **Before** (set in advance) | **After** (retroactive) |
| Method | Pro subscription | Pro instant recovery |
| Duration | Multiple days | Previous day only |
| Limit | None | Once per 7 days per challenge |
''',
    'ja': '''
## 一時停止とは？

休暇や冠婚葬祭など、やむを得ない事情でチャレンジが難しい期間を**事前に指定**することで、その期間中ルーティンをこなさなくても**ストリークが途切れない**機能です。

> 一時停止は **Pro専用** 機能です。

---

## 動作方式

- 一時停止期間中にルーティンを**しなくても**ストリークが維持されます。
- 一時停止期間中でもルーティンを**実行できます** — チェックインすると進捗が上がります。
- ストリーク回復と異なり、**事前に**期間を設定する方式です。
- 期間終了後は翌日から通常どおりストリークが再計算されます。

---

## 使い方

1. **🚩 チャレンジ**タブへ移動します。
2. **一時停止**ボタンをタップします。
3. 一時停止する期間（開始日〜終了日）を選択します。
4. 選択完了後、その期間に一時停止が適用されます。

---

## 一時停止の解除

終了日前に早期解除できます。

1. チャレンジ画面の**「一時停止中」**バナーを確認します。
2. バナー右側の**一時停止を解除**ボタンをタップします。
3. 確認ダイアログで同意すると即座に解除されます。

---

## ストリーク回復との違い

| 項目 | 一時停止 | ストリーク回復 |
|---|---|---|
| タイミング | **事前**設定 | **事後**回復 |
| 方法 | Pro限定 | Pro即時回復 |
| 期間 | 複数日指定可能 | 直前の1日のみ |
| 制限 | なし | チャレンジごと7日1回 |
''',
    'es': '''
## ¿Qué es Pausar?

Pausar te permite **designar un período con antelación** — como vacaciones o una ocasión especial — durante el cual tu racha **no se romperá** aunque te saltes la rutina.

> Pausar es una función **exclusiva de Pro**.

---

## Cómo funciona

- Saltarte la rutina durante una pausa **no romperá tu racha**.
- **Puedes hacer check-in** durante la pausa — cuenta para tu progreso.
- A diferencia de la recuperación de racha, se configura **de antemano**.
- Al terminar la pausa, la racha se reanuda normalmente al día siguiente.

---

## Cómo usarlo

1. Ve a la pestaña **🚩 Retos**.
2. Toca el botón **Pausar**.
3. Selecciona el período de pausa (fecha inicio ~ fecha fin).
4. La pausa se aplica de inmediato tras la selección.

---

## Cancelar una pausa antes de tiempo

Puedes cancelar la pausa antes de que termine.

1. Encuentra el banner **"En pausa"** en la pantalla de Retos.
2. Toca el botón **Cancelar pausa** a la derecha.
3. Confirma en el diálogo — la pausa finaliza de inmediato.

---

## Pausar vs. Recuperación de racha

| | Pausar | Recuperación de racha |
|---|---|---|
| Momento | **Antes** (configuración previa) | **Después** (retroactivo) |
| Método | Suscripción Pro | Recuperación Pro instantánea |
| Duración | Varios días | Solo el día anterior |
| Límite | Ninguno | Una vez cada 7 días por reto |
''',
  };
}
