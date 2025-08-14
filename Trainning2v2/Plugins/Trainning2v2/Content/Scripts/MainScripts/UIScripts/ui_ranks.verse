using { /Fortnite.com/Devices }
using { /Fortnite.com/UI}
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { CustomProps }


ui_ranks<public> := class(creative_device):
 
    @editable
    MaybeDependencyInjector<private> : ?dependency_injector = false
    var MaybeGameManager<private>: ?game_manager = false

    var PlayerWidgetsMap<private> : [player]player_widgets = map{}


    OnBegin<override>()<suspends>:void=
        SetupDependencies()


    Init<public>(Player : player) : void =
        InitializePlayerUI(Player)


    InitializePlayerUI(Player : player) : void =
        Canvas : canvas = canvas{}
        ProgressBar : custom_progress_bar = custom_progress_bar{Width := 300.0, Heigth := 32.0}
        #Initialize the progress bar
        ProgressBar.Init()
        CanvasSlot := canvas_slot:
            Widget := ProgressBar.GetRootWidget()
            Anchors := anchors{Minimum := vector2{X:=0.0, Y:=1.0}, Maximum := vector2{X:=0.0, Y:=1.0}}
            Offsets := margin{Left :=115.0, Top := -250.0}
        Canvas.AddWidget(CanvasSlot)
        PlayerWidgets := player_widgets:
            Canvas := Canvas
            ProgressBar := ProgressBar

        if(set PlayerWidgetsMap[Player]= PlayerWidgets, PlayerUI := GetPlayerUI[Player]):
            PlayerUI.AddWidget(Canvas)


    InitRankUI<public>(Player : player, RankSettings : rank_settings) : void=
        
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            if:
                PlayerData := MaybePlayerData?
            then:
                UpdateRank(Player, RankSettings)


    UpdateRank<public>(Player : player, RankSettings : rank_settings) : void=
         
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            if:
                PlayerData := MaybePlayerData?
            then:
                RankIndex := PlayerData.GetPlayerRank()
                if(Widgets := PlayerWidgetsMap[Player], NewRank := RankSettings.Ranks[RankIndex], Image := RankSettings.Images[RankIndex])
                then:
                    Widgets.ProgressBar.SetForeGroundColor(NewRank.ForegroundColor)
                    Widgets.ProgressBar.SetBackGroundColor(NewRank.BackgroundColor)
                    Widgets.ProgressBar.SetRankText(NewRank.Name)
                    Widgets.ProgressBar.SetImage(Image, NewRank.ImageSize)
                    UpdateProgress(Player, RankSettings)
                    
                    
    UpdateProgress<public>(Player : player, RankSettings : rank_settings) : void=
        if(GameManager := MaybeGameManager?):
            MaybePlayerData := GameManager.GetMaybePlayerData(Player)
            if:
                PlayerData := MaybePlayerData?
            then:
                RankIndex := PlayerData.GetPlayerRank()
                if(Widgets := PlayerWidgetsMap[Player], CurrentRank := RankSettings.Ranks[RankIndex]):
                    if(NextRank := RankSettings.Ranks[RankIndex +1]):
                        Progress := 1.0 * (PlayerData.GetPlayerPrestige() - CurrentRank.PointsNeeded) / (1.0 * (NextRank.PointsNeeded - CurrentRank.PointsNeeded))
                        ProgressText := "{PlayerData.GetPlayerPrestige()} / {NextRank.PointsNeeded}"
                        Widgets.ProgressBar.SetProgress(Progress, ProgressText) 
                    else:
                        Progress := 1.0
                        ProgressText := "{PlayerData.GetPlayerPrestige()}"
                        Widgets.ProgressBar.SetProgress(Progress, ProgressText)

    
    SetupDependencies():void=
        if:
            DependencyInjector := MaybeDependencyInjector?
        then:
            set MaybeGameManager = DependencyInjector.GetGameManager()
        else:
            Print(
                "Dependency Injector not available",
                ?Duration := 4.0,
                ?Color := NamedColors.Red
            )

player_widgets := struct:
    Canvas : canvas
    ProgressBar : custom_progress_bar

            
custom_progress_bar<public> := class :
    Width : float = 0.0
    Heigth : float = 0.0

    RankTextureBlock : texture_block = texture_block{DefaultImage := CustomProps.Unranked}
    ColorBlockForeground : color_block = color_block{}
    ColorBlockBackground : color_block = color_block{}
    RanktextBlock : text_block = text_block{DefaultTextColor := NamedColors.White}
    ProgressTextBlock : text_block = text_block{DefaultTextColor := NamedColors.White}

    var RootWidget : widget = color_block{}

    Init() : void =
        ColorBlockForeground.SetDesiredSize(vector2{X:=Width, Y:=Heigth})
        ColorBlockBackground.SetDesiredSize(vector2{X:=Width, Y:=Heigth})
        set RootWidget = overlay:
            Slots:= array:
                overlay_slot:
                    Widget:= RankTextureBlock
                    HorizontalAlignment := horizontal_alignment.Center
                    Padding := margin{Right := 210.0}
                overlay_slot:
                    Widget:= stack_box:
                        Orientation := orientation.Vertical
                        Slots:= array:
                            stack_box_slot:
                                Widget:= RanktextBlock
                                HorizontalAlignment := horizontal_alignment.Center
                            stack_box_slot:
                                Widget:= overlay:
                                    Slots:= array:
                                        overlay_slot:
                                            Widget:= ColorBlockBackground
                                            HorizontalAlignment := horizontal_alignment.Left
                                        overlay_slot:
                                            Widget:= ColorBlockForeground
                                            HorizontalAlignment := horizontal_alignment.Left
                                        overlay_slot:
                                            Widget:= ProgressTextBlock
                                            HorizontalAlignment := horizontal_alignment.Center

    SetProgress(InProgress : float, ProgressText : string) : void =
        var NewProgress : float = 0.0
        if(InProgress > 1.0) then set NewProgress = 1.0
        else if(InProgress < 0.0) then set NewProgress = 0.0
        else set NewProgress = InProgress

        NewWidth := NewProgress * Width
        ColorBlockForeground.SetDesiredSize(vector2{X:=NewWidth, Y:=Heigth})
        SetProgressText(ProgressText)

    GetRootWidget() : widget = RootWidget                                        
    SetForeGroundColor(Color : color) : void =
        ColorBlockForeground.SetColor(Color)    
    SetBackGroundColor(Color : color) : void =
        ColorBlockBackground.SetColor(Color)
    SetRankText(String : string) : void =
        RanktextBlock.SetText(StringToMessage(String))
    SetProgressText(String : string) : void =
        ProgressTextBlock.SetText(StringToMessage(String))
    SetImage(NewImage : texture, NewSize : vector2) : void =
        RankTextureBlock.SetImage(NewImage)
        RankTextureBlock.SetDesiredSize(NewSize)

StringToMessage<localizes>(String : string) : message = "{String}"
    
