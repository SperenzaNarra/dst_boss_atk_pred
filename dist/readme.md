# Boss Attack Predictor

If you want to add more warnings into this mod, you need to know the following things

## everything you need to set in main/tables/bosses.lua
- worldtimerkey: save the key of the timer, you should find it from the file like "dragonfly_spawner.lua"
- nametotag:
    - cave: the object will spawn in cave world
    - master: the object will spawn in the master world
    - inst: the timer of the object is not built in TheWorld, instead it should be find by calling ```c_findnext()```
- nametoattacktimefirst: the object will attack player when it spawns
- nametospawntimefirst: the object equires player to activates
- nametostring: used to display the name of the object
- nametoimage: stored the tex file path
- nametoscript: stored the xml file path

## add asset in modmain.lua
It is not hard but easily forgotten

## special case in main/bosscmd.lua
Some of the bosses don't follow the logic as the others. For example, bee queen.
According to the beequeenhive.lua, the timer is stored in ```inst.components.timer``` instead of
```inst.components.worldsettingstimer```, so we need to take it as a special case and write into
the file main/bosscmd.lua
```lua
if name == "beequeenhive" then
    if target.components.timer ~= nil and not target.components.timer:IsPaused(key) then
        return target.components.timer:GetTimeLeft(key)
    end
else
```

## Others
If you don't know how to convert the png file into tex, please use [TexTools](https://forums.kleientertainment.com/files/file/73-handsome-matts-tools/).
And don't forget to build a custom xml file for each tex file you provide.
Good luck!  