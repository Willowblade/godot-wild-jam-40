extends Node


onready var BESTIARY = {
	"chicken": {
		"name": "Chick",
		"description": "It began with the forging of the Great Chicks. Three were given to the Elves, immortal, wisest and fairest of all beings. Seven to the Dwarf-Lords, great miners and hatchmen of the mountain halls. And nine, nine chicks were gifted to the race of Men, who above all else desire power.",
		"creature": preload("res://assets/creature/chick.png"),
		"egg": preload("res://assets/eggs/chicken.png"),
	},
	"octosquid": {
		"name": "Octosquid",
		"description": "Is it an octopus? Is it a squid? We just don't know. What we do know? It's cute as heck that's what.",
		"creature": preload("res://assets/creature/octosquid.png"),
		"egg": preload("res://assets/eggs/chode-egg.png"),
	}
}

onready var EGGS = {}

func _ready():
	pass
