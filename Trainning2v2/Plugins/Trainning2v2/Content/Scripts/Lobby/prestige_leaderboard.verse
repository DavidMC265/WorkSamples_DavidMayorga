
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors }
using { MainScripts }
using { Lib }



prestige_leaderboard := class(creative_device):
  @editable
  LeaderBoardSheets : []creative_prop = array{}
  @editable
  NextButton : button_device = button_device{}
  @editable
  PrevButton : button_device = button_device{}
  @editable
  var CurrentSheet : int = 0

  # Runs when the device is started in a running game
  OnBegin<override>()<suspends>:void=
    HideSheets()
    if(Sheet := LeaderBoardSheets[CurrentSheet]):
      Sheet.Show()
    NextButton.InteractedWithEvent.Subscribe(NextSheet)

    PrevButton.InteractedWithEvent.Subscribe(PrevSheet)
   
  
  NextSheet(Agent:agent):void=
    set CurrentSheet += 1
    Print("CurrentIndex:{CurrentSheet}",?Duration := 4.0,?Color := NamedColors.Orange)
    if(CurrentSheet >= LeaderBoardSheets.Length):
      set CurrentSheet = 0

    if(Sheet := LeaderBoardSheets[CurrentSheet]):
      HideSheets()
      Sheet.Show()

  PrevSheet(Agent:agent):void=
    set CurrentSheet -= 1
    Print("CurrentIndex:{CurrentSheet}",?Duration := 4.0,?Color := NamedColors.Orange)

    if(CurrentSheet < 0):
      set CurrentSheet = LeaderBoardSheets.Length

    if(Sheet := LeaderBoardSheets[CurrentSheet]):
      HideSheets()
      Sheet.Show()

  HideSheets():void=
    for(Sheet : LeaderBoardSheets):
      Sheet.Hide()
          


  
      
    
   