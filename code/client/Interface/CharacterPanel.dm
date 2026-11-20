client/proc/HTML_BrowseCharacter()
	var/mob/player/p = src.mob
	var/html_content = {"
		<!DOCTYPE html>
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
				.container {
					padding:5px;
					height:94%;
				}
				.panel {
					display: flex;
					flex-direction: column;
					box-sizing: border-box;
					padding: 10px;
					overflow: hidden;
					height:100%;

					background-color: #111;
					border: 2px solid #2b2b2b;
					border-radius: 10px;
				}
				/* Character panel at top */
				.character-panel {
					display: flex;
					align-items: center;
					gap: 10px;

					background-color: #1a1a1a;
					overflow:hidden;
					margin-bottom:5px;
				}

				.section {
					flex: 1;
					height:82%;
					padding: 10px;
					overflow: auto;
					scrollbar-width: none;

					background-color: #1a1a1a;
					border: 1px solid #333;
					border-radius: 8px;
				}

				.character-img {
					width: 64px;
					height: 64px;
					border-radius: 5px;
					background-color: #333;
					background-size: cover;
					background-position: center;
				}

				.character-img img {
					width:100%;
					height:100%;
					overflow:hidden;
				}

				.char-info {
					flex: 1;
					display: flex;
					flex-direction: column;
					gap: 4px;
				}

				.char-name {
					font-size: 1em;
					font-weight: bold;
					color: #e69010;
				}

				.char-level {
					font-size: 0.8em;
				}

				.info-row {
					display: flex;
					justify-content: space-between;
					padding: 3px 0;
					font-size: 0.8em;
				}

				.level-row {
					display: flex;
					justify-content: space-between;
				}

				.info-row span:first-child {
					color: #e69010;
					font-weight: bold;
				}

				.divider {
					border-top: 1px solid #333;
					margin: 10px 0;
				}

				.bar-label {
					font-size: 0.8em;
					color: #e69010;
					font-weight:bold;
				}
				#he-t {
					color:#fff;
					font-weight:normal;
				}
				#reishi-t {
					color:#fff;
					font-weight:normal;
				}

				progress {
					width: 100%;
					height: 8px;
					border-radius: 4px;
					overflow: hidden;
					-webkit-appearance: none;
					appearance: none;
				}

				progress::-webkit-progress-bar {
					background-color: #2c2c2c;
					border-radius: 6px;
				}

				.health-bar::-webkit-progress-value {
					background-color: red;
					border-radius: 4px;
				}

				.reiatsu-bar::-webkit-progress-value {
					background-color: #4fc3f7;
					border-radius: 4px;
				}
				.exp-bar::-webkit-progress-value {
					background-color: purple;
					border-radius: 4px;
				}

				.green { background-color: #4caf50; }
				.orange { background-color: #ffa726; }
				.blue { background-color: #4fc3f7; }
				.lightblue { background-color: #03cafc }
				.red { background-color: #ef5350; }

				.stat-row {
					display: flex;
					justify-content: space-between;
					padding: 3px 0;
					font-size: 0.8em;
				}

				.stat-row span:first-child {
					color:#fff;
					font-weight: bold;
				}
				.reishi-padding-top {
					padding-top:5px;
				}

				#stat_versatility::after,
				#stat_hp_regen::after,
				#stat_mana_regen::after,
				#stat_critical_strike::after,
				#stat_cooldown_reduction::after,
				#stat_block_chance::after,
				#stat_parry_chance::after,
				#fatigue::after {
					content: "%";
				}
			</style>
		</head>
		<body>

			<div class="title-bar">
				<span>Character</span>
				<button class="close-btn" onclick="BYOND.command('CloseCharacterPanel')">X</button>
			</div>
			<div class="container">
				<div class="panel">
					<!-- Character Panel -->
					<div class="character-panel">
						<div class="character-img"><img id="character-appearance" src="\ref[p.appearance]"></div>
						<div class="char-info">
							<div class="char-name" id="name">[p.name]</div>
							<div class="char-level level-row">
								<span id="level">Lvl: [p.level]</span>
								<span>
									<span id="exp">[p.exp]</span>/<span id="req_exp">[p.req_exp]</span>
									(<span id="exp_percent">[round(p.exp/p.req_exp*100,0.5)]</span>%)
								</span>
							</div>
							<progress
								id="exp-bar"
								max="[p.req_exp]"
								value="[p.exp]"
								class="exp-bar">
							</progress>
						</div>
					</div>

					<!-- Content Section -->
					<div class="section">

						<div class="info-row">
							<span>Race:</span>
							<span id="race">[p.race]</span>
						</div>
						
						<div class="info-row">
							<span>Guild:</span>
							<span id="guild">[p.guild?.name]</span>
						</div>

						<div class="info-row">
							<span>Realm:</span>
							<span id="realm">[p.realm]</span>
						</div>

						<div class="divider"></div>

						<!-- Health -->
						<div class="bar-label">
							Health:<font color=white>
							<span id="hp">[p.hp]</span>/<span id="max_hp">[p.max_hp]</span>
							(<span id="hp_percent">[round(p.hp/p.max_hp*100)]</span>%)</font>
						</div>
						<progress
							id="health-bar"
							max="[p.max_hp]"
							value="[p.hp]"
							class="health-bar">
						</progress>

						<!-- Mana / Reishi -->
						<div class="bar-label reishi-padding-top">
							Reishi:<font color=white>
							<span id="mana">[p.mana]</span>/<span id="max_mana">[p.max_mana]</span>
							(<span id="mana_percent">[round(p.mana/p.max_mana*100)]</span>%)</font>
						</div>
						<progress
							id="reishi-bar"
							max="[p.max_mana]"
							value="[p.mana]"
							class="reiatsu-bar">
						</progress>

						<div class="divider"></div>

						<!-- Primary Stats -->
						<div class="stat-row">
							<span>Attack:</span>
							<span id="stat_attack">[p.stat_attack]</span>
						</div>
						<div class="stat-row">
							<span>Reiatsu:</span>
							<span id="stat_reiatsu">[p.stat_reiatsu]</span>
						</div>
						<div class="stat-row">
							<span>Defense:</span>
							<span id="stat_defense">[p.stat_defense]</span>
						</div>
						<div class="stat-row">
							<span>Versatility:</span>
							<span id="stat_versatility">[p.stat_versatility]</span>
						</div>
						
						<div class="divider"></div>

						<div class="stat-row">
							<span>Health regen:</span>
							<span id="stat_hp_regen">[p.stat_hp_regen]</span>
						</div>
						<div class="stat-row">
							<span>Reishi regen:</span>
							<span id="stat_mana_regen">[p.stat_mana_regen]</span>
						</div>
	  "}

	if(p.stat_crit_chance)
		html_content += {"
						<div class="stat-row">
							<span>Critical Strike Chance:</span>
							<span><span id="stat_crit_chance">[p.stat_crit_chance]</span>%</span>
						</div>
						"}

	if(p.stat_cooldown_reduction)
		html_content += {"
						<div class="stat-row">
							<span>Cooldown Reduction:</span>
							<span id="stat_cooldown_reduction">[p.stat_cooldown_reduction]</span>
						</div>
						"}

	if(p.stat_block_chance)
		html_content += {"
						<div class="stat-row">
							<span>Block Chance:</span>
							<span id="stat_block_chance">[p.stat_block_chance]</span>
						</div>
						"}

	if(p.stat_parry_chance)
		html_content += {"
						<div class="stat-row">
								<span>Parry Chance:</span>
								<span id="stat_parry_chance">[p.stat_parry_chance]</span>
							</div>
						"}


	if(p.race=="Shinigami")
		html_content += {"
		<div class="divider"></div>
		<div class="attribute"><span>Shikai Mastery:</span><span id="shikai-text">[p.shikai_mastery]</span></div>"}

		if(p.shikai_mastery >= 100)
			html_content += {"<div class="attribute"><span>Bankai Mastery:</span><span id="shikai-text">[p.bankai_mastery]</span></div>"}

	html_content += {"
	<div class="divider"></div>

	<div class="stat-row">
		<span>Fatigue:</span>
		<span id="fatigue">[p.fatigue]</span>
	</div>

	<div class="stat-row">
		<span>Kills:</span>
		<span id="kills">[p.kills]</span>
	</div>

	<div class="stat-row">
		<span>Money:</span>
		<span id="money">[p.money]</span>
	</div>
	<!--end section-->
	</div>
	<!--end panel-->
	</div>
	<!--end container-->
	</div>
	"}

	html_content += @{"
	<!--SCRIPT--->
	<script>

		function UpdateAppearance(_appearance) {
			document.getElementById('character-appearance').src = _appearance;
		}


		function TickUpdate(jsonString) {
			let parsed;

			try {
				parsed = JSON.parse(jsonString);
			} catch (err) {
				console.error("Invalid JSON string:", err);
				return;
			}

			// ! Variables that have corresponding progress bars.
			const progressBars = {
				exp: {
					bar: "exp-bar",
					max: "req_exp",
					percent: "exp_percent"
				},
				hp: {
					bar: "health-bar",
					max: "max_hp",
					percent: "hp_percent"
				},
				mana: {
					bar: "reishi-bar",
					max: "max_mana",
					percent: "mana_percent"
				}
			};

			// ! Update text fields using their matching variable names.
			for (const [key, value] of Object.entries(parsed)) {
				const element = document.getElementById(key);

				if (element) {
					element.textContent = value;
				}

				// Update character appearance separately.
				if (key === "character-appearance") {
					const appearance = document.getElementById(key);

					if (appearance) {
						appearance.src = value;
					}
				}
			}

			// ! Synchronize bars after all text fields have been updated.
			for (const [currentKey, config] of Object.entries(progressBars)) {
				const currentElement = document.getElementById(currentKey);
				const maxElement = document.getElementById(config.max);
				const bar = document.getElementById(config.bar);
				const percentElement = document.getElementById(config.percent);

				if (!bar) continue;

				// * Read the latest values from the DOM.
				// * This also handles cases where only one value changed.
				const current = Number(currentElement?.textContent);
				const max = Number(maxElement?.textContent);

				if (!Number.isFinite(current) || !Number.isFinite(max)) {
					continue;
				}

				bar.max = max;
				bar.value = current;

				if (percentElement) {
					const percent = max > 0
					? Math.round((current / max) * 100)
					: 0;

				percentElement.textContent = percent;
				}
			}
		}
		</script>
	"}
	html_content += {"<!--close--></body></html>"}


	src << browse(html_content, "window=characterWindow.browser")

client
	verb
		OpenCharacterPanel()
			set hidden = 1
			set category = "Test"
			ui_is_open[UI_CHARACTER] = TRUE 
			winset(src, "main.characterChild", "is-visible=1;")
			HTML_BrowseCharacter()

		CloseCharacterPanel()
			set hidden = 1
			set category = "Test"
			winset(src, "main.characterChild", "is-visible=0;")
			ui_is_open[UI_CHARACTER] = FALSE