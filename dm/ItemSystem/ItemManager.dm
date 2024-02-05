var/list/itemPool = list()

itemManager
	var/list/items = list()

	proc
		loadItems()
			var/json/Data = JsonReader('json/items.json')
			var/json/Array = Data["items"]

			for( var/json/Object/Item in Array)
				var/obj/item/NewItem = obj/item()
				NewItem.id = Item["id"]
				NewItem.name = Item["name"]
				NewItem.type = Item["type"]

				if (Item["effect"])
					NewItem.effect = Item["effect"]
				
				if (Item["damage"])
					NewItem.damage = Item["damage"]

				items += NewItem
			. = 1
		
		getItemByID(itemID)
			for (var/obj/item/Item in items)
				if(Item.id == itemID)
					return Item
			return null
		
		getItem()
			if (itemPool)
				// If there are items in the pool, reuse one
				var/obj/item/PooledItem = itemPool.pop()
				PooledItem.id = 0 // Reset ID or any other properties
				return PooledItem
			else
				return obj/item()

		recycleItem(obj/item/Item)
			itemPool += Item
