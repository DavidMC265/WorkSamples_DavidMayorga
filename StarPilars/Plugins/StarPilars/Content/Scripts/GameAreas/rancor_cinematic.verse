using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using {/Verse.org/Random }
using { /Verse.org/Simulation }
using { Lib }
using { MainScripts }


Rancor_Cinematic_DependecyInjector<localizes>:message = "Dependency Injector"

rancor_cinematic := class(creative_device):

    #Dependencies
    @editable:
        Categories := array{ Rancor_Cinematic_DependecyInjector }
    var MaybeDependencyInjector<private> : ?dependency_injector = false

    var MaybePillarsManager<private> : ?pillars_manager = false
    var MaybeHatStore<private>: ?hat_store = false
    var MaybeGameManager<private> : ?game_manager = false

    @editable:
    CinematicChairs : []chair_device = array{}
    @editable:
    Cinematics : []cinematic_sequence_device = array{}
    @editable:
    ArenaFloor : volume_device = volume_device{}
    

    OnBegin<override>()<suspends>:void=
        SetupDependencies()

        ArenaFloor.AgentEntersEvent.Subscribe(CheckChair)
        for(idx->Cinematic : Cinematics):
            Cinematic.StoppedEvent.SubscribeEmpty(KillPlayer, idx)


    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybePillarsManager = DependencyInjector.GetPillarsManager()
            set MaybeHatStore = DependencyInjector.GetHatStore()
            set MaybeGameManager = DependencyInjector.GetGameManager()
        else:
            Print(
                "Dependency Injector not available from lobby_controller script",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )


    CheckChair(Agent : agent):void =
        if:
            GameManager := MaybeGameManager?,
            MaybePlayerData := GameManager.GetMaybePlayerData(Agent),
            PillarsManager := MaybePillarsManager?, 
            Player := player[Agent],
            HatStore := MaybeHatStore?
            PlayerData := MaybePlayerData?
        then:
            PlayerHasFallen := PlayerData.GetHasFallen()
            if(PlayerHasFallen = true):
                return

            PlayerData.SetHasFallen(true)
            PillarsManager.RemoveItemTimerForPlayer(Player)
            #Remove PlayersHat if they are wearing one
            Print("Hat removed from player", ?Duration := 4.0,?Color := NamedColors.Orange)
            HatStore.RemoveHatTrigger.Trigger(Player)

            RandomChairInfo := GetRandomChair()
            #seat the agent in the chair and play the corresponding cinematic
            RandomChairInfo(0).Seat(Agent)
            RandomChairInfo(1).Play(Agent)

    KillPlayer(Index : int):void=
        Print("Index:{Index}", ?Duration := 5.0,?Color := NamedColors.Green)
        if(Chair := CinematicChairs[Index]):
            MaybePlayer := Chair.GetSeatedAgent()
            if:
                SeatedAgent := MaybePlayer?
                FortCharacter := SeatedAgent.GetFortCharacter[]
            then:
                Chair.Eject(SeatedAgent)
                Print("Kill Player", ?Duration := 4.0,?Color := NamedColors.Orange)
                FortCharacter.Damage(1000.0)

    GetRandomChair():tuple(chair_device, cinematic_sequence_device)=
        var ChairInfo : tuple(chair_device, cinematic_sequence_device) = (chair_device{}, cinematic_sequence_device{})
        for:
            Chair : CinematicChairs
            RandomChairIdx := GetRandomInt(0, CinematicChairs.Length - 1)
            CinematicSequence := Cinematics[RandomChairIdx]
            RandomChair := CinematicChairs[RandomChairIdx]
            not RandomChair.IsOccupied[]
        do:
            Print("Index of chair founded: {RandomChairIdx}", ?Duration := 4.0,?Color := NamedColors.Yellow)
            for:
                idx -> ChairElement : CinematicChairs
                idx = RandomChairIdx
            do:
                if(ChairSelected := CinematicChairs[RandomChairIdx], CinematicSelected := Cinematics[RandomChairIdx]):

            set ChairInfo = (RandomChair, CinematicSequence)
            return ChairInfo

        return ChairInfo
   
        


                
                


            