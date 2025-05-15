Greetings modder!

You're here because you are curious what quality can affect,
as well as what quality does to each property since they all scale differently.

Before we begin you should know that quality internally refers to a level,
this numeric value is what dictates how good the quality bonus is on each thing that supports it,
at the time of writing (2.0.3) there is no fine-grained control about higher/lower boosts based on names.

These are the current levels:
- 0, normal
- 1, uncommon
- 2, rare
- 3, epic
- 5, legendary
(notice how there's no quality using level 4, effectively making legendary twice as good even though "it's the nest")

Quite a bunch of quality affected properties (denoted by the blue diamond icon in the factoriopedia) use the same bonus,
when this document refers to "the default bonus" it refers to this formula: `normal * (1.0 + 0.3 * level)`

(note that this initial list does not include round/floor/ceil stuff, but it'll give you the general idea of it all)
(also note that i have not added extra brackets to the math where it is technically redundant, so pay close attention)

# module
- effect: default bonus, but for quality modules the result of that `* 0.1` (next_probability on **normal** quality)
# accumulator
- energy-capacity: `* (1 + level)`
- input-flow-limit: `default`
- output-flow-limit: `default`
# asteroid collector
- storage-size: `+ (prototype.inventory_size_quality_increase * level)`
- collector-arm-storage-size: `+ (prototype.arm_inventory_size_quality_increase * level)` (unused by space age)
- collection-area: `+ level`
- collection-arm-max-speed: `* (1 + prototype.arm_speed_quality_scaling * level)` (note the hidden angular speed caps)
- collection-arm-count: `+ prototype.arm_count_quality_scaling * level`
# beacon
- beacon-effectivity: `+ prototype.distribution_effectivity_bonus_per_quality_level * quality`
- energy-consumption: `* quality_prototype.beacon_power_usage_multiplier`
# boiler
- fluid-consumption: `default`
- fluid-output: `default`
# burner generator
- maximum-power-output: `default`
# cargo bay
- inventory-size-bonus: `default` (weird, 20 * 1.3 is 26 but uncommon has 25)
# landing pad
- continuous-radar-coverage-distance: `+ level`
# crafting machine
- crafting-speed: `default` (devs: this uses identical math as the default code yet doesn't call use that function)
# electric pole
- wire-reach: `+ level * 2`
- supply-area: `+ level`
# entity with health
- base-health: `default` (note that for biter spawners there's an additional quality diamond on hover, not in pedia)
# flying robot
- energy-capacity: `* (1 + level)`
- minimum-operational-time: some math stuff that takes the quality energy capacity / by quality energy usage or smth
- maximum-flying-reach: more maths based on the operational time that takes speed and such into account, aka derived
# fusion generator
- maximum-power-output: `default`
- fluid-consumption: `default`
- fluid-output: `default`
# fusion reactor
- maximum-power-output: `default`
- fluid-consumption: `default`
- fluid-output: `default`
- maximum-power-input: `default` (confusing, the power input stays the same, but this scales just the fuel input?)
# generator
- maximum-power-output: `default`
- fluid-consumption: `default`
# inserter
- rotation-speed: `default` (devs: both rotation and extension speed use the default bonus with duplicate math)
# lab
- research-speed: `default` (devs: again, duplicate math)
- science-pack-drain: `* quality_prototype.science_pack_drain_multiplier`
# mining drill
- mining-drill-resource-drain: `* quality_prototype.mining_drill_resource_drain_multiplier`
# radar
- continuous-radar-coverage-distance: `+ level`
- exploration-radar-coverage-distance: `+ level`
# reactor
- heat-output: `default`
# roboport
- robot-recharge-rate: `default` (devs: in the code the quality checks for optional? this is unlike the others)
# solar panel
- maximum-power-output: `default`
# spider vehicle
- inventory-size: `default`
# sticker
- duration: `default`
# thruster
- fluid-consumption: `default`
# battery equipment
- energy-capacity: `default` (note that this is different from accumulators, and unused input & output quality rates)
# belt immunity equipment
- reduced-energy: `/ default` (aka / (1.0 + 0.3 * level))
# energy shield equipment
- shield: `default`
# equipment grid
- width: `+ level`
- height: `+ level`
# generator equipment
- maximum-power-output: `default`
- max-energy-consumption: `default?` (by default there is no burner generator i can use to double check)
# movement bonus equipment (exoskeletons)
- movement-speed-bonus: `default`
# roboport equipment
- personal-roboport-max-robot-count: `default` (devs: more duplicate math)
- robot-recharge-rate: `default`
- max consumption: `max robots * recharge rate`
# solar panel equipment
- maximum-power-output: `default`
# armor
- inventory-size-bonus: `default`
# item
- spoils-slower: `default`
# tool (repair & science)
- durability: `* (1 + level)`
# attack parameters (turrets/artillery)
- automatic-range: `1 + level * 0.1`
- manual-range: `automatic-range * prototype.manual_range_modifier`
- range: `1 + level * 0.1`
# chain trigger
- fork-chance-per-jump: `+ fork_chance_increase_per_quality_level * level`
# damage trigger (nukes)
- damage: `damage * trigger base modifiers * default, then damage * trigger modifiers * default` (or something, idk)

Now that this list is done i'll write this line last:
I tried my best to document them all, some might be wrong (eyeballed) or missed entirely, but this is better than nil :)

Oh, you're still here?
Well if you're one of the reds, good luck generating this list automatically, believe me, ive tried.

I fell down the rabbit hole of trying to extract it from the test for quality descriptions,
it worked reasonably but there are a lot of duplicates between entity types and item types.

My advice is, just search for `quality-tooltip` and go through the codebase by hand.

- Quezler
