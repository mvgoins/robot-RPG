love.graphics.setDefaultFilter("nearest","nearest")
fixedsysS = love.graphics.newFont("Fixedsys500c.ttf",14) -- cutesy but need a better font!
fixedsysM = love.graphics.newFont("Fixedsys500c.ttf",20)
fixedsysL = love.graphics.newFont("Fixedsys500c.ttf",26)
love.graphics.setFont(fixedsysM)

--print("save directory is "..love.filesystem.getSaveDirectory())
--print("getidentity is "..love.filesystem.getIdentity())

--print("does the save file exist? "..tostring(love.filesystem.exists("save")))
--print(" ")

require "controls"
require "maps"
require "assets"

view = "title" -- can be title, game, combat, gameover, endDoor, endShuttle

subkey = "none" -- this is for tracking whether you're in the menu on the main screen
subtarget = "none" -- what part of the menu you're looking at -- maybe not necessary? -- other note: menus as tables?

endstate = "none"
panX = 0
panY = 0
shuttleengine = 1
shuttlestate = 0


-- check later to see if any of these could be moved/made local 

-- starting locations in x,y,z coordinates
proloc = {7,31,1} -- normal start
--proloc = {30,4,2} -- second floor stairs
--proloc = {6,12,2} -- near the boss
--proloc = {3, 2, 2} -- shuttle bay

proface = protagonist_front -- what direction you're facing. used for the character icon. "front" is looking at player.
combatCount = 0 -- goes up by 1 every step
attack = 0 -- this needs to be made local later
combatTarget = "empty" -- what you're going to fight
combatTargetBonus = "empty" -- placeholder for multi-target fights
keyInput = "okay" -- whether or not you can type right now -- can be "okay" or "frozen"
combatpicktarget = 0 -- decides what you're going to fight
combatMenu = "top" -- what menu option you currently have selected
combatsubMenu = "none"
combatselect = 1
combatselectskill = 1


gameMaincursor = 1 -- blehhhhh these shouldn't be global?
gameItemcursor = 1
gameSkillcursor = 1
gameScrapcursor = 1

scrapPPcursor = 1
scrapAttcursor = 1
scrapSkillcursor = 1

menuYNcursor = 1

gameStatusMessage = nil
combatStatusMessage1 = nil
combatStatusMessage2 = nil
combatMessageCounter = 0

-- stats
prostats = {
			["currentHP"] = 100, 
			["maxHP"] = 100, 
			["currentPP"] = 10, 
			["maxPP"]=10, 
			["scrap"]=0, 
			["weapon"] = 0, 
			["weaponmax"] = 3, 
			["armor"] = 0, 
			["armormax"] = 3, 
			["speed"] = 0, 
			["speedmax"] = 3, 
			["shield"] = 0, 
			["pp1"] = 10, 
			["pp2"] = 1,
			}  
			
proskills = {				-- spells, essentially. they use pp. 0 don't have it, level 2 should be max. 
			["heal"] = 1, 
			["harm"] = 0, 
			["shield"] = 0,
			}
			
proitems = {
			["weapon"] = "no", 
			["armor"] = "no", 
			["speed"] = "no",
			["battery"] = "no",
			["factory"] = "no",
			["csteel"] = "no",
			["key"] = "yes", 
			}
			
batstats = {["currentHP"] = 15, ["maxHP"] = 15}
ratstats = {["currentHP"] = 30, ["maxHP"] = 30}
bossstats = {["currentHP"] = 100, ["maxHP"] = 100, ["currentPP"] = 10, ["maxPP"]=10, ["alive"] = "yes" }

healPads = {
			{8,16,1,50},
			{23,4,1,50},
			{28,4,2,50},
			{11,19,2,50},
			}

-- colors in rgba tables
colorwhite = {255, 255, 255}
colorgrey = {192, 192, 192}
colordarkgrey = {82, 82, 82}

function love.load()
	love.window.setMode(640,480)
	--print(love.math.random(1,100))
	--print(love.math.random(1,100))
	--print(love.math.random(1,100))
end

function love.update(dt)
	
	if combatMenu == "messages" then
		--print(combatMessageCounter)
		combatMessageCounter = combatMessageCounter + dt
		
		if combatMessageCounter >= 2 then -- display messages for 2 seconds
			if combatTarget == "empty" then
				view = "game"
				combatMenu = nil
			else
				combatMenu = "top"
				combatMessageCounter = 0
				combatStatusMessage1 = nil
				combatStatusMessage2 = nil
			end
		end
	end
	
	if endstate == "shuttle" or endstate == "door" then
		if panX > -640 then
			keyInput = "frozen"
			panX = panX - (dt + 0.5)
		end
	end
	
	if endstate == "shuttle" then
		if panX < -320 and panX > -640 then
			panY = panY + dt + 0.4
		end
		
		shuttlestate = shuttlestate + dt
		
		if shuttlestate >= 0 and shuttlestate <= 0.1 then
			shuttleengine = 1
		elseif shuttlestate >0.1 and shuttlestate <= 0.2 then
			shuttleengine = 2
		elseif shuttlestate > 0.2 then
			shuttlestate = 0
		end
		
	end
	
end

