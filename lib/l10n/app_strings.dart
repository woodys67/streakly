class AppStrings {
  final String language;
  const AppStrings._(this.language);

  static AppStrings of(String language) => AppStrings._(language);

  String _s({
    required String en,
    required String ko,
    required String ja,
    required String zhCN,
    required String zhTW,
    required String es,
    required String de,
    required String pt,
    required String ru,
  }) {
    switch (language) {
      case 'Korean':           return ko;
      case 'Japanese':         return ja;
      case 'ChineseSimplified':return zhCN;
      case 'ChineseTraditional':return zhTW;
      case 'Spanish':          return es;
      case 'German':           return de;
      case 'Portuguese':       return pt;
      case 'Russian':          return ru;
      default:                 return en;
    }
  }

  // ── Challenge Mode ───────────────────────────────────────────
  String get singleChallenge => _s(en:'Solo Challenge', ko:'싱글 챌린지', ja:'ソロチャレンジ', zhCN:'单人挑战', zhTW:'單人挑戰', es:'Desafío individual', de:'Solo Challenge', pt:'Desafio solo', ru:'Одиночный вызов');
  String get multiChallenge => _s(en:'Team Challenge', ko:'팀 챌린지', ja:'チームチャレンジ', zhCN:'团队挑战', zhTW:'團隊挑戰', es:'Desafío en equipo', de:'Team Challenge', pt:'Desafio em equipe', ru:'Командный вызов');
  String get premiumLabel => _s(en:'PRO', ko:'PRO', ja:'PRO', zhCN:'PRO', zhTW:'PRO', es:'PRO', de:'PRO', pt:'PRO', ru:'PRO');
  String get multiChallengeTeaser => _s(
    en:'Team Challenge is coming soon!\nCompete and grow together with friends.',
    ko:'팀 챌린지가 곧 출시됩니다!\n친구들과 함께 경쟁하고 성장해보세요.',
    ja:'チームチャレンジが近日公開！\n友達と一緒に競い合い、成長しよう。',
    zhCN:'团队挑战即将推出！\n与朋友一起竞争和成长。',
    zhTW:'團隊挑戰即將推出！\n與朋友一起競爭和成長。',
    es:'¡El desafío en equipo llega pronto!\nCompite y crece junto a tus amigos.',
    de:'Team-Challenge kommt bald!\nWetteifere und wachse gemeinsam mit Freunden.',
    pt:'Desafio em equipe em breve!\nCompita e cresça com amigos.',
    ru:'Командный вызов скоро!\nСоревнуйтесь и растите вместе с друзьями.',
  );

  // ── Bottom Nav ──────────────────────────────────────────────
  String get navHome => _s(en:'Home', ko:'홈', ja:'ホーム', zhCN:'主页', zhTW:'主頁', es:'Inicio', de:'Startseite', pt:'Início', ru:'Главная');
  String get navChallenges => _s(en:'Challenges', ko:'챌린지', ja:'チャレンジ', zhCN:'挑战', zhTW:'挑戰', es:'Desafíos', de:'Challenges', pt:'Desafios', ru:'Вызовы');
  String get navRecords => _s(en:'Records', ko:'기록', ja:'記録', zhCN:'记录', zhTW:'記錄', es:'Registros', de:'Aufzeichnungen', pt:'Registros', ru:'Записи');
  String get navSettings => _s(en:'Settings', ko:'설정', ja:'設定', zhCN:'设置', zhTW:'設定', es:'Ajustes', de:'Einstellungen', pt:'Configurações', ru:'Настройки');

  // ── Common ───────────────────────────────────────────────────
  String get cancel => _s(en:'Cancel', ko:'취소', ja:'キャンセル', zhCN:'取消', zhTW:'取消', es:'Cancelar', de:'Abbrechen', pt:'Cancelar', ru:'Отмена');
  String get save => _s(en:'Save', ko:'저장', ja:'保存', zhCN:'保存', zhTW:'儲存', es:'Guardar', de:'Speichern', pt:'Salvar', ru:'Сохранить');
  String get delete => _s(en:'Delete', ko:'삭제', ja:'削除', zhCN:'删除', zhTW:'刪除', es:'Eliminar', de:'Löschen', pt:'Excluir', ru:'Удалить');
  String get ok => _s(en:'OK', ko:'확인', ja:'OK', zhCN:'确定', zhTW:'確定', es:'Aceptar', de:'OK', pt:'OK', ru:'ОК');
  String get createChallenge => _s(en:'Create Challenge', ko:'챌린지 만들기', ja:'チャレンジを作成', zhCN:'创建挑战', zhTW:'建立挑戰', es:'Crear desafío', de:'Challenge erstellen', pt:'Criar desafio', ru:'Создать вызов');

  // ── Home Screen ──────────────────────────────────────────────
  String get todaysRoutines => _s(en:"Today's Routines", ko:'오늘의 루틴', ja:'今日のルーティン', zhCN:'今日例行', zhTW:'今日例行', es:'Rutinas de hoy', de:'Heutige Routinen', pt:'Rotinas de hoje', ru:'Сегодняшние распорядки');
  String doneCount(int done, int total) => _s(
    en:'Done $done/$total', ko:'완료 $done/$total', ja:'完了 $done/$total',
    zhCN:'完成 $done/$total', zhTW:'完成 $done/$total', es:'Hecho $done/$total',
    de:'Erledigt $done/$total', pt:'Feito $done/$total', ru:'Готово $done/$total',
  );
  String get startFirstChallenge => _s(
    en:'Start Your First Challenge!', ko:'첫 번째 챌린지를 시작해보세요!', ja:'最初のチャレンジを始めましょう！',
    zhCN:'开始你的第一个挑战！', zhTW:'開始你的第一個挑戰！', es:'¡Empieza tu primer desafío!',
    de:'Starte deine erste Challenge!', pt:'Comece seu primeiro desafio!', ru:'Начните свой первый вызов!',
  );
  String get todayRestDay => _s(
    en:'Rest day today 🎉', ko:'오늘은 쉬는 날이에요 🎉', ja:'今日は休息日です 🎉',
    zhCN:'今天是休息日 🎉', zhTW:'今天是休息日 🎉', es:'¡Hoy es día de descanso! 🎉',
    de:'Heute ist Ruhetag 🎉', pt:'Hoje é dia de descanso 🎉', ru:'Сегодня день отдыха 🎉',
  );
  String get todayRestDayDesc => _s(
    en:'No challenges scheduled for today.', ko:'오늘 예정된 챌린지가 없어요.', ja:'今日予定されているチャレンジはありません。',
    zhCN:'今天没有安排挑战。', zhTW:'今天沒有安排挑戰。', es:'No hay desafíos programados para hoy.',
    de:'Für heute sind keine Challenges geplant.', pt:'Nenhum desafio agendado para hoje.', ru:'На сегодня вызовов нет.',
  );
  String get habitMethodDesc => _s(
    en:'Build habits through consistency', ko:'꾸준함으로 습관을 만들어보세요.', ja:'継続することで習慣を作ろう',
    zhCN:'通过坚持养成好习惯', zhTW:'透過堅持養成好習慣', es:'Crea hábitos a través de la constancia',
    de:'Gewohnheiten durch Beständigkeit aufbauen', pt:'Construa hábitos através da consistência', ru:'Формируйте привычки через постоянство',
  );
  String get weeklyCompletion => _s(en:'Weekly Completion', ko:'주간 완료율', ja:'週間達成率', zhCN:'本周完成率', zhTW:'本週完成率', es:'Completado semanal', de:'Wöchentliche Vollendung', pt:'Conclusão semanal', ru:'Еженедельное выполнение');
  String get badgesEarned => _s(en:'Badges Earned', ko:'획득 배지', ja:'獲得バッジ', zhCN:'已获徽章', zhTW:'已獲徽章', es:'Insignias obtenidas', de:'Verdiente Abzeichen', pt:'Emblemas conquistados', ru:'Заработанные значки');

  // ── Streak Card ──────────────────────────────────────────────
  String daysOnFire(int days) => _s(
    en:'$days Days On Fire!', ko:'${days}일 연속 달성!', ja:'${days}日連続達成！',
    zhCN:'连续${days}天完成！', zhTW:'連續${days}天完成！', es:'¡$days días en racha!',
    de:'$days Tage am Stück!', pt:'$days dias em sequência!', ru:'${days} дней подряд!',
  );
  String get currentStreak => _s(en:'Current Streak', ko:'현재 스트릭', ja:'現在のストリーク', zhCN:'当前连续', zhTW:'當前連續', es:'Racha actual', de:'Aktuelle Serie', pt:'Sequência atual', ru:'Текущая серия');

  // ── Challenge Screen ─────────────────────────────────────────
  String get challengeTab => _s(en:'Challenge', ko:'챌린지', ja:'チャレンジ', zhCN:'挑战', zhTW:'挑戰', es:'Desafío', de:'Challenge', pt:'Desafio', ru:'Вызов');
  String get noActiveChallenge => _s(en:'No Active Challenge', ko:'진행 중인 챌린지 없음', ja:'進行中のチャレンジなし', zhCN:'没有进行中的挑战', zhTW:'沒有進行中的挑戰', es:'Sin desafío activo', de:'Keine aktive Challenge', pt:'Nenhum desafio ativo', ru:'Нет активных вызовов');
  String get noActiveChallengeDesc => _s(
    en:'Create your first challenge to get started', ko:'챌린지를 만들어 시작하세요', ja:'チャレンジを作成して始めましょう',
    zhCN:'创建挑战开始吧', zhTW:'建立挑戰開始吧', es:'Crea tu primer desafío para empezar',
    de:'Erstelle deine erste Challenge zum Starten', pt:'Crie seu primeiro desafio para começar', ru:'Создайте свой первый вызов, чтобы начать',
  );
  String get progress => _s(en:'Progress', ko:'진행도', ja:'進捗', zhCN:'进度', zhTW:'進度', es:'Progreso', de:'Fortschritt', pt:'Progresso', ru:'Прогресс');
  String daysProgress(int done, int total) => _s(
    en:'$done of $total Days', ko:'${total}일 중 ${done}일 완료', ja:'${total}日中${done}日完了',
    zhCN:'${total}天中已完成${done}天', zhTW:'${total}天中已完成${done}天', es:'$done de $total días',
    de:'$done von $total Tagen', pt:'$done de $total dias', ru:'$done из $total дней',
  );
  String dayStreak(int days) => _s(
    en:'$days Day Streak! 🔥', ko:'${days}일 연속! 🔥', ja:'${days}日連続！🔥',
    zhCN:'连续${days}天！🔥', zhTW:'連續${days}天！🔥', es:'¡Racha de $days días! 🔥',
    de:'$days Tage Serie! 🔥', pt:'Sequência de $days dias! 🔥', ru:'Серия $days дней! 🔥',
  );
  String daysChallenge(int days) => _s(
    en:'$days-Days Challenge', ko:'${days}일 챌린지', ja:'${days}日間チャレンジ',
    zhCN:'${days}天挑战', zhTW:'${days}天挑戰', es:'Desafío de $days días',
    de:'$days-Tage-Challenge', pt:'Desafio de $days dias', ru:'Вызов на $days дней',
  );
  String get subRoutines => _s(en:'Sub-routines', ko:'서브 루틴', ja:'サブルーティン', zhCN:'子例行', zhTW:'子例行', es:'Sub-rutinas', de:'Unter-Routinen', pt:'Sub-rotinas', ru:'Подпрограммы');
  String get notesMotivation => _s(en:'Notes & Motivation', ko:'메모 & 동기부여', ja:'メモ＆モチベーション', zhCN:'备注＆动力', zhTW:'備註＆動力', es:'Notas y motivación', de:'Notizen & Motivation', pt:'Notas e motivação', ru:'Заметки и мотивация');
  String get dailyLogs => _s(en:'Daily Logs', ko:'데일리 로그', ja:'デイリーログ', zhCN:'每日日志', zhTW:'每日日誌', es:'Registros diarios', de:'Tageseinträge', pt:'Registros diários', ru:'Ежедневные записи');
  String entriesCount(int count) => _s(
    en:'$count entries', ko:'${count}개 기록', ja:'${count}件の記録',
    zhCN:'${count}条记录', zhTW:'${count}條記錄', es:'$count entradas',
    de:'$count Einträge', pt:'$count entradas', ru:'${count} записей',
  );
  String get noLogsYet => _s(en:'No logs yet', ko:'아직 기록이 없어요', ja:'まだ記録がありません', zhCN:'还没有记录', zhTW:'還沒有記錄', es:'Aún no hay registros', de:'Noch keine Einträge', pt:'Ainda não há registros', ru:'Записей пока нет');
  String get shareThoughtButton => _s(
    en:'Share your thought for today', ko:'오늘의 생각 기록하기', ja:'今日の気持ちを記録する',
    zhCN:'记录今天的想法', zhTW:'記錄今天的想法', es:'Comparte tu pensamiento de hoy',
    de:'Teile deinen Gedanken für heute', pt:'Compartilhe seu pensamento de hoje', ru:'Поделитесь мыслью на сегодня',
  );
  String get shareThoughtTitle => _s(en:'Share Your Thought', ko:'오늘의 생각', ja:'今日の気持ち', zhCN:'今天的想法', zhTW:'今天的想法', es:'Tu pensamiento', de:'Dein Gedanke', pt:'Seu pensamento', ru:'Ваша мысль');
  String get shareThoughtHint => _s(en:'How did today go?', ko:'오늘 하루 어땠나요?', ja:'今日はどうでしたか？', zhCN:'今天怎么样？', zhTW:'今天怎麼樣？', es:'¿Cómo fue hoy?', de:'Wie war dein Tag?', pt:'Como foi hoje?', ru:'Как прошёл день?');
  String get deleteChallenge => _s(en:'Delete Challenge', ko:'챌린지 삭제', ja:'チャレンジを削除', zhCN:'删除挑战', zhTW:'刪除挑戰', es:'Eliminar desafío', de:'Challenge löschen', pt:'Excluir desafio', ru:'Удалить вызов');
  String get deleteChallengeConfirm => _s(
    en:'Deleting this challenge will erase all records. Are you sure?',
    ko:'챌린지를 삭제하면 모든 기록이 사라집니다. 정말 삭제할까요?',
    ja:'このチャレンジを削除すると、すべての記録が失われます。本当に削除しますか？',
    zhCN:'删除此挑战将删除所有记录。确定要删除吗？',
    zhTW:'刪除此挑戰將刪除所有記錄。確定要刪除嗎？',
    es:'Eliminar este desafío borrará todos los registros. ¿Estás seguro?',
    de:'Das Löschen dieser Challenge entfernt alle Einträge. Bist du sicher?',
    pt:'Excluir este desafio apagará todos os registros. Tem certeza?',
    ru:'Удаление этого вызова сотрёт все записи. Вы уверены?',
  );

  // ── New Challenge Screen ─────────────────────────────────────
  String get newChallenge => _s(en:'New Challenge', ko:'새 챌린지', ja:'新しいチャレンジ', zhCN:'新挑战', zhTW:'新挑戰', es:'Nuevo desafío', de:'Neue Challenge', pt:'Novo desafio', ru:'Новый вызов');
  String get mainRoutineLabel => _s(en:'MAIN ROUTINE', ko:'메인 루틴', ja:'メインルーティン', zhCN:'主例行', zhTW:'主例行', es:'RUTINA PRINCIPAL', de:'HAUPT-ROUTINE', pt:'ROTINA PRINCIPAL', ru:'ОСНОВНАЯ ПРОГРАММА');
  String get subRoutineLabel => _s(en:'SUB ROUTINE (OPTIONAL)', ko:'서브 루틴 (선택사항)', ja:'サブルーティン（任意）', zhCN:'子例行（可选）', zhTW:'子例行（可選）', es:'SUB-RUTINA (OPCIONAL)', de:'UNTER-ROUTINE (OPTIONAL)', pt:'SUB-ROTINA (OPCIONAL)', ru:'ПОДПРОГРАММА (НЕОБЯЗАТЕЛЬНО)');
  String get addSubRoutine => _s(en:'Add Sub-routine', ko:'서브 루틴 추가', ja:'サブルーティンを追加', zhCN:'添加子例行', zhTW:'新增子例行', es:'Añadir sub-rutina', de:'Unter-Routine hinzufügen', pt:'Adicionar sub-rotina', ru:'Добавить подпрограмму');
  String get targetDaysLabel => _s(en:'TARGET DAYS', ko:'목표 일수', ja:'目標日数', zhCN:'目标天数', zhTW:'目標天數', es:'DÍAS OBJETIVO', de:'ZIELTAGE', pt:'DIAS ALVO', ru:'ЦЕЛЕВЫЕ ДНИ');
  String get sevenDays => _s(en:'7 Days', ko:'7일', ja:'7日間', zhCN:'7天', zhTW:'7天', es:'7 días', de:'7 Tage', pt:'7 dias', ru:'7 дней');
  String get fourteenDays => _s(en:'14 Days', ko:'14일', ja:'14日間', zhCN:'14天', zhTW:'14天', es:'14 días', de:'14 Tage', pt:'14 dias', ru:'14 дней');
  String get twentyOneDays => _s(en:'21 Days', ko:'21일', ja:'21日間', zhCN:'21天', zhTW:'21天', es:'21 días', de:'21 Tage', pt:'21 dias', ru:'21 день');
  String get custom => _s(en:'Custom', ko:'직접 입력', ja:'カスタム', zhCN:'自定义', zhTW:'自訂', es:'Personalizado', de:'Benutzerdefiniert', pt:'Personalizado', ru:'Пользовательский');
  String get enterDaysHint => _s(en:'Enter number of days', ko:'일수를 입력하세요', ja:'日数を入力してください', zhCN:'请输入天数', zhTW:'請輸入天數', es:'Ingresa el número de días', de:'Anzahl der Tage eingeben', pt:'Digite o número de dias', ru:'Введите количество дней');
  String get reminderTimeLabel => _s(en:'REMINDER TIME', ko:'알림 시간', ja:'リマインダー時刻', zhCN:'提醒时间', zhTW:'提醒時間', es:'HORA DE RECORDATORIO', de:'ERINNERUNGSZEIT', pt:'HORA DO LEMBRETE', ru:'ВРЕМЯ НАПОМИНАНИЯ');
  String get repetitionLabel => _s(en:'REPETITION', ko:'반복 요일', ja:'繰り返し', zhCN:'重复', zhTW:'重複', es:'REPETICIÓN', de:'WIEDERHOLUNG', pt:'REPETIÇÃO', ru:'ПОВТОРЕНИЕ');
  String get notesLabel => _s(en:'NOTES & MOTIVATION', ko:'메모 & 동기부여', ja:'メモ＆モチベーション', zhCN:'备注＆动力', zhTW:'備註＆動力', es:'NOTAS Y MOTIVACIÓN', de:'NOTIZEN & MOTIVATION', pt:'NOTAS E MOTIVAÇÃO', ru:'ЗАМЕТКИ И МОТИВАЦИЯ');
  String get notesHint => _s(
    en:'Write your motivation here...', ko:'동기부여 문구를 작성해보세요...', ja:'モチベーションを書いてください...',
    zhCN:'写下你的动力...', zhTW:'寫下你的動力...', es:'Escribe tu motivación aquí...',
    de:'Schreibe hier deine Motivation...', pt:'Escreva sua motivação aqui...', ru:'Напишите свою мотивацию здесь...',
  );
  String get startChallenge => _s(en:'Start Challenge ⚡', ko:'챌린지 시작 ⚡', ja:'チャレンジ開始 ⚡', zhCN:'开始挑战 ⚡', zhTW:'開始挑戰 ⚡', es:'Iniciar desafío ⚡', de:'Challenge starten ⚡', pt:'Iniciar desafio ⚡', ru:'Начать вызов ⚡');
  String get mainRoutineEmpty => _s(
    en:'Please enter a main routine name', ko:'메인 루틴 이름을 입력해주세요', ja:'メインルーティン名を入力してください',
    zhCN:'请输入主例行名称', zhTW:'請輸入主例行名稱', es:'Por favor ingresa el nombre de la rutina principal',
    de:'Bitte gib den Namen der Haupt-Routine ein', pt:'Por favor insira o nome da rotina principal', ru:'Пожалуйста, введите название основной программы',
  );
  String get invalidDays => _s(
    en:'Please enter valid number of days', ko:'유효한 일수를 입력해주세요', ja:'有効な日数を入力してください',
    zhCN:'请输入有效的天数', zhTW:'請輸入有效的天數', es:'Por favor ingresa un número de días válido',
    de:'Bitte gib eine gültige Anzahl von Tagen ein', pt:'Por favor insira um número válido de dias', ru:'Пожалуйста, введите корректное количество дней',
  );

  // ── Add Subroutine Modal ─────────────────────────────────────
  String get addSubRoutineTitle => _s(en:'Add Sub-routine', ko:'서브 루틴 추가', ja:'サブルーティンを追加', zhCN:'添加子例行', zhTW:'新增子例行', es:'Añadir sub-rutina', de:'Unter-Routine hinzufügen', pt:'Adicionar sub-rotina', ru:'Добавить подпрограмму');
  String get subRoutineNameLabel => _s(en:'SUB-ROUTINE NAME', ko:'서브 루틴 이름', ja:'サブルーティン名', zhCN:'子例行名称', zhTW:'子例行名稱', es:'NOMBRE DE SUB-RUTINA', de:'UNTER-ROUTINE NAME', pt:'NOME DA SUB-ROTINA', ru:'НАЗВАНИЕ ПОДПРОГРАММЫ');
  String get subRoutineNameHint => _s(en:'e.g., Morning Stretch', ko:'예) 아침 스트레칭', ja:'例：朝のストレッチ', zhCN:'例：早晨伸展', zhTW:'例：早晨伸展', es:'ej., Estiramiento matutino', de:'z.B. Morgengymnastik', pt:'ex., Alongamento matinal', ru:'напр., Утренняя растяжка');
  String get notificationTimeLabel => _s(en:'NOTIFICATION TIME', ko:'알림 시간', ja:'通知時刻', zhCN:'通知时间', zhTW:'通知時間', es:'HORA DE NOTIFICACIÓN', de:'BENACHRICHTIGUNGSZEIT', pt:'HORA DA NOTIFICAÇÃO', ru:'ВРЕМЯ УВЕДОМЛЕНИЯ');
  String get alertOn => _s(en:'Alert ON', ko:'알림 ON', ja:'通知 ON', zhCN:'通知 开', zhTW:'通知 開', es:'Alerta ON', de:'Alarm EIN', pt:'Alerta LIGADO', ru:'Уведомление ВКЛ');
  String get alertOff => _s(en:'Alert OFF', ko:'알림 OFF', ja:'通知 OFF', zhCN:'通知 关', zhTW:'通知 關', es:'Alerta OFF', de:'Alarm AUS', pt:'Alerta DESLIGADO', ru:'Уведомление ВЫКЛ');
  String get subRoutineEmpty => _s(
    en:'Please enter a sub-routine name', ko:'서브 루틴 이름을 입력해주세요', ja:'サブルーティン名を入力してください',
    zhCN:'请输入子例行名称', zhTW:'請輸入子例行名稱', es:'Por favor ingresa el nombre de la sub-rutina',
    de:'Bitte gib den Namen der Unter-Routine ein', pt:'Por favor insira o nome da sub-rotina', ru:'Пожалуйста, введите название подпрограммы',
  );
  String get proTip => _s(
    en:'Pro Tip: Breaking your routine into smaller steps makes it easier to stay consistent!',
    ko:'팁: 루틴을 작은 단계로 나누면 꾸준히 실천하기 더 쉬워져요!',
    ja:'ヒント：ルーティンを小さなステップに分けると、継続しやすくなります！',
    zhCN:'提示：将例行分解为小步骤，更容易坚持！',
    zhTW:'提示：將例行分解為小步驟，更容易堅持！',
    es:'Consejo: ¡Dividir tu rutina en pasos pequeños hace más fácil mantenerse constante!',
    de:'Tipp: Das Aufteilen deiner Routine in kleinere Schritte macht es leichter, dranzubleiben!',
    pt:'Dica: Dividir sua rotina em etapas menores torna mais fácil manter a consistência!',
    ru:'Совет: Разбивка распорядка на небольшие шаги облегчает постоянство!',
  );

  // ── Records Screen ───────────────────────────────────────────
  String get recordsTitle => _s(en:'Records', ko:'기록', ja:'記録', zhCN:'记录', zhTW:'記錄', es:'Registros', de:'Aufzeichnungen', pt:'Registros', ru:'Записи');
  String get habitBuilder => _s(en:'Habit Builder', ko:'습관 형성자', ja:'習慣形成者', zhCN:'习惯养成者', zhTW:'習慣養成者', es:'Constructor de hábitos', de:'Gewohnheitsbildner', pt:'Construtor de hábitos', ru:'Строитель привычек');
  String get successLabel => _s(en:'SUCCESS', ko:'성공률', ja:'成功率', zhCN:'成功率', zhTW:'成功率', es:'ÉXITO', de:'ERFOLG', pt:'SUCESSO', ru:'УСПЕХ');
  String get overallRate => _s(en:'Overall Rate', ko:'전체 성공률', ja:'全体達成率', zhCN:'整体成功率', zhTW:'整體成功率', es:'Tasa general', de:'Gesamtquote', pt:'Taxa geral', ru:'Общий показатель');
  String get keepItUp => _s(
    en:'Keep it up! Consistency\nis the key to success.',
    ko:'계속 도전하세요! 꾸준함이\n성공의 열쇠예요.',
    ja:'続けましょう！継続こそが\n成功への鍵です。',
    zhCN:'加油！坚持就是\n成功的关键。',
    zhTW:'加油！堅持就是\n成功的關鍵。',
    es:'¡Sigue así! La constancia\nes la clave del éxito.',
    de:'Weiter so! Beständigkeit\nist der Schlüssel zum Erfolg.',
    pt:'Continue assim! Consistência\né a chave do sucesso.',
    ru:'Продолжайте! Постоянство —\nключ к успеху.',
  );
  String get totalStreaks => _s(en:'TOTAL STREAKS', ko:'총 스트릭', ja:'総ストリーク', zhCN:'总连续', zhTW:'總連續', es:'RACHAS TOTALES', de:'GESAMTSERIEN', pt:'SEQUÊNCIAS TOTAIS', ru:'ВСЕГО СЕРИЙ');
  String get completed => _s(en:'COMPLETED', ko:'완료', ja:'完了', zhCN:'已完成', zhTW:'已完成', es:'COMPLETADO', de:'ABGESCHLOSSEN', pt:'CONCLUÍDO', ru:'ВЫПОЛНЕНО');
  String get completedInfo => _s(
    en:'Total number of challenges you have successfully completed.',
    ko:'성공적으로 완료한 챌린지의 총 개수입니다.',
    ja:'正常に完了したチャレンジの総数です。',
    zhCN:'您成功完成的挑战总数。',
    zhTW:'您成功完成的挑戰總數。',
    es:'Número total de desafíos que has completado con éxito.',
    de:'Gesamtzahl der erfolgreich abgeschlossenen Challenges.',
    pt:'Número total de desafios que você concluiu com sucesso.',
    ru:'Общее количество успешно завершённых вызовов.',
  );
  String get completedChallenges => _s(en:'Completed Challenges', ko:'완료된 챌린지', ja:'完了したチャレンジ', zhCN:'已完成挑战', zhTW:'已完成挑戰', es:'Desafíos completados', de:'Abgeschlossene Challenges', pt:'Desafios concluídos', ru:'Завершённые вызовы');
  String get noRecordsYet => _s(
    en:'Complete challenges to see your records here!',
    ko:'챌린지를 완료하면 여기서 기록을 확인할 수 있어요!',
    ja:'チャレンジを完了すると、ここに記録が表示されます！',
    zhCN:'完成挑战后，您的记录将显示在这里！',
    zhTW:'完成挑戰後，您的記錄將顯示在這裡！',
    es:'¡Completa desafíos para ver tus registros aquí!',
    de:'Schließe Challenges ab, um deine Aufzeichnungen hier zu sehen!',
    pt:'Conclua desafios para ver seus registros aqui!',
    ru:'Выполняйте вызовы, чтобы увидеть свои записи здесь!',
  );
  String get keepGoingRecords => _s(
    en:'Keep going! Your completed challenges will appear here.',
    ko:'계속 도전하세요! 완료된 챌린지가 여기에 표시됩니다.',
    ja:'頑張ってください！完了したチャレンジがここに表示されます。',
    zhCN:'继续加油！完成的挑战将显示在这里。',
    zhTW:'繼續加油！完成的挑戰將顯示在這裡。',
    es:'¡Sigue adelante! Tus desafíos completados aparecerán aquí.',
    de:'Weiter so! Deine abgeschlossenen Challenges erscheinen hier.',
    pt:'Continue! Seus desafios concluídos aparecerão aqui.',
    ru:'Продолжайте! Ваши завершённые вызовы появятся здесь.',
  );
  String challengeSummary(int days, int completedDays) => _s(
    en:'$days Days · $completedDays Completed', ko:'${days}일 · ${completedDays}일 완료', ja:'${days}日間 · ${completedDays}日完了',
    zhCN:'${days}天 · ${completedDays}天完成', zhTW:'${days}天 · ${completedDays}天完成', es:'$days días · $completedDays completados',
    de:'$days Tage · $completedDays abgeschlossen', pt:'$days dias · $completedDays concluídos', ru:'$days дней · $completedDays выполнено',
  );

  // ── Settings Screen ──────────────────────────────────────────
  String get resetApp => _s(en:'Reset App', ko:'앱 초기화', ja:'アプリをリセット', zhCN:'重置应用', zhTW:'重置應用程式', es:'Reiniciar app', de:'App zurücksetzen', pt:'Redefinir app', ru:'Сбросить приложение');
  String get resetAppConfirm => _s(
    en:'All challenges and data will be permanently deleted. This cannot be undone.',
    ko:'모든 챌린지와 데이터가 영구적으로 삭제됩니다. 이 작업은 되돌릴 수 없습니다.',
    ja:'すべてのチャレンジとデータが完全に削除されます。この操作は元に戻せません。',
    zhCN:'所有挑战和数据将被永久删除，此操作无法撤销。',
    zhTW:'所有挑戰和資料將被永久刪除，此操作無法撤銷。',
    es:'Todos los desafíos y datos serán eliminados permanentemente. Esta acción no se puede deshacer.',
    de:'Alle Challenges und Daten werden dauerhaft gelöscht. Dies kann nicht rückgängig gemacht werden.',
    pt:'Todos os desafios e dados serão excluídos permanentemente. Esta ação não pode ser desfeita.',
    ru:'Все вызовы и данные будут удалены навсегда. Это действие нельзя отменить.',
  );
  String get editName => _s(en:'Edit Name', ko:'이름 수정', ja:'名前を編集', zhCN:'编辑名称', zhTW:'編輯名稱', es:'Editar nombre', de:'Name bearbeiten', pt:'Editar nome', ru:'Изменить имя');
  String get nameHint => _s(en:'Enter your name', ko:'이름을 입력하세요', ja:'名前を入力', zhCN:'输入名称', zhTW:'輸入名稱', es:'Ingresa tu nombre', de:'Name eingeben', pt:'Digite seu nome', ru:'Введите имя');
  String get appSettings => _s(en:'App Settings', ko:'앱 설정', ja:'アプリ設定', zhCN:'应用设置', zhTW:'應用程式設定', es:'Ajustes de la app', de:'App-Einstellungen', pt:'Configurações do app', ru:'Настройки приложения');
  String get languages => _s(en:'Languages', ko:'언어', ja:'言語', zhCN:'语言', zhTW:'語言', es:'Idiomas', de:'Sprachen', pt:'Idiomas', ru:'Языки');
  String get notificationSettings => _s(en:'Notification Settings', ko:'알림 설정', ja:'通知設定', zhCN:'通知设置', zhTW:'通知設定', es:'Notificaciones', de:'Benachrichtigungen', pt:'Notificações', ru:'Уведомления');
  String get themeSettings => _s(en:'Theme Settings', ko:'테마 설정', ja:'テーマ設定', zhCN:'主题设置', zhTW:'主題設定', es:'Tema', de:'Design', pt:'Tema', ru:'Тема');
  String get darkMode => _s(en:'Dark Mode', ko:'다크 모드', ja:'ダークモード', zhCN:'深色模式', zhTW:'深色模式', es:'Modo oscuro', de:'Dunkelmodus', pt:'Modo escuro', ru:'Тёмная тема');
  String get lightMode => _s(en:'Light Mode', ko:'라이트 모드', ja:'ライトモード', zhCN:'浅色模式', zhTW:'淺色模式', es:'Modo claro', de:'Hellmodus', pt:'Modo claro', ru:'Светлая тема');
  String get teamChallengeSubscribe => _s(en:'Team Challenge Pro', ko:'팀 챌린지 구독', ja:'チームチャレンジPro', zhCN:'团队挑战Pro', zhTW:'團隊挑戰Pro', es:'Suscripción Team Challenge', de:'Team-Challenge Pro', pt:'Assinatura Team Challenge', ru:'Командный вызов Pro');
  String get teamChallengeSubscribeDesc => _s(
    en:'Subscribe to unlock Team Challenge mode\nand compete with friends.',
    ko:'팀 챌린지 모드를 구독하고\n친구들과 함께 경쟁해보세요.',
    ja:'チームチャレンジモードを購読して\n友達と競い合いましょう。',
    zhCN:'订阅团队挑战模式\n与朋友一起竞争。',
    zhTW:'訂閱團隊挑戰模式\n與朋友一起競爭。',
    es:'Suscríbete al modo Team Challenge\ny compite con amigos.',
    de:'Abonniere den Team-Challenge-Modus\nund konkurriere mit Freunden.',
    pt:'Assine o modo Team Challenge\ne compita com amigos.',
    ru:'Подпишитесь на режим Командного вызова\nи соревнуйтесь с друзьями.',
  );
  String get subscribeNow => _s(en:'Subscribe Now', ko:'지금 구독하기', ja:'今すぐ購読', zhCN:'立即订阅', zhTW:'立即訂閱', es:'Suscribirse ahora', de:'Jetzt abonnieren', pt:'Assinar agora', ru:'Подписаться сейчас');
  String get signOut => _s(en:'Sign Out', ko:'로그아웃', ja:'サインアウト', zhCN:'退出登录', zhTW:'登出', es:'Cerrar sesión', de:'Abmelden', pt:'Sair', ru:'Выйти');
  String get streaklyMember => _s(en:'Streakly Member', ko:'Streakly 멤버', ja:'Streaklyメンバー', zhCN:'Streakly会员', zhTW:'Streakly會員', es:'Miembro de Streakly', de:'Streakly-Mitglied', pt:'Membro Streakly', ru:'Участник Streakly');
  String get signOutConfirm => _s(
    en:'Are you sure you want to sign out? Your data will be preserved.',
    ko:'로그아웃하시겠어요? 기존 데이터는 그대로 보존됩니다.',
    ja:'サインアウトしますか？データはそのまま保持されます。',
    zhCN:'确定要退出登录吗？您的数据将被保留。',
    zhTW:'確定要登出嗎？您的資料將被保留。',
    es:'¿Seguro que quieres cerrar sesión? Tus datos se conservarán.',
    de:'Möchtest du dich wirklich abmelden? Deine Daten bleiben erhalten.',
    pt:'Tem certeza que deseja sair? Seus dados serão preservados.',
    ru:'Вы уверены, что хотите выйти? Ваши данные будут сохранены.',
  );

  // ── Badge ───────────────────────────────────────────────────
  String get badgesTitle => _s(en:'My Badges', ko:'획득한 배지', ja:'獲得バッジ', zhCN:'我的徽章', zhTW:'我的徽章', es:'Mis insignias', de:'Meine Abzeichen', pt:'Meus emblemas', ru:'Мои значки');
  String get noBadgesYet => _s(en:'No badges earned yet.\nKeep going!', ko:'아직 획득한 배지가 없어요.\n계속 도전해보세요!', ja:'まだバッジはありません。\n続けてみましょう！', zhCN:'还没有获得徽章，继续加油！', zhTW:'還沒有獲得徽章，繼續加油！', es:'Sin insignias aún.\n¡Sigue así!', de:'Noch keine Abzeichen.\nWeiter so!', pt:'Nenhum emblema ainda.\nContinue!', ru:'Пока нет значков.\nПродолжайте!');
  String get badge7Days => _s(en:'7-Day Hero', ko:'7일 달성', ja:'7日間達成', zhCN:'7天英雄', zhTW:'7天英雄', es:'Héroe de 7 días', de:'7-Tage-Held', pt:'Herói de 7 dias', ru:'Герой 7 дней');
  String get badge14Days => _s(en:'14-Day Master', ko:'14일 달성', ja:'14日間マスター', zhCN:'14天达人', zhTW:'14天達人', es:'Maestro de 14 días', de:'14-Tage-Meister', pt:'Mestre de 14 dias', ru:'Мастер 14 дней');
  String get badgeCompleted => _s(en:'Challenge Complete!', ko:'챌린지 완료!', ja:'チャレンジ達成！', zhCN:'挑战完成！', zhTW:'挑戰完成！', es:'¡Desafío completado!', de:'Challenge abgeschlossen!', pt:'Desafio concluído!', ru:'Вызов выполнен!');

  // ── Auth / Profile ─────────────────────────────────────────
  String get loginOrSignUp => _s(
    en: 'Log in / Sign up', ko: '로그인 / 회원가입',
    ja: 'ログイン / 新規登録', zhCN: '登录 / 注册', zhTW: '登入 / 註冊',
    es: 'Iniciar sesión / Registrarse', de: 'Anmelden / Registrieren',
    pt: 'Entrar / Registrar', ru: 'Войти / Зарегистрироваться',
  );
  String get selectProfileImage => _s(
    en: 'Select Profile Image', ko: '프로필 이미지 선택',
    ja: 'プロフィール画像を選択', zhCN: '选择头像', zhTW: '選擇頭像',
    es: 'Seleccionar imagen de perfil', de: 'Profilbild auswählen',
    pt: 'Selecionar imagem de perfil', ru: 'Выбрать фото профиля',
  );
  String get teamChallengeLoginRequired => _s(
    en: 'An account is required\nto use Team Challenge.',
    ko: '팀 챌린지를 이용하려면\n계정이 필요합니다.',
    ja: 'チームチャレンジを使用するには\nアカウントが必要です。',
    zhCN: '使用团队挑战需要账户。', zhTW: '使用團隊挑戰需要帳戶。',
    es: 'Se requiere una cuenta\npara usar el Desafío en equipo.',
    de: 'Für Team Challenge\nist ein Konto erforderlich.',
    pt: 'É necessária uma conta\npara usar o Desafio em equipe.',
    ru: 'Для использования командного вызова\nнеобходима учётная запись.',
  );
  String get signUpAction => _s(
    en: 'Sign Up', ko: '회원가입하기',
    ja: '新規登録する', zhCN: '注册', zhTW: '註冊',
    es: 'Registrarse', de: 'Registrieren',
    pt: 'Cadastrar', ru: 'Зарегистрироваться',
  );
  String get alreadyHaveAccountAction => _s(
    en: 'I already have an account', ko: '이미 계정이 있어요',
    ja: 'すでにアカウントがあります', zhCN: '我已有账户', zhTW: '我已有帳戶',
    es: 'Ya tengo una cuenta', de: 'Ich habe bereits ein Konto',
    pt: 'Já tenho uma conta', ru: 'У меня уже есть аккаунт',
  );
  String get emailVerificationRequired => _s(
    en: 'Email verification required. Please check your inbox.',
    ko: '이메일 인증이 필요합니다. 받은 편지함을 확인해주세요.',
    ja: 'メール認証が必要です。受信トレイを確認してください。',
    zhCN: '需要验证邮箱，请查看收件箱。', zhTW: '需要驗證信箱，請查看收件箱。',
    es: 'Se requiere verificación de correo. Comprueba tu bandeja de entrada.',
    de: 'E-Mail-Verifizierung erforderlich. Bitte prüfe deinen Posteingang.',
    pt: 'Verificação de e-mail necessária. Verifique sua caixa de entrada.',
    ru: 'Необходимо подтверждение email. Проверьте почту.',
  );

  // ── Landing Screen ──────────────────────────────────────────
  String get landingTagline => _s(
    en:'Build habits with Streakly challenges',
    ko:'Streakly 챌린지로 습관을 만들어보세요',
    ja:'Streaklyチャレンジで習慣を作ろう',
    zhCN:'用Streakly挑战养成习惯',
    zhTW:'用Streakly挑戰養成習慣',
    es:'Crea hábitos con los desafíos de Streakly',
    de:'Gewohnheiten mit Streakly-Challenges aufbauen',
    pt:'Crie hábitos com os desafios do Streakly',
    ru:'Создавайте привычки с вызовами Streakly',
  );
  String get signUp => _s(en:'Sign Up', ko:'회원가입', ja:'会員登録', zhCN:'注册', zhTW:'註冊', es:'Registrarse', de:'Registrieren', pt:'Cadastrar', ru:'Регистрация');
  String get signIn => _s(en:'Sign In', ko:'로그인', ja:'ログイン', zhCN:'登录', zhTW:'登入', es:'Iniciar sesión', de:'Anmelden', pt:'Entrar', ru:'Войти');
  String get continueAsGuest => _s(en:'Continue as Guest', ko:'게스트로 시작하기', ja:'ゲストとして始める', zhCN:'以访客身份继续', zhTW:'以訪客身份繼續', es:'Continuar como invitado', de:'Als Gast fortfahren', pt:'Continuar como convidado', ru:'Продолжить как гость');

  // ── Sign-In Screen ───────────────────────────────────────────
  String get signInWelcome => _s(en:'Welcome back!', ko:'다시 오셨군요!', ja:'おかえりなさい！', zhCN:'欢迎回来！', zhTW:'歡迎回來！', es:'¡Bienvenido de vuelta!', de:'Willkommen zurück!', pt:'Bem-vindo de volta!', ru:'С возвращением!');
  String get signInSubtitle => _s(en:'Sign in to continue your challenges', ko:'로그인하고 챌린지를 이어가세요', ja:'ログインしてチャレンジを続けよう', zhCN:'登录并继续您的挑战', zhTW:'登入並繼續您的挑戰', es:'Inicia sesión para continuar tus desafíos', de:'Melde dich an, um deine Challenges fortzusetzen', pt:'Entre para continuar seus desafios', ru:'Войдите, чтобы продолжить вызовы');
  String get emailLabel => _s(en:'Email', ko:'이메일', ja:'メール', zhCN:'邮箱', zhTW:'電子郵件', es:'Correo electrónico', de:'E-Mail', pt:'E-mail', ru:'Эл. почта');
  String get passwordLabel => _s(en:'Password', ko:'비밀번호', ja:'パスワード', zhCN:'密码', zhTW:'密碼', es:'Contraseña', de:'Passwort', pt:'Senha', ru:'Пароль');
  String get forgotPassword => _s(en:'Forgot your password?', ko:'비밀번호를 잊으셨나요?', ja:'パスワードをお忘れですか？', zhCN:'忘记密码？', zhTW:'忘記密碼？', es:'¿Olvidaste tu contraseña?', de:'Passwort vergessen?', pt:'Esqueceu a senha?', ru:'Забыли пароль?');
  String get orDivider => _s(en:'or', ko:'또는', ja:'または', zhCN:'或', zhTW:'或', es:'o', de:'oder', pt:'ou', ru:'или');
  String get continueWithApple => _s(en:'Continue with Apple', ko:'Apple로 계속하기', ja:'Appleで続ける', zhCN:'使用Apple继续', zhTW:'使用Apple繼續', es:'Continuar con Apple', de:'Mit Apple fortfahren', pt:'Continuar com Apple', ru:'Продолжить через Apple');
  String get continueWithGoogle => _s(en:'Continue with Google', ko:'Google로 계속하기', ja:'Googleで続ける', zhCN:'使用Google继续', zhTW:'使用Google繼續', es:'Continuar con Google', de:'Mit Google fortfahren', pt:'Continuar com Google', ru:'Продолжить через Google');
  String get noAccountQuestion => _s(en:"Don't have an account?", ko:'계정이 없으신가요?', ja:'アカウントをお持ちでないですか？', zhCN:'还没有账户？', zhTW:'還沒有帳戶？', es:'¿No tienes una cuenta?', de:'Kein Konto?', pt:'Não tem uma conta?', ru:'Нет аккаунта?');
  String get resendConfirmEmail => _s(en:'Resend Confirmation Email', ko:'인증 메일 재발송', ja:'認証メールを再送', zhCN:'重新发送验证邮件', zhTW:'重新傳送驗證郵件', es:'Reenviar correo de confirmación', de:'Bestätigungs-E-Mail erneut senden', pt:'Reenviar e-mail de confirmação', ru:'Отправить письмо повторно');
  String get emailRequired => _s(en:'Please enter your email', ko:'이메일을 입력해주세요', ja:'メールアドレスを入力してください', zhCN:'请输入邮箱', zhTW:'請輸入電子郵件', es:'Por favor ingresa tu correo', de:'Bitte E-Mail eingeben', pt:'Por favor insira seu e-mail', ru:'Пожалуйста, введите e-mail');
  String get emailInvalid => _s(en:'Invalid email format', ko:'올바른 이메일 형식이 아닙니다', ja:'正しいメール形式ではありません', zhCN:'邮箱格式不正确', zhTW:'電子郵件格式不正確', es:'Formato de correo no válido', de:'Ungültiges E-Mail-Format', pt:'Formato de e-mail inválido', ru:'Неверный формат e-mail');
  String get passwordRequired => _s(en:'Please enter your password', ko:'비밀번호를 입력해주세요', ja:'パスワードを入力してください', zhCN:'请输入密码', zhTW:'請輸入密碼', es:'Por favor ingresa tu contraseña', de:'Bitte Passwort eingeben', pt:'Por favor insira sua senha', ru:'Пожалуйста, введите пароль');
  String get migrationError => _s(en:'Error during data migration:', ko:'데이터 이전 중 문제가 발생했습니다:', ja:'データ移行中にエラーが発生しました：', zhCN:'数据迁移时出错：', zhTW:'資料遷移時出錯：', es:'Error durante la migración de datos:', de:'Fehler bei der Datenmigration:', pt:'Erro durante a migração de dados:', ru:'Ошибка при миграции данных:');

  // ── Sign-Up Screen ───────────────────────────────────────────
  String get signUpTitle => _s(en:"Let's get started!", ko:'시작해볼까요?', ja:'さあ、始めましょう！', zhCN:'开始吧！', zhTW:'開始吧！', es:'¡Empecemos!', de:'Legen wir los!', pt:'Vamos começar!', ru:'Начнём!');
  String get signUpSubtitle => _s(en:'Create an account and start your challenges', ko:'계정을 만들고 챌린지를 시작하세요', ja:'アカウントを作成してチャレンジを始めよう', zhCN:'创建账户并开始挑战', zhTW:'建立帳戶並開始挑戰', es:'Crea una cuenta y comienza tus desafíos', de:'Erstelle ein Konto und starte deine Challenges', pt:'Crie uma conta e comece seus desafios', ru:'Создайте аккаунт и начните вызовы');
  String get nicknameLabel => _s(en:'Nickname', ko:'닉네임', ja:'ニックネーム', zhCN:'昵称', zhTW:'暱稱', es:'Apodo', de:'Spitzname', pt:'Apelido', ru:'Псевдоним');
  String get nicknameHint => _s(en:'Enter your display name', ko:'표시될 이름을 입력하세요', ja:'表示名を入力してください', zhCN:'输入显示名称', zhTW:'輸入顯示名稱', es:'Ingresa el nombre a mostrar', de:'Anzeigenamen eingeben', pt:'Digite o nome de exibição', ru:'Введите отображаемое имя');
  String get passwordWithMin => _s(en:'Password (8+ characters)', ko:'비밀번호 (8자 이상)', ja:'パスワード（8文字以上）', zhCN:'密码（8个字符以上）', zhTW:'密碼（8個字元以上）', es:'Contraseña (mínimo 8 caracteres)', de:'Passwort (mind. 8 Zeichen)', pt:'Senha (mínimo 8 caracteres)', ru:'Пароль (от 8 символов)');
  String get confirmPasswordLabel => _s(en:'Confirm Password', ko:'비밀번호 확인', ja:'パスワード確認', zhCN:'确认密码', zhTW:'確認密碼', es:'Confirmar contraseña', de:'Passwort bestätigen', pt:'Confirmar senha', ru:'Подтвердите пароль');
  String get alreadyHaveAccount => _s(en:'Already have an account?', ko:'이미 계정이 있으신가요?', ja:'既にアカウントをお持ちですか？', zhCN:'已有账户？', zhTW:'已有帳戶？', es:'¿Ya tienes una cuenta?', de:'Schon ein Konto?', pt:'Já tem uma conta?', ru:'Уже есть аккаунт?');
  String get nicknameRequired => _s(en:'Please enter a nickname', ko:'닉네임을 입력해주세요', ja:'ニックネームを入力してください', zhCN:'请输入昵称', zhTW:'請輸入暱稱', es:'Por favor ingresa un apodo', de:'Bitte Spitznamen eingeben', pt:'Por favor insira um apelido', ru:'Пожалуйста, введите псевдоним');
  String get passwordMinLength => _s(en:'Password must be at least 8 characters', ko:'비밀번호는 8자 이상이어야 합니다', ja:'パスワードは8文字以上必要です', zhCN:'密码至少需要8个字符', zhTW:'密碼至少需要8個字元', es:'La contraseña debe tener al menos 8 caracteres', de:'Das Passwort muss mindestens 8 Zeichen haben', pt:'A senha deve ter pelo menos 8 caracteres', ru:'Пароль должен быть не менее 8 символов');
  String get passwordMismatch => _s(en:'Passwords do not match', ko:'비밀번호가 일치하지 않습니다', ja:'パスワードが一致しません', zhCN:'密码不匹配', zhTW:'密碼不匹配', es:'Las contraseñas no coinciden', de:'Passwörter stimmen nicht überein', pt:'As senhas não coincidem', ru:'Пароли не совпадают');

  // ── Forgot Password Screen ───────────────────────────────────
  String get forgotPasswordTitle => _s(en:'Reset Password', ko:'비밀번호 재설정', ja:'パスワードリセット', zhCN:'重置密码', zhTW:'重設密碼', es:'Restablecer contraseña', de:'Passwort zurücksetzen', pt:'Redefinir senha', ru:'Сброс пароля');
  String get forgotPasswordSubtitle => _s(
    en:'Enter your email and we\'ll send you a reset link.',
    ko:'가입하신 이메일 주소를 입력하시면\n비밀번호 재설정 링크를 보내드립니다.',
    ja:'メールアドレスを入力するとリセットリンクをお送りします。',
    zhCN:'输入您的邮箱，我们将发送重置链接。',
    zhTW:'輸入您的電子郵件，我們將發送重設連結。',
    es:'Ingresa tu correo y te enviaremos un enlace de restablecimiento.',
    de:'Gib deine E-Mail ein und wir senden dir einen Reset-Link.',
    pt:'Insira seu e-mail e enviaremos um link de redefinição.',
    ru:'Введите e-mail, и мы отправим ссылку для сброса.',
  );
  String get sendResetEmail => _s(en:'Send Reset Email', ko:'재설정 메일 보내기', ja:'リセットメールを送る', zhCN:'发送重置邮件', zhTW:'傳送重設郵件', es:'Enviar correo de restablecimiento', de:'Reset-E-Mail senden', pt:'Enviar e-mail de redefinição', ru:'Отправить письмо для сброса');
  String get emailSentTitle => _s(en:'Email sent!', ko:'메일을 보냈어요!', ja:'メールを送りました！', zhCN:'邮件已发送！', zhTW:'郵件已傳送！', es:'¡Correo enviado!', de:'E-Mail gesendet!', pt:'E-mail enviado!', ru:'Письмо отправлено!');
  String emailSentDesc(String email) => _s(
    en:'A reset link has been sent to $email.\nPlease also check your spam folder.',
    ko:'$email 으로\n비밀번호 재설정 링크를 보내드렸습니다.\n스팸 폴더도 확인해보세요.',
    ja:'$email に\nパスワードリセットリンクをお送りしました。\nスパムフォルダもご確認ください。',
    zhCN:'重置链接已发送至 $email。\n请同时检查您的垃圾邮件文件夹。',
    zhTW:'重設連結已傳送至 $email。\n請同時檢查您的垃圾郵件資料夾。',
    es:'Se ha enviado un enlace de restablecimiento a $email.\nRevisa también tu carpeta de spam.',
    de:'Ein Reset-Link wurde an $email gesendet.\nBitte auch den Spam-Ordner prüfen.',
    pt:'Um link de redefinição foi enviado para $email.\nVerifique também sua pasta de spam.',
    ru:'Ссылка для сброса отправлена на $email.\nПроверьте также папку со спамом.',
  );
  String get backToSignIn => _s(en:'Back to Sign In', ko:'로그인으로 돌아가기', ja:'ログインに戻る', zhCN:'返回登录', zhTW:'返回登入', es:'Volver a iniciar sesión', de:'Zurück zur Anmeldung', pt:'Voltar ao login', ru:'Вернуться ко входу');
  String get deleteAccount => _s(en:'Delete Account', ko:'계정삭제', ja:'アカウント削除', zhCN:'注销账户', zhTW:'刪除帳戶', es:'Eliminar cuenta', de:'Konto löschen', pt:'Excluir conta', ru:'Удалить аккаунт');
  String get deleteAccountConfirm => _s(
    en:'All your data will be permanently deleted and cannot be recovered. Are you sure you want to delete your account?',
    ko:'모든 데이터가 영구적으로 삭제되며 복구할 수 없습니다. 정말로 계정을 삭제하시겠어요?',
    ja:'すべてのデータが完全に削除され、復元できません。本当にアカウントを削除しますか？',
    zhCN:'所有数据将被永久删除，无法恢复。确定要注销账户吗？',
    zhTW:'所有資料將被永久刪除，無法復原。確定要刪除帳戶嗎？',
    es:'Todos tus datos serán eliminados permanentemente y no podrán recuperarse. ¿Seguro que quieres eliminar tu cuenta?',
    de:'Alle deine Daten werden dauerhaft gelöscht und können nicht wiederhergestellt werden. Möchtest du dein Konto wirklich löschen?',
    pt:'Todos os seus dados serão excluídos permanentemente e não poderão ser recuperados. Tem certeza que deseja excluir sua conta?',
    ru:'Все ваши данные будут удалены навсегда и не могут быть восстановлены. Вы уверены, что хотите удалить аккаунт?',
  );

  // ── Profile Image Labels ─────────────────────────────────
  List<String> get profileImageLabels => [
    _s(en:'Energy',      ko:'에너지',  ja:'エネルギー', zhCN:'能量',  zhTW:'能量',  es:'Energía',        de:'Energie',          pt:'Energia',    ru:'Энергия'),
    _s(en:'Achievement', ko:'성취',    ja:'達成',       zhCN:'成就',  zhTW:'成就',  es:'Logro',          de:'Leistung',         pt:'Conquista',  ru:'Достижение'),
    _s(en:'Goal',        ko:'목표',    ja:'目標',       zhCN:'目标',  zhTW:'目標',  es:'Meta',           de:'Ziel',             pt:'Meta',       ru:'Цель'),
    _s(en:'Value',       ko:'가치',    ja:'価値',       zhCN:'价值',  zhTW:'價值',  es:'Valor',          de:'Wert',             pt:'Valor',      ru:'Ценность'),
    _s(en:'Challenge',   ko:'도전',    ja:'挑戦',       zhCN:'挑战',  zhTW:'挑戰',  es:'Desafío',        de:'Herausforderung',  pt:'Desafio',    ru:'Вызов'),
    _s(en:'Growth',      ko:'성장',    ja:'成長',       zhCN:'成长',  zhTW:'成長',  es:'Crecimiento',    de:'Wachstum',         pt:'Crescimento',ru:'Рост'),
    _s(en:'Shine',       ko:'빛남',    ja:'輝き',       zhCN:'闪耀',  zhTW:'閃耀',  es:'Brillo',         de:'Glanz',            pt:'Brilho',     ru:'Сияние'),
    _s(en:'Overcome',    ko:'극복',    ja:'克服',       zhCN:'克服',  zhTW:'克服',  es:'Superar',        de:'Überwinden',       pt:'Superar',    ru:'Преодоление'),
  ];
}
