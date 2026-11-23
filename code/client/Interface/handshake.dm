client
	var/list/page_ready = list()

	verb
		PageResponse(id as text, status as text)
			set hidden = 1

			world.log << "id=[id]; status=[status]"

			if(!id || !status) return

			page_ready[id] = status

	proc
		await_response(id, timeout = 50)

			while( !page_ready[id] || timeout > 0)

				sleep(10/world.fps)
				timeout--

			return page_ready[id]