
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { /Verse.org/Random }

player_controller := class(creative_device):

    var CurrentCookieCount : int = 0

    @editable
    var CookieSignalManagerDevice : signal_remote_manager_device = signal_remote_manager_device{}
    @editable
    var HUDCookieMessage : hud_message_device = hud_message_device{}


    OnBegin<override>()<suspends>:void=
        Print("Hi")
        # CookieSignalManagerDevice.PrimarySignalEvent.Subscribe(Show1stCookieHUD)

    # Show1stCookieHUD(Agent : agent): void= 
    #     # HUDCookieMessage.Show();
    #     set CurrentCookieCount += 1
