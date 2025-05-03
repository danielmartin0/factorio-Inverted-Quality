[![Discord](https://img.shields.io/badge/Discord-%235865F2.svg?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/VuVhYUBbWE)[![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/danielmartin0/Inverted-Quality)[![Ko-fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/thesixthroc)

# Inverted Quality

Quality now consists of negative tiers (positive tiers are removed).

Crafting items has a two-thirds chance to reduce their quality by one tier. Unlike vanilla quality, this means long production chains tend make items worse. Quality modules reduce the chance that the crafted item will be degraded.

To cope with the new gameplay, new entities are included (detailed below). In particular, the Downgrade Port means that high-quality items can be used in low-quality recipes.

## Quality levels

| Quality | Level | Notes |
|-----------------|-------|-------|
| Normal | 0 | Mostly the same as Normal in vanilla, though a few items are buffed (e.g. power poles). |
| Scuffed | -1 |  |
| Funky | -2 |  |
| Defective | -3 |  |
| Broken | -5 | Generally nonfunctional |

## New entities

* Downgrade port
    * A 1x1 entity that can be attached to the side of assemblers. Items inserted into the port are delivered to the assembler reduced in quality by one level.
        * Using this port means that quality in this mod is backwards-compatible: high-quality items can be used in low-quality recipes.
* Meltdown facility
    * Items of any quality can be melted down into 1/8 of their base materials in Normal quality.
        * Currently, '1/8 of base materials' is defined as the end result of repeatedly recycling items until they self-recycle, except with an factor 1/8 overall rather than 1/4 for each step.

## Further details

* Like in vanilla, each instance of degradation has a 10% chance to be 'upgraded' to jump extra tiers.
    * This applies to both machine crafting and handcrafting. Multi-step handcrafting tends to result in especially degraded items.
* Due to API constraints a few properties are immune to quality in this mod, e.g. mining drill resource drain.
* This mod triggers a few base game bugs.
    * The quality bonus shown in the tooltip of crafting machines is incorrect.
    * The rotation speed of Nominal inserters is unusually poor.
    * Science pack durability stats are misrepresented in the UI.
    * Quality modules are no longer affected by quality.
* Please report any issues not listed above. Playtest feedback is also very welcome, at time of writing nobody knows this mod's gameplay that well.

## Special Thanks

* SafTheLamb for a long discussion on the names of the quality tiers.
* Hurricane for their Arc Furnace graphics as used in the Meltdown facility.
* AnotherZach for conversations on Broken quality.

---

[![Discord](https://img.shields.io/discord/1309620686347702372?style=for-the-badge&logo=discord&logoColor=bf6434&label=The%20Foundry&labelColor=222222&color=bf6434)](https://discord.gg/VuVhYUBbWE)