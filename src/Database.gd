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
		"egg": preload("res://assets/eggs/squid.png"),
	},
	"mouse": {
		"egg": preload("res://assets/eggs/mouse.png"),
		"description": "A mouse, plural mice, is a small mammal. Characteristically, mice are known to have a pointed snout, small rounded ears, a body-length scaly tail, and a high hatching rate. A litter typically consists of 5-8 eggs. The best known mouse species is the common house mouse (Mus musculus). Mice are also popular as pets. They are known to invade homes for food and shelter.",
		"creature": preload("res://assets/creature/mouse.png"),
		"name": "Mouse",
		"flavor": "Woah! Rad!"
	},
	"moose": {
		"egg": preload("res://assets/eggs/moose.png"),
		"description": "A large animal used to the cold, it gets out of the egg fully sentient and can speak Swedish, Finnish, Danish and Norwegian like it's nobody's business. ",
		"creature": preload("res://assets/creature/moose.png"),
		"name": "Moose",
	},
	"molebear": {
		"egg": preload("res://assets/eggs/molebear.png"),
		"creature": preload("res://assets/creature/molebear.png"),
		"name": "Molebear",
		"description": "An animal crazy about honey and messing up people's gardens. At the age of three, a molebear needs to set out to the UAE and dig for an oil source, which funds the molebear government. I'm not sure why I had to hatch this egg.",
	},
	"sapling": {
		"egg": preload("res://assets/eggs/sapling.png"),
		"creature": preload("res://assets/creature/sapling.png"),
		"name": "Sapling",
		"description": "It's a sapling, but what plant is it from exactly? Definitely not a sequoia. To find out, I'll probably have to work in my aunt's sapling orphanage. See you in the next game!"
	},
	"unicorn": {
		"egg": preload("res://assets/eggs/unicorn.png"),
		"creature": preload("res://assets/creature/unicorn.png"),
		"name": "Unicorn",
		"description": "A magical being that's elusive to anyone but professional egg caretakers. It has a single colourful horn that it uses for mating, after which the male poops an egg. Yes. True fact. They don't teach this in school kids."
	},
	"willow": {
		"egg": preload("res://assets/eggs/willow.png"),
		"creature": preload("res://assets/creature/willow.png"),
		"name": "Lil' Willow",
		"description": "If you raise him well, you can have a cute little underpaid software engineer all of your own. This guy implies several falsehoods about human procreation, maybe humans are delivered by storks after all? And the storks already hatch the humans? But then who hatches the stork?"
	}
}

onready var EGGS = {}

func _ready():
	pass
