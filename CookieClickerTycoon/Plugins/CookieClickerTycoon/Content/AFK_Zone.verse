using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }


AFK_Zone := class(creative_device):

    @editable 
    var AFKMutatorZone : mutator_zone_device = mutator_zone_device{}

    var HasPlayerEnteredZone : logic = false

    @editable
    GameManagerInst : game_manager = game_manager{}


    OnBegin<override>()<suspends>:void=
        AFKMutatorZone.AgentBeginsEmotingEvent.Subscribe(BeginAFKGrant)
        AFKMutatorZone.AgentEndsEmotingEvent.Subscribe(StopGrantingCookies)


    BeginAFKGrant(Agent : agent):void=
        spawn:
            GrantCookiesEverySecond(Agent)


    GrantCookiesEverySecond(Agent : agent)<suspends>: void =
        set HasPlayerEnteredZone = true
        loop:
            if(HasPlayerEnteredZone = true):
                if(Player := player[Agent]):
                    GameManagerInst.HandleCookieUpdateAndDisplay(Agent)
                    Sleep(1.0)
            else if(HasPlayerEnteredZone = false):
                break

        
    StopGrantingCookies(Agent : agent): void = 
        set HasPlayerEnteredZone = false