function saveGame()

	-- it's better to rewrite how the game sets the stats, so it just checks the inventory and then sets them new on load
	-- but we'll do this for now. practice, I guess.
	
	-- prostats
	love.filesystem.write("save",tostring(prostats.currentHP).."\n")
	love.filesystem.append("save",tostring(prostats.maxHP).."\n")
	love.filesystem.append("save",tostring(prostats.currentPP).."\n")
	love.filesystem.append("save",tostring(prostats.maxPP).."\n")
	love.filesystem.append("save",tostring(prostats.scrap).."\n")
	love.filesystem.append("save",tostring(prostats.weapon).."\n")
	love.filesystem.append("save",tostring(prostats.weaponmax).."\n")
	love.filesystem.append("save",tostring(prostats.armor).."\n")
	love.filesystem.append("save",tostring(prostats.armormax).."\n")
	love.filesystem.append("save",tostring(prostats.speed).."\n")
	love.filesystem.append("save",tostring(prostats.speedmax).."\n")
	love.filesystem.append("save",tostring(prostats.shield).."\n")
	love.filesystem.append("save",tostring(prostats.pp1).."\n")
	love.filesystem.append("save",tostring(prostats.pp2).."\n")
	
	-- proskills
	love.filesystem.append("save",tostring(proskills.heal).."\n")
	love.filesystem.append("save",tostring(proskills.harm).."\n")
	love.filesystem.append("save",tostring(proskills.shield).."\n")
	
	--proitems
	love.filesystem.append("save",tostring(proitems.weapon).."\n")
	love.filesystem.append("save",tostring(proitems.armor).."\n")
	love.filesystem.append("save",tostring(proitems.speed).."\n")
	love.filesystem.append("save",tostring(proitems.battery).."\n")
	love.filesystem.append("save",tostring(proitems.factory).."\n")
	love.filesystem.append("save",tostring(proitems.csteel).."\n")
	love.filesystem.append("save",tostring(proitems.key).."\n")
	
	-- boss status
	love.filesystem.append("save",tostring(bossstats.alive).."\n")

	-- location, added last, because I forgot it at first and don't want to redo all the loadgame indices
	love.filesystem.append("save",tostring(proloc[1].."\n"))
	love.filesystem.append("save",tostring(proloc[2].."\n"))
	love.filesystem.append("save",tostring(proloc[3].."\n"))
		
end

function saveMaps()
	-- this is not elegant
	
	if love.filesystem.exists("map1") then
		love.filesystem.remove("map1")
	end
	
	if love.filesystem.exists("map2") then
		love.filesystem.remove("map2")
	end
	
	love.filesystem.newFile("map1")
	love.filesystem.newFile("map2")
	--[[ -- checking to make sure the table outputs correctly
	for floor,map in ipairs(dungeon_features) do
		print("floor "..floor)
		for rowIndex,row in ipairs(dungeon_features[floor]) do
			print("floor "..floor.." and row "..rowIndex)
			for columnIndex,column in ipairs(dungeon_features[floor][rowIndex]) do
				print(columnIndex..","..rowIndex..","..floor.." is "..dungeon_features[floor][rowIndex][columnIndex])
			end
		end
	end --]]

	-- save feature map 1
	for rowIndex, row in ipairs(dungeon_features[1]) do
		for columnIndex, column in ipairs(dungeon_features[1][rowIndex]) do
			love.filesystem.append("map1",tostring(dungeon_features[1][rowIndex][columnIndex]).."\n")
		end
	end
	
	-- save feature map 2
	for rowIndex, row in ipairs(dungeon_features[2]) do
		for columnIndex, column in ipairs(dungeon_features[2][rowIndex]) do
			love.filesystem.append("map2",tostring(dungeon_features[2][rowIndex][columnIndex]).."\n")
		end
	end
end

function loadGame()

	local loadgame = {}
	local map1 = {}
	local map2 = {}
	
	local ymap1 = 1
	local xcount1 = 1
	local ymap2 = 1
	local xcount2 = 1
	
	for y = 1,32 do -- initialize all the rows in the maps
		map1[y] = {}
		map2[y] = {}
	end
	

	for line in love.filesystem.lines("save") do
		table.insert(loadgame,line)
	end
	
	for line in love.filesystem.lines("map1") do
		table.insert(map1[ymap1],tonumber(line)) -- note: problem for non-number entries! 
		xcount1 = xcount1 + 1
		if xcount1 == 33 then
			xcount1 = 1
			ymap1 = ymap1 + 1
		end
	end
	
	for line in love.filesystem.lines("map2") do
		table.insert(map2[ymap2],tonumber(line)) -- note: problem for non-number entries!
		xcount2 = xcount2 + 1
		if xcount2 == 33 then
			xcount2 = 1
			ymap2 = ymap2 + 1
		end
	end
	
	dungeon_features[1] = map1
	dungeon_features[2] = map2
	--mapcheck()
	
--[[
	for line in love.filesystem.lines("map2") do
		for y = 1,32 do
			for x = 1,32 do
				table.insert(map2[y],tonumber(line))
			end
		end
	end
	
	dungeon_features[2] = map2
	--]]
--[[	for i,v in ipairs(loadgame) do -- test it!
		print(loadgame[i])
	end--]]

	prostats.currentHP = loadgame[1] + 0
	prostats.maxHP = loadgame[2] + 0
	prostats.currentPP = loadgame[3] + 0
	prostats.maxPP = loadgame[4] + 0
	prostats.scrap = loadgame[5] + 0 
	prostats.weapon = loadgame[6] + 0
	prostats.weaponmax = loadgame[7] + 0
	prostats.armor = loadgame[8] + 0
	prostats.armormax = loadgame[9] + 0
	prostats.speed = loadgame[10] + 0
	prostats.speedmax = loadgame[11] + 0
	prostats.shield = loadgame[12] + 0
	prostats.pp1 = loadgame[13] + 0
	prostats.pp2 = loadgame[14] + 0
	
	proskills.heal = loadgame[15] + 0
	proskills.harm = loadgame[16] + 0
	proskills.shield = loadgame[17] + 0
	
	proitems.weapon = loadgame[18]
	proitems.armor = loadgame[19]
	proitems.speed = loadgame[20]
	proitems.battery = loadgame[21]
	proitems.factory = loadgame[22]
	proitems.csteel = loadgame[23]
	proitems.key = loadgame[24]
	
	bossstats.alive = loadgame[25]	
	
	proloc[1] = loadgame[26] + 0
	proloc[2] = loadgame[27] + 0
	proloc[3] = loadgame[28] + 0
	
