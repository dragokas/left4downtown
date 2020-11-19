left4downtown extension is here and supported
----------------------------------
0.4.7.5 Changes:
 - Added no player slots build.
 - Added L4D_OnEntityShoved forward.
 
0.4.7.4 Changes:
 - Updated signatures (forwards+playerslots).
 - Code cleanup.
 - Added L4D_OnClearTeamScores, L4D_OnRecalculateVersusScore forwards.
 - Removed broken L4D_GetCampaignScores native (switches to l4d_direct API).

0.4.7.3 Changes:
 - Added 3 left4downtown2 forwards (L4D_OnMobRushStart, L4D_OnFirstSurvivorLeftSafeArea, L4D_OnEnterGhostState).
 - Fixed L4D_OnShovedBySurvivor forward have incorect parameter num.
 - Removed unnecessary L4D_ScavengeBeginRoundSetupTime native.
 - Removed L4D_OnClearTeamScores forward (temporarily).
 - Removed L4D_GetSurvivorHealthBonus, L4D_SetSurvivorHealthBonus natives (switches to l4d_direct API).