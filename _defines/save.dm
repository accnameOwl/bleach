proc
    SAVE_SHINIGAMI_SQUAD()
        var/savefile/f = file("saves/world/squad_shinigami.sav")
        f << shinigami_squad_members
    LOAD_SHINIGAMI_SQUAD() 
        var/savefile/f = file("saves/world/squad_shinigami.sav")
        f >> shinigami_squad_members

    SAVE_HOLLOW_SQUAD() 
        var/savefile/f = file("saves/world/squad_hollow.sav")
        f << hollow_espada_members
    LOAD_HOLLOW_SQUAD() 
        var/savefile/f = file("saves/world/squad_hollow.sav")
        f >> hollow_espada_members

    SAVE_QUINCY_SQUAD() 
        var/savefile/f = file("saves/world/squad_quincy.sav")
        f << quincy_sternritter_members
    LOAD_QUINCY_SQUAD() 
        var/savefile/f = file("saves/world/squad_quincy.sav")
        f >> quincy_sternritter_members
