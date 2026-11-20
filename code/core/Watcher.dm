#define get_watcher_updates(ref,watcher,time) (watcher.last_update>time ? (watcher.updates & watcher.subscribers[(ref)]) : null)

// verbs can come in after the world/Tick()
#ifndef NEXT_SERVER_TICK_TIME
#define NEXT_SERVER_TICK_TIME world.time
#endif

watcher
	var/tmp
		weakref/owner				//a weak reference to the watched object
		list/subscribers = alist()	//subscribers and their subscribed hooks
		list/updates = list()		//hooks and the last time they were fired
		last_update = 1#INF			//the last time any hook was fired
	proc
		//call to subscribe an object to this watcher's updates
		//the first argument is the subscriber
		//all subsequent arguments are the names of the hooks we want to watch for
		//if no hooks are passed, this is the same as unsubscribing from all hooks
		Subscribe(datum/ref)
			if(args.len<2)
				subscribers -= ref
			else
				subscribers[ref] = subscribers[ref] | args.Copy(2,0)

		//call to unsubscribe an object from this watcher's updates
		//the first argument is the subscriber
		//all subsequent arguments are the names of hooks we want to stop watching
		//if no hooks are passed, unsubscribe from all hooks
		Unsubscribe(datum/ref)
			if(args.len<2)
				//one argument is passed, so unsubscribe the subscriber
				subscribers -= ref
			else
				//remove the passed hooks from the subscribers list
				var/list/l = subscribers[ref]
				if(l)
					l -= args.Copy(2,0)

				//if the subscriber is no longer subscribed to any hooks, remove the subscriber
				if(!l.len)
					subscribers -= ref

		//call to cause a hook to be marked as updated
		//each arg is the name of a hook
		Update()
			var/time = last_update = NEXT_SERVER_TICK_TIME
			for(var/v in args)
				updates[v] = time

	//create this watcher and notify the object it now has a watcher
	New(datum/owner)
		if(owner)
			src.owner = owner.Weakref()
			owner.Watching(src)


datum
	var/tmp
		watcher/watcher
	proc
		//called when a new watcher is created for this object.
		//You should override this to initialize the list of hooks and force a full update
		Watching(watcher/watcher)
			set waitfor = 0

		//call to start watching this object
		//if no watcher is currently present, create one, and subscribe the watcher.
		//the first arg is the subscriber
		//the second+ args are the hooks to subscribe to
		Watch(datum/ref)
			(watcher ||= new/watcher(src)).Subscribe(arglist(args))
			return watcher

		//call to stop watching this object
		//the first arg is the subscriber
		//the second+ args are the hooks to unsubscribe from
		//if there are no more subscribers, unlink the watcher datum from this object
		Unwatch(datum/ref)
			if(watcher)
				watcher.Unsubscribe(arglist(args))
				if(!watcher.subscribers.len)
					watcher.owner.refid = null
					watcher = null
			return watcher