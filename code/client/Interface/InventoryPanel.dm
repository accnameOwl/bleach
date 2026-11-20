
client
	verb
		OpenInventoryPanel()
		//	set hidden = 1
			set category = "Test"
			HTML_BrowseInventory()
			winset(src, "main.characterChild", "is-visible=1;")
			if(!ui_is_open[UI_INVENTORY])
				winset(src, "main.characterChild", "is-visible=1;")
				ui_is_open[UI_INVENTORY] = TRUE

	proc
		__get_inventory_html_card(item/i)
			return {"
			<li class="item-card">
				<img class="item-image" src="/ref[i.appearance]" alt="[i.name]" />
				<div class="item-name">[i.name]</div>
				<button class="equip-btn" onclick=equip([i.id])>Equip</button>
      		</li>
	  		"}
		__get_inventory_html_card_test()
			return {"
			<li class="item-card">
				<img class="item-image" src="" alt="Icon" />
				<div class="item-name">This is the name</div>
				<button class="equip-btn" onclick=>Equip</button>
      		</li>
	  		"}

		HTML_BrowseInventory()
			var/html_content = {"
				<!DOCTYPE html>
				<html lang="en">
				<head>
					<style>
						html, body{
							width:100%;
							height:100%;
							margin:0px;
						}
						body {
							background-color: #1e1e1e;
							font-family: Arial, sans-serif;
							color: white;
							overflow:hidden;
						}
						.title-bar {
							display: flex;
							justify-content: space-between;
							align-items: center;
							height: 14px;
							background-color: #3a3a3a;
							padding: 0 6px;
							font-size: 10px;
							color: #ddd;
							border-bottom: 1px solid #555;
						}

						.close-btn {
							background: none;
							border: none;
							color: #aaa;
							cursor: pointer;
							font-size: 10px;
							line-height: 1;
							padding: 0;
						}

						.close-btn:hover {
							color: #f55;
						}

						.inventory-container {
							overflow: hidden;
							height: 94%;
							padding:5px;
						}

						.inventory {
							list-style-type: none;
							padding: 10px;
							margin: 0;
							overflow: auto;
							scrollbar-width: none;
							background-color: #111;
							border: 2px solid #2b2b2b;
							border-radius: 10px;
							height: 93%;
						}

						.item-card {
							display: flex;
							align-items: center;
							background-color: #1f1f1f;
							border: 1px solid #444;
							border-radius: 4px;
							padding: 8px;
							margin-bottom: 8px;
						}

						.item-image {
							width: 32px;
							height: 32px;
							image-rendering: pixelated;
							margin-right: 10px;
						}

						.item-name {
							flex-grow: 1;
							font-size: 14px;
						}

						.equip-btn {
							background-color: #4caf50;
							color: white;
							border: none;
							padding: 5px 10px;
							border-radius: 4px;
							cursor: pointer;
							font-size: 12px;
						}

						.equip-btn:hover {
							background-color: #45a049;
						}
					</style>
				</head>
				<body>
					<div class="title-bar">
						<span>Inventory</span>
						<button class="close-btn" onclick="BYOND.command('CloseCharacterPanel')">X</button>
					</div>
					<div class="inventory-container">
						<ul class="inventory">
			"}

//			for(var/obj/item/i in src.mob)
//				html_content += __get_inventory_html_card(i)
			for(var/i = 1, i < 10, i++)
				html_content += __get_inventory_html_card_test()

			html_content += {"
					</ul>
				</div>

				<script>
				</script>
				</body>
				</html>
				"}

			src << browse(html_content, "window=characterWindow.browser")