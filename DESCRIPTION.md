[![Discord](https://img.shields.io/badge/Discord-%235865F2.svg?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/VuVhYUBbWE)[![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/danielmartin0/Inverted-Quality)[![Ko-fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/thesixthroc)

# Inverted Quality

Replaces Quality by a new system, Degradation.

Mined and smelted items start at Nominal degradation. Each time an item is crafted, it has a 90% chance to become more degraded.

Unlike in vanilla, low-degradation items can be used in high-degradation recipes.

Three new entities are introduced:
* Downgrade port:
    * A 1x1 entity you can attach to the side of assemblers. When items are inserted into the port they are delivered to the assembler with one level of degradation.
        * This means that unlike with Quality, degradation is 'backwards-compatible': low-degradation items can be used in high-degradation recipes.
* Burner assembling machine:
    * A simple fuel-powered assembling machine with simple ingredients. This allows the player to craft degraded items early in the game (since handcrafting is only possible at Nominal degradation).
* Meltdown facility;
    * Items of any degradation can be melted down into 1/8 of their raw materials.
        *  

## Degradation levels

Nominal degradation is almost exactly the same as Normal quality in vanilla, with a few small exceptions such as the supply area of power poles.

| Degradation Name | Level |
|-----------------|-------|
| Nominal | 5|
| Scuffed | 4 |
| Funky | 3 |
| Defective | 2 |
| Busted | 0 |

For compatibility reasons the degradation levels overwrite and rename the existing quality levels.

## Special Thanks

* Sapheroni for long discussions on the names of each degradation level.

---

[![Discord](https://img.shields.io/discord/1309620686347702372?style=for-the-badge&logo=discord&logoColor=bf6434&label=The%20Foundry&labelColor=222222&color=bf6434)](https://discord.gg/VuVhYUBbWE)