using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }


minigames_manager := class(creative_device):

    @editable GameManager : game_manager = game_manager{}

    @editable WelcomingZone : mutator_zone_device = mutator_zone_device{}
    @editable Dialogue : popup_dialog_device = popup_dialog_device{}

    @editable Minigame1 : skilled_interaction_device = skilled_interaction_device{}
    @editable ButtonMiniGame1 : button_device = button_device{}

    @editable Minigame2 : skilled_interaction_device = skilled_interaction_device{}
    @editable ButtonMiniGame2 : button_device = button_device{}

    @editable Minigame3 : skilled_interaction_device = skilled_interaction_device{}
    @editable ButtonMiniGame3 : button_device = button_device{}

    @editable var PerfectInputCookiesToGrant : int = 50
    @editable var GoodInputCookiesToGrant : int = 20

    @editable var PercentageToSubtract : int = 20

    var HasEnteredInitialZone : logic = false
    var TotalAmount1 : int = 1
    var TotalAmount2 : int = 1
    var TotalAmount3 : int = 1

    OnBegin<override>()<suspends>:void=
        WelcomingZone.AgentEntersEvent.Subscribe(WelcomingAction)

        ButtonMiniGame1.InteractedWithEvent.Subscribe(PlayMinigame1)
        ButtonMiniGame2.InteractedWithEvent.Subscribe(PlayMinigame2)
        ButtonMiniGame3.InteractedWithEvent.Subscribe(PlayMinigame3)
        
        var Minigames : []skilled_interaction_device = array{Minigame1, Minigame2, Minigame3}

        for(Minigame : Minigames):
            Minigame.PerfectInputTriggeredEvent.Subscribe(GrantMaxCookies)
            Minigame.GoodInputTriggeredEvent.Subscribe(GrantCookies)
            Minigame.InteractionFailedEvent.Subscribe(SubtractCookies)

    PlayMinigame1(Agent : agent): void =
        if(Player := player[Agent], Minigame1.BeginInteraction[Player]):
            # Print("FirstGamePlayed!")

    PlayMinigame2(Agent : agent): void =
        if(Player := player[Agent], Minigame2.BeginInteraction[Player]):
            # Print("SecondGamePlayed!")

    PlayMinigame3(Agent: agent): void = 
        if(Player := player[Agent], Minigame3.BeginInteraction[Player]):
            # Print("ThirdGamePlayed!")

    GrantMaxCookies(Agent : agent, value : float): void =
        set TotalAmount1 = PerfectInputCookiesToGrant * GameManager.AmountToAddPerClick
        set GameManager.CurrentCookieCount += TotalAmount1

    SubtractCookies(Agent : agent): void = 
        if(Value : int = Floor(GameManager.CurrentCookieCount * PercentageToSubtract / 100)):
            # Print("{Value} is the percentage amount that will be subtracted!", ?Duration := 2.0, ?Color := NamedColors.Green)           
            set GameManager.CurrentCookieCount -= Value

    GrantCookies(Agent : agent, value : float): void = 
        set TotalAmount2 = GoodInputCookiesToGrant * GameManager.AmountToAddPerClick
        set GameManager.CurrentCookieCount += TotalAmount2
        
    WelcomingAction(Agent : agent): void =
        # Print("About to show the player the message on screen!", ?Duration := 2.0, ?Color := NamedColors.LightGreen)
        Dialogue.Show(Agent)
        # Dialogue.Disable()        