end

function mapcheck()

	-- checking to make sure the table outputs correctly
	for floor,map in ipairs(dungeon_features) do
		print("floor "..floor)
		for rowIndex,row in ipairs(dungeon_features[floor]) do
			print("floor "..floor.." and row "..rowIndex)
			for columnIndex,column in ipairs(dungeon_features[floor][rowIndex]) do
				print(columnIndex..","..rowIndex..","..floor.." is "..dungeon_features[floor][rowIndex][columnIndex])
			end
		end
	end
end

function viewTitle() -- the title/start screen
	love.graphics.printf("ROBOT QUEST",0,140,640,"center")
	love.graphics.printf("[N]ew Game",0,300,640,"center")
	if love.filesystem.exists("save") then
		love.graphics.printf("[L]oad Game",0,350,640,"center")
	end
	
	--[[ debug stuff, making sure images load. delete this later
	love.graphics.draw(protagonist_front,0,0)
	love.graphics.draw(dungeon_floor,64,0)
	love.graphics.draw(dungeon_wall,96,0)
	love.graphics.draw(treasure1,0,64)
	love.graphics.draw(healPad3,64,64) --]]
	
end -- end viewTitle

function viewGame() -- the main view of the map/dungeon

	local mbX = 32
	local mbY = 250

	-- draw the terrain
	for y = -5,5 do
		currentY = proloc[2] + y
		if dungeon_terrain[proloc[3]][currentY] then
			for x = -5,5 do
				currentX = proloc[1] + x
				if dungeon_terrain[proloc[3]][currentY][currentX] then
					local checkspot = dungeon_terrain[proloc[3]][currentY][currentX]
					if checkspot == 0 then
						love.graphics.draw(dungeon_wall,16 + 32 * (x + 5),16 + 32 * (y + 5))
					elseif checkspot == 1 then
						love.graphics.draw(dungeon_floor,16 + 32 * (x + 5),16 + 32 * (y + 5))
					elseif checkspot == 2 then
						love.graphics.draw(floor2,16 + 32 * (x + 5),16 + 32 * (y + 5))
					elseif checkspot == 3 then
						love.graphics.draw(floor3,16 + 32 * (x + 5),16 + 32 * (y + 5))
					elseif checkspot == 4 then
						love.graphics.draw(floor4,16 + 32 * (x + 5),16 + 32 * (y + 5))
					elseif checkspot == 9 then
						love.graphics.draw(floor9,16 + 32 * (x + 5),16 + 32 * (y + 5))					
					end
				end
			end
		end
	end -- end terrain drawing
	
	-- draw terrain features (treasure chests, portals, et cetera)
	for y = -5,5 do
		currentY = proloc[2] + y
		if dungeon_features[proloc[3]][currentY] then
			for x = -5,5 do
				currentX = proloc[1] + x
				
				if dungeon_features[proloc[3]][currentY][currentX] then
				--[[ 1: stairs down
				 	 2: stairs up
				 	 3: regular chest
				 	 4: cyber chest
				 	 5: charged heal pad
				 	 6: half-charged heal pad
				 	 7: drained heal pad
					 8: stone door
					 9: cyber door
				 --]]	 
				 	 
				 	local here = dungeon_features[proloc[3]][currentY][currentX]
					local drawX = 16 + 32 * (x + 5)
					local drawY = 16 + 32 * (y + 5)
					
					if here == 1 then
						love.graphics.draw(stairsDown,drawX, drawY)

					elseif here == 2 then
						love.graphics.draw(stairsUp,drawX, drawY)

					elseif here == 3 then
						love.graphics.draw(treasure1,drawX, drawY)

					elseif here == 4 then
						love.graphics.draw(treasure2,drawX, drawY)

					elseif here == 5 then
						love.graphics.draw(healPad3,drawX, drawY)
						
					elseif here == 6 then
						love.graphics.draw(healPad2,drawX, drawY)
						
					elseif here == 7 then
						love.graphics.draw(healPad1,drawX, drawY)
						
					elseif here == 8 then
						love.graphics.draw(rock,drawX, drawY)
						
					elseif here == 9 then
						love.graphics.draw(door,drawX, drawY)

					elseif here == 10 then
						love.graphics.draw(shuttle,drawX, drawY)		
						
					elseif here == 11 then
						love.graphics.draw(dungeon_wall,drawX, drawY)		
						
					elseif here == 12 then
						love.graphics.draw(outsidelight,drawX,drawY)	
					end
				end
			end
		end
	end -- end feature drawing		
	
	love.graphics.draw(screenborder1,0,0) -- draw a border around the map
		
	love.graphics.draw(proface, 16 + 32 * 5,16 + 32 * 5) -- draw the character
	
	if gameStatusMessage then
		love.graphics.printf(gameStatusMessage,32,400,592,"center")
	end
	
	
	if subkey == "none" then -- draw the normal stats you see
	
		love.graphics.print("HP: "..prostats.currentHP.."/"..prostats.maxHP,416,32)
		love.graphics.print("PP: "..prostats.currentPP.."/"..prostats.maxPP,416,82)
		love.graphics.print("Scrap: "..prostats.scrap,416,132)
		love.graphics.print("[M]enu",416,332)
		
		
	elseif subkey == "main" then -- draw the menu overtop

		love.graphics.print("Check",416,32)
		love.graphics.print("Skills",416,82)
		love.graphics.print("Scrap",416,132)
		love.graphics.print("Items",416,182)

		love.graphics.print("[S]ave",416,332)
		love.graphics.print("[L]oad",516,332)
		
		if gameMaincursor < 5 then
			love.graphics.draw(menuSelector,396, 35 + 50 * (gameMaincursor - 1))
		else 
			love.graphics.draw(menuSelector,396, 335)
		end

	elseif subkey == "mainItems" then
	
		if proitems.weapon == "yes" then
			love.graphics.print("W-Plans",416,32)
		end
		
		if proitems.armor == "yes" then
			love.graphics.print("A-Plans",416,82)
		end
		
		if proitems.speed == "yes" then
			love.graphics.print("S-Plans",416,132)
		end
		
		if proitems.battery == "yes" then
			love.graphics.print("Battery",416,182)
		end
		
		if proitems.factory == "yes" then
			love.graphics.print("Factory",416,232)
		end
		
		if proitems.csteel == "yes" then
			love.graphics.print("C-Steel",416,282)
		end
		
		if proitems.key == "yes" then
			love.graphics.print("Key",416,332)
		end
	
	elseif subkey == "mainScrap" then
		love.graphics.print("Restore PP",416,82)
		love.graphics.print("Upgrade Attribute",416,132)
		love.graphics.print("Upgrade Skill",416,182)
		
		love.graphics.draw(menuSelector,396,85 + 50 * (gameScrapcursor - 1))
	

	elseif subkey == "mainItems" then
		love.graphics.print("Items...",416,82)
	
	
	elseif subkey == "mainSkills" then
		love.graphics.print("Heal",416,82)
		love.graphics.print("Harm",416,132)
		love.graphics.print("Shield",416,182)

		love.graphics.draw(menuSelector,396,85 + 50 * (gameSkillcursor - 1))	
	
	-- scrap submenu
	elseif subkey == "scrapPP" then
		love.graphics.printf("Turn "..prostats.pp1.." scrap into "..prostats.pp2.." power?",416,32,200,"center")
		love.graphics.print("No",416,132)
	
		if prostats.currentPP < prostats.maxPP and prostats.scrap >= 10 then
			love.graphics.print("Yes",416,182)
		else
			love.graphics.setColor(colordarkgrey)
			love.graphics.print("Yes",416,182)
			love.graphics.setColor(colorwhite)
		end
		
	
		love.graphics.draw(menuSelector,396,135 + 50 * (scrapPPcursor - 1))
	
		love.graphics.print("Scrap: "..prostats.scrap,416,282)
		love.graphics.print("Power: "..prostats.currentPP.."/"..prostats.maxPP,416,332)
		
	elseif subkey == "scrapAttributes" then
		love.graphics.print("Upgrade attribute?",416,32)
		love.graphics.print("Weapon: "..prostats.weapon.."/"..prostats.weaponmax,416,132)
		love.graphics.print("Armor : "..prostats.armor.."/"..prostats.armormax,416,182)
		love.graphics.print("Speed : "..prostats.speed.."/"..prostats.speedmax,416,232)
		
		love.graphics.draw(menuSelector,396,135 + 50 * (scrapAttcursor - 1))
	
	
	elseif subkey == "weaponCheck" then
		local nextwep = prostats.weapon + 1
		local nextwepcost = nextwep * 500
		
		if prostats.weapon < prostats.weaponmax then
			love.graphics.printf("Upgrade weapon for "..nextwepcost.." scrap?",416,32,200,"center")

			love.graphics.print("No",416,132)
		
			if prostats.scrap >= nextwepcost then
				love.graphics.print("Yes",416,182)
			else
				love.graphics.setColor(colordarkgrey)
				love.graphics.print("Yes",416,182)
				love.graphics.setColor(colorwhite)
			end
		
			love.graphics.draw(menuSelector,396,135 + 50 * (menuYNcursor - 1))
	
		else
			love.graphics.print("Weapons are maxed!",416,32)
		end
	
	elseif subkey == "armorCheck" then
		local nextarm = prostats.armor + 1
		local nextarmcost = nextarm * 500
		
		if prostats.armor < prostats.armormax then
			love.graphics.printf("Upgrade armor for "..nextarmcost.." scrap?",416,32,200,"center")

			love.graphics.print("No",416,132)

		
			if prostats.scrap >= nextarmcost then
				love.graphics.print("Yes",416,182)
			else
				love.graphics.setColor(colordarkgrey)
				love.graphics.print("Yes",416,182)
				love.graphics.setColor(colorwhite)
			end
		
			love.graphics.draw(menuSelector,396,135 + 50 * (menuYNcursor - 1))
		
		else
			love.graphics.print("Armor is maxed!",416,32)
		end

	elseif subkey == "speedCheck" then
		local nextspd = prostats.speed + 1
		local nextspdcost = nextspd * 500
		
		if prostats.speed < prostats.speedmax then
			love.graphics.printf("Upgrade speed for "..nextspdcost.." scrap?",416,32,200,"center")

			love.graphics.print("No",416,132)

		
			if prostats.scrap >= nextspdcost then
				love.graphics.print("Yes",416,182)
			else
				love.graphics.setColor(colordarkgrey)
				love.graphics.print("Yes",416,182)
				love.graphics.setColor(colorwhite)
			end
		
			love.graphics.draw(menuSelector,396,135 + 50 * (menuYNcursor - 1))
		
		else
			love.graphics.print("Speed is maxed!",416,32)
		end

	elseif subkey == "scrapSkills" then
		love.graphics.print("Upgrade skill?",416,32)
		love.graphics.print("Heal  : "..proskills.heal.."/2",416,132)
		love.graphics.print("Harm  : "..proskills.harm.."/2",416,182)
		love.graphics.print("Shield: "..proskills.shield.."/2",416,232)
		
		love.graphics.draw(menuSelector,396,135 + 50 * (scrapSkillcursor - 1))
		
	elseif subkey == "healCheck" then
		local nextheal = proskills.heal + 1
		local nextcost = (proskills.heal + 1) * 1000
		
		if proskills.heal < 2 then
			love.graphics.printf("Upgrade Heal for "..nextcost.." scrap?",416,32,200,"center")

			love.graphics.print("No",416,132)

		
			if prostats.scrap >= nextcost then
				love.graphics.print("Yes",416,182)
			else
				love.graphics.setColor(colordarkgrey)
				love.graphics.print("Yes",416,182)
				love.graphics.setColor(colorwhite)
			end
		
			love.graphics.draw(menuSelector,396,135 + 50 * (menuYNcursor - 1))
		
		else
			love.graphics.print("Heal is maxed!",416,32)
		end	
	
	
	elseif subkey == "harmCheck" then
		local nextharm = proskills.harm + 1
		local nextcost = (proskills.harm + 1) * 1000
		
		if proskills.harm < 2 then
			love.graphics.printf("Upgrade Harm for "..nextcost.." scrap?",416,32,200,"center")

			love.graphics.print("No",416,132)

		
			if prostats.scrap >= nextcost then
				love.graphics.print("Yes",416,182)
			else
				love.graphics.setColor(colordarkgrey)
				love.graphics.print("Yes",416,182)
				love.graphics.setColor(colorwhite)
			end
		
			love.graphics.draw(menuSelector,396,135 + 50 * (menuYNcursor - 1))
		
		else
			love.graphics.print("Harm is maxed!",416,32)
		end		
	
	
	elseif subkey == "shieldCheck" then
		local nextshield = proskills.shield + 1
		local nextcost = (proskills.shield + 1) * 1000
		
		if proskills.shield < 2 then
			love.graphics.printf("Upgrade Shield for "..nextcost.." scrap?",416,32,200,"center")

			love.graphics.print("No",416,132)

		
			if prostats.scrap >= nextcost then
				love.graphics.print("Yes",416,182)
			else
				love.graphics.setColor(colordarkgrey)
				love.graphics.print("Yes",416,182)
				love.graphics.setColor(colorwhite)
			end
		
			love.graphics.draw(menuSelector,396,135 + 50 * (menuYNcursor - 1))
		
		else
			love.graphics.print("Shield is maxed!",416,32)
		end	
	
	end -- end the whole damn scrapview drawing stack
	
