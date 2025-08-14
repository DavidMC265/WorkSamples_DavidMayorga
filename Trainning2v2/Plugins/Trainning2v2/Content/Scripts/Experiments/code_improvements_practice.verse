using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors/NamedColors }
using { /Verse.org/Simulation }



PlayerRanks<public>:= enum{ None, Unranked, Bronze, SilverTier, GoldTier, Platinum, Diamond }



code_improvements_practice := class(creative_device):
    

    var MaybePlayerRank : ?PlayerRanks = false

    @editable
    BronzeRankButton : button_device = button_device{}

    @editable
    SilverRankButton : button_device = button_device{}

    @editable
    GetPlayerCurrentRankButton : button_device = button_device{}

    @editable
    IncrementPlayerRankButton : button_device = button_device{}

    # var TycoonAreasArray : []EventAreas = array{
    #     EventAreas.Quarry, 
    #     EventAreas.Forge, 
    #     EventAreas.Garden, 
    #     EventAreas.Clinic, 
    #     EventAreas.Kitchen, 
    #     EventAreas.Research
    # }

    OnBegin<override>()<suspends>:void=
        BronzeRankButton.InteractedWithEvent.Subscribe(OnBronzeRankButtonhPressed)
        SilverRankButton.InteractedWithEvent.Subscribe(OnSilverRankButtonPressed)
        GetPlayerCurrentRankButton.InteractedWithEvent.Subscribe(GetPlayerRank)
        IncrementPlayerRankButton.InteractedWithEvent.Subscribe(IncrementPlayerRank)


    OnBronzeRankButtonhPressed(Agent : agent): void =
        Print("Player rank set to Bronze")
        set MaybePlayerRank = option{ PlayerRanks.Bronze }

    OnSilverRankButtonPressed(Agent : agent): void =
        Print("Player rank set to Silver")
        set MaybePlayerRank = option{ PlayerRanks.SilverTier}


    GetPlayerRank(Agent : agent): PlayerRanks =
        if(PlayerRank := MaybePlayerRank?):
            case(PlayerRank):
                PlayerRanks.Unranked =>
                    Print("CurrentRank is Unranked")

                PlayerRanks.Bronze => 
                    Print("CurrentRank is Bronze")

                PlayerRanks.SilverTier =>
                    Print("CurrentRank is Silver")

                PlayerRanks.GoldTier =>
                    Print("CurrentRank is Gold")
                
                PlayerRanks.Platinum =>
                    Print("CurrentRank is Platinum")

                PlayerRanks.Diamond =>
                    Print("CurrentRank is Diamond")

                _=>
                    Print("PlayerRank is somehow not valid!!!")

            return PlayerRank
        else:
            return PlayerRanks.None


    IncrementPlayerRank(Agent :agent): void=
        if(CurrentPlayerRank := MaybePlayerRank?):
            case(CurrentPlayerRank):

                PlayerRanks.Unranked =>
                    Print("CurrentRank is Unranked, need to upgrade to Bronze")

                PlayerRanks.Bronze => 
                    Print("CurrentRank is Bronze, need to upgrade to Silver")

                PlayerRanks.SilverTier =>
                    Print("CurrentRank is Silver, need to upgrade to Gold")

                PlayerRanks.GoldTier =>
                    Print("CurrentRank is Gold, need to upgrade to Platinum")
                
                PlayerRanks.Platinum =>
                    Print("CurrentRank is Platinum, need to upgrade to Diamond")

                PlayerRanks.Diamond =>
                    Print("CurrentRank is Diamond, cannot upgrade anymore")

                _=>
                    Print("CurrentRank is somehow not valid!!!")


    DecrementPlayerRank(): void =
        Print("ok")
