using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Verse.org/Assets }
using { /Fortnite.com/UI }

WelcomeUI := class:
    var WelcomeCanvas : canvas = canvas{}
    var ExitButton : button_loud = button_loud{}
    var WelcomeBackground : texture_block = texture_block{DefaultImage := UI.WelcomeTemplate}

    var Title : text_block = text_block{}
    var Title2 : text_block = text_block{}

    var Description1 : text_block = text_block{}
    var Description2 : text_block = text_block{}
    var Description3 : text_block = text_block{}
    var Description4 : text_block = text_block{}

    StringToMessage<localizes>(String : string) : message = "{String}"
    
    GetWelcomeUI(): canvas =
        WelcomeCanvas.AddWidget(canvas_slot:
            Widget := WelcomeBackground
            Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}}
            Offsets := margin{Left:= 11.953552, Top := -0.836797, Right := 1433.828979, Bottom:= 1061.821777}
            Alignment := vector2{X:= 0.5, Y:= 0.5}
            SizeToContent := false
            ZOrder := 0
        )
        WelcomeCanvas.AddWidget(canvas_slot:
            Widget := Title
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}}
            Offsets := margin{Left := 776.000000, Top := 188.000000, Right := 166.201202, Bottom:= 113.072075}
            Alignment := vector2{X:= 0.0, Y:= 0.0}
            SizeToContent := true
            ZOrder := 1
        )
        WelcomeCanvas.AddWidget(canvas_slot:
            Widget := Title2
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}}
            Offsets := margin{Left := 840.000000, Top := 240.000000, Right := 165.000000, Bottom:= 41.000000}
            Alignment := vector2{X:= 0.0, Y:= 0.0}
            SizeToContent := true
            ZOrder := 1
        )
        WelcomeCanvas.AddWidget(canvas_slot:
            Widget := Description1
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}}
            Offsets := margin{Left := 520.000000, Top := 408.000000, Right := 165.000000, Bottom:= 432.725830}
            Alignment := vector2{X:= 0.0, Y:= 0.0}
            SizeToContent := true
            ZOrder := 1
        )
        WelcomeCanvas.AddWidget(canvas_slot:
            Widget := Description2
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}}
            Offsets := margin{Left := 528.000000, Top := 464.000000, Right := 165.000000, Bottom:= 432.725830}
            Alignment := vector2{X:= 0.0, Y:= 0.0}
            SizeToContent := true
            ZOrder := 1
        )
        WelcomeCanvas.AddWidget(canvas_slot:
            Widget := Description3
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}}
            Offsets := margin{Left := 516.000000, Top := 524.000000, Right := 165.000000, Bottom:= 432.725830}
            Alignment := vector2{X:= 0.0, Y:= 0.0}
            SizeToContent := true
            ZOrder := 1
        )
        WelcomeCanvas.AddWidget(canvas_slot:
            Widget := Description4
            Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 0.0, Y:= 0.0}}
            Offsets := margin{Left := 532.000000, Top := 584.000000, Right := 165.000000, Bottom:= 432.725830}
            Alignment := vector2{X:= 0.0, Y:= 0.0}
            SizeToContent := true
            ZOrder := 1
        )
        WelcomeCanvas.AddWidget(canvas_slot:
            Widget := ExitButton
            Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}}
            Offsets := margin{Left := -289.768616, Top := 286.577698, Right := 262.384613, Bottom:= 54.236458}
            Alignment := vector2{X:= 0.5, Y:= 0.5}
            SizeToContent := false
            ZOrder := 1
        )

        ExitButton.OnClick().Subscribe(HandleExit)
        ExitButton.SetText(StringToMessage("Lets Go"))

        Title.SetText(StringToMessage("Welcome to the Cookie"))
        Title.SetTextColor(NamedColors.White)
        Title2.SetText(StringToMessage("Tycoon Clicker!"))
        Title2.SetTextColor(NamedColors.White)

        Description1.SetText(StringToMessage("Tap, bake and build to create the ultimate cookie business."))
        Description1.SetTextColor(NamedColors.White)
        Description2.SetText(StringToMessage("Construct your factory from the start, use your cookie "))
        Description2.SetTextColor(NamedColors.White)

        Description3.SetText(StringToMessage("clicker and take on the evil zombies in the Zombie zone to"))
        Description3.SetTextColor(NamedColors.White)
        Description4.SetText(StringToMessage("obtain cookies and claim your title as the ultimate king!"))
        Description4.SetTextColor(NamedColors.White)

        return WelcomeCanvas


    HandleExit(Message : widget_message): void=
        Player := Message.Player
        if(PlayerUI := GetPlayerUI[Player]):
            PlayerUI.RemoveWidget(WelcomeCanvas)
        

# ZombieZoneUI := class:
#     var ZombieZoneCanvas : canvas = canvas{}
#     var TimeRemainingForWaveText : text_block = text_block{}
            
#     StringToMessage<localizes>(String : string) : message = "{String}"
    
