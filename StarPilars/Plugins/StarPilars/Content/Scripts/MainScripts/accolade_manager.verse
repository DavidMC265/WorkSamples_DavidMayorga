using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }
using { Meshes }


AccoladeManager_DependecyInjector<localizes>:message = "Dependency Injector"
AccoladeManager_BountyHunting<localizes>:message = "Bounty Hunting"
AccoladeManager_HatStore<localizes>:message = "Hat Store"
AccoladeManager_Pickups<localizes>:message = "Pickups"
AccoladeManager_Game<localizes>: message = "Game"
AccoladeManager_MysteryBox<localizes>: message = "Mystery Box"
AccoladeManager_TimePlayed<localizes>: message = "Time Played"
AccoladeManager_Quests<localizes>: message = "Quests"
AccoladeManager_ChairSpectator<localizes>: message = "Chair Spectator"
AccoladeManager_XPShop<localizes>:message = "XP Shop"


accolade_manager<public> := class(creative_device):

    @editable:
        Categories := array {AccoladeManager_BountyHunting }
    BountyAssigner_Accolade<private> : accolades_device = accolades_device{}

    @editable:
        Categories := array {AccoladeManager_BountyHunting }
    BountyAccepter_Accolade<private> : accolades_device = accolades_device{}

    @editable:
        Categories := array { AccoladeManager_BountyHunting }
    BountySet_Accolade<private>: accolades_device = accolades_device{}

    @editable:
        Categories := array { AccoladeManager_HatStore }
    HatPurchased_Acolade<private>: accolades_device = accolades_device{}

    @editable:
        Categories := array { AccoladeManager_Pickups }
    CurrencyPickups_Accolade<private>: accolades_device = accolades_device{}

    @editable:
        Categories := array { AccoladeManager_Game }
    Elimination_Accolade<private>: accolades_device = accolades_device{}

    @editable:
        Categories := array { AccoladeManager_Game }
    GameWon_Accolade<private>: accolades_device = accolades_device{}

    @editable:
        Categories := array { AccoladeManager_MysteryBox }
    MysteryBox_Accolade<private>: accolades_device = accolades_device{}

    @editable:
        Categories := array { AccoladeManager_TimePlayed }
    TimePlayed_Accolade<private>: accolades_device = accolades_device{}

    @editable:
        Categories := array { AccoladeManager_Quests }
    QuestCompleted_Accolade<private>: accolades_device = accolades_device{} 

    @editable:
        Categories := array{ AccoladeManager_ChairSpectator }
    ChairSpectator_Accolade<private>: accolades_device = accolades_device{} 

    @editable:
        Categories := array{ AccoladeManager_XPShop }
    VerySmallXPShop_Accolade<private>: accolades_device = accolades_device{} 

    @editable:
        Categories := array{ AccoladeManager_XPShop }
    SmallXPShop_Accolade<private>: accolades_device = accolades_device{} 

    @editable:
        Categories := array{ AccoladeManager_XPShop }
    MediumXPShop_Accolade<private>: accolades_device = accolades_device{} 

    @editable:
        Categories := array{ AccoladeManager_XPShop }
    LargeXPShop_Accolade<private>: accolades_device = accolades_device{} 

    @editable:
        Categories := array{ AccoladeManager_XPShop }
    VeryLargeXPShop_Accolade<private>: accolades_device = accolades_device{} 


    GrantBountyAssignerAccolade<public>(Agent : agent): void =
        BountyAssigner_Accolade.Award(Agent)

    GrantBountyAccepterAccolade<public>(Agent : agent): void =
        BountyAssigner_Accolade.Award(Agent)

    GrantBountySetAccolade<public>(Agent : agent): void =
        BountySet_Accolade.Award(Agent)

    GrantPurchasedHatAccolade<public>(Agent : agent): void =
        HatPurchased_Acolade.Award(Agent)

    GrantCurrencyPickupAccolade<public>(Agent : agent): void =
        CurrencyPickups_Accolade.Award(Agent)

    GrantEliminationAccolade<public>(Agent : agent): void =
        Elimination_Accolade.Award(Agent)

    GrantGameWonAccolade<public>(Agent : agent): void =
        GameWon_Accolade.Award(Agent)

    GrantMysteryBoxAccolade<public>(Agent : agent): void =
        MysteryBox_Accolade.Award(Agent)

    GrantTimePlayedAccolade<public>(Agent : agent): void =
        TimePlayed_Accolade.Award(Agent)

    GrantQuestCompletedAccolade<public>(Agent : agent): void =
        QuestCompleted_Accolade.Award(Agent)

    GrantChairSpectatorAccolade<public>(Agent : agent): void =
        ChairSpectator_Accolade.Award(Agent)

    GrantVerySmallAccolade<public>(Agent : agent): void =
        VerySmallXPShop_Accolade.Award(Agent)

    GrantSmallAccolade<public>(Agent : agent): void =
        SmallXPShop_Accolade.Award(Agent)

    GrantMediumAccolade<public>(Agent : agent): void =
        MediumXPShop_Accolade.Award(Agent)
    
    GrantLargeAccolade<public>(Agent : agent): void =
        LargeXPShop_Accolade.Award(Agent)

    GrantVeryLargeAccolade<public>(Agent : agent): void =
        VeryLargeXPShop_Accolade.Award(Agent)