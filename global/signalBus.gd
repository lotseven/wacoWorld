extends Node

# --- MAGNET SIGNALS --- #
signal updateNodeMagnets # from magmanager to genpurposemagnetables
signal groupingHasChanged # from magManager to nodes that need to update, including: MagnetContainer, genPurposeMagnetable
signal switchToGrouping(visible) # from magManager to ui
signal createMagnet(object, position, angle) # from magnetProjectile to magManager and genPurposeMagnetable
signal updateAimArrowVisibility(visible) # from magMangager to ui

# --- INFO FOR PLAYER --- #
signal hurtPlayer(obj) # from deathSpike to player
signal updateCheckpoint(obj) # from checkpoint to player
signal startEpisode(char) # from anywhere that wants to start an episode to diaManager
