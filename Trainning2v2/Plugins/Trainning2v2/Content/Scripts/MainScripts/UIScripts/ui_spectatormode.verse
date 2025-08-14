using { /Fortnite.com/Devices }
using { /Fortnite.com/FortPlayerUtilities }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }


ui_spectatormode<public> := class(base_ui):

    ExitText<localizes> : message = "Exit"
    ButtonExit : button_loud = button_loud{}

    CreateCanvas<override>():void=
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{ X:= 0.5, Y:= 1.0}, Maximum := vector2{X:= 0.5, Y:= 1.0} }
                    Offsets := margin{Left := -5.883865, Top := -185.057022, Right := 254.154144, Bottom := 88.048065}
                    Alignment := vector2{X:= 0.5, Y:= 0.5}
                    ZOrder := 2
                    SizeToContent := false
                    Widget := ButtonExit

        ButtonExit.SetText(ExitText)
        ButtonExit.OnClick().Subscribe(OnExitClicked)


    OnExitClicked(WidgetPlayer : widget_message): void =
        if:
            PlayerData:=MaybePlayerData?
            EventMediator:=PlayerData.GameManager.EventMediator
            Player := WidgetPlayer.Player
            RespawningLocation := PlayerData.RespawningLocationSpectator
            # DefaultClassSelector := PlayerData.DefaultClassAndTeamSelector?
        then:
            PlayerData.HideSpectatorUI()
            Player.Respawn(RespawningLocation, IdentityRotation())
            # DefaultClassSelector.ChangeTeamAndClass(Player)

            