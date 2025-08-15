using { /Fortnite.com }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }
using { GameAreas }
using { Tests}


dependency_injector<public> := class(creative_device):

    Logger:log = log{Channel := simple_log, DefaultLevel := log_level.Normal}
    DebugLogger:log = log{Channel := debugging_tester_log, DefaultLevel := log_level.Debug}
    ExceptionLogger:log = log{Channel := catch_exceptions_log, DefaultLevel := log_level.Warning}


    @editable
    var MaybeGameManager: ?game_manager = false
    @editable
    var MaybeEventMediator: ?event_mediator = false
    @editable
    var MaybeLobbyController : ?lobby_controller = false
    @editable
    var MaybePillarsManager : ?pillars_manager = false
    @editable
    var MaybeBountyHunting : ?bounty_hunting = false
    @editable
    var MaybeAccoladeManager : ?accolade_manager = false
    @editable
    var MaybeHatStore : ?hat_store = false
    @editable
    var MaybePlayerCurrencyModifier : ?player_currencymodifier = false
    @editable
    var MaybeQuestManager : ?quest_manager = false
    @editable
    var MaybeXPShop : ?xp_shop = false


    GetGameManager<public>(): ?game_manager =
        if:
            Dependency := game_manager[MaybeGameManager?]
        then:
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

    GetLobbyController<public>(): ?lobby_controller =
        if:
            Dependency := lobby_controller[MaybeLobbyController?]
        then:
            return option{ Dependency }
        else:
            ExceptionLogger.Print("Lobby Controller was not initialized")
            return false

    GetPillarsManager<public>(): ?pillars_manager =
        if:
            Dependency := pillars_manager[MaybePillarsManager?]
        then:
            return option{ Dependency }
        else:
            ExceptionLogger.Print("Pillars Manager was not initialized")
            return false


    GetBountyHunting<public>(): ?bounty_hunting =
        if:
            Dependency := bounty_hunting[MaybeBountyHunting?]
        then:
            return option{ Dependency }
        else:
            ExceptionLogger.Print("Bounty Hunting was not initialized")
            return false


    GetAccoladeManager<public>(): ?accolade_manager =
        if:
            Dependency := accolade_manager[MaybeAccoladeManager?]
        then:
            return option{ Dependency }
        else:
            ExceptionLogger.Print("Accolade Manager was not initialized")
            return false


    GetHatStore<public>(): ?hat_store =
        if:
            Dependency := hat_store[MaybeHatStore?]
        then:
            return option{ Dependency }
        else:
            ExceptionLogger.Print("Accolade Manager was not initialized")
            return false

    GetPlayerCurrencyModifier<public>(): ?player_currencymodifier =
        if:
            Dependency := player_currencymodifier[MaybePlayerCurrencyModifier?]
        then:
            return option { Dependency }
        else:
            ExceptionLogger.Print("Player Currency Modifier was not initialized")
            return false

    GetQuestManager<public>(): ?quest_manager =
        if:
            Dependency := quest_manager[MaybeQuestManager?]
        then:
            return option { Dependency }
        else:
            ExceptionLogger.Print("Quest Manager was not initialized")
            return false

    GetXPShop<public>(): ?xp_shop =
        if:
            Dependency := xp_shop[MaybeXPShop?]
        then:
            return option { Dependency }
        else:
            ExceptionLogger.Print("XP Shop was not initialized")
            return false


