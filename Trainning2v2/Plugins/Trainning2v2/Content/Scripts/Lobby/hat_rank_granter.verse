using { /Fortnite.com }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { MainScripts }
using { Lib }


hat_rank_granter<public> := class(creative_device):

    @editable
    MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private>: ?game_manager = false
    var MaybeEventMediator<private> : ?event_mediator = false
    var MaybePregameLobby<private> : ?pregame_lobby = false
    

    @editable
    vfx_powerup_unranked<private> : visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable
    vfx_powerup_Bronce<private> : visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable
    vfx_powerup_Silver<private> : visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable
    vfx_powerUp_Gold<private> : visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable
    vfx_powerUp_Platinium<private> : visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable
    vfx_powerUp_Diamond<private> : visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable
    button_Unranked<private> : button_device = button_device{}

    @editable
    button_Bronce<private> : button_device = button_device{}

    @editable
    button_Silver<private> : button_device = button_device{}

    @editable
    button_gold<private> : button_device = button_device{}

    @editable
    button_platinium<private> : button_device = button_device{}

    @editable
    button_Diamond<private> : button_device = button_device{}

    @editable
    CantWearHatMessage<private> : hud_message_device = hud_message_device{}


    OnBegin<override>()<suspends>:void=
        SetupDependencies()
        button_Unranked.InteractedWithEvent.Subscribe(OnUnrankedButtonPressed)
        button_Bronce.InteractedWithEvent.Subscribe(OnBronceButtonPressed)
        button_Silver.InteractedWithEvent.Subscribe(OnSilverButtonPressed)
        button_gold.InteractedWithEvent.Subscribe(OnGoldButtonPressed)
        button_platinium.InteractedWithEvent.Subscribe(OnPlatiniumButtonPressed)
        button_Diamond.InteractedWithEvent.Subscribe(OnDiamondButtonPressed)
    
    
    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
            set MaybePregameLobby = DependencyInjector.GetPreGameLobby()
        else:
            Print(
                "Dependency Injector not available",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )
        

    OnUnrankedButtonPressed(Agent : agent): void =
        if (GameManager:= MaybeGameManager?):
            MaybePlayerData:= GameManager.GetMaybePlayerData(Agent)
            if (data_player:=MaybePlayerData?):
                current_player_rank:= data_player.GetPlayerRank()
                if (current_player_rank >= 0):
                    vfx_powerup_unranked.Pickup(Agent)
                    set data_player.hasHat = true
                else:
                    CantWearHatMessage.Show(Agent)
    

    OnBronceButtonPressed(Agent : agent) : void =
        if (GameManager:= MaybeGameManager?):
            MaybePlayerData:= GameManager.GetMaybePlayerData(Agent)
            if (data_player:=MaybePlayerData?):
                current_player_rank:= data_player.GetPlayerRank()
                if(current_player_rank >= 1):
                    vfx_powerup_Bronce.Pickup(Agent)
                    set data_player.hasHat = true
                else:
                    CantWearHatMessage.Show(Agent)
                    

    OnSilverButtonPressed(Agent : agent) : void =
        if (GameManager:= MaybeGameManager?):
            MaybePlayerData:= GameManager.GetMaybePlayerData(Agent)
            if (data_player:= MaybePlayerData?):
                current_player_rank:= data_player.GetPlayerRank()
                if (current_player_rank >= 2):
                    vfx_powerup_Silver.Pickup(Agent)
                    set data_player.hasHat = true
                else:
                    CantWearHatMessage.Show(Agent)


    OnGoldButtonPressed(Agent : agent) : void =
        if (GameManager:= MaybeGameManager?):
            MaybePlayerData:= GameManager.GetMaybePlayerData(Agent)
            if (data_player:= MaybePlayerData?):
                current_player_rank:= data_player.GetPlayerRank()
                if (current_player_rank >= 3):
                    vfx_powerUp_Gold.Pickup(Agent)
                    set data_player.hasHat = true
                else:
                    CantWearHatMessage.Show(Agent)
    

    OnPlatiniumButtonPressed(Agent : agent) : void =
        if (GameManager:= MaybeGameManager?):
            MaybePlayerData:= GameManager.GetMaybePlayerData(Agent)
            if (data_player:= MaybePlayerData?):
                current_player_rank:= data_player.GetPlayerRank()
                if (current_player_rank >= 4):
                    vfx_powerUp_Platinium.Pickup(Agent)
                    set data_player.hasHat = true
                else:
                    CantWearHatMessage.Show(Agent)


    OnDiamondButtonPressed(Agent : agent) : void =
        if (GameManager:= MaybeGameManager?):
            MaybePlayerData:= GameManager.GetMaybePlayerData(Agent)
            if (data_player:= MaybePlayerData?):
                current_player_rank:= data_player.GetPlayerRank()
                if (current_player_rank >= 5):
                    vfx_powerUp_Diamond.Pickup(Agent)
                    set data_player.hasHat = true
                else:
                    CantWearHatMessage.Show(Agent)
            
    
    GrantHat<public>(Agent : agent) : void =
        if (GameManager:= MaybeGameManager?):
            MaybePlayerData:= GameManager.GetMaybePlayerData(Agent)
            if (data_player:= MaybePlayerData?):
                if (data_player.hasHat= true):
                    currentplayerrank:= data_player.GetPlayerRank()
                    case (currentplayerrank):
                        0 => 
                            vfx_powerup_unranked.Pickup(Agent)
                        1 => 
                            vfx_powerup_Bronce.Pickup(Agent)
                        2 =>
                            vfx_powerup_Silver.Pickup(Agent)
                        3 =>
                            vfx_powerUp_Gold.Pickup(Agent)
                        4 =>
                            vfx_powerUp_Platinium.Pickup(Agent)
                        5 =>
                            vfx_powerUp_Diamond.Pickup(Agent)
                        _ => # default
                            Print(
                                "Player Rank Index received is out of bounds therefore it is invalid from hat_rank_granter", 
                                ?Duration := 7.0, 
                                ?Color := NamedColors.Red
                            )
