using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/FortPlayerUtilities }
using { /Fortnite.com/Game }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }
using { Lib }
using { MainScripts }



joinin_game_test := class(creative_device):

    @editable       RoundSettigs : round_settings_device = round_settings_device{}
    @editable       GameManager :game_manager = game_manager{}
    
    @editable       GameStartSpawners : []player_spawner_device = array{}

    @editable       EliminationButton : button_device = button_device{}
    @editable       InitialTeamClassSelector : class_and_team_selector_device = class_and_team_selector_device{}
    @editable       OnElimiatedClassSelector : class_and_team_selector_device = class_and_team_selector_device{}


    @editable       ElimiatedPlayersSpawners : []player_spawner_device = array{}
    @editable       EnableSpawnersButton : button_device = button_device{}

    @editable       EmojisBillboard : billboard_device = billboard_device{}

    @editable       WinUIButton : button_device = button_device{}
    @editable       LossUIButton : button_device = button_device{}
    @editable       RoundwinHudMessage : hud_message_device = hud_message_device{}
    @editable       RoundLossHudMessage : hud_message_device = hud_message_device{}

    @editable:
    RankIconCreativeProp<private> : creative_prop = creative_prop{}

    @editable
    SilverMatButton : button_device = button_device{}

    @editable       HudPlayerInfoOverride : hud_controller_device = hud_controller_device{}
    @editable       HudControllerButton : button_device = button_device{}

    @editable:
    SilverRankMatIcon<private> : ?material =  false

    #Time Played Stat creator
    # @editable
    # TimePlayedStatCreatorDevice : stat_creator_device = stat_creator_device{}
    # @editable
    # TimePlayedIncrementStatButton : button_device = button_device{}

    # var TimePlayedMinutes : int = 0



    EliminationEmojiCode : string = "{0u1f408}"
    EmojiCode : string = "{0u1f480}"
    Emoji1 : string = "💀"
    Emoji2 : string = "🎁"
    MessageVal : string = "The emoji is: "
    EmojiIconMessage<localizes> (MessageTh : string, Emoji : string) : message = "{MessageTh}{Emoji}"


    Message1<localizes>(Agent : agent): message = "{Agent}"

    
    OnBegin<override>()<suspends>:void=
        HudPlayerInfoOverride.Disable()

        # TimePlayedIncrementStatButton.InteractedWithEvent.Subscribe(OnStatButtonPressed)
        # TimePlayedStatCreatorDevice.MaximumReachedEvent.Subscribe(OnTimePlayedReached)
        # TimePlayedStatCreatorDevice.LevelChangedEvent.Subscribe(OnPlayerLevelChanged)

        HudControllerButton.InteractedWithEvent.Subscribe(OnHudControllerButtonPressed)

        WinUIButton.InteractedWithEvent.Subscribe(OnRoundWinUIButtonPressed)
        LossUIButton.InteractedWithEvent.Subscribe(OnRoundLossUIButtonPressed)
        SilverMatButton.InteractedWithEvent.Subscribe(ChangePropMatToSilver)     
        
        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            if(FortCharacter := Player.GetFortCharacter[]):
                FortCharacter.DamagedEvent().Subscribe(OnPlayerDamaged)

        for(ElimiatedPlayersSpawner : ElimiatedPlayersSpawners):
            ElimiatedPlayersSpawner.Disable()


        EliminationButton.InteractedWithEvent.Subscribe(OnButtonPressed)
        EnableSpawnersButton.InteractedWithEvent.Subscribe(OnSpawnersButtonPressed)

        for(GameStartSpawner : GameStartSpawners):
            GameStartSpawner.SpawnedEvent.SubscribeAgent(OnPlayerSpawnedEv, GameStartSpawner)


        Sleep(7.0)

        for(GameStartSpawner : GameStartSpawners):
            GameStartSpawner.Disable()

        SetEmojiBillboardText()

    
    # OnStatButtonPressed(Agent : agent): void =
    #     set TimePlayedMinutes += 1
    #     if(TimePlayedStatCreatorDevice.SetValue[Agent, TimePlayedMinutes]){}            


    # OnPlayerLevelChanged(MaybeAgent : ?agent, NewLevel : int): void=
    #     Print("Player has reached a new level it is now {NewLevel}")
    #     if(Agent := MaybeAgent?):
    #         set TimePlayedMinutes = 0 
            
    #         if:
    #             PlayerLevel := TimePlayedStatCreatorDevice.GetLevel[Agent]
    #             PlayerLevel >= 5
    #         then:
    #             if:
    #                 TimePlayedStatCreatorDevice.SetLevel[Agent, 1]
    #             then:
    #                 Print("Player Level has been restarted to Level 1!!!!!")


    # OnTimePlayedReached(MaybeAgent : ?agent, Value : int): void =
    #     if:
    #         Agent := MaybeAgent?
    #         # TimePlayedStatCreatorDevice.SetValue[Agent, 0]
    #     then:
    #         Print("Time Played Stat reset for the player!!!")



    OnPlayerDamaged(Result : damage_result): void =
        Print("The player has been damaged!!")

        
    ChangePropMatToSilver(Agent : agent): void =
        if(SilverMat := SilverRankMatIcon?):
            RankIconCreativeProp.SetMaterial(SilverMat)
        else:
            Print(
                "Silver Mat is not valid to Set Material!!", 
                ?Duration := 8.0, 
                ?Color := NamedColors.Red
            )


    SetEmojiBillboardText()<suspends>: void =
        EmojisBillboard.SetText(EmojiIconMessage(MessageVal, EliminationEmojiCode))
        Print("{Emoji1}")
        Sleep(2.0)
        EmojisBillboard.SetText(EmojiIconMessage(MessageVal, EliminationEmojiCode))
        Print("{Emoji2}")



    OnPlayerSpawnedEv(Agent : agent, Spawner : player_spawner_device): void =
        InitialTeamClassSelector.ChangeTeamAndClass(Agent)
        Spawner.Disable()



    OnButtonPressed(Agent : agent): void =
        if:
            Player := player[Agent]
            FortCharacter := Player.GetFortCharacter[]
        then:
            FortCharacter.Damage(100.00)

            spawn { ChangePlayerTeam(Agent) }


    ChangePlayerTeam(Agent : agent)<suspends>: void =
        Sleep(7.0)

        OnElimiatedClassSelector.ChangeTeamAndClass(Agent)


    OnSpawnersButtonPressed(Agent : agent): void =
        for(ElimiatedPlayersSpawner : ElimiatedPlayersSpawners):
            ElimiatedPlayersSpawner.Enable()

    
    OnRoundWinUIButtonPressed(Agent : agent): void =
        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            RoundwinHudMessage.Show(Player)


    OnRoundLossUIButtonPressed(Agent : agent): void =
        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            RoundLossHudMessage.Show(Player)


    OnHudControllerButtonPressed(Agent : agent): void =
        HudPlayerInfoOverride.Enable()


    


    










        