end -- end viewGame

function skillHealCheck()
	if prostats.currentPP >= 2 and prostats.currentHP < prostats.maxHP then
		prostats.currentPP = prostats.currentPP - 2
	
		local toheal = prostats.currentHP + 10 * proskills.heal
		subkey = "none"

		if toheal < prostats.maxHP then
			prostats.currentHP = toheal
			gameStatusMessage = "Healed "..10 * proskills.heal.." HP."
		else 
			prostats.currentHP = prostats.maxHP
			gameStatusMessage = "HP fully restored."
		end
	
	elseif prostats.currentPP < 2 then
		gameStatusMessage = "Not enough power."
	
	elseif prostats.currentHP == prostats.maxHP then
		gameStatusMessage = "HP already at maximum."
	end	
end

function skillHarmCheck()
	
	if prostats.currentPP >= 6 then
		if dungeon_features[proloc[3]][proloc[2] + 1][proloc[1]] == 8 
			or dungeon_features[proloc[3]][proloc[2] - 1][proloc[1]] == 8
			or dungeon_features[proloc[3]][proloc[2]][proloc[1] + 1] == 8
			or dungeon_features[proloc[3]][proloc[2]][proloc[1] - 1] == 8 then
			
 			for y = -1,1 do -- so right now this destroys everything around the player if one of the things is a rock
 				for x = -1,1 do -- that's.. not great! but there's no actual case where it matters so I'm running with it
 					dungeon_features[proloc[3]][proloc[2] + y][proloc[1] + x] = 0
 				end
 			end
 			gameStatusMessage = "You removed the rock."
 			prostats.currentPP = prostats.currentPP - 6
 			subkey = "none"
 		else
 			gameStatusMessage = "There's nothing to use that on here."
 		end
 	else
		gameStatusMessage = "You don't have enough power."
	end
