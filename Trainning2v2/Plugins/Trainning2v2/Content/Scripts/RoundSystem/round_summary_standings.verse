using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/FortPlayerUtilities }
using { /Fortnite.com/Game }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { Lobby }
using { MainScripts }


RoundSummaryDependencies<localizes>:message = "Dependency Injection"
RoundSummaryDevices<localizes>: message = "Devices"
RoundSummaryTeleportingProps<localizes>: message = "Teleporting Props"
RoundSummaryBillboards<localizes>: message = "Billboards"
RoundSummaryEmojies<localizes>: message = "Emojies"
RoundSummaryIcons<localizes>: message = "Icons"

round_summary_standings := class(creative_device):

        #Dependencies
    @editable: 
        Categories := array{ RoundSummaryDependencies }
    var MaybeDependencyInjector : ?dependency_injector = false

    var MaybeGameManager: ?game_manager = false
    var MaybeEventMediator : ?event_mediator = false
    var MaybePregameLobby : ?pregame_lobby = false

        #Devices
    @editable: 
        Categories := array{ RoundSummaryDevices }
    EndGameDevice : end_game_device = end_game_device{}

    @editable: 
        Categories := array{ RoundSummaryDevices }
    StartingTeamSelectorDevice : class_and_team_selector_device = class_and_team_selector_device{}

    @editable: 
        Categories := array{ RoundSummaryDevices }
    StandingsCinematicSequencer : cinematic_sequence_device = cinematic_sequence_device{}

    @editable: 
        Categories := array{ RoundSummaryDevices }
    RoundSettingsDevice : round_settings_device = round_settings_device{}

        #Teleporting Props
    @editable: 
        Categories := array{ RoundSummaryTeleportingProps }
    FirstPlaceStandingProp : creative_prop = creative_prop{}

    @editable: 
        Categories := array{ RoundSummaryTeleportingProps }
    SecondPlaceStandingProp : creative_prop = creative_prop{}

    @editable: 
        Categories := array{ RoundSummaryTeleportingProps }
    ThirdPlaceStandingProp : creative_prop = creative_prop{}

    @editable: 
        Categories := array{ RoundSummaryTeleportingProps }
    FourthPlaceStandingProp : creative_prop = creative_prop{}

        #Icon Creative Props
    @editable:
        Categories := array{ RoundSummaryIcons }
    SkullIconFirstPlaceProp : creative_prop = creative_prop{}

    @editable:
        Categories := array{ RoundSummaryIcons }
    SkullIconSecondPlaceProp : creative_prop = creative_prop{}

    @editable:
        Categories := array{ RoundSummaryIcons }
    SkullIconThirdPlaceProp : creative_prop = creative_prop{}

    @editable:
        Categories := array{ RoundSummaryIcons }
    SkullIconFourthPlaceProp : creative_prop = creative_prop{}

    @editable:
        Categories := array{ RoundSummaryIcons }
    TargetIconFirstPlaceProp : creative_prop = creative_prop{}

    @editable:
        Categories := array{ RoundSummaryIcons }
    TargetIconSecondPlaceProp : creative_prop = creative_prop{}

    @editable:
        Categories := array{ RoundSummaryIcons }
    TargetIconThirdPlaceProp : creative_prop = creative_prop{}

    @editable:
        Categories := array{ RoundSummaryIcons }
    TargetIconFourthPlaceProp : creative_prop = creative_prop{}

        #Billboards
    @editable: 
        Categories := array{ RoundSummaryBillboards }
    FirstPlaceBillboard : billboard_device = billboard_device{}

    @editable: 
        Categories := array{ RoundSummaryBillboards }
    SecondPlaceBillboard : billboard_device = billboard_device{}

    @editable: 
        Categories := array{ RoundSummaryBillboards }
    ThirdPlaceBillboard : billboard_device = billboard_device{}

    @editable: 
        Categories := array{ RoundSummaryBillboards }
    FourthPlaceBillboard : billboard_device = billboard_device{}

    var IsFirstPlaceTaken<private> : logic = false
    var IsSecondPlaceTaken<private> : logic = false
    var IsThirdPlaceTaken<private> : logic = false
    var IsFourthPlaceTaken<private>: logic = false

    var EliminationsCurrentGamePlayers<private>: []int = array{}
    
        #Emojies
    @editable: 
        Categories := array{ RoundSummaryEmojies }
    EliminationsEmoji : string = "E"

    @editable: 
        Categories := array{ RoundSummaryEmojies }
    KillstreakEmoji : string = "S" 


    EliminationEmojiCode : string = "{0u1f408}"
    EmojiCode : string = "{0u1f480}"


    # EliminationsMessage<localizes> (MatchEliminationsPlayer : int, MatchEliminationsIcon : string, MatchKillstreakPlayer : int, MatchKillstreakIcon : string) : message = "{MatchEliminationsPlayer}{MatchEliminationsIcon} {MatchKillstreakPlayer}{MatchKillstreakIcon}"
    StringMesage<localizes> (String : string) : message = "{String}"

    EliminationsMessage<localizes> (MatchEliminationsPlayer : int, MatchKillstreakPlayer : int) : message = "{MatchEliminationsPlayer}  {MatchKillstreakPlayer}"



    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        FirstPlaceBillboard.SetText(StringMesage(""))
        SecondPlaceBillboard.SetText(StringMesage(""))
        ThirdPlaceBillboard.SetText(StringMesage(""))
        FourthPlaceBillboard.SetText(StringMesage(""))

        #Hide Creative Prop Icons

        SkullIconFirstPlaceProp.Hide()
        SkullIconSecondPlaceProp.Hide()
        SkullIconThirdPlaceProp.Hide()
        SkullIconFourthPlaceProp.Hide()

        TargetIconFirstPlaceProp.Hide()
        TargetIconSecondPlaceProp.Hide()
        TargetIconThirdPlaceProp.Hide()
        TargetIconFourthPlaceProp.Hide()


        StandingsCinematicSequencer.StoppedEvent.Subscribe(OnSequencerEnded)

        # if(EventMediator := MaybeEventMediator?):
        #     EventMediator.OnGameEnds.Await()

        #     Sleep(3.0)

        #     AllPlayers := GetPlayspace().GetPlayers()

        #     for(Player : AllPlayers):
        #         if(FortCharacter := Player.GetFortCharacter[]):
        #             FortCharacter.PutInStasis(stasis_args{ AllowEmotes := true, AllowTurning := true, AllowFalling := true })

        #     Sleep(2.0)

        #     SendPlayersToStandingPodium()


    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeEventMediator = DependencyInjector.GetEventMediator()
            set MaybePregameLobby = DependencyInjector.GetPreGameLobby()
        else:
            Print(
                "Dependency Injector not available from Round Start manager",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )
                

    TeleportPlayerToPodium(Agent : agent, TeleportingProp : creative_prop)<suspends>: void =
        LocationTransform := TeleportingProp.GetTransform()
        LocationTranslation := LocationTransform.Translation

        DestinationLoc := vector3{ X:= LocationTranslation.X, Y:= LocationTranslation.Y, Z:= LocationTranslation.Z + 2.0 }

        if(FortCharacter := Agent.GetFortCharacter[]):
            if(FortCharacter.TeleportTo[DestinationLoc, LocationTransform.Rotation]):
                Sleep(0.5)
                FortCharacter.PutInStasis(stasis_args{AllowEmotes := true})
            else:
                Agent.Respawn(DestinationLoc, LocationTransform.Rotation)
                Sleep(0.5)
                FortCharacter.PutInStasis(stasis_args{AllowEmotes := true})
        


    OnSequencerEnded(): void =
        StartingTeamSelectorDevice.Enable()

        AllPlayers := GetPlayspace().GetPlayers()
        for(Player : AllPlayers):
            StartingTeamSelectorDevice.ChangeTeamAndClass(Player)
            
            Print(
                "Switched players team to the default team from the round summary standing script!!!", 
                ?Duration :=10.0, 
                ?Color := NamedColors.Red
            )

        # Only getting all the players since RoundSettingsDevice.EndRound requires and Agent
        if(Player := AllPlayers[0]):
            EndGameDevice.Activate(Player)


    SendPlayersToStandingPodium(): void =
        if(EventMediator := MaybeEventMediator?):
            EventMediator.EmitOnPlayersAreSentToPodium()

        if(PregameLobby := MaybePregameLobby?):
            Print(
                "Length of CurrentGamePlayers is: {PregameLobby.CurrentGamePlayers.Length}", 
                ?Duration := 10.0, 
                ?Color := NamedColors.Yellow
            )

            for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                if(GameManager := MaybeGameManager?):
                    MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)
                    if(PlayerData := MaybePlayerData?):
                        PlayerData.HideScoreboardUI()
                        CurrentGameEliminationsPlayer := PlayerData.GetCurrentGameEliminations()
                        set EliminationsCurrentGamePlayers += array{ CurrentGameEliminationsPlayer }

                        Print(
                            "Length of CurrentGaEliminationsCurrentGamePlayers Array is now: {EliminationsCurrentGamePlayers.Length}", 
                            ?Duration := 10.0, 
                            ?Color := NamedColors.Yellow
                        )
    

        set EliminationsCurrentGamePlayers = SortGameElimnationsForPlayers(EliminationsCurrentGamePlayers)



        case(EliminationsCurrentGamePlayers.Length):
            0 =>
                Print(
                    "EliminationsCurrentGamePlayers Array is 0, so its invalid", 
                    ?Duration := 5.0, 
                    ?Color := NamedColors.Red
                )
            1 =>
                Print(
                    "EliminationsCurrentGamePlayers Array is 1, so its invalid", 
                    ?Duration := 5.0, 
                    ?Color := NamedColors.Red
                )
            2 =>
                if:
                    FirstPlaceEliminations := EliminationsCurrentGamePlayers[0]
                    SecondPlaceEliminations := EliminationsCurrentGamePlayers[1]
                then:
                    if(GameManager := MaybeGameManager?, PregameLobby := MaybePregameLobby?):
                        for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                            MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)

                            if(PlayerData := MaybePlayerData?):
                                FinalCurrentGameEliminationsPlayer := PlayerData.GetCurrentGameEliminations()
                                FinalCurrentGameHighesKillstreakPlayer := PlayerData.GetCurrentGameHighestKillstreak()

                                if(FinalCurrentGameEliminationsPlayer = FirstPlaceEliminations):
                                    spawn{ TeleportPlayerToPodium(CurrentGamePlayer, FirstPlaceStandingProp) }

                                    FirstPlaceBillboard.SetText(
                                        EliminationsMessage(
                                            FinalCurrentGameEliminationsPlayer, 
                                            FinalCurrentGameHighesKillstreakPlayer 
                                        )
                                    )

                                    SkullIconFirstPlaceProp.Show()
                                    TargetIconFirstPlaceProp.Show()

                                if(FinalCurrentGameEliminationsPlayer = SecondPlaceEliminations):
                                    spawn{ TeleportPlayerToPodium(CurrentGamePlayer, SecondPlaceStandingProp) }

                                    SecondPlaceBillboard.SetText(
                                        EliminationsMessage(
                                            FinalCurrentGameEliminationsPlayer, 
                                            FinalCurrentGameHighesKillstreakPlayer 
                                        )
                                    )

                                    SkullIconSecondPlaceProp.Show()
                                    TargetIconSecondPlaceProp.Show()

            3 =>
                if:
                    FirstPlaceEliminations := EliminationsCurrentGamePlayers[0]
                    SecondPlaceEliminations := EliminationsCurrentGamePlayers[1]
                    ThirdPlaceEliminations := EliminationsCurrentGamePlayers[2]
                then:
                    Print(
                        "First Place Eliminations are : {FirstPlaceEliminations}", 
                        ?Duration := 8.0, 
                        ?Color := NamedColors.Orange
                    )
                    if(GameManager := MaybeGameManager?, PregameLobby := MaybePregameLobby?):
                        for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                            MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)

                            if(PlayerData := MaybePlayerData?):
                                FinalCurrentGameEliminationsPlayer := PlayerData.GetCurrentGameEliminations()
                                FinalCurrentGameHighesKillstreakPlayer := PlayerData.GetCurrentGameHighestKillstreak()

                                if(FinalCurrentGameEliminationsPlayer = FirstPlaceEliminations):
                                    spawn{ TeleportPlayerToPodium(CurrentGamePlayer, FirstPlaceStandingProp) }

                                    FirstPlaceBillboard.SetText(
                                        EliminationsMessage(
                                            FinalCurrentGameEliminationsPlayer, 
                                            FinalCurrentGameHighesKillstreakPlayer 
                                        )
                                    )

                                    SkullIconFirstPlaceProp.Show()
                                    TargetIconFirstPlaceProp.Show()

                                if(FinalCurrentGameEliminationsPlayer = SecondPlaceEliminations):
                                    spawn{ TeleportPlayerToPodium(CurrentGamePlayer, SecondPlaceStandingProp) }

                                    SecondPlaceBillboard.SetText(
                                        EliminationsMessage(
                                            FinalCurrentGameEliminationsPlayer, 
                                            FinalCurrentGameHighesKillstreakPlayer
                                        )
                                    )

                                    SkullIconSecondPlaceProp.Show()
                                    TargetIconSecondPlaceProp.Show()

                                if(FinalCurrentGameEliminationsPlayer = ThirdPlaceEliminations):
                                    spawn{ TeleportPlayerToPodium(CurrentGamePlayer, ThirdPlaceStandingProp) }

                                    ThirdPlaceBillboard.SetText(
                                        EliminationsMessage(
                                            FinalCurrentGameEliminationsPlayer, 
                                            FinalCurrentGameHighesKillstreakPlayer 
                                        )
                                    )

                                    SkullIconThirdPlaceProp.Show()
                                    TargetIconThirdPlaceProp.Show()


            4 =>
                if:
                    FirstPlaceEliminations := EliminationsCurrentGamePlayers[0]
                    SecondPlaceEliminations := EliminationsCurrentGamePlayers[1]
                    ThirdPlaceEliminations := EliminationsCurrentGamePlayers[2]
                    FourthPlaceEliminations := EliminationsCurrentGamePlayers[3]

                then:
                    if(GameManager := MaybeGameManager?, PregameLobby := MaybePregameLobby?):
                        for(CurrentGamePlayer : PregameLobby.CurrentGamePlayers):
                            MaybePlayerData := GameManager.GetMaybePlayerData(CurrentGamePlayer)

                            if(PlayerData := MaybePlayerData?):
                                FinalCurrentGameEliminationsPlayer := PlayerData.GetCurrentGameEliminations()
                                FinalCurrentGameHighesKillstreakPlayer := PlayerData.GetCurrentGameHighestKillstreak()


                                if(FinalCurrentGameEliminationsPlayer = FirstPlaceEliminations):
                                    spawn{ TeleportPlayerToPodium(CurrentGamePlayer, FirstPlaceStandingProp) }

                                    FirstPlaceBillboard.SetText(
                                        EliminationsMessage(
                                            FinalCurrentGameEliminationsPlayer, 
                                            FinalCurrentGameHighesKillstreakPlayer 
                                        )
                                    )

                                    SkullIconFirstPlaceProp.Show()
                                    TargetIconFirstPlaceProp.Show()

                                if(FinalCurrentGameEliminationsPlayer = SecondPlaceEliminations):
                                    spawn{ TeleportPlayerToPodium(CurrentGamePlayer, SecondPlaceStandingProp) }

                                    SecondPlaceBillboard.SetText(
                                        EliminationsMessage(
                                            FinalCurrentGameEliminationsPlayer, 
                                            FinalCurrentGameHighesKillstreakPlayer 
                                        )
                                    )

                                    SkullIconSecondPlaceProp.Show()
                                    TargetIconSecondPlaceProp.Show()

                                if(FinalCurrentGameEliminationsPlayer = ThirdPlaceEliminations):
                                    spawn{ TeleportPlayerToPodium(CurrentGamePlayer, ThirdPlaceStandingProp) }

                                    ThirdPlaceBillboard.SetText(
                                        EliminationsMessage(
                                            FinalCurrentGameEliminationsPlayer, 
                                            FinalCurrentGameHighesKillstreakPlayer 
                                        )
                                    )

                                    SkullIconThirdPlaceProp.Show()
                                    TargetIconThirdPlaceProp.Show()

                                if(FinalCurrentGameEliminationsPlayer = FourthPlaceEliminations):
                                    spawn{ TeleportPlayerToPodium(CurrentGamePlayer, FourthPlaceStandingProp) }

                                    FourthPlaceBillboard.SetText(
                                        EliminationsMessage(
                                            FinalCurrentGameEliminationsPlayer, 
                                            FinalCurrentGameHighesKillstreakPlayer 
                                        )
                                    )

                                    SkullIconFourthPlaceProp.Show()
                                    TargetIconFourthPlaceProp.Show()

            _=>
                Print(
                    "EliminationsCurrentGamePlayers Array is greater than 3, so its invalid", 
                    ?Duration := 5.0, 
                    ?Color := NamedColors.Red
                )


        StandingsCinematicSequencer.Play()


    SortGameElimnationsForPlayers(UnsortedScore : []int) :[]int= 
        var SortedArray : []int = UnsortedScore
        for(I := 0..SortedArray.Length-1):
            for(J := 0..SortedArray.Length - I - 2):
                if(E1 := SortedArray[J],  E2 := SortedArray[J+1]):
                    if(E1 < E2):
                        if:
                            set SortedArray[J] = E2
                            set SortedArray[J+1] = E1              
        return SortedArray

