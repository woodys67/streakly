class AppStrings {
  final String language;
  const AppStrings._(this.language);

  static AppStrings of(String language) => AppStrings._(language);

  String get langCode {
    switch (language) {
      case 'Korean':            return 'ko';
      case 'Japanese':          return 'ja';
      case 'ChineseSimplified': return 'zhCN';
      case 'ChineseTraditional':return 'zhCN';
      case 'Spanish':           return 'es';
      case 'German':            return 'de';
      case 'Portuguese':        return 'pt';
      case 'Russian':           return 'ru';
      default:                  return 'en';
    }
  }

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
  String get recoverStreak => _s(en:'Recover Streak', ko:'스트릭 복구', ja:'ストリーク回復', zhCN:'恢复连续', zhTW:'恢復連續', es:'Recuperar racha', de:'Serie wiederherstellen', pt:'Recuperar sequência', ru:'Восстановить серию');
  String get recoverStreakCost => _s(en:'Costs 3 Willpower', ko:'의지력 3 소모', ja:'意志力3消費', zhCN:'消耗3意志力', zhTW:'消耗3意志力', es:'Cuesta 3 fuerza de voluntad', de:'Kostet 3 Willenskraft', pt:'Custa 3 força de vontade', ru:'Стоит 3 силы воли');
  String get recoverStreakConfirmTitle => _s(en:'Recover Streak?', ko:'스트릭을 복구할까요?', ja:'ストリークを回復しますか？', zhCN:'恢复连续记录？', zhTW:'恢復連續記錄？', es:'¿Recuperar racha?', de:'Serie wiederherstellen?', pt:'Recuperar sequência?', ru:'Восстановить серию?');
  String get recoverStreakConfirmBody => _s(en:'Yesterday\'s streak will be restored by spending 3 Willpower.', ko:'의지력 3을 소모하여 어제의 스트릭을 복구합니다.', ja:'意志力3を消費して昨日のストリークを回復します。', zhCN:'消耗3意志力恢复昨天的连续记录。', zhTW:'消耗3意志力恢復昨天的連續記錄。', es:'Se restaurará la racha de ayer gastando 3 de fuerza de voluntad.', de:'Der gestrige Streak wird durch den Verbrauch von 3 Willenskraft wiederhergestellt.', pt:'A sequência de ontem será restaurada gastando 3 de força de vontade.', ru:'Вчерашняя серия будет восстановлена с расходом 3 силы воли.');
  String get streakRecovered => _s(en:'Streak Recovered!', ko:'스트릭이 복구되었습니다!', ja:'ストリーク回復完了！', zhCN:'连续记录已恢复！', zhTW:'連續記錄已恢復！', es:'¡Racha recuperada!', de:'Serie wiederhergestellt!', pt:'Sequência recuperada!', ru:'Серия восстановлена!');
  String get notEnoughWillpower => _s(en:'Not enough Willpower', ko:'의지력이 부족합니다', ja:'意志力が不足しています', zhCN:'意志力不足', zhTW:'意志力不足', es:'Fuerza de voluntad insuficiente', de:'Nicht genug Willenskraft', pt:'Força de vontade insuficiente', ru:'Недостаточно силы воли');
  String get createChallenge => _s(en:'Create Challenge', ko:'챌린지 만들기', ja:'チャレンジを作成', zhCN:'创建挑战', zhTW:'建立挑戰', es:'Crear desafío', de:'Challenge erstellen', pt:'Criar desafio', ru:'Создать вызов');

  // ── Badge ────────────────────────────────────────────────────
  String get badgeUnlockTitle => _s(en:'🎉 Badge Unlocked!', ko:'🎉 배지 획득!', ja:'🎉 バッジ獲得！', zhCN:'🎉 获得徽章！', zhTW:'🎉 獲得徽章！', es:'🎉 ¡Insignia desbloqueada!', de:'🎉 Abzeichen erhalten!', pt:'🎉 Emblema desbloqueado!', ru:'🎉 Значок получен!');
  String get badgeCollectionTitle => _s(en:'Badge Collection', ko:'배지 컬렉션', ja:'バッジコレクション', zhCN:'徽章收藏', zhTW:'徽章收藏', es:'Colección de insignias', de:'Abzeichen-Sammlung', pt:'Coleção de emblemas', ru:'Коллекция значков');
  String get badgeEarnedSection => _s(en:'Earned Badges', ko:'획득한 배지', ja:'獲得済みバッジ', zhCN:'已获得徽章', zhTW:'已獲得徽章', es:'Insignias obtenidas', de:'Erhaltene Abzeichen', pt:'Emblemas conquistados', ru:'Полученные значки');
  String get badgeSecretCondition => _s(en:'Condition is hidden.', ko:'조건이 숨겨져 있습니다.', ja:'条件は非公開です。', zhCN:'条件已隐藏。', zhTW:'條件已隱藏。', es:'La condición está oculta.', de:'Bedingung ist verborgen.', pt:'A condição está oculta.', ru:'Условие скрыто.');
  String get badgeEarnedEmpty => _s(en:'No badges yet. Start checking in!', ko:'아직 획득한 배지가 없습니다. 체크인을 시작해보세요!', ja:'まだバッジがありません。チェックインしましょう！', zhCN:'还没有徽章。开始打卡吧！', zhTW:'還沒有徽章。開始打卡吧！', es:'Sin insignias aún. ¡Empieza a registrarte!', de:'Noch keine Abzeichen. Fang an einzuchecken!', pt:'Nenhum emblema ainda. Comece o check-in!', ru:'Значков пока нет. Начните отмечаться!');
  String get badgeCategoryAll => _s(en:'All', ko:'전체', ja:'すべて', zhCN:'全部', zhTW:'全部', es:'Todo', de:'Alle', pt:'Tudo', ru:'Все');
  String get badgeCategoryStreak => _s(en:'🔥 Streak', ko:'🔥 스트릭', ja:'🔥 ストリーク', zhCN:'🔥 连击', zhTW:'🔥 連擊', es:'🔥 Racha', de:'🔥 Serie', pt:'🔥 Sequência', ru:'🔥 Серия');
  String get badgeCategoryCompletion => _s(en:'🏆 Completion', ko:'🏆 완주', ja:'🏆 完走', zhCN:'🏆 完成', zhTW:'🏆 完成', es:'🏆 Completado', de:'🏆 Abschluss', pt:'🏆 Conclusão', ru:'🏆 Завершение');
  String get badgeCategoryLogging => _s(en:'📝 Logging', ko:'📝 기록', ja:'📝 記録', zhCN:'📝 记录', zhTW:'📝 記錄', es:'📝 Registro', de:'📝 Protokoll', pt:'📝 Registro', ru:'📝 Записи');
  String get badgeCategoryTiming => _s(en:'⏰ Timing', ko:'⏰ 타이밍', ja:'⏰ タイミング', zhCN:'⏰ 时机', zhTW:'⏰ 時機', es:'⏰ Timing', de:'⏰ Timing', pt:'⏰ Timing', ru:'⏰ Тайминг');
  String get badgeCategorySubroutine => _s(en:'🧩 Subroutine', ko:'🧩 서브루틴', ja:'🧩 サブルーティン', zhCN:'🧩 子程序', zhTW:'🧩 子程序', es:'🧩 Subrutina', de:'🧩 Subroutine', pt:'🧩 Sub-rotina', ru:'🧩 Подпрограмма');
  String get badgeCategoryTeam => _s(en:'👥 Team', ko:'👥 팀', ja:'👥 チーム', zhCN:'👥 团队', zhTW:'👥 團隊', es:'👥 Equipo', de:'👥 Team', pt:'👥 Equipe', ru:'👥 Команда');
  String badgeEarnedOn(DateTime date) {
    final y = date.year, m = date.month, d = date.day;
    return _s(
      en: 'Earned ${_monthEn(m)} $d, $y',
      ko: '${y}년 ${m}월 ${d}일 획득',
      ja: '${y}年${m}月${d}日 獲得',
      zhCN: '${y}年${m}月${d}日 获得',
      zhTW: '${y}年${m}月${d}日 獲得',
      es: 'Obtenido el $d/${m}/$y',
      de: 'Erhalten am $d.$m.$y',
      pt: 'Obtido em $d/$m/$y',
      ru: 'Получено $d.${m.toString().padLeft(2,'0')}.$y',
    );
  }
  static String _monthEn(int m) => const ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m-1];

  // ── Guest / Account ──────────────────────────────────────────
  String get guestDisplayName => _s(en:'Guest', ko:'게스트', ja:'ゲスト', zhCN:'访客', zhTW:'訪客', es:'Invitado', de:'Gast', pt:'Convidado', ru:'Гость');
  String get deleteAccountFailed => _s(en:'Failed to delete account.', ko:'계정 삭제에 실패했습니다.', ja:'アカウントの削除に失敗しました。', zhCN:'删除账户失败。', zhTW:'刪除帳戶失敗。', es:'Error al eliminar la cuenta.', de:'Konto konnte nicht gelöscht werden.', pt:'Falha ao excluir conta.', ru:'Не удалось удалить аккаунт.');
  String get emailNotConfirmedError => _s(en:'Email verification required. Please check your inbox.', ko:'이메일 인증이 필요합니다. 받은 편지함을 확인해주세요.', ja:'メール認証が必要です。受信ボックスを確認してください。', zhCN:'需要验证邮箱。请查收收件箱。', zhTW:'需要驗證電子郵件。請查看收件匣。', es:'Se requiere verificación. Revisa tu correo.', de:'E-Mail-Bestätigung erforderlich. Bitte überprüfe deinen Posteingang.', pt:'Verificação de e-mail necessária. Verifique sua caixa de entrada.', ru:'Требуется подтверждение email. Проверьте входящие.');
  String get appleLoginFailed => _s(en:'Apple login failed.', ko:'Apple 로그인에 실패했습니다.', ja:'Appleログインに失敗しました。', zhCN:'Apple登录失败。', zhTW:'Apple登入失敗。', es:'Error al iniciar sesión con Apple.', de:'Apple-Anmeldung fehlgeschlagen.', pt:'Falha no login com Apple.', ru:'Ошибка входа через Apple.');
  String get appleLoginError => _s(en:'An error occurred during Apple login.', ko:'Apple 로그인 중 오류가 발생했습니다.', ja:'Appleログイン中にエラーが発生しました。', zhCN:'Apple登录过程中发生错误。', zhTW:'Apple登入過程中發生錯誤。', es:'Error durante el inicio de sesión con Apple.', de:'Fehler beim Apple-Login.', pt:'Erro durante o login com Apple.', ru:'Ошибка при входе через Apple.');
  String get googleLoginFailed => _s(en:'Google login failed.', ko:'Google 로그인에 실패했습니다.', ja:'Googleログインに失敗しました。', zhCN:'Google登录失败。', zhTW:'Google登入失敗。', es:'Error al iniciar sesión con Google.', de:'Google-Anmeldung fehlgeschlagen.', pt:'Falha no login com Google.', ru:'Ошибка входа через Google.');

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
  String get willpower => _s(en:'Willpower', ko:'의지력', ja:'意志力', zhCN:'意志力', zhTW:'意志力', es:'Fuerza de voluntad', de:'Willenskraft', pt:'Força de vontade', ru:'Сила воли');
  String get myWillpower => _s(en:'My Willpower', ko:'나의 의지력', ja:'私の意志力', zhCN:'我的意志力', zhTW:'我的意志力', es:'Mi fuerza de voluntad', de:'Meine Willenskraft', pt:'Minha força de vontade', ru:'Моя сила воли');
  String get todayWillpowerLabel => _s(en:"Today's Gain", ko:'오늘의 의지력', ja:'今日の意志力', zhCN:'今日获得', zhTW:'今日獲得', es:'Ganancia hoy', de:'Heute gewonnen', pt:'Ganho hoje', ru:'Сегодня');
  String get willpowerSubtitle => _s(en:'Cumulative Score', ko:'누적 달성 점수', ja:'累計達成スコア', zhCN:'累计达成分数', zhTW:'累計達成分數', es:'Puntuación acumulada', de:'Gesamtpunktzahl', pt:'Pontuação acumulada', ru:'Накопленные очки');
  String challengePoints(int n) => _s(en:'+$n pts', ko:'+${n}점', ja:'+${n}点', zhCN:'+${n}点', zhTW:'+${n}點', es:'+$n pts', de:'+$n Pkt', pt:'+$n pts', ru:'+$n оч');
  String get tierSeed     => _s(en:'Seed',     ko:'씨앗', ja:'種',  zhCN:'种子', zhTW:'種子', es:'Semilla',      de:'Keim',        pt:'Semente',    ru:'Семя');
  String get tierSprout   => _s(en:'Sprout',   ko:'새싹', ja:'芽',  zhCN:'嫩芽', zhTW:'嫩芽', es:'Brote',        de:'Sprössling',  pt:'Broto',      ru:'Росток');
  String get tierGrowth   => _s(en:'Growth',   ko:'성장', ja:'成長', zhCN:'成长', zhTW:'成長', es:'Crecimiento',  de:'Wachstum',    pt:'Crescimento',ru:'Рост');
  String get tierFruition => _s(en:'Fruition', ko:'결실', ja:'結実', zhCN:'结实', zhTW:'結實', es:'Fruto',        de:'Reife',       pt:'Maturidade', ru:'Плод');
  String get tierLegend   => _s(en:'Legend',   ko:'전설', ja:'伝説', zhCN:'传说', zhTW:'傳說', es:'Leyenda',      de:'Legende',     pt:'Lenda',      ru:'Легенда');

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
  String get sevenDays => _s(en:'7 Days', ko:'7일', ja:'7日間', zhCN:'7天', zhTW:'7天', es:'7d', de:'7T', pt:'7d', ru:'7');
  String get fourteenDays => _s(en:'14 Days', ko:'14일', ja:'14日間', zhCN:'14天', zhTW:'14天', es:'14d', de:'14T', pt:'14d', ru:'14');
  String get twentyOneDays => _s(en:'21 Days', ko:'21일', ja:'21日間', zhCN:'21天', zhTW:'21天', es:'21d', de:'21T', pt:'21d', ru:'21');
  String get custom => _s(en:'Custom', ko:'직접 입력', ja:'カスタム', zhCN:'自定义', zhTW:'自訂', es:'Personalizado', de:'Benutzerdefiniert', pt:'Personalizado', ru:'Пользовательский');
  String get enterDaysHint => _s(en:'Enter number of days', ko:'일수를 입력하세요', ja:'日数を入力してください', zhCN:'请输入天数', zhTW:'請輸入天數', es:'Ingresa el número de días', de:'Anzahl der Tage eingeben', pt:'Digite o número de dias', ru:'Введите количество дней');
  String get reminderTimeLabel => _s(en:'REMINDER TIME', ko:'알림 시간', ja:'リマインダー時刻', zhCN:'提醒时间', zhTW:'提醒時間', es:'HORA DE RECORDATORIO', de:'ERINNERUNGSZEIT', pt:'HORA DO LEMBRETE', ru:'ВРЕМЯ НАПОМИНАНИЯ');
  String get reminderDisabledHint => _s(
    en:'Disabled — sub-routine alert times are set',
    ko:'비활성화 — 서브루틴 알림 시간이 설정되어 있어요',
    ja:'無効 — サブルーティンの通知時刻が設定されています',
    zhCN:'已禁用 — 子例行通知时间已设置',
    zhTW:'已停用 — 子例行通知時間已設定',
    es:'Desactivado — tiempos de sub-rutinas configurados',
    de:'Deaktiviert — Sub-Routine-Zeiten gesetzt',
    pt:'Desativado — horários de sub-rotinas definidos',
    ru:'Отключено — установлено время подпрограмм',
  );
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
  String get resetAppConfirm2 => _s(
    en:'⚠️ All server data will be permanently deleted and cannot be recovered.\n\nAre you absolutely sure?',
    ko:'⚠️ 서버에 저장된 모든 데이터가 영구적으로 삭제되며 복구할 수 없습니다.\n\n정말 초기화하시겠습니까?',
    ja:'⚠️ サーバーに保存されたすべてのデータが完全に削除され、復元できません。\n\n本当にリセットしますか？',
    zhCN:'⚠️ 服务器上存储的所有数据将被永久删除且无法恢复。\n\n您确定要重置吗？',
    zhTW:'⚠️ 伺服器上儲存的所有資料將被永久刪除且無法復原。\n\n您確定要重置嗎？',
    es:'⚠️ Todos los datos almacenados en el servidor se eliminarán permanentemente y no se pueden recuperar.\n\n¿Estás absolutamente seguro?',
    de:'⚠️ Alle auf dem Server gespeicherten Daten werden dauerhaft gelöscht und können nicht wiederhergestellt werden.\n\nBist du absolut sicher?',
    pt:'⚠️ Todos os dados armazenados no servidor serão excluídos permanentemente e não poderão ser recuperados.\n\nTem absoluta certeza?',
    ru:'⚠️ Все данные, хранящиеся на сервере, будут удалены навсегда и не могут быть восстановлены.\n\nВы абсолютно уверены?',
  );
  String get resetAppFinal => _s(en:'Yes, Delete Everything', ko:'네, 모두 삭제합니다', ja:'はい、すべて削除します', zhCN:'是的，删除所有', zhTW:'是的，刪除所有', es:'Sí, eliminar todo', de:'Ja, alles löschen', pt:'Sim, excluir tudo', ru:'Да, удалить всё');
  String get editName => _s(en:'Edit Name', ko:'이름 수정', ja:'名前を編集', zhCN:'编辑名称', zhTW:'編輯名稱', es:'Editar nombre', de:'Name bearbeiten', pt:'Editar nome', ru:'Изменить имя');
  String get nameHint => _s(en:'Enter your name', ko:'이름을 입력하세요', ja:'名前を入力', zhCN:'输入名称', zhTW:'輸入名稱', es:'Ingresa tu nombre', de:'Name eingeben', pt:'Digite seu nome', ru:'Введите имя');
  String get appSettings => _s(en:'App Settings', ko:'앱 설정', ja:'アプリ設定', zhCN:'应用设置', zhTW:'應用程式設定', es:'Ajustes de la app', de:'App-Einstellungen', pt:'Configurações do app', ru:'Настройки приложения');
  String get appGuide => _s(en:'App Guide', ko:'앱 가이드', ja:'アプリガイド', zhCN:'应用介绍', zhTW:'應用程式介紹', es:'Guía de la app', de:'App-Anleitung', pt:'Guia do app', ru:'Руководство');

  // 앱 소개 — 항목 타이틀
  String get guideHowToUse => _s(en:'How to Use', ko:'사용법', ja:'使い方', zhCN:'使用方法', zhTW:'使用方法', es:'Cómo usar', de:'Anleitung', pt:'Como usar', ru:'Как пользоваться');
  String get guideCreateChallenge => _s(en:'Creating a Challenge', ko:'챌린지 만들기', ja:'チャレンジを作る', zhCN:'创建挑战', zhTW:'建立挑戰', es:'Crear un reto', de:'Challenge erstellen', pt:'Criar um desafio', ru:'Создать задачу');
  String get guideStreakSystem => _s(en:'Streak System', ko:'스트릭 시스템', ja:'ストリークシステム', zhCN:'连续系统', zhTW:'連續系統', es:'Sistema de racha', de:'Streak-System', pt:'Sistema de sequência', ru:'Система серий');
  String get guideStreakRecovery => _s(en:'Streak Recovery', ko:'스트릭 복구', ja:'ストリーク回復', zhCN:'连续恢复', zhTW:'連續恢復', es:'Recuperación de racha', de:'Streak-Wiederherstellung', pt:'Recuperação de sequência', ru:'Восстановление серии');
  String get guideWillpower => _s(en:'Willpower & Level', ko:'의지력 & 레벨', ja:'意志力 & レベル', zhCN:'意志力与等级', zhTW:'意志力與等級', es:'Fuerza de voluntad y nivel', de:'Willenskraft & Level', pt:'Força de vontade e nível', ru:'Сила воли и уровень');
  String get guideBadge => _s(en:'Badge System', ko:'배지 시스템', ja:'バッジシステム', zhCN:'徽章系统', zhTW:'徽章系統', es:'Sistema de insignias', de:'Abzeichen-System', pt:'Sistema de medalhas', ru:'Система значков');

  // 앱 소개 — 항목 설명
  String get guideHowToUseBody => _s(
    en:'Tap + to create a challenge and check off your routine every day. Complete all sub-routines to mark the day done. Check your progress on the Home screen.',
    ko:'+ 버튼으로 챌린지를 만들고 매일 루틴을 체크하세요. 서브루틴을 모두 완료하면 해당 날짜가 달성됩니다. 홈 화면에서 오늘의 진행 상황을 확인하세요.',
    ja:'＋ボタンでチャレンジを作り、毎日ルーティンをチェックしましょう。サブルーティンをすべて完了するとその日が達成されます。',
    zhCN:'点击+创建挑战，每天完成例行任务并打卡。完成所有子任务即可标记当天完成。',
    zhTW:'點擊+建立挑戰，每天完成例行任務並打卡。完成所有子任務即可標記當天完成。',
    es:'Toca + para crear un reto y marca tu rutina cada día. Completa todos los sub-retos para marcar el día como logrado.',
    de:'Tippe auf +, um eine Challenge zu erstellen, und hake deine Routine täglich ab. Schließe alle Sub-Routinen ab, um den Tag als erledigt zu markieren.',
    pt:'Toque em + para criar um desafio e marque sua rotina todos os dias. Complete todas as sub-rotinas para marcar o dia como concluído.',
    ru:'Нажмите +, чтобы создать задачу, и отмечайте выполнение каждый день. Завершите все подзадачи, чтобы засчитать день.',
  );
  String get guideCreateChallengeBody => _s(
    en:'Set a target (7 / 14 / 21 days or custom), add sub-routines, choose repeat days, and set a reminder time. The challenge starts the day you create it.',
    ko:'목표 일수(7·14·21일 또는 직접 입력), 서브루틴, 반복 요일, 알림 시간을 설정할 수 있습니다. 챌린지는 만든 날부터 시작됩니다.',
    ja:'目標日数（7・14・21日またはカスタム）、サブルーティン、繰り返し曜日、通知時間を設定できます。チャレンジは作成日から始まります。',
    zhCN:'可设置目标天数（7/14/21天或自定义）、子任务、重复日期和提醒时间。挑战从创建当天开始。',
    zhTW:'可設定目標天數（7/14/21天或自訂）、子任務、重複日期和提醒時間。挑戰從建立當天開始。',
    es:'Establece un objetivo (7/14/21 días o personalizado), añade sub-retos, elige días de repetición y configura un recordatorio. El reto empieza el día que lo creas.',
    de:'Lege ein Ziel (7/14/21 Tage oder benutzerdefiniert) fest, füge Sub-Routinen hinzu, wähle Wiederholungstage und stelle eine Erinnerungszeit ein.',
    pt:'Defina uma meta (7/14/21 dias ou personalizado), adicione sub-rotinas, escolha dias de repetição e configure um lembrete.',
    ru:'Установите цель (7/14/21 дней или своё), добавьте подзадачи, выберите дни повторения и время напоминания.',
  );
  String get guideStreakSystemBody => _s(
    en:'Each day you complete your routine, your streak grows. Miss a day and it resets to 0. The Total Streaks on the Records screen shows the combined current streak across all challenges.',
    ko:'매일 루틴을 완료하면 스트릭이 1씩 쌓입니다. 하루라도 빠지면 0으로 초기화됩니다. 기록 화면의 총 스트릭은 모든 챌린지의 현재 스트릭 합계입니다.',
    ja:'毎日ルーティンを完了するとストリークが1増えます。1日でも欠かすとリセットされます。記録画面の総ストリークは全チャレンジの現在ストリーク合計です。',
    zhCN:'每天完成例行任务，连续天数+1。漏掉一天则归零。记录页面的总连续是所有挑战当前连续天数的总和。',
    zhTW:'每天完成例行任務，連續天數+1。漏掉一天則歸零。記錄頁面的總連續是所有挑戰當前連續天數的總和。',
    es:'Cada día que completas tu rutina, tu racha crece. Si fallas un día, vuelve a 0. Las Rachas Totales en Registros muestran la suma actual de todas las rachas.',
    de:'Jeden Tag, an dem du deine Routine abschließt, wächst dein Streak. Verpasst du einen Tag, wird er auf 0 zurückgesetzt.',
    pt:'A cada dia que você completa sua rotina, sua sequência cresce. Perca um dia e ela volta a 0.',
    ru:'Каждый день выполнения задачи увеличивает серию на 1. Пропустите день — серия сбрасывается в 0.',
  );
  String get guideStreakRecoveryBody => _s(
    en:'If you miss yesterday\'s routine, a recovery button appears on the card. Spend 3 Willpower to restore the streak. Recovery is available once every 7 days per challenge.',
    ko:'어제 루틴을 빠뜨린 경우 카드 하단에 복구 버튼이 나타납니다. 의지력 3을 소모해 스트릭을 되살릴 수 있습니다. 챌린지당 7일에 한 번 사용 가능합니다.',
    ja:'昨日のルーティンを逃した場合、カード下部に回復ボタンが表示されます。意志力3を消費してストリークを復活させることができます。チャレンジごとに7日に1回使用可能です。',
    zhCN:'如果昨天的任务未完成，卡片底部会出现恢复按钮。消耗3意志力可恢复连续记录。每个挑战每7天可使用一次。',
    zhTW:'如果昨天的任務未完成，卡片底部會出現恢復按鈕。消耗3意志力可恢復連續記錄。每個挑戰每7天可使用一次。',
    es:'Si te perdiste la rutina de ayer, aparece un botón de recuperación en la tarjeta. Gasta 3 de fuerza de voluntad para restaurar la racha. Disponible una vez cada 7 días por reto.',
    de:'Wenn du die gestrige Routine verpasst hast, erscheint ein Wiederherstellungsknopf. Verbrauche 3 Willenskraft, um den Streak wiederherzustellen. Einmal alle 7 Tage pro Challenge verfügbar.',
    pt:'Se você perdeu a rotina de ontem, um botão de recuperação aparece no cartão. Gaste 3 de força de vontade para restaurar a sequência. Disponível uma vez a cada 7 dias por desafio.',
    ru:'Если вчера задача не выполнена, на карточке появится кнопка восстановления. Потратьте 3 силы воли, чтобы вернуть серию. Доступно раз в 7 дней на задачу.',
  );
  String get guideWillpowerBody => _s(
    en:'You earn 1 Willpower for every day you complete a routine. Willpower never decreases and powers your level: Seed → Sprout → Growth → Fruition → Legend. Higher levels make streak recovery cheaper.',
    ko:'루틴을 완료할 때마다 의지력이 1 쌓입니다. 의지력은 절대 줄어들지 않으며 레벨을 높입니다: 씨앗 → 새싹 → 성장 → 결실 → 전설. 레벨이 높을수록 스트릭 복구에 쓸 여유가 생깁니다.',
    ja:'ルーティンを完了するたびに意志力が1増えます。意志力は絶対に減らず、レベルを上げます：種→芽→成長→実り→伝説。レベルが高いほどストリーク回復に使える余裕が生まれます。',
    zhCN:'每完成一天的任务获得1意志力。意志力永不减少，并提升等级：种子→嫩芽→成长→结实→传说。等级越高，用于恢复连续的余量越大。',
    zhTW:'每完成一天的任務獲得1意志力。意志力永不減少，並提升等級：種子→嫩芽→成長→結實→傳說。等級越高，用於恢復連續的餘量越大。',
    es:'Ganas 1 de fuerza de voluntad por cada día que completas una rutina. Nunca disminuye y sube tu nivel: Semilla→Brote→Crecimiento→Fruto→Leyenda.',
    de:'Du verdienst 1 Willenskraft für jeden Tag, an dem du eine Routine abschließt. Willenskraft nimmt nie ab und erhöht dein Level: Keim→Sprössling→Wachstum→Frucht→Legende.',
    pt:'Você ganha 1 de força de vontade por cada dia que completa uma rotina. Nunca diminui e aumenta seu nível: Semente→Broto→Crescimento→Fruto→Lenda.',
    ru:'За каждый выполненный день вы получаете 1 силу воли. Она никогда не уменьшается и повышает уровень: Семя→Росток→Рост→Плод→Легенда.',
  );
  String get guideBadgeBody => _s(
    en:'Earn badges by reaching milestones: completing streaks, finishing challenges, logging in at certain times, and more. Check your collection on the Records screen.',
    ko:'스트릭 달성, 챌린지 완료, 특정 시간대 로그인 등 다양한 조건을 달성하면 배지를 획득합니다. 기록 화면에서 획득한 배지와 미획득 배지를 모두 확인할 수 있습니다.',
    ja:'ストリーク達成、チャレンジ完了、特定時間帯のログインなど様々な条件でバッジを獲得できます。記録画面で確認できます。',
    zhCN:'达成连续记录、完成挑战、在特定时间登录等各种条件可获得徽章。在记录页面查看已获得和未获得的徽章。',
    zhTW:'達成連續記錄、完成挑戰、在特定時間登入等各種條件可獲得徽章。在記錄頁面查看已獲得和未獲得的徽章。',
    es:'Gana insignias al alcanzar hitos: completar rachas, terminar retos, iniciar sesión en ciertos momentos y más. Consulta tu colección en la pantalla de Registros.',
    de:'Verdiene Abzeichen durch Meilensteine: Streaks abschließen, Challenges beenden, zu bestimmten Zeiten anmelden und mehr. Überprüfe deine Sammlung auf dem Bildschirm Aufzeichnungen.',
    pt:'Ganhe medalhas ao atingir marcos: completar sequências, terminar desafios, fazer login em horários específicos e mais. Veja sua coleção na tela de Registros.',
    ru:'Зарабатывайте значки, достигая вех: завершая серии, выполняя задачи, входя в определённое время и многое другое. Проверьте коллекцию на экране Записей.',
  );
  String get languages => _s(en:'Languages', ko:'언어', ja:'言語', zhCN:'语言', zhTW:'語言', es:'Idiomas', de:'Sprachen', pt:'Idiomas', ru:'Языки');
  String get notificationSettings => _s(en:'Notification Settings', ko:'알림 설정', ja:'通知設定', zhCN:'通知设置', zhTW:'通知設定', es:'Notificaciones', de:'Benachrichtigungen', pt:'Notificações', ru:'Уведомления');
  String get notificationPermissionDenied => _s(en:'Notification permission denied. Please enable it in Settings.', ko:'알림 권한이 거부되었습니다. 설정에서 허용해주세요.', ja:'通知の権限が拒否されました。設定から許可してください。', zhCN:'通知权限被拒绝，请在设置中开启。', zhTW:'通知權限被拒絕，請在設定中開啟。', es:'Permiso de notificación denegado. Actívalo en Ajustes.', de:'Benachrichtigungsberechtigung verweigert. Bitte in den Einstellungen aktivieren.', pt:'Permissão de notificação negada. Ative nas Configurações.', ru:'Разрешение на уведомления отклонено. Включите в настройках.');
  String get notificationPermissionDeniedTitle => _s(en:'Allow Notifications', ko:'알림 권한 필요', ja:'通知の許可が必要', zhCN:'需要通知权限', zhTW:'需要通知權限', es:'Permitir notificaciones', de:'Benachrichtigungen erlauben', pt:'Permitir notificações', ru:'Разрешить уведомления');
  String get notificationPermissionDeniedBody => _s(en:'Notification permission is required. Go to Settings to enable it.', ko:'알림 권한이 필요합니다. 설정 앱에서 알림을 허용해주세요.', ja:'通知の権限が必要です。設定アプリから許可してください。', zhCN:'需要通知权限，请前往设置开启。', zhTW:'需要通知權限，請前往設定開啟。', es:'Se requiere permiso. Ve a Ajustes para activarlo.', de:'Benachrichtigungsberechtigung erforderlich. Gehe zu Einstellungen.', pt:'Permissão necessária. Vá para Configurações para ativar.', ru:'Требуется разрешение. Перейдите в Настройки.');
  String get goToSettings => _s(en:'Go to Settings', ko:'설정으로 이동', ja:'設定を開く', zhCN:'前往设置', zhTW:'前往設定', es:'Ir a Ajustes', de:'Zu Einstellungen', pt:'Ir para Configurações', ru:'Открыть настройки');
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
  String get migrationError => _s(en:'Error during data migration:', ko:'데이터 이전 중 문제가 발생했습니다:', ja:'データ移行中にエラーが発생しました：', zhCN:'数据迁移时出错：', zhTW:'資料遷移時出錯：', es:'Error durante la migración de datos:', de:'Fehler bei der Datenmigration:', pt:'Erro durante a migração de dados:', ru:'Ошибка при миграции данных:');
  String get emailEnglishOnly => _s(en:'Email must be entered in English only.', ko:'이메일은 영문으로만 입력해주세요.', ja:'メールアドレスは英語で入力してください。', zhCN:'请用英文输入邮箱地址。', zhTW:'請用英文輸入電子郵件地址。', es:'El correo debe ingresarse solo en inglés.', de:'E-Mail bitte nur auf Englisch eingeben.', pt:'O e-mail deve ser inserido apenas em inglês.', ru:'Email необходимо вводить только на английском.');
  String get mergeDialogTitle => _s(en:'Guest Data Found', ko:'게스트 데이터 발견', ja:'ゲストデータが見つかりました', zhCN:'发现访客数据', zhTW:'發現訪客資料', es:'Datos de invitado encontrados', de:'Gastdaten gefunden', pt:'Dados de convidado encontrados', ru:'Найдены данные гостя');
  String mergeDialogBody(int count) => _s(
    en: 'You have $count challenge(s) created in guest mode. What would you like to do?',
    ko: '게스트 모드에서 만든 챌린지 ${count}개가 있습니다. 어떻게 처리하시겠습니까?',
    ja: 'ゲストモードで作成したチャレンジが${count}件あります。どうしますか？',
    zhCN: '您在访客模式下创建了${count}个挑战。您想怎么处理？',
    zhTW: '您在訪客模式下建立了${count}個挑戰。您想怎麼處理？',
    es: 'Tienes $count desafío(s) creado(s) en modo invitado. ¿Qué deseas hacer?',
    de: 'Sie haben $count Challenge(s) im Gastmodus erstellt. Was möchten Sie tun?',
    pt: 'Você tem $count desafio(s) criado(s) no modo convidado. O que deseja fazer?',
    ru: 'У вас есть $count вызов(а/ов), созданных в гостевом режиме. Что вы хотите сделать?',
  );
  String get mergeDialogKeepServer => _s(en:'Keep existing data', ko:'기존 데이터 유지', ja:'既存データを保持', zhCN:'保留现有数据', zhTW:'保留現有資料', es:'Mantener datos existentes', de:'Vorhandene Daten behalten', pt:'Manter dados existentes', ru:'Сохранить текущие данные');
  String get mergeDialogMerge => _s(en:'Merge guest data', ko:'게스트 데이터 병합', ja:'ゲストデータを統合', zhCN:'合并访客数据', zhTW:'合併訪客資料', es:'Combinar datos de invitado', de:'Gastdaten zusammenführen', pt:'Mesclar dados de convidado', ru:'Объединить данные гостя');

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