end	


function skillShieldCheck()
	gameStatusMessage = "There's no need for that now."
	subkey = "none"
end


function featureCheck() -- see if the player is on a feature, and do something if they are

	local floor = proloc[3]
	local here = dungeon_features[proloc[3]][proloc[2]][proloc[1]]
	
	--print("floor: "..proloc[3].." y: "..proloc[2].." x: "..proloc[1])
	--print("Here is: "..here)
	--print(" ")
	
	if here == 0 then
		gameStatusMessage = "Nothing interesting here."
	elseif here == 1 then
		proloc[3] = proloc[3] + 1
	elseif here == 2 then
		proloc[3] = proloc[3] - 1
	elseif here == 3 then -- there has got to be a better way to do this. all treasures in a table, probably, and ipairs through it
		love.audio.play(treasure)
		if floor == 1 then -- 1st floor treasures
			if proloc[2] == 29 and proloc[1] == 3 then
				gameStatusMessage = "You found 1000 scrap."
				prostats.scrap = prostats.scrap + 1000
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0 -- DON'T USE "HERE". that just sets that VARIABLE to the number. has to be the direct array address. not sure how to shortcut it.
				print(here)

			elseif proloc[2] == 23 and proloc[1] == 3 then
				gameStatusMessage = "You found 750 scrap."
				prostats.scrap = prostats.scrap + 750
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0
				
			elseif proloc[2] == 23 and proloc[1] == 19 then
				gameStatusMessage = "You found 500 scrap."
				prostats.scrap = prostats.scrap + 500
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0
			end
				
		elseif floor == 2 then
			if proloc[2] == 3 and proloc[1] == 28 then
				gameStatusMessage = "You found 750 scrap."
				prostats.scrap = prostats.scrap + 750
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0 
				
				
			elseif proloc[2] == 5 and proloc[1] == 28 then
				gameStatusMessage = "You found 750 scrap."
				prostats.scrap = prostats.scrap + 750
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0

			elseif proloc[2] == 27 and proloc[1] == 29 then
				gameStatusMessage = "You found 3000 scrap."
				prostats.scrap = prostats.scrap + 3000
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0		
			end
					
		end -- end regular treasure
		
	elseif here == 4 then -- cyber chests
		love.audio.play(powerup)
		if floor == 1 then
			if proloc[2] == 13 and proloc[1] == 25 then
				gameStatusMessage = "You found some schematics. Your maximum speed increases."
				prostats.speedmax = 5
				proitems.speed = "yes"
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0
			
			elseif proloc[2] == 27 and proloc[1] == 24 then
				gameStatusMessage = "You found a battery upgrade. Your maximum power increases."
				prostats.maxPP = 20
				proitems.battery = "yes"
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0
				
			end

		elseif floor == 2 then
			if proloc[2] == 15 and proloc[1] == 27 then -- weapon plans
				gameStatusMessage = "You found some schematics. Your maximum weapon increases."
				prostats.weaponmax = 5
				proitems.weapon = "yes"
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0
				
			elseif proloc[2] == 20 and proloc[1] == 3 then -- armor plans
				gameStatusMessage = "You found some schematics. Your maximum armor increases."
				prostats.armormax = 5
				proitems.armor = "yes"
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0
	
			elseif proloc[2] == 5 and proloc[1] == 23 then -- factory
				gameStatusMessage = "Your nanomachines are more efficient at converting scrap now."
				prostats.pp2 = 3
				proitems.factory = "yes"
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0

			elseif proloc[2] == 5 and proloc[1] == 11 then -- c-steel
				gameStatusMessage = "Your nanomachines upgrade your frame and your maximum health increases."
				prostats.maxHP = 150
				proitems.csteel = "yes"
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0
			
			elseif proloc[2] == 12 and proloc[1] == 2 then -- key
				gameStatusMessage = "You find the key to the locked door... and some seeds."
				proitems.key = "yes"
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0
			end
		end -- end cyber treasure
	
	elseif here == 5 then
		--print("healing pad")
		if prostats.currentHP == prostats.maxHP then
			gameStatusMessage = "You are currently undamaged."
		elseif prostats.currentHP + 50 < prostats.maxHP then
			love.audio.play(healpad)
			prostats.currentHP = prostats.currentHP + 50
			
			for i,v in ipairs(healPads) do
				if healPads[i][1] == proloc[1] and healPads[i][2] == proloc[2] and healPads[i][3] == proloc[3] then
					healPads[i][4] = 0
				end
			end
			
			dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 7

			if prostats.currentHP >= math.floor(prostats.maxHP * 0.9) then -- if you're at 90% health, a different message
				gameStatusMessage = "Most of your damage is repaired."
			else
				gameStatusMessage = "Some of your damage is repaired."
			end
		else
			gameStatusMessage = "All of your damage is repaired."
			prostats.currentHP = prostats.maxHP
			love.audio.play(healpad)
			
			for i,v in ipairs(healPads) do
				if healPads[i][1] == proloc[1] and healPads[i][2] == proloc[2] and healPads[i][3] == proloc[3] then
					healPads[i][4] = 0
				end
			end	
			dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 7

		end
		
	elseif here == 6 or here == 7 then
		--print("not yet")
		gameStatusMessage = "The heal pad isn't recharged yet."
	
	elseif here == 10 then
		view = "endShuttle"
		endstate = "shuttle"
