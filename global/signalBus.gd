extends Node

# --- MAGNET SIGNALS --- #
signal updateNodeMagnets # from magmanager to genpurposemagnetables
signal groupingHasChanged # from magManager to nodes that need to update, including: MagnetContainer, genPurposeMagnetable
signal switchToGrouping(visible) # from magManager to ui
signal createMagnet(object, position, angle) # from magnetProjectile to magManager and genPurposeMagnetable
signal updateAimArrowVisibility(visible) # from magMangager to ui
signal passGroupsList(list) # from magManager to genPurposeMagnetbale & whatever else

# --- INFO FOR PLAYER --- #
signal hurtPlayer(obj) # from deathSpike to player
signal updateCheckpoint(obj) # from checkpoint to player
signal updateCharacterInteracting(x) # (from characterModel.gd to UI & dialogManager) and from sceneSwitcher to player BOTH FOR DIALOG
# AND FOR SCENE SWITCHING, COULD CAUSE ISSUES
signal dialogModeActive(x) # from dialogManager to anyone who needs that info potentially :3

# --- GENERAL GAME INFO --- #
signal sceneSwitched # called from sceneSwitcher when it does its thing, right now just for magManager to reset magnets
