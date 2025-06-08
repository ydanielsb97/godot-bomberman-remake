extends Object

class_name SkinTextures

enum Types {
	WHITE,
	BLUE,
	RED,
	CYAN,
	DARK_BLUE,
	GOLD,
	GREEN,
	NEGATIVE,
	ORANGE_PASTEL,
	PASTELISH_GREEN,
	PINK,
	PURPLE
}

const TEXTURES: Dictionary[Types, CompressedTexture2D]= {
	Types.WHITE: preload("res://assets/images/characters/animation characters.png"),
	Types.BLUE: preload("res://assets/images/characters/animation characters blue.png"),
	Types.RED: preload("res://assets/images/characters/red1.png"),
	Types.CYAN: preload("res://assets/images/characters/animation characters cyan.png"),
	Types.DARK_BLUE: preload("res://assets/images/characters/animation characters dark blue.png"),
	Types.GOLD: preload("res://assets/images/characters/animation characters gold.png"),
	Types.GREEN: preload("res://assets/images/characters/animation characters green.png"),
	Types.NEGATIVE: preload("res://assets/images/characters/animation characters negativ.png"),
	Types.ORANGE_PASTEL: preload("res://assets/images/characters/animation characters orange pastel.png"),
	Types.PASTELISH_GREEN: preload("res://assets/images/characters/animation characters pastelish green.png"),
	Types.PINK: preload("res://assets/images/characters/animation characters pink.png"),
	Types.PURPLE: preload("res://assets/images/characters/animation characters purple.png"),
}
