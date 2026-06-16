class AppStrings {
  final String language;
  const AppStrings._(this.language);
  static AppStrings of(String language) => AppStrings._(language);
  String get langCode {
    switch (language) {
      case 'Korean':            return 'ko';
      case 'Japanese':          return 'ja';
      case 'Spanish':           return 'es';
      default:                  return 'en';
    }
  }
  String _s({
    required String en,
    required String ko,
    required String ja,
    required String es,
  }) {
    switch (language) {
      case 'Korean':           return ko;
      case 'Japanese':         return ja;
      case 'Spanish':          return es;
      default:                 return en;
    }
  }
  // ── Challenge Mode ───────────────────────────────────────────
  String get singleChallenge => _s(en:'Solo Challenge', ko:'싱글 챌린지', ja:'ソロチャレンジ', es:'Desafío individual');
  String get multiChallenge => _s(en:'Team Challenge', ko:'팀 챌린지', ja:'チームチャレンジ', es:'Desafío en equipo');
  String get premiumLabel => _s(en:'PRO', ko:'PRO', ja:'PRO', es:'PRO');
  String get multiChallengeTeaser => _s(
    en:'Team Challenge is coming soon!\nCompete and grow together with friends.',
    ko:'팀 챌린지가 곧 출시됩니다!\n친구들과 함께 경쟁하고 성장해보세요.',
    ja:'チームチャレンジが近日公開！\n友達と一緒に競い合い、成長しよう。',
    es:'¡El desafío en equipo llega pronto!\nCompite y crece junto a tus amigos.',
  );
  // ── Bottom Nav ──────────────────────────────────────────────
  String get navHome => _s(en:'Home', ko:'홈', ja:'ホーム', es:'Inicio');
  String get navChallenges => _s(en:'Challenges', ko:'챌린지', ja:'チャレンジ', es:'Desafíos');
  String get navRecords => _s(en:'Records', ko:'기록', ja:'記録', es:'Registros');
  String get navSettings => _s(en:'Profile', ko:'프로필', ja:'プロフィール', es:'Perfil');
  // ── Common ───────────────────────────────────────────────────
  String get cancel => _s(en:'Cancel', ko:'취소', ja:'キャンセル', es:'Cancelar');
  String get save => _s(en:'Save', ko:'저장', ja:'保存', es:'Guardar');
  String get delete => _s(en:'Delete', ko:'삭제', ja:'削除', es:'Eliminar');
  String get ok => _s(en:'OK', ko:'확인', ja:'OK', es:'Aceptar');
  String get recoverStreak => _s(en:'Recover Streak', ko:'스트릭 복구', ja:'ストリーク回復', es:'Recuperar racha');
  // ── Pause Ticket ─────────────────────────────────────────────
  String get pauseTicketButton => _s(en:'Use Pause Ticket', ko:'정지권 사용', ja:'一時停止チケット使用', es:'Usar ticket de pausa');
  String get pauseTicketTitle => _s(en:'Challenge Pause Ticket', ko:'챌린지 정지권', ja:'チャレンジ一時停止チケット', es:'Ticket de pausa');
  String get pauseTicketDesc => _s(
    en:'During the selected period, your streak will not break even if you miss a day.\n\nIdeal for vacations or special occasions.\n\n₩1,900',
    ko:'선택한 기간 동안 루틴을 수행하지 않아도 스트릭이 끊기지 않습니다.\n\n휴가나 경조사 등 부득이한 상황에 사용하세요.\n\n₩1,900',
    ja:'選択した期間中はルーティンをこなさなくてもストリークが途切れません。\n\n休暇や特別な行事の際にご利用ください。\n\n₩1,900',
    es:'Durante el período seleccionado, tu racha no se romperá aunque faltes un día.\n\nIdeal para vacaciones u ocasiones especiales.\n\n₩1,900',
  );
  String get pauseTicketBuy => _s(en:'Buy (₩1,900)', ko:'구매하기 (₩1,900)', ja:'購入する (₩1,900)', es:'Comprar (₩1,900)');
  String get pauseActivated => _s(en:'Pause ticket applied!', ko:'정지권이 적용되었습니다!', ja:'一時停止チケットが適用されました！', es:'¡Ticket de pausa aplicado!');
  String get pauseActive => _s(en:'Paused', ko:'일시정지 중', ja:'一時停止中', es:'En pausa');
  String pauseActiveUntil(String date) => _s(en:'Until $date', ko:'$date 까지', ja:'$date まで', es:'Hasta $date');
  String get pauseAlreadyActive => _s(en:'A pause is already active for this challenge.', ko:'이미 정지권이 적용 중입니다.', ja:'すでに一時停止が適用されています。', es:'Ya hay una pausa activa para este reto.');
  String get pauseSelectPeriod => _s(en:'Select Pause Period', ko:'정지 기간 선택', ja:'一時停止期間を選択', es:'Seleccionar período de pausa');
  String get pauseCancel => _s(en:'End Pause', ko:'정지 해제', ja:'一時停止を解除', es:'Cancelar pausa');
  String get pauseCancelConfirmTitle => _s(en:'End Pause?', ko:'정지를 해제할까요?', ja:'一時停止を解除しますか？', es:'¿Cancelar pausa?');
  String get pauseCancelConfirmBody => _s(en:'The pause will end immediately. No refund will be issued.', ko:'정지권이 즉시 해제됩니다. 환불은 제공되지 않습니다.', ja:'一時停止をすぐに解除します。返金はされません。', es:'La pausa finalizará de inmediato. No se realizará ningún reembolso.');
  String get pauseCancelled => _s(en:'Pause ended.', ko:'정지가 해제되었습니다.', ja:'一時停止が解除されました。', es:'Pausa cancelada.');
  String get recoverStreakHint => _s(en:'You can recover a streak!', ko:'복구할 수 있는 스트릭이 있어요!', ja:'回復できるストリークがあります！', es:'¡Puedes recuperar una racha!');
  String get recoverStreakCost => _s(en:'Costs 3 Willpower', ko:'의지력 3 소모', ja:'意志力3消費', es:'Cuesta 3 fuerza de voluntad');
  String get recoverStreakConfirmTitle => _s(en:'Recover Streak?', ko:'스트릭을 복구할까요?', ja:'ストリークを回復しますか？', es:'¿Recuperar racha?');
  String get recoverStreakConfirmBody => _s(en:'Watch a short ad to recover yesterday\'s streak.', ko:'짧은 광고를 시청하면 어제의 스트릭을 복구할 수 있습니다.', ja:'短い広告を見ると昨日のストリークを回復できます。', es:'Mira un anuncio corto para recuperar la racha de ayer.');
  String get adNotReady => _s(en:'Ad not ready. Please try again shortly.', ko:'광고를 불러오는 중입니다. 잠시 후 다시 시도해주세요.', ja:'広告を読み込んでいます。少し後にお試しください。', es:'Anuncio no listo. Inténtalo de nuevo en breve.');
  String get streakRecovered => _s(en:'Streak Recovered!', ko:'스트릭이 복구되었습니다!', ja:'ストリーク回復完了！', es:'¡Racha recuperada!');
  String get notEnoughWillpower => _s(en:'Not enough Willpower', ko:'의지력이 부족합니다', ja:'意志力が不足しています', es:'Fuerza de voluntad insuficiente');
  String get createChallenge => _s(en:'Create Challenge', ko:'챌린지 만들기', ja:'チャレンジを作成', es:'Crear desafío');
  // ── Badge ────────────────────────────────────────────────────
  String get badgeUnlockTitle => _s(en:'🎉 Badge Unlocked!', ko:'🎉 배지 획득!', ja:'🎉 バッジ獲得！', es:'🎉 ¡Insignia desbloqueada!');
  String get badgeCollectionTitle => _s(en:'Badge Collection', ko:'배지 컬렉션', ja:'バッジコレクション', es:'Colección de insignias');
  String get badgeEarnedSection => _s(en:'Earned Badges', ko:'획득한 배지', ja:'獲得済みバッジ', es:'Insignias obtenidas');
  String get badgeSecretCondition => _s(en:'Condition is hidden.', ko:'조건이 숨겨져 있습니다.', ja:'条件は非公開です。', es:'La condición está oculta.');
  String get badgeEarnedEmpty => _s(en:'No badges yet. Start checking in!', ko:'아직 획득한 배지가 없습니다. 체크인을 시작해보세요!', ja:'まだバッジがありません。チェックインしましょう！', es:'Sin insignias aún. ¡Empieza a registrarte!');
  String get badgeCategoryAll => _s(en:'All', ko:'전체', ja:'すべて', es:'Todo');
  String get badgeCategoryStreak => _s(en:'🔥 Streak', ko:'🔥 스트릭', ja:'🔥 ストリーク', es:'🔥 Racha');
  String get badgeCategoryCompletion => _s(en:'🏆 Completion', ko:'🏆 완주', ja:'🏆 完走', es:'🏆 Completado');
  String get badgeCategoryLogging => _s(en:'📝 Logging', ko:'📝 기록', ja:'📝 記録', es:'📝 Registro');
  String get badgeCategoryTiming => _s(en:'⏰ Timing', ko:'⏰ 타이밍', ja:'⏰ タイミング', es:'⏰ Timing');
  String get badgeCategorySubroutine => _s(en:'🧩 Subroutine', ko:'🧩 서브루틴', ja:'🧩 サブルーティン', es:'🧩 Subrutina');
  String get badgeCategoryTeam => _s(en:'👥 Team', ko:'👥 팀', ja:'👥 チーム', es:'👥 Equipo');
  String badgeEarnedOn(DateTime date) {
    final y = date.year, m = date.month, d = date.day;
    return _s(
      en: 'Earned ${_monthEn(m)} $d, $y',
      ko: '${y}년 ${m}월 ${d}일 획득',
      ja: '${y}年${m}月${d}日 獲得',
      es: 'Obtenido el $d/${m}/$y',
    );
  }
  static String _monthEn(int m) => const ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m-1];
  // ── Guest / Account ──────────────────────────────────────────
  String get guestDisplayName => _s(en:'Guest', ko:'게스트', ja:'ゲスト', es:'Invitado');
  String get deleteAccountFailed => _s(en:'Failed to delete account.', ko:'계정 삭제에 실패했습니다.', ja:'アカウントの削除に失敗しました。', es:'Error al eliminar la cuenta.');
  String get emailNotConfirmedError => _s(en:'Email verification required. Please check your inbox.', ko:'이메일 인증이 필요합니다. 받은 편지함을 확인해주세요.', ja:'メール認証が必要です。受信ボックスを確認してください。', es:'Se requiere verificación. Revisa tu correo.');
  String get appleLoginFailed => _s(en:'Apple login failed.', ko:'Apple 로그인에 실패했습니다.', ja:'Appleログインに失敗しました。', es:'Error al iniciar sesión con Apple.');
  String get appleLoginError => _s(en:'An error occurred during Apple login.', ko:'Apple 로그인 중 오류가 발생했습니다.', ja:'Appleログイン中にエラーが発生しました。', es:'Error durante el inicio de sesión con Apple.');
  String get googleLoginFailed => _s(en:'Google login failed.', ko:'Google 로그인에 실패했습니다.', ja:'Googleログインに失敗しました。', es:'Error al iniciar sesión con Google.');
  // ── Home Screen ──────────────────────────────────────────────
  String get todaysRoutines => _s(en:"Today's Routines", ko:'오늘의 루틴', ja:'今日のルーティン', es:'Rutinas de hoy');
  String doneCount(int done, int total) => _s(
    en:'Done $done/$total', ko:'완료 $done/$total', ja:'完了 $done/$total',
    es:'Hecho $done/$total',
  );
  String get startFirstChallenge => _s(
    en:'Start Your First Challenge!', ko:'첫 번째 챌린지를 시작해보세요!', ja:'最初のチャレンジを始めましょう！',
    es:'¡Empieza tu primer desafío!',
  );
  String get todayRestDay => _s(
    en:'Rest day today 🎉', ko:'오늘은 쉬는 날이에요 🎉', ja:'今日は休息日です 🎉',
    es:'¡Hoy es día de descanso! 🎉',
  );
  String get todayRestDayDesc => _s(
    en:'No challenges scheduled for today.', ko:'오늘 예정된 챌린지가 없어요.', ja:'今日予定されているチャレンジはありません。',
    es:'No hay desafíos programados para hoy.',
  );
  String get habitMethodDesc => _s(
    en:'Build habits through consistency', ko:'꾸준함으로 습관을 만들어보세요.', ja:'継続することで習慣を作ろう',
    es:'Crea hábitos a través de la constancia',
  );
  String get weeklyCompletion => _s(en:'Weekly Completion', ko:'주간 완료율', ja:'週間達成率', es:'Completado semanal');
  String get badgesEarned => _s(en:'Badges Earned', ko:'획득 배지', ja:'獲得バッジ', es:'Insignias obtenidas');
  // ── Streak Card ──────────────────────────────────────────────
  String daysOnFire(int days) => _s(
    en:'$days Days On Fire!', ko:'${days}일 연속 달성!', ja:'${days}日連続達成！',
    es:'¡$days días en racha!',
  );
  String get currentStreak => _s(en:'Current Streak', ko:'현재 스트릭', ja:'現在のストリーク', es:'Racha actual');
  String get willpower => _s(en:'Willpower', ko:'의지력', ja:'意志力', es:'Fuerza de voluntad');
  String get myWillpower => _s(en:'My Willpower', ko:'나의 의지력', ja:'私の意志力', es:'Mi fuerza de voluntad');
  String get todayWillpowerLabel => _s(en:"Today's Gain", ko:'오늘의 의지력', ja:'今日の意志力', es:'Ganancia hoy');
  String get willpowerSubtitle => _s(en:'Cumulative Score', ko:'누적 달성 점수', ja:'累計達成スコア', es:'Puntuación acumulada');
  String challengePoints(int n) => _s(en:'+$n pts', ko:'+${n}점', ja:'+${n}点', es:'+$n pts');
  String get tierSeed     => _s(en:'Seed',     ko:'씨앗', ja:'種', es:'Semilla');
  String get tierSprout   => _s(en:'Sprout',   ko:'새싹', ja:'芽', es:'Brote');
  String get tierGrowth   => _s(en:'Growth',   ko:'성장', ja:'成長', es:'Crecimiento');
  String get tierFruition => _s(en:'Fruition', ko:'결실', ja:'結実', es:'Fruto');
  String get tierLegend   => _s(en:'Legend',   ko:'전설', ja:'伝説', es:'Leyenda');
  // ── Challenge Screen ─────────────────────────────────────────
  String get challengeTab => _s(en:'Challenge', ko:'챌린지', ja:'チャレンジ', es:'Desafío');
  String get noActiveChallenge => _s(en:'No Active Challenge', ko:'진행 중인 챌린지 없음', ja:'進行中のチャレンジなし', es:'Sin desafío activo');
  String get noActiveChallengeDesc => _s(
    en:'Create your first challenge to get started', ko:'챌린지를 만들어 시작하세요', ja:'チャレンジを作成して始めましょう',
    es:'Crea tu primer desafío para empezar',
  );
  String get progress => _s(en:'Progress', ko:'진행도', ja:'進捗', es:'Progreso');
  String daysProgress(int done, int total) => _s(
    en:'$done of $total Days', ko:'${total}일 중 ${done}일 완료', ja:'${total}日中${done}日完了',
    es:'$done de $total días',
  );
  String dayStreak(int days) => _s(
    en:'$days Day Streak! 🔥', ko:'${days}일 연속! 🔥', ja:'${days}日連続！🔥',
    es:'¡Racha de $days días! 🔥',
  );
  String daysChallenge(int days) => _s(
    en:'$days-Days Challenge', ko:'${days}일 챌린지', ja:'${days}日間チャレンジ',
    es:'Desafío de $days días',
  );
  String get subRoutines => _s(en:'Sub-routines', ko:'서브 루틴', ja:'サブルーティン', es:'Sub-rutinas');
  String get notesMotivation => _s(en:'Notes & Motivation', ko:'메모 & 동기부여', ja:'メモ＆モチベーション', es:'Notas y motivación');
  String get dailyLogs => _s(en:'Daily Logs', ko:'데일리 로그', ja:'デイリーログ', es:'Registros diarios');
  String entriesCount(int count) => _s(
    en:'$count entries', ko:'${count}개 기록', ja:'${count}件の記録',
    es:'$count entradas',
  );
  String get noLogsYet => _s(en:'No logs yet', ko:'아직 기록이 없어요', ja:'まだ記録がありません', es:'Aún no hay registros');
  String get shareThoughtButton => _s(
    en:'Share your thought for today', ko:'오늘의 생각 기록하기', ja:'今日の気持ちを記録する',
    es:'Comparte tu pensamiento de hoy',
  );
  String get shareThoughtTitle => _s(en:'Share Your Thought', ko:'오늘의 생각', ja:'今日の気持ち', es:'Tu pensamiento');
  String get shareThoughtHint => _s(en:'How did today go?', ko:'오늘 하루 어땠나요?', ja:'今日はどうでしたか？', es:'¿Cómo fue hoy?');
  String get deleteChallenge => _s(en:'Delete Challenge', ko:'챌린지 삭제', ja:'チャレンジを削除', es:'Eliminar desafío');
  String get deleteChallengeConfirm => _s(
    en:'Deleting this challenge will erase all records. Are you sure?',
    ko:'챌린지를 삭제하면 모든 기록이 사라집니다. 정말 삭제할까요?',
    ja:'このチャレンジを削除すると、すべての記録が失われます。本当に削除しますか？',
    es:'Eliminar este desafío borrará todos los registros. ¿Estás seguro?',
  );
  // ── New Challenge Screen ─────────────────────────────────────
  String get newChallenge => _s(en:'New Challenge', ko:'새 챌린지', ja:'新しいチャレンジ', es:'Nuevo desafío');
  String get mainRoutineLabel => _s(en:'MAIN ROUTINE', ko:'메인 루틴', ja:'メインルーティン', es:'RUTINA PRINCIPAL');
  String get subRoutineLabel => _s(en:'SUB ROUTINE (OPTIONAL)', ko:'서브 루틴 (선택사항)', ja:'サブルーティン（任意）', es:'SUB-RUTINA (OPCIONAL)');
  String get addSubRoutine => _s(en:'Add Sub-routine', ko:'서브 루틴 추가', ja:'サブルーティンを追加', es:'Añadir sub-rutina');
  String get targetDaysLabel => _s(en:'TARGET DAYS', ko:'목표 일수', ja:'目標日数', es:'DÍAS OBJETIVO');
  String get sevenDays => _s(en:'7 Days', ko:'7일', ja:'7日間', es:'7d');
  String get fourteenDays => _s(en:'14 Days', ko:'14일', ja:'14日間', es:'14d');
  String get twentyOneDays => _s(en:'21 Days', ko:'21일', ja:'21日間', es:'21d');
  String get custom => _s(en:'Custom', ko:'직접 입력', ja:'カスタム', es:'Personalizado');
  String get enterDaysHint => _s(en:'Enter number of days', ko:'일수를 입력하세요', ja:'日数を入力してください', es:'Ingresa el número de días');
  String get reminderTimeLabel => _s(en:'REMINDER TIME', ko:'알림 시간', ja:'リマインダー時刻', es:'HORA DE RECORDATORIO');
  String get reminderDisabledHint => _s(
    en:'Disabled — sub-routine alert times are set',
    ko:'비활성화 — 서브루틴 알림 시간이 설정되어 있어요',
    ja:'無効 — サブルーティンの通知時刻が設定されています',
    es:'Desactivado — tiempos de sub-rutinas configurados',
  );
  String get repetitionLabel => _s(en:'REPETITION', ko:'반복 요일', ja:'繰り返し', es:'REPETICIÓN');
  String get notesLabel => _s(en:'NOTES & MOTIVATION', ko:'메모 & 동기부여', ja:'メモ＆モチベーション', es:'NOTAS Y MOTIVACIÓN');
  String get notesHint => _s(
    en:'Write your motivation here...', ko:'동기부여 문구를 작성해보세요...', ja:'モチベーションを書いてください...',
    es:'Escribe tu motivación aquí...',
  );
  String get startChallenge => _s(en:'Start Challenge ⚡', ko:'챌린지 시작 ⚡', ja:'チャレンジ開始 ⚡', es:'Iniciar desafío ⚡');
  String get mainRoutineEmpty => _s(
    en:'Please enter a main routine name', ko:'메인 루틴 이름을 입력해주세요', ja:'メインルーティン名を入力してください',
    es:'Por favor ingresa el nombre de la rutina principal',
  );
  String get invalidDays => _s(
    en:'Please enter valid number of days', ko:'유효한 일수를 입력해주세요', ja:'有効な日数を入力してください',
    es:'Por favor ingresa un número de días válido',
  );
  // ── Add Subroutine Modal ─────────────────────────────────────
  String get addSubRoutineTitle => _s(en:'Add Sub-routine', ko:'서브 루틴 추가', ja:'サブルーティンを追加', es:'Añadir sub-rutina');
  String get subRoutineNameLabel => _s(en:'SUB-ROUTINE NAME', ko:'서브 루틴 이름', ja:'サブルーティン名', es:'NOMBRE DE SUB-RUTINA');
  String get subRoutineNameHint => _s(en:'e.g., Morning Stretch', ko:'예) 아침 스트레칭', ja:'例：朝のストレッチ', es:'ej., Estiramiento matutino');
  String get notificationTimeLabel => _s(en:'NOTIFICATION TIME', ko:'알림 시간', ja:'通知時刻', es:'HORA DE NOTIFICACIÓN');
  String get alertOn => _s(en:'Alert ON', ko:'알림 ON', ja:'通知 ON', es:'Alerta ON');
  String get alertOff => _s(en:'Alert OFF', ko:'알림 OFF', ja:'通知 OFF', es:'Alerta OFF');
  String get subRoutineEmpty => _s(
    en:'Please enter a sub-routine name', ko:'서브 루틴 이름을 입력해주세요', ja:'サブルーティン名を入力してください',
    es:'Por favor ingresa el nombre de la sub-rutina',
  );
  String get proTip => _s(
    en:'Pro Tip: Breaking your routine into smaller steps makes it easier to stay consistent!',
    ko:'팁: 루틴을 작은 단계로 나누면 꾸준히 실천하기 더 쉬워져요!',
    ja:'ヒント：ルーティンを小さなステップに分けると、継続しやすくなります！',
    es:'Consejo: ¡Dividir tu rutina en pasos pequeños hace más fácil mantenerse constante!',
  );
  // ── Records Screen ───────────────────────────────────────────
  String get recordsTitle => _s(en:'Records', ko:'기록', ja:'記録', es:'Registros');
  String get habitBuilder => _s(en:'Habit Builder', ko:'습관 형성자', ja:'習慣形成者', es:'Constructor de hábitos');
  String get successLabel => _s(en:'SUCCESS', ko:'성공률', ja:'成功率', es:'ÉXITO');
  String get overallRate => _s(en:'Overall Rate', ko:'전체 성공률', ja:'全体達成率', es:'Tasa general');
  String get keepItUp => _s(
    en:'Keep it up! Consistency\nis the key to success.',
    ko:'계속 도전하세요! 꾸준함이\n성공의 열쇠예요.',
    ja:'続けましょう！継続こそが\n成功への鍵です。',
    es:'¡Sigue así! La constancia\nes la clave del éxito.',
  );
  String get totalStreaks => _s(en:'TOTAL STREAKS', ko:'총 스트릭', ja:'総ストリーク', es:'RACHAS TOTALES');
  String get totalStreaksInfo => _s(
    en:'Sum of current streak counts across all your active challenges.',
    ko:'모든 활성 챌린지의 현재 스트릭 합계입니다.',
    ja:'すべてのアクティブチャレンジの現在のストリーク合計です。',
    es:'Suma de las rachas actuales de todos tus desafíos activos.',
  );
  String get longestStreakLabel => _s(en:'LONGEST STREAK', ko:'최장 스트릭', ja:'最長ストリーク', es:'RACHA MÁS LARGA');
  String get longestStreakInfo => _s(
    en:'Your all-time personal best streak record across all challenges.',
    ko:'모든 챌린지를 통틀어 역대 가장 긴 스트릭 기록입니다.',
    ja:'すべてのチャレンジを通じた歴代最長ストリーク記録です。',
    es:'Tu récord histórico de racha más larga en todos los desafíos.',
  );
  String get streakRecoveryLabel => _s(en:'RECOVERIES', ko:'스트릭 복구', ja:'ストリーク回復', es:'RECUPERACIONES');
  String get streakRecoveryInfo => _s(
    en:'Total number of times you have recovered a streak by spending Willpower.',
    ko:'의지력을 사용해 스트릭을 복구한 총 횟수입니다.',
    ja:'意志力を使ってストリークを回復した合計回数です。',
    es:'Número total de veces que recuperaste una racha usando fuerza de voluntad.',
  );
  String get badgeCollectionInfo => _s(
    en:'Badges earned by achieving milestones and completing challenges.',
    ko:'챌린지 달성 및 완료로 획득한 배지 컬렉션입니다.',
    ja:'チャレンジの達成や完了で獲得したバッジのコレクションです。',
    es:'Insignias ganadas al alcanzar hitos y completar desafíos.',
  );
  String get completed => _s(en:'COMPLETED', ko:'완료', ja:'完了', es:'COMPLETADO');
  String get completedInfo => _s(
    en:'Total number of challenges you have successfully completed.',
    ko:'성공적으로 완료한 챌린지의 총 개수입니다.',
    ja:'正常に完了したチャレンジの総数です。',
    es:'Número total de desafíos que has completado con éxito.',
  );
  String get completedChallenges => _s(en:'Completed Challenges', ko:'완료된 챌린지', ja:'完了したチャレンジ', es:'Desafíos completados');
  String get noRecordsYet => _s(
    en:'Complete challenges to see your records here!',
    ko:'챌린지를 완료하면 여기서 기록을 확인할 수 있어요!',
    ja:'チャレンジを完了すると、ここに記録が表示されます！',
    es:'¡Completa desafíos para ver tus registros aquí!',
  );
  String get keepGoingRecords => _s(
    en:'Keep going! Your completed challenges will appear here.',
    ko:'계속 도전하세요! 완료된 챌린지가 여기에 표시됩니다.',
    ja:'頑張ってください！完了したチャレンジがここに表示されます。',
    es:'¡Sigue adelante! Tus desafíos completados aparecerán aquí.',
  );
  String challengeSummary(int days, int completedDays) => _s(
    en:'$days Days · $completedDays Completed', ko:'${days}일 · ${completedDays}일 완료', ja:'${days}日間 · ${completedDays}日完了',
    es:'$days días · $completedDays completados',
  );
  // ── Settings Screen ──────────────────────────────────────────
  String get resetApp => _s(en:'Reset App', ko:'앱 초기화', ja:'アプリをリセット', es:'Reiniciar app');
  String get resetAppConfirm => _s(
    en:'All challenges and data will be permanently deleted. This cannot be undone.',
    ko:'모든 챌린지와 데이터가 영구적으로 삭제됩니다. 이 작업은 되돌릴 수 없습니다.',
    ja:'すべてのチャレンジとデータが完全に削除されます。この操作は元に戻せません。',
    es:'Todos los desafíos y datos serán eliminados permanentemente. Esta acción no se puede deshacer.',
  );
  String get resetAppConfirm2 => _s(
    en:'⚠️ All server data will be permanently deleted and cannot be recovered.\n\nAre you absolutely sure?',
    ko:'⚠️ 서버에 저장된 모든 데이터가 영구적으로 삭제되며 복구할 수 없습니다.\n\n정말 초기화하시겠습니까?',
    ja:'⚠️ サーバーに保存されたすべてのデータが完全に削除され、復元できません。\n\n本当にリセットしますか？',
    es:'⚠️ Todos los datos almacenados en el servidor se eliminarán permanentemente y no se pueden recuperar.\n\n¿Estás absolutamente seguro?',
  );
  String get resetAppFinal => _s(en:'Yes, Delete Everything', ko:'네, 모두 삭제합니다', ja:'はい、すべて削除します', es:'Sí, eliminar todo');
  String get editName => _s(en:'Edit Name', ko:'이름 수정', ja:'名前を編集', es:'Editar nombre');
  String get nameHint => _s(en:'Enter your name', ko:'이름을 입력하세요', ja:'名前を入力', es:'Ingresa tu nombre');
  String get appSettings => _s(en:'App Settings', ko:'앱 설정', ja:'アプリ設定', es:'Ajustes de la app');
  String get appGuide => _s(en:'App Guide', ko:'앱 가이드', ja:'アプリガイド', es:'Guía de la app');
  String get legalInfo => _s(en:'Legal', ko:'법적 정보', ja:'法的情報', es:'Legal');
  String get accountSection => _s(en:'Account', ko:'계정', ja:'アカウント', es:'Cuenta');
  String get privacyPolicy => _s(en:'Privacy Policy', ko:'개인정보처리방침', ja:'プライバシーポリシー', es:'Política de privacidad');
  String get termsOfService => _s(en:'Terms of Service', ko:'이용약관', ja:'利用規約', es:'Términos de servicio');
  String get appVersion => _s(en:'Version', ko:'버전', ja:'バージョン', es:'Versión');
  // 앱 소개 — 항목 타이틀
  String get guideHowToUse => _s(en:'How to Use', ko:'사용법', ja:'使い方', es:'Cómo usar');
  String get guideCreateChallenge => _s(en:'Creating a Challenge', ko:'챌린지 만들기', ja:'チャレンジを作る', es:'Crear un reto');
  String get guideStreakSystem => _s(en:'Streak System', ko:'스트릭 시스템', ja:'ストリークシステム', es:'Sistema de racha');
  String get guideStreakRecovery => _s(en:'Streak Recovery', ko:'스트릭 복구', ja:'ストリーク回復', es:'Recuperación de racha');
  String get guideWillpower => _s(en:'Willpower & Level', ko:'의지력 & 레벨', ja:'意志力 & レベル', es:'Fuerza de voluntad y nivel');
  String get guideBadge => _s(en:'Badge System', ko:'배지 시스템', ja:'バッジシステム', es:'Sistema de insignias');
  String get guidePauseTicket => _s(en:'Pause Ticket', ko:'정지권', ja:'一時停止チケット', es:'Ticket de pausa');
  // 앱 소개 — 항목 설명
  String get guideHowToUseBody => _s(
    en:'Tap + to create a challenge and check off your routine every day. Complete all sub-routines to mark the day done. Check your progress on the Home screen.',
    ko:'+ 버튼으로 챌린지를 만들고 매일 루틴을 체크하세요. 서브루틴을 모두 완료하면 해당 날짜가 달성됩니다. 홈 화면에서 오늘의 진행 상황을 확인하세요.',
    ja:'＋ボタンでチャレンジを作り、毎日ルーティンをチェックしましょう。サブルーティンをすべて完了するとその日が達成されます。',
    es:'Toca + para crear un reto y marca tu rutina cada día. Completa todos los sub-retos para marcar el día como logrado.',
  );
  String get guideCreateChallengeBody => _s(
    en:'Set a target (7 / 14 / 21 days or custom), add sub-routines, choose repeat days, and set a reminder time. The challenge starts the day you create it.',
    ko:'목표 일수(7·14·21일 또는 직접 입력), 서브루틴, 반복 요일, 알림 시간을 설정할 수 있습니다. 챌린지는 만든 날부터 시작됩니다.',
    ja:'目標日数（7・14・21日またはカスタム）、サブルーティン、繰り返し曜日、通知時間を設定できます。チャレンジは作成日から始まります。',
    es:'Establece un objetivo (7/14/21 días o personalizado), añade sub-retos, elige días de repetición y configura un recordatorio. El reto empieza el día que lo creas.',
  );
  String get guideStreakSystemBody => _s(
    en:'Each day you complete your routine, your streak grows. Miss a day and it resets to 0. The Total Streaks on the Records screen shows the combined current streak across all challenges.',
    ko:'매일 루틴을 완료하면 스트릭이 1씩 쌓입니다. 하루라도 빠지면 0으로 초기화됩니다. 기록 화면의 총 스트릭은 모든 챌린지의 현재 스트릭 합계입니다.',
    ja:'毎日ルーティンを完了するとストリークが1増えます。1日でも欠かすとリセットされます。記録画面の総ストリークは全チャレンジの現在ストリーク合計です。',
    es:'Cada día que completas tu rutina, tu racha crece. Si fallas un día, vuelve a 0. Las Rachas Totales en Registros muestran la suma actual de todas las rachas.',
  );
  String get guideStreakRecoveryBody => _s(
    en:'If you miss yesterday\'s routine, a recovery button appears on the card. Spend 3 Willpower to restore the streak. Recovery is available once every 7 days per challenge.',
    ko:'어제 루틴을 빠뜨린 경우 카드 하단에 복구 버튼이 나타납니다. 의지력 3을 소모해 스트릭을 되살릴 수 있습니다. 챌린지당 7일에 한 번 사용 가능합니다.',
    ja:'昨日のルーティンを逃した場合、カード下部に回復ボタンが表示されます。意志力3を消費してストリークを復活させることができます。チャレンジごとに7日に1回使用可能です。',
    es:'Si te perdiste la rutina de ayer, aparece un botón de recuperación en la tarjeta. Gasta 3 de fuerza de voluntad para restaurar la racha. Disponible una vez cada 7 días por reto.',
  );
  String get guideWillpowerBody => _s(
    en:'You earn 1 Willpower for every day you complete a routine. Willpower never decreases and powers your level: Seed → Sprout → Growth → Fruition → Legend. Higher levels make streak recovery cheaper.',
    ko:'루틴을 완료할 때마다 의지력이 1 쌓입니다. 의지력은 절대 줄어들지 않으며 레벨을 높입니다: 씨앗 → 새싹 → 성장 → 결실 → 전설. 레벨이 높을수록 스트릭 복구에 쓸 여유가 생깁니다.',
    ja:'ルーティンを完了するたびに意志力が1増えます。意志力は絶対に減らず、レベルを上げます：種→芽→成長→実り→伝説。レベルが高いほどストリーク回復に使える余裕が生まれます。',
    es:'Ganas 1 de fuerza de voluntad por cada día que completas una rutina. Nunca disminuye y sube tu nivel: Semilla→Brote→Crecimiento→Fruto→Leyenda.',
  );
  String get guideBadgeBody => _s(
    en:'Earn badges by reaching milestones: completing streaks, finishing challenges, logging in at certain times, and more. Check your collection on the Records screen.',
    ko:'스트릭 달성, 챌린지 완료, 특정 시간대 로그인 등 다양한 조건을 달성하면 배지를 획득합니다. 기록 화면에서 획득한 배지와 미획득 배지를 모두 확인할 수 있습니다.',
    ja:'ストリーク達成、チャレンジ完了、特定時間帯のログインなど様々な条件でバッジを獲得できます。記録画面で確認できます。',
    es:'Gana insignias al alcanzar hitos: completar rachas, terminar retos, iniciar sesión en ciertos momentos y más. Consulta tu colección en la pantalla de Registros.',
  );
  String get languages => _s(en:'Languages', ko:'언어', ja:'言語', es:'Idiomas');
  String get notificationSettings => _s(en:'Notification Settings', ko:'알림 설정', ja:'通知設定', es:'Notificaciones');
  String get notificationPermissionDenied => _s(en:'Notification permission denied. Please enable it in Settings.', ko:'알림 권한이 거부되었습니다. 설정에서 허용해주세요.', ja:'通知の権限が拒否されました。設定から許可してください。', es:'Permiso de notificación denegado. Actívalo en Ajustes.');
  String get notificationPermissionDeniedTitle => _s(en:'Allow Notifications', ko:'알림 권한 필요', ja:'通知の許可が必要', es:'Permitir notificaciones');
  String get notificationPermissionDeniedBody => _s(en:'Notification permission is required. Go to Settings to enable it.', ko:'알림 권한이 필요합니다. 설정 앱에서 알림을 허용해주세요.', ja:'通知の権限が必要です。設定アプリから許可してください。', es:'Se requiere permiso. Ve a Ajustes para activarlo.');
  String get goToSettings => _s(en:'Go to Settings', ko:'설정으로 이동', ja:'設定を開く', es:'Ir a Ajustes');
  String get themeSettings => _s(en:'Theme Settings', ko:'테마 설정', ja:'テーマ設定', es:'Tema');
  String get darkMode => _s(en:'Dark Mode', ko:'다크 모드', ja:'ダークモード', es:'Modo oscuro');
  String get lightMode => _s(en:'Light Mode', ko:'라이트 모드', ja:'ライトモード', es:'Modo claro');
  String get teamChallengeSubscribe => _s(en:'Team Challenge Pro', ko:'팀 챌린지 구독', ja:'チームチャレンジPro', es:'Suscripción Team Challenge');
  String get teamChallengeSubscribeDesc => _s(
    en:'Subscribe to unlock Team Challenge mode\nand compete with friends.',
    ko:'팀 챌린지 모드를 구독하고\n친구들과 함께 경쟁해보세요.',
    ja:'チームチャレンジモードを購読して\n友達と競い合いましょう。',
    es:'Suscríbete al modo Team Challenge\ny compite con amigos.',
  );
  String get subscribeNow => _s(en:'Subscribe Now', ko:'지금 구독하기', ja:'今すぐ購読', es:'Suscribirse ahora');
  String get signOut => _s(en:'Sign Out', ko:'로그아웃', ja:'サインアウト', es:'Cerrar sesión');
  String get streaklyMember => _s(en:'Streakly Member', ko:'Streakly 멤버', ja:'Streaklyメンバー', es:'Miembro de Streakly');
  String get signOutConfirm => _s(
    en:'Are you sure you want to sign out? Your data will be preserved.',
    ko:'로그아웃하시겠어요? 기존 데이터는 그대로 보존됩니다.',
    ja:'サインアウトしますか？データはそのまま保持されます。',
    es:'¿Seguro que quieres cerrar sesión? Tus datos se conservarán.',
  );
  // ── Badge ───────────────────────────────────────────────────
  String get badgesTitle => _s(en:'My Badges', ko:'획득한 배지', ja:'獲得バッジ', es:'Mis insignias');
  String get noBadgesYet => _s(en:'No badges earned yet.\nKeep going!', ko:'아직 획득한 배지가 없어요.\n계속 도전해보세요!', ja:'まだバッジはありません。\n続けてみましょう！', es:'Sin insignias aún.\n¡Sigue así!');
  String get badge7Days => _s(en:'7-Day Hero', ko:'7일 달성', ja:'7日間達成', es:'Héroe de 7 días');
  String get badge14Days => _s(en:'14-Day Master', ko:'14일 달성', ja:'14日間マスター', es:'Maestro de 14 días');
  String get badgeCompleted => _s(en:'Challenge Complete!', ko:'챌린지 완료!', ja:'チャレンジ達成！', es:'¡Desafío completado!');
  // ── Auth / Profile ─────────────────────────────────────────
  String get loginOrSignUp => _s(
    en: 'Log in / Sign up', ko: '로그인 / 회원가입',
    ja: 'ログイン / 新規登録',
    es: 'Iniciar sesión / Registrarse',
  );
  String get selectProfileImage => _s(
    en: 'Select Profile Image', ko: '프로필 이미지 선택',
    ja: 'プロフィール画像を選択',
    es: 'Seleccionar imagen de perfil',
  );
  String get teamChallengeLoginRequired => _s(
    en: 'An account is required\nto use Team Challenge.',
    ko: '팀 챌린지를 이용하려면\n계정이 필요합니다.',
    ja: 'チームチャレンジを使用するには\nアカウントが必要です。',
    es: 'Se requiere una cuenta\npara usar el Desafío en equipo.',
  );
  String get signUpAction => _s(
    en: 'Sign Up', ko: '회원가입하기',
    ja: '新規登録する',
    es: 'Registrarse',
  );
  String get alreadyHaveAccountAction => _s(
    en: 'I already have an account', ko: '이미 계정이 있어요',
    ja: 'すでにアカウントがあります',
    es: 'Ya tengo una cuenta',
  );
  String get emailVerificationRequired => _s(
    en: 'Email verification required. Please check your inbox.',
    ko: '이메일 인증이 필요합니다. 받은 편지함을 확인해주세요.',
    ja: 'メール認証が必要です。受信トレイを確認してください。',
    es: 'Se requiere verificación de correo. Comprueba tu bandeja de entrada.',
  );
  // ── Landing Screen ──────────────────────────────────────────
  String get landingTagline => _s(
    en:'Build habits with Streakly challenges',
    ko:'Streakly 챌린지로 습관을 만들어보세요',
    ja:'Streaklyチャレンジで習慣を作ろう',
    es:'Crea hábitos con los desafíos de Streakly',
  );
  String get signUp => _s(en:'Sign Up', ko:'회원가입', ja:'会員登録', es:'Registrarse');
  String get signIn => _s(en:'Sign In', ko:'로그인', ja:'ログイン', es:'Iniciar sesión');
  String get continueAsGuest => _s(en:'Continue as Guest', ko:'게스트로 시작하기', ja:'ゲストとして始める', es:'Continuar como invitado');
  // ── Sign-In Screen ───────────────────────────────────────────
  String get signInWelcome => _s(en:'Welcome back!', ko:'다시 오셨군요!', ja:'おかえりなさい！', es:'¡Bienvenido de vuelta!');
  String get signInSubtitle => _s(en:'Sign in to continue your challenges', ko:'로그인하고 챌린지를 이어가세요', ja:'ログインしてチャレンジを続けよう', es:'Inicia sesión para continuar tus desafíos');
  String get emailLabel => _s(en:'Email', ko:'이메일', ja:'メール', es:'Correo electrónico');
  String get passwordLabel => _s(en:'Password', ko:'비밀번호', ja:'パスワード', es:'Contraseña');
  String get forgotPassword => _s(en:'Forgot your password?', ko:'비밀번호를 잊으셨나요?', ja:'パスワードをお忘れですか？', es:'¿Olvidaste tu contraseña?');
  String get orDivider => _s(en:'or', ko:'또는', ja:'または', es:'o');
  String get continueWithApple => _s(en:'Continue with Apple', ko:'Apple로 계속하기', ja:'Appleで続ける', es:'Continuar con Apple');
  String get continueWithGoogle => _s(en:'Continue with Google', ko:'Google로 계속하기', ja:'Googleで続ける', es:'Continuar con Google');
  String get noAccountQuestion => _s(en:"Don't have an account?", ko:'계정이 없으신가요?', ja:'アカウントをお持ちでないですか？', es:'¿No tienes una cuenta?');
  String get resendConfirmEmail => _s(en:'Resend Confirmation Email', ko:'인증 메일 재발송', ja:'認証メールを再送', es:'Reenviar correo de confirmación');
  String get emailRequired => _s(en:'Please enter your email', ko:'이메일을 입력해주세요', ja:'メールアドレスを入力してください', es:'Por favor ingresa tu correo');
  String get emailInvalid => _s(en:'Invalid email format', ko:'올바른 이메일 형식이 아닙니다', ja:'正しいメール形式ではありません', es:'Formato de correo no válido');
  String get passwordRequired => _s(en:'Please enter your password', ko:'비밀번호를 입력해주세요', ja:'パスワードを入力してください', es:'Por favor ingresa tu contraseña');
  String get migrationError => _s(en:'Error during data migration:', ko:'데이터 이전 중 문제가 발생했습니다:', ja:'データ移行中にエラーが発생しました：', es:'Error durante la migración de datos:');
  String get emailEnglishOnly => _s(en:'Email must be entered in English only.', ko:'이메일은 영문으로만 입력해주세요.', ja:'メールアドレスは英語で入力してください。', es:'El correo debe ingresarse solo en inglés.');
  String get mergeDialogTitle => _s(en:'Guest Data Found', ko:'게스트 데이터 발견', ja:'ゲストデータが見つかりました', es:'Datos de invitado encontrados');
  String mergeDialogBody(int count) => _s(
    en: 'You have $count challenge(s) created in guest mode. What would you like to do?',
    ko: '게스트 모드에서 만든 챌린지 ${count}개가 있습니다. 어떻게 처리하시겠습니까?',
    ja: 'ゲストモードで作成したチャレンジが${count}件あります。どうしますか？',
    es: 'Tienes $count desafío(s) creado(s) en modo invitado. ¿Qué deseas hacer?',
  );
  String get mergeDialogKeepServer => _s(en:'Keep existing data', ko:'기존 데이터 유지', ja:'既存データを保持', es:'Mantener datos existentes');
  String get mergeDialogMerge => _s(en:'Merge guest data', ko:'게스트 데이터 병합', ja:'ゲストデータを統合', es:'Combinar datos de invitado');
  String get keepServerConfirmTitle => _s(en:'Delete guest data?', ko:'게스트 데이터를 삭제할까요?', ja:'ゲストデータを削除しますか？', es:'¿Eliminar datos de invitado?');
  String get keepServerConfirmBody => _s(
    en: 'Guest mode data will be permanently deleted and only your existing account data will be loaded.',
    ko: '게스트 모드에서 기록된 데이터가 영구적으로 삭제되고, 기존 계정의 데이터만 불러옵니다.',
    ja: 'ゲストモードで記録したデータは完全に削除され、既存のアカウントデータのみが読み込まれます。',
    es: 'Los datos del modo invitado se eliminarán permanentemente y solo se cargarán los datos de tu cuenta existente.',
  );
  String get keepServerConfirmAction => _s(en:'Delete & keep account data', ko:'삭제하고 기존 데이터 유지', ja:'削除して既存データを保持', es:'Eliminar y mantener datos de cuenta');
  String get mergeConfirmTitle => _s(en:'Merge guest data?', ko:'게스트 데이터를 병합할까요?', ja:'ゲストデータを統合しますか？', es:'¿Combinar datos de invitado?');
  String get mergeConfirmBody => _s(
    en: 'Guest mode challenges will be added to your existing account data. Both datasets will coexist.',
    ko: '게스트 모드에서 만든 챌린지가 기존 계정 데이터에 추가됩니다. 두 데이터가 함께 유지됩니다.',
    ja: 'ゲストモードで作成したチャレンジが既存のアカウントデータに追加されます。両方のデータが保持されます。',
    es: 'Los desafíos del modo invitado se añadirán a los datos de tu cuenta existente. Ambos conjuntos de datos coexistirán.',
  );
  String get mergeConfirmAction => _s(en:'Merge', ko:'병합하기', ja:'統合する', es:'Combinar');
  // ── Sign-Up Screen ───────────────────────────────────────────
  String get signUpTitle => _s(en:"Let's get started!", ko:'시작해볼까요?', ja:'さあ、始めましょう！', es:'¡Empecemos!');
  String get signUpSubtitle => _s(en:'Create an account and start your challenges', ko:'계정을 만들고 챌린지를 시작하세요', ja:'アカウントを作成してチャレンジを始めよう', es:'Crea una cuenta y comienza tus desafíos');
  String get nicknameLabel => _s(en:'Nickname', ko:'닉네임', ja:'ニックネーム', es:'Apodo');
  String get nicknameHint => _s(en:'Enter your display name', ko:'표시될 이름을 입력하세요', ja:'表示名を入力してください', es:'Ingresa el nombre a mostrar');
  String get passwordWithMin => _s(en:'Password (8+ characters)', ko:'비밀번호 (8자 이상)', ja:'パスワード（8文字以上）', es:'Contraseña (mínimo 8 caracteres)');
  String get confirmPasswordLabel => _s(en:'Confirm Password', ko:'비밀번호 확인', ja:'パスワード確認', es:'Confirmar contraseña');
  String get alreadyHaveAccount => _s(en:'Already have an account?', ko:'이미 계정이 있으신가요?', ja:'既にアカウントをお持ちですか？', es:'¿Ya tienes una cuenta?');
  String get nicknameRequired => _s(en:'Please enter a nickname', ko:'닉네임을 입력해주세요', ja:'ニックネームを入力してください', es:'Por favor ingresa un apodo');
  String get passwordMinLength => _s(en:'Password must be at least 8 characters', ko:'비밀번호는 8자 이상이어야 합니다', ja:'パスワードは8文字以上必要です', es:'La contraseña debe tener al menos 8 caracteres');
  String get passwordMismatch => _s(en:'Passwords do not match', ko:'비밀번호가 일치하지 않습니다', ja:'パスワードが一致しません', es:'Las contraseñas no coinciden');
  // ── Forgot Password Screen ───────────────────────────────────
  String get forgotPasswordTitle => _s(en:'Reset Password', ko:'비밀번호 재설정', ja:'パスワードリセット', es:'Restablecer contraseña');
  String get forgotPasswordSubtitle => _s(
    en:'Enter your email and we\'ll send you a reset link.',
    ko:'가입하신 이메일 주소를 입력하시면\n비밀번호 재설정 링크를 보내드립니다.',
    ja:'メールアドレスを入力するとリセットリンクをお送りします。',
    es:'Ingresa tu correo y te enviaremos un enlace de restablecimiento.',
  );
  String get sendResetEmail => _s(en:'Send Reset Email', ko:'재설정 메일 보내기', ja:'リセットメールを送る', es:'Enviar correo de restablecimiento');
  String get emailSentTitle => _s(en:'Email sent!', ko:'메일을 보냈어요!', ja:'メールを送りました！', es:'¡Correo enviado!');
  String emailSentDesc(String email) => _s(
    en:'A reset link has been sent to $email.\nPlease also check your spam folder.',
    ko:'$email 으로\n비밀번호 재설정 링크를 보내드렸습니다.\n스팸 폴더도 확인해보세요.',
    ja:'$email に\nパスワードリセットリンクをお送りしました。\nスパムフォルダもご確認ください。',
    es:'Se ha enviado un enlace de restablecimiento a $email.\nRevisa también tu carpeta de spam.',
  );
  String get backToSignIn => _s(en:'Back to Sign In', ko:'로그인으로 돌아가기', ja:'ログインに戻る', es:'Volver a iniciar sesión');
  String get deleteAccount => _s(en:'Delete Account', ko:'계정삭제', ja:'アカウント削除', es:'Eliminar cuenta');
  String get deleteAccountConfirm => _s(
    en:'All your data will be permanently deleted and cannot be recovered. Are you sure you want to delete your account?',
    ko:'모든 데이터가 영구적으로 삭제되며 복구할 수 없습니다. 정말로 계정을 삭제하시겠어요?',
    ja:'すべてのデータが完全に削除され、復元できません。本当にアカウントを削除しますか？',
    es:'Todos tus datos serán eliminados permanentemente y no podrán recuperarse. ¿Seguro que quieres eliminar tu cuenta?',
  );
  // ── Profile Image Labels ─────────────────────────────────
  List<String> get profileImageLabels => [
    _s(en:'Energy',      ko:'에너지',  ja:'エネルギー',  es:'Energía'),
    _s(en:'Achievement', ko:'성취',    ja:'達成',  es:'Logro'),
    _s(en:'Goal',        ko:'목표',    ja:'目標',  es:'Meta'),
    _s(en:'Value',       ko:'가치',    ja:'価値',  es:'Valor'),
    _s(en:'Challenge',   ko:'도전',    ja:'挑戦',  es:'Desafío'),
    _s(en:'Growth',      ko:'성장',    ja:'成長',  es:'Crecimiento'),
    _s(en:'Shine',       ko:'빛남',    ja:'輝き',  es:'Brillo'),
    _s(en:'Overcome',    ko:'극복',    ja:'克服',  es:'Superar'),
  ];
}