--		print("starting shuttle end")
		
	elseif here == 12 then
		view = "endDoor"
		endstate = "door"
--		print("starting door end")
		
	end	-- ends all the possible feature checking
	
	-- note: no check for 8 or 9, since those block movement and cannot be stood on. use custom messages for those.
	
end -- ending featureCheck()

function healPadRegen()
local padnum = 0
	for i,v in ipairs(healPads) do
		--padnum = padnum + 1
		--print("checking pad "..padnum)
		if healPads[i][4] < 50 then
			healPads[i][4] = healPads[i][4] + 1
		--	print("Pad "..padnum.." + 1!")
		end
			
		if healPads[i][4] >= 25 and healPads[i][4] < 50 then
			dungeon_features[healPads[i][3]][healPads[i][2]][healPads[i][1]] = 6
			
		elseif healPads[i][4] == 50 then
			dungeon_features[healPads[i][3]][healPads[i][2]][healPads[i][1]] = 5
		end
	end

end

function combatCheck() -- begin the check to see if a random encounter happens -- but it's all combat, I guess? rework for later iteration of the game

	combatCount = combatCount + 1
	
	attack = love.math.random(1,25) + combatCount -- this should be made local later; global now for ease of debugging

	if proloc[3] == 2 and proloc[2] == 12 and proloc[1] == 4 then
		if bossstats.alive == "yes" then
			keyInput = "frozen"
			combatTarget = "boss"
			bossstats.currentHP = 100
			print("full health!")
			bossstats.currentPP = 10
			print("full power!")
			view = "combat"
			combatMenu = "top"
			keyInput = "okay"
			combatCount = 0
		end

	elseif attack > 49 then
		keyInput = "frozen" -- I'm not sure if there'd be enough time for someone to hit a key between the time this starts and the time combat actually come sup, but.. might as well freeze the keys just in case
		combatSelection()
		view = "combat"
		combatMenu = "top"
		keyInput = "okay"
		combatCount = 0
	end
end -- end combatCheck


