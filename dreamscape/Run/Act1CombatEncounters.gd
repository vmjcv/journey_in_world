class_name Act1
extends Reference

"""
The enemies list, is a list of dictionaries, which define which enemy to spawn
in each encounter. You can also optionally specified starting effects
for each enemy, as well as a specific intent to start with. The intent
Should be a valid index within the intents available for that enemy

As an example:

		"enemies": {
			"hard": [
				{
					"definition": EnemyDefinitions.THE_LAUGHING_ONE,
					"starting_intent": 1
					"health_modifier": -10
					"starting_defence": 10
					"starting_effects": [
						{
							"name": Terms.ACTIVE_EFFECTS.vulnerable.name,
							"stacks": 5
						}
					]
				},
			]
		}
"""

const ENEMIES := [
	{
		"journal_description":\
			'I found myself between [url={torment_tag1}]a pair of featureless creeps laughing[/url] at me.',
		"journal_reward":\
			'Through overcoming that weird experience, [url=card_draft]I felt wiser.[/url]',
		"enemies": {
			"easy": [
				{
					"definition": EnemyDefinitions.THE_LAUGHING_ONE,
				},
				{
					"definition": EnemyDefinitions.THE_LAUGHING_ONE,
				},
			],
			"medium": [
				{
					"definition": EnemyDefinitions.THE_LAUGHING_ONE,
				},
				{
					"definition": EnemyDefinitions.THE_LAUGHING_ONE,
				},
				{
					"definition": EnemyDefinitions.THE_LAUGHING_ONE,
				},
			],
			"hard": [
				{
					"definition": EnemyDefinitions.THE_LAUGHING_ONE,
				},
				{
					"definition": EnemyDefinitions.THE_LAUGHING_ONE,
				},
				{
					"definition": EnemyDefinitions.THE_LAUGHING_ONE,
				},
				{
					"definition": EnemyDefinitions.THE_LAUGHING_ONE,
				}
			],
		},
		"journal_art": preload("res://addons/cfc/assets/journal/the_laughing_one.jpeg"),
	},
	{
		"journal_description":\
			'Was that [url={torment_tag1}]a curious owl with three eyes[/url] staring at me?',
		"journal_reward":\
			'Through overcoming that weird experience, [url=card_draft]I felt wiser.[/url]',
		"journal_art": preload("res://addons/cfc/assets/journal/fearmonger.jpeg"),
		"enemies": {
			"easy": [
				{
					"definition": EnemyDefinitions.FEARMONGER,
					"health_modifier": -30,
				},
			],
			"medium": [
				{
					"definition": EnemyDefinitions.FEARMONGER,
				},
			],
			"hard": [
				{
					"definition": EnemyDefinitions.FEARMONGER,
					"health_modifier": -20,
				},
				{
					"definition": EnemyDefinitions.FEARMONGER,
					"health_modifier": -20,
				},
			],
		},
	},
	{
		"journal_description":\
			'I saw [url={torment_tag1}]a strange form with a head like a lamp[/url] moving towards me.',
		"journal_reward":\
			'Through overcoming that weird experience, [url=card_draft]I felt wiser.[/url]',
		"enemies": {
			"easy": [
				{
					"definition": EnemyDefinitions.GASLIGHTER,
					"health_modifier": -20,
				},
			],
			"medium": [
				{
					"definition": EnemyDefinitions.GASLIGHTER,
				},
			],
			"hard": [
				{
					"definition": EnemyDefinitions.GASLIGHTER,
					"health_modifier": +10,
					"starting_defence": +10,
				},
			],
		},
		"journal_art": preload("res://addons/cfc/assets/journal/gaslighter.jpeg"),
	},
	{
		"journal_description":\
			'[url={torment_tag1}]<Description to be added>[/url].',
		"journal_reward":\
			'Through overcoming that weird experience, [url=card_draft]I felt wiser.[/url]',
		"enemies": {
			"easy": [
				{
					"definition": EnemyDefinitions.UNNAMED_ENEMY_1,
					"health_modifier": -10,
				},
			],
			"medium": [
				{
					"definition": EnemyDefinitions.UNNAMED_ENEMY_1,
					"starting_effects": [
						{
							"name": Terms.ACTIVE_EFFECTS.thorns.name,
							"stacks": 1
						}
					]
				},
			],
			"hard": [
				{
					"definition": EnemyDefinitions.UNNAMED_ENEMY_1,
					"health_modifier": +30,
					"starting_effects": [
						{
							"name": Terms.ACTIVE_EFFECTS.thorns.name,
							"stacks": 3
						}
					]
				},
			],
		},
#		"journal_art": preload("res://addons/cfc/assets/journal/the_critic.jpeg"),
	},
	{
		"journal_description":\
			'Strange furry animals with massive noses (or were they trunks) [url={torment_tag1}]started sniffing at me, and pointing out my weaknesses[/url].',
		"journal_reward":\
			'Through overcoming that weird experience, [url=card_draft]I felt wiser.[/url]',
		"enemies": {
			"easy": [
				{
					"definition": EnemyDefinitions.THE_CRITIC,
					"starting_effects": [
						{
							"name": Terms.ACTIVE_EFFECTS.strengthen.name,
							"stacks": 2
						}
					]
				},
			],
			"medium": [
				{
					"definition": EnemyDefinitions.THE_CRITIC,
				},
				{
					"definition": EnemyDefinitions.THE_CRITIC,
				},
			],
			"hard": [
				{
					"definition": EnemyDefinitions.THE_CRITIC,
					"starting_effects": [
						{
							"name": Terms.ACTIVE_EFFECTS.strengthen.name,
							"stacks": 2
						}
					]
				},
				{
					"definition": EnemyDefinitions.THE_CRITIC,
					"health_modifier": +25,
				},
			],
		},
		"journal_art": preload("res://addons/cfc/assets/journal/the_critic.jpeg"),
	},
	{
		"journal_description":\
			'I somehow ended in a peculiar argument [url={torment_tag1}]with a clown[/url].',
		"journal_reward":\
			'Through overcoming that weird experience, [url=card_draft]I felt wiser.[/url]',
		"enemies": {
			"easy": [
				{
					"definition": EnemyDefinitions.CLOWN,
					"health_modifier": -10,
				},
			],
			"medium": [
				{
					"definition": EnemyDefinitions.CLOWN,
				},
			],
			"hard": [
				{
					"definition": EnemyDefinitions.CLOWN,
					"starting_defence": +20,
					"starting_effects": [
						{
							"name": Terms.ACTIVE_EFFECTS.fortify.name,
							"stacks": 1
						}
					]
				},
			],
		},
		"journal_art": preload("res://addons/cfc/assets/journal/clown.jpeg"),
	},
	{
		"journal_description":\
			'What a [url={torment_tag1}]depressive butterfly[/url].',
		"journal_reward":\
			'Through overcoming that weird experience, [url=card_draft]I felt wiser.[/url]',
		"enemies": {
			"easy": [
				{
					"definition": EnemyDefinitions.BUTTERFLY,
					"health_modifier": -10,
				},
			],
			"medium": [
				{
					"definition": EnemyDefinitions.BUTTERFLY,
				},
			],
			"hard": [
				{
					"definition": EnemyDefinitions.BUTTERFLY,
					"health_modifier": +10,
					"starting_effects": [
						{
							"name": Terms.ACTIVE_EFFECTS.strengthen.name,
							"stacks": 2
						}
					]
				},
			],
		},
#		"journal_art": preload("res://addons/cfc/assets/journal/clown.jpeg"),
	},
	{
		"journal_description":\
			'Am I cursed[url={torment_tag1}]or is it just bad luck[/url]?',
		"journal_reward":\
			'Through overcoming that weird experience, [url=card_draft]I felt wiser.[/url]',
		"enemies": {
			"easy": [
				{
					"definition": EnemyDefinitions.BROKEN_MIRROR,
					"health_modifier": -12,
				},
				{
					"definition": EnemyDefinitions.BROKEN_MIRROR,
					"health_modifier": -12,
				},
				{
					"definition": EnemyDefinitions.BROKEN_MIRROR,
					"health_modifier": -12,
				},
			],
			"medium": [
				{
					"definition": EnemyDefinitions.BROKEN_MIRROR,
				},
				{
					"definition": EnemyDefinitions.BROKEN_MIRROR,
				},
			],
			"hard": [
				{
					"definition": EnemyDefinitions.BROKEN_MIRROR,
					"starting_defence": +10,
					"health_modifier": +10,
				},
				{
					"definition": EnemyDefinitions.BROKEN_MIRROR,
					"starting_defence": +10,
					"health_modifier": +10,
				},
			],
		},
#		"journal_art": preload("res://addons/cfc/assets/journal/clown.jpeg"),
	},
#	{
#		"journal_description":\
#			'I found myself cowering before [url={torment_tag1}]a three-eyed owl[/url]'\
#			+ ' while someone in the distance was [url={torment_tag2}]laughing at my aprehension.[/url]',
#		"journal_reward":\
#			'Through overcoming that weird experience, [url=card_draft]I felt wiser.[/url]',
#		"enemies": [
#			{
#				"definition": EnemyDefinitions.FEARMONGER,
#			},
#			{
#				"definition": EnemyDefinitions.THE_LAUGHING_ONE,
#			},
#		]
#	},
#	{
#		"journal_description":\
#			'I discovered that [url={torment_tag1}]the lamps that should not be[/url] were multiplying.',
#		"journal_reward":\
#			'Through overcoming that weird experience, [url=card_draft]I felt wiser.[/url]',
#		"enemies": [
#			{
#				"definition": EnemyDefinitions.GASLIGHTER,
#			},
#			{
#				"definition": EnemyDefinitions.GASLIGHTER,
#			},
#		],
#		"journal_art": preload("res://addons/cfc/assets/journal/gaslighter.jpeg"),
#	},
]

const BOSSES := {
	"Narcissus": {
		"scene": preload("res://addons/cfc/src/dreamscape/CombatElements/Enemies/Bosses/Narcissus.tscn"),
		"journal_description":\
			'I found someone I am sure I know, but I can\'t quite remember who.'\
			+ 'I found them gazing in a mirror, or was it a lake? They turned their attention to me...',
		"journal_reward":\
			'Through the many lies and denials, [url=boss_card_draft]I cornered the truth out of them.[/url]'\
			+ 'and for once felt like [url=boss_artifact]I was getting somewhere[/url].',
	}
}
