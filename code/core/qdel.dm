
var/alist/qdel_pool = alist()
proc/qdel(atom/movable/a)
    if(ismob(a))
        var/mob/m = a
        if(m.client)
            return
    a.loc = null
    qdel_pool+=a

proc/qdel_clean()
    set waitfor = 0
    set background = 1
    do
        if(length(qdel_pool))
            qdel_pool[1]:Del()
            qdel_pool.Cut(1)
    while(world.tick_usage <= 95)
