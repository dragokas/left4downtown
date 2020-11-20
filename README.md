Left 4 Downtown
----------------------------------
This is extension for SourceMod (L4D game series).

**Description:**

Provides useful natives and forwards for developers. Details are available in [original topic](https://forums.alliedmods.net/showthread.php?t=91132).

**Compatibility**

At the moment, it is outdated and superseded by [Left 4 DHooks Direct](https://forums.alliedmods.net/showthread.php?t=321696) Direct by **SilverShot**
 - L4D1
 - For L4D2 use, [Left 4 Downtown 2](https://forums.alliedmods.net/showthread.php?t=134032) or **Left 4 DHooks Direct**

**Purpose**

Repository is intended to use in the old server builds that are very dependent on this particular extension and can't be updated to use SM 1.10+ for some reasons.

**Authors**

Downtown1 and XBetaAlpha, Fork by [@raziEiL](https://github.com/raziEiL)

Please, let me know if I forgot somebody.

**ChangeLog**:

0.4.7.5 ([fork by disawar1](https://forums.alliedmods.net/showpost.php?p=2382067&postcount=1190))
 - Added no player slots build.
 - Added L4D_OnEntityShoved forward.
 
0.4.7.4
 - Updated signatures (forwards+playerslots).
 - Code cleanup.
 - Added L4D_OnClearTeamScores, L4D_OnRecalculateVersusScore forwards.
 - Removed broken L4D_GetCampaignScores native (switches to l4d_direct API).

0.4.7.3
 - Added 3 left4downtown2 forwards (L4D_OnMobRushStart, L4D_OnFirstSurvivorLeftSafeArea, L4D_OnEnterGhostState).
 - Fixed L4D_OnShovedBySurvivor forward have incorect parameter num.
 - Removed unnecessary L4D_ScavengeBeginRoundSetupTime native.
 - Removed L4D_OnClearTeamScores forward (temporarily).
 - Removed L4D_GetSurvivorHealthBonus, L4D_SetSurvivorHealthBonus natives (switches to l4d_direct API).