function combatSelection()
	combatpicktarget = love.math.random(1,100)
	
	if combatpicktarget < 51 then -- should be even distribution, but it is not; check randomness issues
		combatTarget = "bat"
		batstats.maxHP = love.math.random(10,15) -- bats have between 10 and 15 HP
		batstats.currentHP = batstats.maxHP
	elseif combatpicktarget >= 51 then
		combatTarget = "rat"
		ratstats.maxHP = love.math.random(20,30) -- rats have between 20 and 30 HP
		ratstats.currentHP = ratstats.maxHP
	end
	
end -- end combatSelection

function combatProAttack()

--	combatStatusMessage1 = nil
--	combatStatusMessage2 = nil
		
	combatDealDamage()
	
	if combatTarget == "bat" then
		if batstats.currentHP > 0 then
			combatTakeDamage()
			love.audio.play(hit1)
		end
	
	elseif combatTarget == "rat" then
		if ratstats.currentHP > 0 then
			combatTakeDamage()
			love.audio.play(hit2)
		end
	
	elseif combatTarget == "boss" then
		if bossstats.currentHP > 0 then
			combatTakeDamage()
			love.audio.play(hit4)
		end
	
	end -- end if-target-then-damage
		
	combatMenu = "messages"
	
end

function combatProScare()
	
	if love.math.random(1,100) > 25 then
		if combatTarget == "boss" then
			proloc[1] = 5
		end
		combatStatusMessage1 = "The enemy backs off."
		combatStatusMessage2 = nil
		combatMenu = "messages"
		combatTarget = "empty" -- do this to make love.update clear the fight properly
	else 
		combatStatusMessage1 = "The enemy isn't intimidated."
		combatTakeDamage()
		combatMenu = "messages"
	end
		combatselect = 1
	combatskillselect = 1

end

function combatProHeal()
	
	prostats.currentPP = prostats.currentPP - 2
	
	local toheal = prostats.currentHP + 10 * proskills.heal

	if toheal < prostats.maxHP then
		prostats.currentHP = toheal
		combatStatusMessage1 = "You repaired "..10 * proskills.heal.." damage."
	else 
		prostats.currentHP = prostats.maxHP
		combatStatusMessage1 = "You healed all your damage."
	end

	combatTakeDamage()

	combatMenu = "messages"

end

function combatProHarm()

	prostats.currentPP = prostats.currentPP - 6
	
	local harm = 10 * proskills.harm
	
	if combatTarget == "bat" then
		batstats.currentHP = batstats.currentHP - harm
		if batstats.currentHP <= 0 then
			combatCleanup() -- should add combat messages here first
		else 
			combatTakeDamage()
		end
	end
	
	if combatTarget == "rat" then
		ratstats.currentHP = ratstats.currentHP - harm
		if ratstats.currentHP <= 0 then
			combatCleanup() -- should add combat messages here first
		else
			combatTakeDamage()
		end
	end
	
	if combatTarget == "boss" then
		bossstats.currentHP = bossstats.currentHP - harm
		if bossstats.currentHP <= 0 then
			combatCleanup() -- should add combat messages here first
		else
			combatTakeDamage()
		end
	end
	
	combatStatusMessage1 = "Your attack did "..harm.." damage."
	combatMenu = "messages"

end

function combatProShield()

	prostats.shield = proskills.shield + 1
	prostats.currentPP = prostats.currentPP - 4
		
	if combatTarget == "bat" then
		prostats.shield = prostats.shield - 1
	end
		
	if combatTarget == "rat" then
		prostats.shield = prostats.shield - 1
	end
	
	if combatTarget == "boss" then
		prostats.shield = prostats.shield - 1 -- they should do more shield damage, but shields are kind of clumsy at the moment. leave this.
	end
	
	combatStatusMessage1 = "You put up an energy field and the enemy attacks."
	combatStatusMessage2 = "You have "..prostats.shield.." shield points remaining."
	combatMenu = "messages"
	combatselect = 1
	combatskillselect = 1
	
end

function combatDealDamage()

	local damage = love.math.random(5,10) + prostats.weapon + math.ceil(0.5 * prostats.speed) -- need something different for speed

	if combatTarget == "bat" then
		batstats.currentHP = batstats.currentHP - damage
		if batstats.currentHP <= 0 then 
			combatCleanup()
		end
	
	
	elseif combatTarget == "rat" then
		ratstats.currentHP = ratstats.currentHP - damage
		if ratstats.currentHP <= 0 then
			combatCleanup()
		end
	
	elseif combatTarget == "boss" then
		bossstats.currentHP = bossstats.currentHP - damage
		if bossstats.currentHP <= 0 then
			combatCleanup()
		end
	
	end -- end the damage dealing
	
	combatStatusMessage1 = "You dealt "..damage.." to the enemy."

end


function combatTakeDamage()

	if prostats.shield > 0 then
		prostats.shield = prostats.shield - 1
	
	elseif combatTarget == "bat" then
		local batdamage = love.math.random(1,5) - prostats.armor
		if batdamage > 0 then
			prostats.currentHP = prostats.currentHP - batdamage
			combatStatusMessage2 = "The bat did "..batdamage.." damage."
			if batstats.currentHP < 10 then
				batstats.currentHP = batstats.currentHP + batdamage -- drain health!
			end
		else
			combatStatusMessage2 = "Your armor blocked the bat."
		end
		
	elseif combatTarget == "rat" then
		local ratdamage = love.math.random(5,10) - prostats.armor
		if ratdamage > 0 then
			prostats.currentHP = prostats.currentHP - ratdamage
			combatStatusMessage2 = "The rat did "..ratdamage.." damage."
		else
			combatStatusMessage2 = "Your armor blocked the rat."
		end		
	
	elseif combatTarget == "boss" then
		local bossdamage = love.math.random(10,15) - prostats.armor
		if bossdamage > 0 then
			prostats.currentHP = prostats.currentHP - bossdamage
			combatStatusMessage2 = "The robots did "..bossdamage.." damage."
		else
			combatStatusMessage2 = "Your armor blocked the robots."
		end
	
	end
	
	if prostats.currentHP <= 0 then
		view = "gameover"
		love.audio.play(destroyed)
	end
	
	combatMenu = "top"
	combatselect = 1
	combatskillselect = 1

