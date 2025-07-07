extends Node

signal updateAimArrowVisibility(visible) # from magMangager to ui
signal createMagnet(object, position, angle) # from magnetProjectile to magManager
#signal magnetButtonClick(magnet) # from magnet to magManager

#signal switchToRecall(visible) # from magManager to ui
signal switchToGrouping(visible) # from magManager to ui
signal groupingHasChanged() # from magManager to nodes that need to update, including: MagnetContainer
