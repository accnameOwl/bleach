#define SAVE_SHINIGAMI_SQUAD() \
    var/savefile/f = file("sav/world/squad_shinigami.sav")\
    f << shinigami_squad_members

#define LOAD_SHINIGAMI_SQUAD() \
    var/savefile/f = file("sav/world/squad_shinigami.sav")\
    f >> shinigami_squad_members

#define SAVE_HOLLOW_SQUAD() \
    var/savefile/f = file("sav/world/squad_hollow.sav")\
    f << hollow_espadamembers

#define LOAD_HOLLOW_SQUAD() \
    var/savefile/f = file("sav/world/squad_hollow.sav")\
    f >> hollow_espada_members

#define SAVE_QUINCY_SQUAD() \
    var/savefile/f = file("sav/world/squad_quincy.sav")\
    f << quincy_sternritter_members
#define LOAD_QUINCY_SQUAD() \
    var/savefile/f = file("sav/world/squad_quincy.sav")\
    f >> quincy_sternritter_members