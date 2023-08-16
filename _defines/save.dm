proc
    SAVE_SHINIGAMI_SQUAD()
        if(global.shinigami_squad_members.len)
            if(fexists("saves/world/squad_shinigami.sav"))
                fdel("saves/world/squad_shinigami.sav")
            var/savefile/f = file("saves/world/squad_shinigami.sav")
            f << global.shinigami_squad_members
    LOAD_SHINIGAMI_SQUAD() 
        var/savefile/f = file("saves/world/squad_shinigami.sav")
        if(fexists(f))
            f >> global.shinigami_squad_members

    SAVE_HOLLOW_SQUAD() 
        if(global.hollow_espada_members.len)
            if(fexists("saves/world/squad_hollow.sav"))
                fdel("saves/world/squad_hollow.sav")
            var/savefile/f = file("saves/world/squad_hollow.sav")
            f << global.hollow_espada_members
    LOAD_HOLLOW_SQUAD() 
        var/savefile/f = file("saves/world/squad_hollow.sav")
        if(fexists(f))
            f >> global.hollow_espada_members

    SAVE_QUINCY_SQUAD() 
        if(global.quincy_sternritter_members.len)
            if(fexists("saves/world/squad_quincy.sav"))
                fdel("saves/world/squad_quincy.sav")
            var/savefile/f = file("saves/world/squad_quincy.sav")
            f << global.quincy_sternritter_members
    LOAD_QUINCY_SQUAD() 
        var/savefile/f = file("saves/world/squad_quincy.sav")
        if(fexists(f))
            f >> global.quincy_sternritter_members
