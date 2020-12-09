# Godot platformer tools :wrench:

## What?
This is an plugin for the Godot game engine, made by @DaylightDr3amer and thought to make the creation of 2D games (especially platformers) easier and quicker, without loosing control.

## How it works?
![Level Idea](https://raw.githubusercontent.com/TheFriendsCraftTeam/GodotPlatformerTools/main/web/level_system.png)
There are three main classes:
- **GameManager**: As you can tell by the name, this Singleton manages everything related to the plugin and it has some useful functions
- **Level**: A Class loaded by the GameManager that keeps all the information inside a Level (tiles, enemies, chests, etc.) that are divided in chunks, to prevent memory overload with large levels.
- **Areas**: These are groups of levels that shares some resources (Background, tiles images, enemies scenes, etc.) and their objective is to make transitions between levels faster.

All of them (and the other classes), work together and are "controlled" with the plugin interface and these interactions saved in a WorldMap file (file.map).

## WAIT!!
This addon (as you can probably see) is current in development version and it's not meant to be used in any game (for now), but if you just want to give it a look and maybe add you own stuff I won't stop you. :wink:

## Some features
[Current Milestone](https://github.com/TheFriendsCraftTeam/GodotPlatformerTools/milestone/1)
### Current:
- [x] It exist!!
- [x] ControlledBody custom class (for players, enemies, and other objects)

### Planned:
- [ ] [Wiki](https://github.com/TheFriendsCraftTeam/GodotPlatformerTools/wiki) **10%**
- [ ] WorldMap editor **80%**
- [ ] Areas management
- [ ] Assets management
- [ ] Some assets creation tools **5%**
- [ ] Background loading
- [ ] Custom level editor **??**
- [ ] Stage, cut-scenes, music and player management **10%**
- [ ] ***MAYBE*** some integrations with other level editors (like [LDtk](https://deepnight.net/tools/ldtk-2d-level-editor/) or [Tiled](https://www.mapeditor.org/))
- [ ] And much more...

## !!BREAKING NEWS!!
### Bug fixes, rename Levels, wiki, and more! [9 Dec 2020]
Ok, I'm pretty exited for this update cuz I worked hard on it. We're near to 0.1, the first release of the addon and I have some features to show you:
- Level renaming, now any Level can be renamed successfully
- Wiki, yes now we have a GitHub Wiki! :partying_face:
- Bug fixes, now the plugin will crash less often!
- Better usage of GitHub, now we have milestones, issues, and a project board!


### Level deletion function, and other minor improvements [27 Nov 2020]
Stuff, stuff and other stuff... Now levels can be deleted, and soon you'll be able to rename them. After that I'll focus on managing the Areas system (some sort of tags so I think it will be easy) and after that the WorldMap files. Now it's late so I can't write more. Bye!
> Yawn, Dieg0

### Functions improvements, artwork and other stuff [10 Nov 2020]
![UI](https://raw.githubusercontent.com/TheFriendsCraftTeam/GodotPlatformerTools/main/web/screenshot_1.png)
After a day of *really* focused development, now I'm here to introduce THE SAME ADDON (or plugin) WITH THE SAME FEATURES OF THE LAST COMMIT BUT NOW WITH MINOR IMPROVEMENTS!! (deep breath) Now every Level has a default artwork (made by me of course) as a little thumbnail (and soon you will be able to modify it). Also now you can annihilate the levels that you don't want anymore!
> Still me Dieg0, the Dev

### New UI, and it (doesn't) WORKS!!
Well, sort of... :sweat_smile: Now the node-based system seems fitting better than that good ol' sh\*t. Now it's time to start making the buttons working. Fortunately most of the functions are already made, so it should be easy (**spoiler alert**, it won't be easy :grin:).
> Dieg0, out

### Yes, there are also here [29 Oct 2020]
**FIRST COMMIT HERE WE GOOOOO!!!** Up there you saw all you need to know about it. This plugin is planned to be used with BigFlatPanda, but I'll make sure that it runs on other games, so don't worry, be happy!! :upside_down_face:
> The one and only DIEG0!!
