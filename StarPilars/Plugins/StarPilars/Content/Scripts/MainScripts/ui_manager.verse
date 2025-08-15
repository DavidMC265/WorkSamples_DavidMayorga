using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /Verse.org/Colors }
using { UIScripts }

TextForUI<localizes>(InText : string) : message = "{InText}"

#base_ui:
    #Base class for the UI elements, it has the basic functions like init, show and hide UI.
    #Create canvas must be overriden in the child classes.

base_ui<public> := class<unique>:

    Logger:log = log{Channel := simple_log, DefaultLevel := log_level.Normal}
    DebugLogger:log = log{Channel := debugging_tester_log, DefaultLevel := log_level.Debug}
    ExceptionLogger:log = log{Channel := catch_exceptions_log, DefaultLevel := log_level.Warning}

    var MaybeGameManager<public>:?game_manager = false
    var MaybeAgent<public>:?agent = false
    var MaybePlayerData<public> : ?player_data = false
    var MaybePlayerUI<public> : ?player_ui = false
    var Canvas<public>:canvas = canvas {}

    Init<public><final>(Agent:agent,GameManager:game_manager, _MaybePlayerData:?player_data):void=
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
    #Manager that stores all UI elements for one player, it has base functions like init, show and hide UI.

ui_manager<public> := class:
    
    var EveryPlayerUI : []base_ui = array {}
    var EveryUI : []base_ui = array {}
    var SpectatorModeUI : ui_spectatormode = ui_spectatormode{}
    var SetPlayerBountyUI : ui_setplayerbounty = ui_setplayerbounty{}
    var PlayerCurrencyUI : ui_playercurrency = ui_playercurrency{}
    var HatsOwnedPlayerUI : ui_hatsownedplayer = ui_hatsownedplayer{}
    var ChairSpectatorUI : ui_chairspectator = ui_chairspectator{}
    var XPShopUI : ui_xpshop = ui_xpshop{}
    # var Resources : ui_resources = ui_resources{}


    InitEveryPlayerUI<public>(Agent:agent,GameManager:game_manager,PlayerData:?player_data):void=
        set EveryPlayerUI = array: #base UIs that will be called from PlayerData's uimanager
            #Resources
            SpectatorModeUI
            SetPlayerBountyUI
            PlayerCurrencyUI
            HatsOwnedPlayerUI
            ChairSpectatorUI
            XPShopUI
        
            
        for(UIP : EveryPlayerUI):
            UIP.Init(Agent,GameManager,PlayerData)

    InitEveryUI<public>(Agent:agent,GameManager:game_manager):void=
        set EveryUI = array: #base UIs that wont be called from PlayerData's uimanager
        
        for(UIP : EveryUI):
            UIP.Init(Agent,GameManager,false)

            
