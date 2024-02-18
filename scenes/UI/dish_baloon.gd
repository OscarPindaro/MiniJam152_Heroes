extends Node2D

const base_assets_path = "res://asset/tags/"
const assets_extension = ".png"

func update_dish(dish):
	if dish == null:
		self.visible = false
	else:
		self.visible = true
	
		var mainTexture = load(base_assets_path + dish["main"] + assets_extension)
		var cookingTexture = load(base_assets_path + dish["cooking"] + assets_extension)
		var sideTexture = load(base_assets_path + dish["side"] + assets_extension)
	
		$MainTexture.texture = mainTexture
		$CookingTexture.texture = cookingTexture
		$SideTexture.texture = sideTexture
