client
	proc
		HTML_BrowseSpellbook()
			var/mob/player/p = src.mob
			var/html_content = {"
				<!DOCTYPE html>
				<html lang="en">
				<head>
				<meta charset="UTF-8" />
				<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
				<title>Spellbook</title>
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

					.spellbook-container {
						overflow: hidden;
						height: 94%;
						padding: 5px;
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
						padding: 0;
					}

					.close-btn:hover {
						color: #f55;
					}

					.spell-grid {
						display: grid;
						grid-template-columns: repeat(2, 1fr);
						gap: 8px;
						padding: 8px;
						background-color: #111;
						border: 2px solid #2b2b2b;
						border-radius: 10px;
						overflow: auto;
						scrollbar-width: none;
					}

					.spell {
						position: relative;
						display: flex;
						align-items: center;
						background-color: #1f1f1f;
						border: 1px solid #444;
						border-radius: 6px;
						padding: 6px;
						transition: background 0.2s ease;
					}

					.spell:hover {
						background-color: #333;
					}

					.spell img {
						width: 32px;
						height: 32px;
						margin-right: 10px;
						image-rendering: pixelated;
						border-radius: 3px;
					}

					.spell-text {
						display:flex;
						flex-direction: column;
					}

					.spell-name {
						font-size: 13px;
						color: #ddd;
					}

					.spell-passive {
						font-size: 8px;
						color:#fff;
					}
					/* Tooltip styling */
					.tooltip {
						position: absolute;
						bottom: 100%;
						left: 0;
						transform: translateY(-8px);
						background-color: #222;
						color: #eee;
						padding: 6px 10px;
						font-size: 12px;
						border: 1px solid #666;
						border-radius: 4px;
						white-space: nowrap;
						z-index: 10;
						opacity: 0;
						pointer-events: none;
						transition: opacity 0.2s ease;
					}

					.spell:hover .tooltip {
						opacity: 1;
						pointer-events: auto;
					}
				</style>
				</head>
				<body>
					<div class="title-bar">
						<span>Spellbook</span>
						<button class="close-btn" onclick="BYOND.command('CloseCharacterPanel')">X</button>
					</div>

					<div class="spellbook-container">
						<div class="spell-grid">

						<!-- EXAMPLES -->

						<div class="spell">
							<img src="https://static.wikia.nocookie.net/wowwiki/images/d/dc/Ability_warlock_inferno.png/revision/latest?cb=20100910143031" alt="Spell 1">
							<div class="spell-text">
								<div class="spell-name">Fiery steps</div>
								<div class="spell-passive">Passive</div>
							</div>
							<div class="tooltip">A blazing fire errupts beneath your steps, dealing (stat_reiatsu * 0.3) <font color="cyan">Reiatsu</font> damage.</div>
						</div>
						<div class="spell">
							<img src="https://static.wikia.nocookie.net/wowwiki/images/0/07/Ability_warlock_backdraft.png/revision/latest?cb=20080822012035" alt="Spell 1">
							<div class="spell-text">
								<div class="spell-name">Ignite</div>
								<div class="spell-passive">Passive</div>
							</div>
						</div>
						<div class="spell">
							<img src="https://static.wikia.nocookie.net/wowwiki/images/f/f6/Ability_hunter_resourcefulness.png/revision/latest?cb=20070113140450" alt="Spell 1">
							<div class="spell-text">
								<div class="spell-name">Byakurai</div>
								<div class="spell-passive">Bakudo</div>
							</div>
						</div>
						<div class="spell">
							<img src="https://static.wikia.nocookie.net/wowwiki/images/e/e8/Ability_mage_firestarter.png/revision/latest?cb=20080911133442" alt="Spell 1">
							<div class="spell-text">
								<div class="spell-name">Shakkahō</div>
								<div class="spell-passive">Bakudo</div>
							</div>
						</div>
						<div class="spell">
							<img src="https://static.wikia.nocookie.net/wowwiki/images/1/15/Ability_vehicle_sonicshockwave.png/revision/latest?cb=20090228012439" alt="Spell 1">
							<div class="spell-text">
								<div class="spell-name">Rikujōkōrō</div>
								<div class="spell-passive">Hado</div>
							</div>
						</div>
			"}

			if(length(p.known_spells_list))
				for(var/i in p.known_spells_list)
					html_content += {"
						<div class="spell">
							<img src="https://static.wikia.nocookie.net/wowwiki/images/d/dc/Ability_warlock_inferno.png/revision/latest?cb=20100910143031" alt="Spell 1">
							<div class="spell-text">
								<div class="spell-name">Fiery steps</div>
								<div class="spell-passive">Passive</div>
							</div>
							<div class="tooltip">A blazing fire errupts beneath your steps, dealing (stat_reiatsu * 0.3) <font color="cyan">Reiatsu</font> damage.</div>
						</div>
					"}

			html_content += {"
		      		</div>
				</div>

				</body>
			</html>
			"}

			src << browse(html_content, "window=characterWindow.browser")
	verb
		OpenSpellbookPanel()
		//	set hidden = 1
			set category = "Test"
			HTML_BrowseSpellbook()
			if(!ui_is_open[UI_SPELLBOOK])
				winset(src, "main.characterChild", "is-visible=1;")
				ui_is_open[UI_SPELLBOOK] = TRUE
