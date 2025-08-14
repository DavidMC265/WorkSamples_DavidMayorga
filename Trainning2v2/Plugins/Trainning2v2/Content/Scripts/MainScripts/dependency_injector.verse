using { /Verse.org/Colors }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { MainScripts }
using { RoundSystem }
using { Lobby }


dependency_injector<public> := class(creative_device):

    Logger:log = log{Channel := simple_log, DefaultLevel := log_level.Normal}
    DebugLogger:log = log{Channel := debugging_tester_log, DefaultLevel := log_level.Debug}
    ExceptionLogger:log = log{Channel := catch_exceptions_log, DefaultLevel := log_level.Warning}

    @editable
    var MaybeGameManager: ?game_manager = false
    @editable
    var MaybeEventMediator: ?event_mediator = false
    @editable
    var MaybeRoundStartManager : ?round_start_manager = false
    @editable
    var MaybePracticeArea : ?practice_area = false
    @editable
    var MaybePreGameLobby : ?pregame_lobby = false
    @editable
    var MaybeMainRankManaer : ?main_rank_manager = false
    @editable
    var MaybeInventoryManager : ?inventory_manager = false
    @editable
    var MaybeJoinInProgressManager : ?joininprogress_manager = false
    @editable
    var MaybeQuestManager : ?quest_manager = false
    @editable
    var MaybeHatGranter : ?hat_rank_granter = false

    GetGameManager<public>(): ?game_manager =
        if:
            Dependency := game_manager[MaybeGameManager?]
        then:
            # Print("Game Manager returned!!", ?Duration := 5.0, ?Color := NamedColors.Orange)
            return option{Dependency}
        else:
            ExceptionLogger.Print("Game Manager was not initialized")
            return false

    GetEventMediator<public>(): ?event_mediator =
        if:
            Dependency := event_mediator[MaybeEventMediator?]
        then:
            return option{Dependency}
        else:
            ExceptionLogger.Print("Event Mediator was not initialized")
            return false

    GetRoundStartManager<public>(): ?round_start_manager = 
        if:
            Dependency := round_start_manager[MaybeRoundStartManager?]
        then:
            return option{Dependency}
        else:
            ExceptionLogger.Print("Round Start Manager was not initialized")
            return false

    GetPracticeArea<public>(): ?practice_area = 
        if:
            Dependency := practice_area[MaybePracticeArea?]
        then:
            return option{Dependency}
        else:
            ExceptionLogger.Print("Practice Area was not initialized")
            return false

    GetPreGameLobby<public>(): ?pregame_lobby = 
        if:
            Dependency := pregame_lobby[MaybePreGameLobby?]
        then:
            return option{Dependency}
        else:
            ExceptionLogger.Print("Pregame Lobby was not initialized")
            return false

    GetMainRankManager<public>() : ?main_rank_manager = 
        if:
            Dependency := main_rank_manager[MaybeMainRankManaer?]
        then:
            return option{Dependency}
        else:
            ExceptionLogger.Print("Main Rank Manager was not initialized")
            return false

    GetInventoryManager<public>(): ?inventory_manager =
        if:
            Dependency := inventory_manager[MaybeInventoryManager?]
        then:
            return option{Dependency}
        else:
            ExceptionLogger.Print("Inventory Manager was not initialized")
            return false

    GetJoinInProgressManager<public>(): ?joininprogress_manager = 
        if:
            Dependency := joininprogress_manager[MaybeJoinInProgressManager?]
        then:
            return option{ Dependency }
        else:
            ExceptionLogger.Print("Join In Progress Manager was not initialized")
            return false

    GetHatGranter<public>(): ?hat_rank_granter=
        if:
            Dependency := hat_rank_granter[MaybeHatGranter?]
        then:
            return option{ Dependency }
        else:
            ExceptionLogger.Print("Hat granter is not initialized")
            return false


    GetQuestManager<public>(): ?quest_manager=
        if:
            Dependency := quest_manager[MaybeQuestManager?]
        then:
            return option{ Dependency }
        else:
            ExceptionLogger.Print("Quest manager was not initialized")
            return false
        


