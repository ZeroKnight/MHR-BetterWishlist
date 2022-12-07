![better_wishlist](https://user-images.githubusercontent.com/719733/206136880-2e74d8a1-f63d-42f1-8392-c9b67476c338.png)

# Monster Hunter Rise: Better Wishlist

Better Wishlist is a mod for Monster Hunter Rise that fixes shortcomings in how wishlist notifications are presented to the player and makes them more intuitive and useful. You will only be notified about an item when you have all materials—including any extra category materials—and can actually craft it. No more misleading/confusing notifications!

# Getting the Mod

Download the latest release [here on GitHub](https://github.com/ZeroKnight/MHR-BetterWishlist/releases) or from my [Nexus Mods](https://www.nexusmods.com/monsterhunterrise/mods/1941) page.

### Requirements

This mod requires [REFramework](https://www.nexusmods.com/monsterhunterrise/mods/26) (v1.3.6 or above).

### Installation

1. Install REFramework to your Monster Hunter Rise game directory
2. Install Better Wishlist via whatever method you prefer:
    1. Using [Vortex Mod Manager](https://www.nexusmods.com/about/vortex/)
    2. Using [Fluffy Manager 5000](https://www.nexusmods.com/monsterhunterrise/mods/7)
    3. Manually

#### Manual Installation

REFramework should already be installed. Extract the mod contents into your Monster Hunter Rise game directory, such that the `reframework` folder ends up in the root of the game directory, like so:

    <path/to/MonsterHunterRise>
    └───reframework
        └───autorun
                BetterWishlist.lua

# A Brief Preface — The Typical Experience

In Monster Hunter Rise, some crafting recipes require not only a specific set of fixed materials to craft an item but can also require an arbitrary amount of materials that the player may freely choose from a specific **category**. This is indeed a nice feature as it allows for more flexible crafting, however, the way that Capcom chose to handle wishlist notifications in lieu of this feature isn't the best. With this system, there are two types of wishlist notifications that a player can see when returning to the village: one for the primary materials, and one for the category materials. Let's take a look at them.

## The "required materials gathered" notification

![materials_gathered](https://user-images.githubusercontent.com/719733/206134856-c6677651-48c5-43b9-9081-9165f0adf73c.png)

This notification is sent when you have all of the fixed, explicitly listed materials for an item recipe. For example:

![item_materials_example](https://user-images.githubusercontent.com/719733/206135202-0bd0c9a7-244c-4070-a295-02c3f56e6bc7.png)

## The "required material **types** gathered" notification

![material_types_gathered](https://user-images.githubusercontent.com/719733/206135104-bb17fa36-6439-4b0b-b3a9-c77ef1e9cb8c.png)

This notification is sent when you have a sufficient amount of materials from the material **category** for an item recipe (if it has one). For example:

![item_material_types_example](https://user-images.githubusercontent.com/719733/206135220-1e26d201-ab72-4ba3-90a9-18ea2255b5e7.png)

Simple enough, right? Sure, but unfortunately the game doesn't explain this connection to you when it introduces material types in crafting which, as I'll get into below, can lead to some confusion. Further still, this presentation method falls a bit short in practice.

# Where Things Can Go Wrong

With how the current system works, a player is very likely to find themselves in a situation where they have enough of the category materials for an item recipe but don't quite have everything needed for the primary, fixed portion of the recipe. Upon returning to the village, the player will be greeted with a "required material **types** gathered" message. The first few times this happens, the player may be misled into believing that they can now craft this item, and so rush to the smithy only to find that they're still missing a primary material.

![missing_primary](https://user-images.githubusercontent.com/719733/206135445-d3722a33-769c-4175-a96e-6abb6b3c2688.png)

This is the same situation that I'm sure many players (myself included) found themselves in during their early hours in Rise. It is quite easy for a new player to not know that there are indeed two separate wishlist notifications.

So how is a player to know when they can *actually* craft an item with category materials? You wait until you get both notification types at the same time, of course! That's right, the game actually sends *separate notifications* when you acquire enough materials for their respective part of the recipe. This is unintuitive as it is, and to make matters worse, the "materials gathered" message can appear several messages apart from the "material types gathered" message if you have a lot of things on your wishlist!

![message_distance_example](https://user-images.githubusercontent.com/719733/206135490-6efcd6cb-69a5-418e-8816-272fce1afb9d.png)

While less likely, the opposite scenario can happen as well; a player can receive the "materials gathered" message, but not have enough category materials to craft the item. If we consider the scenario where a player doesn't meet either requirement, that means that two out of four possible outcomes for wishlist notifications for an item that requires category materials can be misleading. Since having one or the other requirement met is the most common outcome, that means that a wishlist notification is almost always dubious!

## It Gets Worse...

Even as a player learns of this distinction, these notifications transform from misleading into mere noise, as the player will see this notification every time that they return to the village, knowing full well that they cannot craft the item yet. After a while, it's possible that they'll not notice when they are finally able to craft the item, especially if you consider the potential distance between the notification pair.

The current system greatly hamstrings the usefulness of the wishlist in addition to rendering it untrustworthy, to the point where some players will opt to not use it at all. This is an unacceptable state of affairs, so this mod aims to remedy these issues.

# A Better Solution

The ideal solution is obvious: only show wishlist notifications for items that are truly complete. That is, only the items for which you have all of the primary materials as well as enough category materials, if applicable; any other notification is filtered out. To make the notifications read nicely, only the "required materials gathered" messages are shown—also because some recipes have no category materials, of course.

Put simply, if you get a notification for a wishlist item, you are guaranteed to be able to craft that item right then and there.
