
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


Debug_button1 := class(creative_device):
    @editable GameManager : game_manager = game_manager{}
    @editable ButtonForCookiesGrant : button_device = button_device{}
    @editable SecondButtonForCookiesGrant : button_device = button_device{}

    @editable CookiesToGrant : int = 5000;
    @editable CookiesToGrantSecondButton : int = 100;

    OnBegin<override>()<suspends>:void=
        ButtonForCookiesGrant.InteractedWithEvent.Subscribe(ButtonPressEvent)
        SecondButtonForCookiesGrant.InteractedWithEvent.Subscribe(SecondPressEvent)

    ButtonPressEvent(Agent : agent): void =
        GrantCookies(CookiesToGrant)

    SecondPressEvent(Agent : agent): void =
        GrantCookies(CookiesToGrantSecondButton)

    GrantCookies(CookieAmount : int): void = 
        set GameManager.CurrentCookieCount += CookieAmount