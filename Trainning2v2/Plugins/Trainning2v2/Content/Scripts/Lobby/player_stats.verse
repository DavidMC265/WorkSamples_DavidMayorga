using { /Verse.org/Colors }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { MainScripts }
using { Lib }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }

Dependency_PlayerStats<localizes>:message = "Dependency Injection"
Devices_PlayerStats<localizes>:message = "Devices"
LetterProps_PlayerStats<localizes>:message = "Letter Props"

player_stats := class(creative_device):

    Message1<localizes>(Agent : agent) : message = "{Agent}"

    @editable: 
        Categories:= array{ Dependency_PlayerStats }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybeGameManager<private> : ?game_manager = false
    var MaybeMainRankManager<private>: ?main_rank_manager = false

    @editable:
        Categories := array{ Devices_PlayerStats }
    var ButtonForStats<private> : button_device = button_device{}

    @editable:
        Categories := array{ Devices_PlayerStats }
    var PlayerStatsRef<private> : player_reference_device = player_reference_device{}

    @editable:
        Categories := array{ Devices_PlayerStats }
    var BillboardStats<private> : billboard_device = billboard_device{}

    @editable:
        Categories := array{ Devices_PlayerStats }
    var BillboardPlayerName<private> : billboard_device = billboard_device{}

    @editable:
        Categories := array{ Devices_PlayerStats }
    var BillboardStats2<private> : billboard_device = billboard_device{}

    @editable:
        Categories := array{ Devices_PlayerStats }
    var KillsButtonDebug<private> : button_device = button_device{}

    @editable:
        Categories := array{ Devices_PlayerStats }
    var PrestigeButtonDebug<private> : button_device = button_device{}

    @editable:
        Categories := array{ Devices_PlayerStats }
    var PropLettersToHide<private> : []creative_prop = array{}

    @editable:
        Categories := array{ Devices_PlayerStats }
    PlayerStatsRankIcon<private> : creative_prop = creative_prop{}


    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        PlayerStatsRankIcon.Hide()
        
        KillsButtonDebug.InteractedWithEvent.Subscribe(OnPlayerAddsAKill)
        PrestigeButtonDebug.InteractedWithEvent.Subscribe(OnPlayerAddsAPrestige)
        ButtonForStats.InteractedWithEvent.Subscribe(OnStatsButtonIsPressed)

        for(PropLetterToHide : PropLettersToHide):
            PropLetterToHide.Hide()

        BillboardStats.HideText()
        BillboardPlayerName.HideText()
        BillboardStats2.HideText()

        
    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
            set MaybeMainRankManager = DependencyInjector.GetMainRankManager()
        else:
            Print(
                "Dependency Injector not available",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )

    OnPlayerAddsAKill(Agent : agent): void =
        if: 
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            PlayerData.SetPlayerKills(1)
            PlayerData.SaveDataForPlayer()


    OnPlayerAddsAPrestige(Agent : agent): void =
        if: 
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            PlayerData.SetPlayerPrestige(1)
            PlayerData.SaveDataForPlayer()


    OnStatsButtonIsPressed(Agent : agent): void =
        if: 
            GameManager := MaybeGameManager?
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            PlayerData := MaybePlayerData?
        then:
            PlayerData.LoadSaveDataForPlayer()

            for(PropLetterToHide : PropLettersToHide):
                PropLetterToHide.Show() 

            PlayerStatsRef.Register(Agent)

            # PlaytimeSecondsFloat := PlayerData.GetPlaytimeSeconds()

            # if(PlaytimeSecondsInt := Floor[PlaytimeSecondsFloat]):
            BillboardStats.SetText(
                PlayerBillboardText(
                    PlayerData.GetPlayerKills(),  
                    PlayerData.GetPlayerPrestige(), 
                    PlayerData.GetHighestEverKillstreak(), 
                    PlayerData.GetPlayerDeaths()
                )
            )

                BillboardStats.ShowText()
                BillboardPlayerName.SetText(Message1(Agent))
                BillboardPlayerName.ShowText()
                ShowPlayerRankIcon(Agent, PlayerStatsRankIcon)

            PlayerTotalAssists := PlayerData.GetPlayerAssits()
            BillboardStats2.SetText(PlayerBillboardText2(PlayerTotalAssists))
            BillboardStats2.ShowText()



    ShowPlayerRankIcon(Agent : agent, RankIconCreativeProp : creative_prop): void=
        if(GameManager := MaybeGameManager?, MainRankManager := MaybeMainRankManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent)
            var MaybeRankMat : ?material = false

            if(PlayerData := MaybePlayerData?):
                CurrentPlayerRank := PlayerData.GetPlayerRank()

                case(CurrentPlayerRank):
                    0 =>
                        set MaybeRankMat = MainRankManager.UnrankedIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.Show()
                            RankIconCreativeProp.SetMaterial(RankMat)
                    1 =>
                        set MaybeRankMat = MainRankManager.BronzeIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.Show()
                            RankIconCreativeProp.SetMaterial(RankMat)
                    2 =>
                        set MaybeRankMat = MainRankManager.SilverIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.Show()
                            RankIconCreativeProp.SetMaterial(RankMat)
                    3 =>
                        set MaybeRankMat = MainRankManager.GoldIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.Show()
                            RankIconCreativeProp.SetMaterial(RankMat)
                    4 =>
                        set MaybeRankMat = MainRankManager.PlatinumIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.Show()
                            RankIconCreativeProp.SetMaterial(RankMat)
                    5 =>
                        set MaybeRankMat = MainRankManager.DiamondIconMat
                        if(RankMat := MaybeRankMat?):
                            RankIconCreativeProp.Show()
                            RankIconCreativeProp.SetMaterial(RankMat)
                    _=>
                        Print(
                            "Rank Index passed in to set the PlayerReference RankIcon Image is invalid!", 
                            ?Duration := 8.0, 
                            ?Color := NamedColors.Red
                        )


    PlayerBillboardText<localizes>(Kills : int, Prestige : int,  Killstreak : int,  Deaths: int) : message=
        "{Kills}\n{Prestige}\n{Killstreak}\n{Deaths}"

    PlayerBillboardText2<localizes>(Assists : int): message =
        "{Assists}"



