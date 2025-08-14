# using { UIScripts }
using { /Fortnite.com/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { UIScripts }

TextForUI<localizes>(InText : string) : message = "{InText}"

# base_ui:
#     Base class for the UI elements, it has the basic functions like init, show and hide UI.
#     Create canvas must be overriden in the child classes.
        
base_ui<public> := class<unique>:

    Logger:log = log{Channel := simple_log, DefaultLevel := log_level.Normal}
    DebugLogger:log = log{Channel := debugging_tester_log, DefaultLevel := log_level.Debug}
    ExceptionLogger:log = log{Channel := catch_exceptions_log, DefaultLevel := log_level.Warning}

    var MaybeGameManager<public>:?game_manager = false
    var MaybeAgent<public>:?agent = false
    var MaybePlayerData<public> : ?player_data = false
    var MaybePlayerUI<public> : ?player_ui = false
    var Canvas<public>:canvas = canvas {}

    Init<public><final>(Agent:agent,GameManager:game_manager, _MaybePlayerData:?player_data, EventMediator : event_mediator):void=
        set MaybeAgent = option{Agent}
        set MaybeGameManager = option{GameManager}
        set MaybePlayerData = _MaybePlayerData
        if:
            Player:=player[Agent]
            PlayerUI:=GetPlayerUI[Player]
        then:
            set MaybePlayerUI = option{PlayerUI}
        else:
            set MaybePlayerUI = false
        CreateCanvas()

    CreateCanvas<public>():void=
        Logger.Print("Creating canvas")
        
    ShowInteract<public>():void=
        if:
            PlayerUI:=MaybePlayerUI?
        then:
            PlayerUI.AddWidget(Canvas, player_ui_slot{InputMode := ui_input_mode.All})
        else:
            ExceptionLogger.Print("Player UI not initialized, Show UI interactable aborted")

    Show<public><final>():void=
        if:
            PlayerUI:=MaybePlayerUI?
        then:
            PlayerUI.AddWidget(Canvas, player_ui_slot{InputMode := ui_input_mode.None})
        else:
            ExceptionLogger.Print("Player UI not initialized, Show UI aborted")

    Hide<public><final>():void=
        if:
            PlayerUI:=MaybePlayerUI?
        then:
            PlayerUI.RemoveWidget(Canvas)
        else:
            ExceptionLogger.Print("Player UI not initialized, Hide UI aborted")

#ui_manager:
#     Manager that stores all UI elements for one player, it has base functions like init, show and hide UI.

ui_manager<public> := class:
    
    var EveryPlayerUI : []base_ui = array {}
    var EveryUI : []base_ui = array {}

    var Scoreboard : ui_scoreboard = ui_scoreboard{}
    var TwoPlayersLeft : ui_twoplayersleft = ui_twoplayersleft{}
    var TeamSelection : ui_teamselection = ui_teamselection{}
    var Spectator : ui_spectatormode = ui_spectatormode{}
    var GameStartClock : ui_gamestartclock = ui_gamestartclock{}
    var WeaponSelectionTimer : ui_weaponselectiontimer = ui_weaponselectiontimer{}
    var RoundStartCountdownTimer : ui_roundstartcountdown = ui_roundstartcountdown{}
    var MatchSummary : ui_matchsummary = ui_matchsummary{}
    # var PlayerInfo : ui_playerinfo = ui_playerinfo{}

    InitEveryPlayerUI<public>(Agent:agent,GameManager:game_manager,PlayerData:?player_data, EventMediator : event_mediator):void=
        set EveryPlayerUI = array: #base UIs that will be called from PlayerData's uimanager
            # Resources
            # PlayerInfo
            Scoreboard
            TwoPlayersLeft
            TeamSelection
            Spectator
            GameStartClock
            WeaponSelectionTimer
            RoundStartCountdownTimer
            MatchSummary
        
        for(UI : EveryPlayerUI):
            UI.Init(Agent,GameManager,PlayerData, EventMediator)

    InitEveryUI<public>(Agent:agent,GameManager:game_manager, EventMediator : event_mediator):void=
        set EveryUI = array: #base UIs that wont be called from PlayerData's uimanager
        
        for(UI : EveryUI):
            UI.Init(Agent,GameManager,false, EventMediator)