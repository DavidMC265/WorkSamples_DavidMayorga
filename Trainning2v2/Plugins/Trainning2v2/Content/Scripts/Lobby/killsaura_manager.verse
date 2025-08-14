
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using {MainScripts}


AuraTriggers<localizes>:message = "Aura Triggers"
AuraVFXs<localizes>:message = "Aura Powerup VFXs"
AuraMessages<localizes>:message = "Aura Messages"

killsaura_manager := class(creative_device):

    @editable
    MaybeDependencyInjector : ?dependency_injector = false
    #Aura VFXs
    @editable:
        Categories := array{ AuraVFXs }
    BlueAuraVFX : visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable:
        Categories := array{ AuraVFXs }
    RedAuraVFX : visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable:
        Categories := array{ AuraVFXs }
    GoldenAuraVFX : visual_effect_powerup_device = visual_effect_powerup_device{}
    @editable:
        Categories := array{ AuraVFXs }
    DarkAuraVFX : visual_effect_powerup_device = visual_effect_powerup_device{}

    #Aura Removers
    @editable:
        Categories := array{ AuraTriggers }
    AllAurasRemover : trigger_device = trigger_device{}
    @editable:
        Categories := array{ AuraTriggers }
    BlueAuraRemover : trigger_device = trigger_device{}
    @editable:
        Categories := array{ AuraTriggers }
    RedAuraRemover : trigger_device = trigger_device{}
    @editable:
        Categories := array{ AuraTriggers }
    GoldenAuraRemover : trigger_device = trigger_device{}
    @editable:
        Categories := array{ AuraTriggers }
    DarkAuraRemover : trigger_device = trigger_device{}

    #Aura MEssages
    @editable:
        Categories := array{ AuraMessages }
    BlueAuraMessage : hud_message_device = hud_message_device{}
    @editable:
        Categories := array{ AuraMessages }
    RedAuraMessage : hud_message_device = hud_message_device{}
    @editable:
        Categories := array{ AuraMessages }
    GoldenAuraMessage : hud_message_device = hud_message_device{}
    @editable:
        Categories := array{ AuraMessages }
    DarkAuraMessage : hud_message_device = hud_message_device{}

    #Payer Spawners
    @editable
    PlayerSpawners : []player_spawner_device = array{}
    @editable
    JoiningSpawners : []player_spawner_device = array{}


    var MaybeGameManager: ?game_manager = false

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        SetupDependencies()
        
        Sleep(2.5)
        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            SetPlayerAuraVFXs(Player)
            Print("Player Aura VFXs Set", ?Duration := 7.0, ?Color := NamedColors.White)

        for(Spawner : PlayerSpawners):
            Spawner.SpawnedEvent.Subscribe(SetPlayerAuraVFXs)
            
        for(Spawner : JoiningSpawners):
            Spawner.SpawnedEvent.Subscribe(SetPlayerAuraVFXs)

 
    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
        else:
            Print(
                "Dependency Injector not available",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )

    SetPlayerAuraVFXs(Agent : agent): void =
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            if(PlayerData := MaybePlayerData?):
                #Set the VFXs for the player
                set PlayerData.BlueVFX = option{ BlueAuraVFX }
                set PlayerData.RedVFX = option{ RedAuraVFX }
                set PlayerData.GoldenVFX = option{ GoldenAuraVFX }
                set PlayerData.DarkVFX = option{ DarkAuraVFX }
                #Set Aura Removers
                set PlayerData.AllAurasTrigger = option{ AllAurasRemover }
                set PlayerData.BlueAuraTrigger = option{ BlueAuraRemover }
                set PlayerData.RedAuraTrigger = option{ RedAuraRemover }
                set PlayerData.GoldenAuraTrigger = option{ GoldenAuraRemover }
                set PlayerData.DarkAuraTrigger = option{ DarkAuraRemover }
                #Set the messages for the player
                set PlayerData.BlueAuraMessage = option{ BlueAuraMessage }
                set PlayerData.RedAuraMessage = option{ RedAuraMessage }
                set PlayerData.GoldenAuraMessage = option{ GoldenAuraMessage }
                set PlayerData.DarkAuraMessage = option{ DarkAuraMessage }
                