#     GetZombieZoneUI(): canvas =
#         ZombieZoneCanvas.AddWidget(canvas_slot:
#             Widget := TimeRemainingForWaveText
#             Anchors := anchors{Minimum := vector2{X:= 0.5, Y:= 0.5}, Maximum := vector2{X:= 0.5, Y:= 0.5}}
#             Offsets := margin{Left:= 0.0, Top := -350.0, Right := 200.0, Bottom:= 60.0}
#             Alignment := vector2{X:= 0.5, Y:= 0.5}
#             SizeToContent := true
#             ZOrder := 2
#         )

#         TimeRemainingForWaveText.SetText(StringToMessage("Time before next wave"))
#         TimeRemainingForWaveText.SetTextColor(NamedColors.White)


#         return ZombieZoneCanvas
 

UIManager := class(creative_device) {
    @editable var HUDCookieMessage : hud_message_device = hud_message_device{}

    var AmountOfCoinsImage : texture = UI.CookieCurrency

    var AddToCurrentCookiesText : text_block = text_block{DefaultTextColor := NamedColors.White}

    StringToMessage< localizes>(value:string) : message = "{value}"

    # var MaybeMyUIZonePerPlayer : [player]?ZombieZoneUI = map{}


    var AmountOfGoldText : text_block = text_block {
        DefaultTextColor := MakeColorFromHex("FFEDB8FF")
    }

    OpenWelcomeUI<public>(Agent : agent): void =
        if(Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            NewWelcome : WelcomeUI = WelcomeUI{}
            PlayerUI.AddWidget(
                NewWelcome.GetWelcomeUI(), 
                player_ui_slot{InputMode := ui_input_mode.All}
            )


    Init(Player : player) : void = {
        if (PlayerUI := GetPlayerUI[Player]) {
            PlayerUI.AddWidget(AddCookieCurrency())
        }
    }

    UpdateGoldText(Player : player, Change : int): void = {
        AmountOfGoldText.SetText(StringToMessage(AbbreviateNumber((Change) * 1.0)))
    }

    UpdateCookiesToAddText<public>(Player : player, NewInt : int)<suspends>: void =
        if(PlayerUI := GetPlayerUI[Player]):
            PlayerUI.AddWidget(AddToCurrentCookieCurrency())
            AddToCurrentCookiesText.SetVisibility(widget_visibility.Visible)
            AddToCurrentCookiesText.SetText(StringToMessage("+{NewInt}"))
            Sleep(1.0)
            AddToCurrentCookiesText.SetVisibility(widget_visibility.Hidden)
        
    AbbreviateNumber(value:float) : string = {
        if (value >= 1000000000.0) {
            return ToTruncatedString(value / 1000000000.0, 2) + "B"
        } else if (value >= 1000000.0) {
            return ToTruncatedString(value / 1000000.0, 2) + "M"
        } else if (value >= 1000.0) {
            return ToTruncatedString(value / 1000.0, 2) + "K"
        } else {
            return ToTruncatedString(value, 0)
        }
    }

    # ShowCookieHUD<public>(Agent : agent): void= 
    #     HUDCookieMessage.Show();

    ToTruncatedString< public>(Number:float, Decimals:int):[]char=
        var Str:[]char = ToString(Number)
        if:
            DotIndex := Str.Find['.']
            StopIndex := if (Decimals > 0) then Min(DotIndex+Decimals+1,Str.Length) else DotIndex
            if (StrT := Str.Slice[0, StopIndex]) {
                set Str = StrT
            }
        return Str

    AddCookieCurrency() : canvas = {
        NewCanvas := canvas{
            Slots := array {
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 215.328186, Top := 152.502792, Right := 470.656372, Bottom := 298.086639}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    ZOrder := 0
                    Widget := texture_block:
                        DefaultImage := AmountOfCoinsImage
                }
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 192.000000, Top := 115.459473, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    ZOrder := 1
                    Widget := AmountOfGoldText
                }      
            }
        }
    }

    AddToCurrentCookieCurrency() : canvas = {
        NewAddedCanvas := canvas{
            Slots := array {
                canvas_slot {
                    Widget := AddToCurrentCookiesText
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Left := 380.000000, Top := 115.459473, Right := 165.000000, Bottom := 41.000000}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    ZOrder := 2
                } 
            }
        }
    }

    # OpenOrCloseZombieZoneUI<public>(Agent : agent): void =
    #     if(Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
    #         if(MyZombieUI := MaybeMyUIZonePerPlayer[Player]?):
    #             PlayerUI.RemoveWidget(MyZombieUI.GetZombieZoneUI())
    #             if(set MaybeMyUIZonePerPlayer[Player] = false) {}
            
    #         else:
    #             NewZombieZoneUI : ZombieZoneUI = ZombieZoneUI{}
    #             PlayerUI.AddWidget(NewZombieZoneUI.GetZombieZoneUI())
    #             if(set MaybeMyUIZonePerPlayer[Player] = option{NewZombieZoneUI} ) {}

}