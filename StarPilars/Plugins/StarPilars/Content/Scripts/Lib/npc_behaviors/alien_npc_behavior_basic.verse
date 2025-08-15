using { /Fortnite.com }
using { /Fortnite.com/AI }
using { /Fortnite.com/Animation/PlayAnimation }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/SpatialMath }
using { GameAreas }
using { MainScripts }
using{ Lib }


Alien_NPC_Devices<localizes>:message = "Devices"
Alien_NPC_Config<localizes>:message = "Configuration"


alien_npc_behavior_basic<public> := class(npc_behavior):

    @editable:
    var PillarArenaFloorDevices<private> : []volume_device = array{}

    var AttackAnim1<private> : animation_sequence = Animations_NPC.Alien_Anim_AlienArmature_Alien_SwordSlash
    var AttackAnim2<private> : animation_sequence = Animations_NPC.Alien_Anim_AlienArmature_Alien_Punch


    var bChasingPlayer<private> : logic = false

    var AgentsToEliminate<public>:queue(agent) = queue(agent){}

    var WaitDelay : float = 1.5

    var PlayerHasTouchedFloor : event() = event(){}



    OnBegin<override>()<suspends>:void=

        # TaggedItems := FindCreativeObjectsWithTag( pillars_arena_floor_volume_devices_tag{} )
        # for:
        #     TaggedItem : TaggedItems
        #     VolumeFloorDevice := volume_device[TaggedItem]
        #     DeviceTansform := VolumeFloorDevice.GetTransform()
        #     DeviceTranslation := DeviceTansform.Translation
        # do:
        #     Print("Device location is: {DeviceTranslation}")
        #     set PillarArenaFloorDevices += array{ VolumeFloorDevice }

        Print("The length of the PillarArenaFloor Devices is {PillarArenaFloorDevices.Length}")

        for(PillarsArenaFloorDevice : PillarArenaFloorDevices):
            PillarsArenaFloorDevice.AgentEntersEvent.Subscribe(OnPlayerTouchesFloor)

        if:
            Agent := GetAgent[]
            Character := Agent.GetFortCharacter[]
            Navigatable := Character.GetNavigatable[]
            Focusable := Character.GetFocusInterface[]
            NPCAnim := Character.GetPlayAnimationController[]
        then:    
            loop:
                if:
                    DequeueResult := AgentsToEliminate.Dequeue[]
                    set AgentsToEliminate = DequeueResult(0) # Returns the queue with the first element removed
                    AgentToEliminate := DequeueResult(1) # Returns the agent thats at the front of the queue
                then:
                    Print("Following player now")
                    FollowAndEliminatePlayer(Navigatable, Focusable, Character, NPCAnim, AgentToEliminate)
                else:
                    Sleep(WaitDelay)
                    Print("Awaiting Player Has Touched Floor")
                    PlayerHasTouchedFloor.Await()


                    
    OnPlayerTouchesFloor(EnteredAgent : agent): void =
        # if:
        #     Agent := GetAgent[]
        #     Character := Agent.GetFortCharacter[]
        #     Navigatable := Character.GetNavigatable[]
        #     Focusable := Character.GetFocusInterface[]
        #     NPCAnim := Character.GetPlayAnimationController[]
        # then:
        #     spawn{ FollowAndEliminatePlayer(Navigatable, Focusable, Character, NPCAnim, EnteredAgent) }

        if (EnteredAgent <> GetAgent[]):
            set AgentsToEliminate = AgentsToEliminate.Enqueue(EnteredAgent)
            PlayerHasTouchedFloor.Signal()



    FollowAndEliminatePlayer(Navigatable : navigatable, Focusable : focus_interface, NPCChar : fort_character, NPCAnimController : play_animation_controller, EnteredAgent : agent)<suspends>: void =
        if(bChasingPlayer = true):
            return

        set bChasingPlayer = true

        loop:
            Sleep(0.1)
            if:
                # PillarArenaFloorDevice.IsInVolume[EnteredAgent]
                TargetChar := EnteredAgent.GetFortCharacter[]
            then:
                #Print("Character is in volume, NPC Moving to them now!!")
                NavigationTarget := MakeNavigationTarget(EnteredAgent)

                DistanceDifference := Distance( NPCChar.GetTransform().Translation, TargetChar.GetTransform().Translation )

                if(DistanceDifference <= 250.0):
                    Sleep(1.0)
                    RandomIndex := GetRandomInt(0, 1)
                    if(RandomIndex = 0):
                        NPCAnimController.Play(AttackAnim1)
                    else:
                        NPCAnimController.Play(AttackAnim2)
                        
                    Sleep(1.0)
                    TargetChar.Damage(1000.0)
                    set bChasingPlayer = false
                    break

                Result := Navigatable.NavigateTo(NavigationTarget, ?ReachRadius := 150.0)
                spawn{ Focusable.MaintainFocus(EnteredAgent) } 


    OnEnd<override>():void=
        # TODO: Replace this with your code
        Print("Goodbye, NPC!")