end

function combatCleanup()

	if combatTarget == "bat" then
		prostats.scrap = prostats.scrap + 50
		combatStatusMessage2 = "You gained 50 scrap."
	elseif combatTarget == "rat" then
		prostats.scrap = prostats.scrap + 100
		combatStatusMessage2 = "You gained 100 scrap."
	elseif combatTarget == "boss" then
		prostats.scrap = prostats.scrap + 1000
		combatStatusMessage2 = "You gained 1000 scrap."
		bossstats.alive = "no"
	end
	
	combatTarget = "empty"
	love.audio.play(hit3)
	
	prostats.shield = 0
	combatMenu = "messages"
	combatselect = 1
	combatskillselect = 1
	
end

function viewCombat()


	-- here is where we'd draw in background pictures
	love.graphics.draw(combatBorder,0,0) -- draw the border for the screen

	-- draw the target's icon 
	if combatTarget == "bat" then
		love.graphics.draw(batPic,200,16,0,4,4)
	elseif combatTarget == "rat" then
		love.graphics.draw(ratPic,200,16,0,4,4)
	elseif combatTarget == "boss" then
		love.graphics.draw(bossPic,128,16,0,4,4)
		love.graphics.draw(bossPic,256,16,0,4,4)
	end
	

--	love.graphics.print(combatpicktarget,300,100) -- what's going on with who shows up?
	

	if combatMenu == "top" then 
		love.graphics.print("Fight",64,350)
		love.graphics.print("Skill",264,350)
		love.graphics.print("Intimidate",464,350)
		love.graphics.draw(menuSelector,32 + 200 * (combatselect - 1),353)
		
	elseif combatMenu == "skill" then
		love.graphics.print("Heal",64,350)
		love.graphics.print("Harm",264,350)
		love.graphics.print("Shield",464,350)
		love.graphics.draw(menuSelector,32 + 200 * (combatselectskill - 1),353)
	
	elseif combatMenu == "messages" then
		if combatStatusMessage1 then
			love.graphics.print(combatStatusMessage1,32,330)
		end
		if combatStatusMessage2 then
			love.graphics.print(combatStatusMessage2,32,380)
		end
	end
	
	
	-- show hit points and power points and shield level (make this better presentation later)
	love.graphics.print("Health: "..prostats.currentHP,64,420)
	love.graphics.print("Power : "..prostats.currentPP,264,420)
	love.graphics.print("Shield: "..prostats.shield,464,420)
	
	--[[
	if combatTarget == "bat" then
		love.graphics.print(batstats.currentHP,32,32)
	end
	if combatTarget == "rat" then
		love.graphics.print(ratstats.currentHP,32,32)
	end
	if combatTarget == "boss" then
		love.graphics.print(bossstats.currentHP,32,32)
	end--]]

end

function viewGameOver()
	love.graphics.printf("THE END?!",0,240,640,"center")
end

function viewEndDoor()

	--print("door")
	love.graphics.draw(panorama,panX,0)
	love.graphics.draw(protagonist_back,1024 + panX,380)

	if panX <= -640 then
		love.graphics.printf("What will you do next?",0,240,640,"center")
		keyInput = "okay"
	end
	
end

function viewEndShuttle()


	love.graphics.draw(starfield,panX,0)

	-- debug
	--love.graphics.print(panX,32,300)
	--love.graphics.print(panY,32,400)

	local offset = 925
	
	if panX < -320 then
		
		love.graphics.draw(shuttleL,offset + panX,500 - panY)
		
		if shuttleengine == 1 then
			love.graphics.draw(engine1,offset + panX,500 - panY)
		elseif shuttleengine == 2 then
			love.graphics.draw(engine2,offset + panX,500 - panY)
		elseif shuttleengine == 3 then
			love.graphics.draw(engine3,offset + panX,500 - panY)
		end
	end
	
	if panX <= -640 then
		love.graphics.printf("Where will you go next?",0,240,640,"center")
			keyInput = "okay"
	end
end

function viewIntro()

	love.graphics.printf("Your systems activate after a long dormancy.",0,75,640,"center")
	love.graphics.printf("You are in some caves. There is a locked door nearby.",0,175,640,"center")
	love.graphics.printf("Maybe there is a key around here.",0,275,640,"center")
	love.graphics.printf("Or perhaps there is another way out.",0,375,640,"center")


	love.graphics.printf("(press return)",0,450,640,"center")
end

function love.draw() -- decide what to draw on the screen
	if view == "title" then
		viewTitle()
	
	elseif view == "intro" then
		viewIntro()
		
	elseif view == "game" then
		viewGame()
		
	elseif view == "combat" then
		viewCombat()
		
	elseif view == "gameover" then
		viewGameOver()

	elseif view == "endDoor" then
		viewEndDoor()
		
	elseif view == "endShuttle" then
		viewEndShuttle()

	end
end -- end love.draw


function love.keypressed(key)
	if keyInput == "okay" then -- allow inputs only when keys aren't frozen

		if view == "title" then
			keysTitle(key)
		elseif view == "intro" then
			keysIntro(key)
		elseif view == "game" then
			keysGame(key)
		elseif view == "combat" then
			keysCombat(key)
		elseif view == "gameover" then
			keysGameOver(key)
		elseif view == "endShuttle" or view == "endDoor" then
			keysEnding(key)
			
		end

	end

end -- end love.keypressed