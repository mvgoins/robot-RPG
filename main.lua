love.graphics.setDefaultFilter("nearest","nearest")
fixedsysS = love.graphics.newFont("Fixedsys500c.ttf",14) -- cutesy but need a better font!
fixedsysM = love.graphics.newFont("Fixedsys500c.ttf",20)
fixedsysL = love.graphics.newFont("Fixedsys500c.ttf",26)
love.graphics.setFont(fixedsysM)

require "controls"
require "maps"
require "assets"

view = "title"
subkey = "none" -- this is for tracking whether you're in the menu on the main screen
subtarget = "none" -- what part of the menu you're looking at -- maybe not necessary? -- other note: menus as tables?
gamestate = "none" -- this is "saved" or not, for save game. rename this? actually maybe not necessary at all. have a function check to see if a save file exists

-- check later to see if any of these could be moved/made local 
proloc = {7,32,1} -- coordinates of the character. x, y, z. 
proface = protagonist_front -- what direction you're facing. used for the character icon. 
combatCount = 0 -- goes up by 1 every step
attack = 0 -- this needs to be made local later
combatTarget = "empty" -- what you're going to fight
combatTargetBonus = "empty" -- placeholder for multi-target fights
keyInput = "okay" -- whether or not you can type right now
combatpicktarget = 0 -- decides what you're going to fight
combatMenu = "top" -- what menu option you currently have selected
combatsubMenu = "none"
combatselect = 1
combatselectskill = 1


gameMaincursor = 1 -- blehhhhh these shouldn't be global
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
			
proskills = {
			["heal"] = 1, 
			["harm"] = 0, 
			["shield"] = 0,
			} -- spells, essentially. they use pp. 0 don't have it, level 2 should be max. 
			
proitems = {
			["bluekey"] = "no", 
			["weapon"] = "no", 
			["armor"] = "no", 
			["speed"] = "no",
			["battery"] = "no",
			["factory"] = "no",
			["steel"] = "no"
			}
			
batstats = {["currentHP"] = 15, ["maxHP"] = 15}
ratstats = {["currentHP"] = 30, ["maxHP"] = 30}
bossstats = {["currentHP"] = 100, ["maxHP"] = 100, ["currentPP"] = 10, ["maxPP"]=10 }

healPads = {
			{8,16,1,50},
			{23,4,1,50},
			}

-- colors in rgba tables
colorwhite = {255, 255, 255}
colorgrey = {192, 192, 192}
colordarkgrey = {82, 82, 82}

function love.load()
	love.window.setMode(640,480)
	print(love.math.random(1,100))
	print(love.math.random(1,100))
	print(love.math.random(1,100))
end

function love.update(dt)
	
	if combatMenu == "messages" then
		combatMessageCounter = combatMessageCounter + dt
		
		if combatMessageCounter >= 2 then -- display messages for 2 seconds
			combatMenu = "top"
			combatMessageCounter = 0
			combatStatusMessage1 = nil
			combatStatusMessage2 = nil
		end
	end

end

function viewTitle() -- the title/start screen
	love.graphics.printf("ROBOT QUEST",0,240,640,"center")
	love.graphics.printf("[N]ew Game",0,300,640,"center")

	-- debug stuff, making sure images load. delete this later
	love.graphics.draw(protagonist_front,0,0)
	love.graphics.draw(dungeon_floor,64,0)
	love.graphics.draw(dungeon_wall,96,0)
	love.graphics.draw(treasure1,0,64)
	love.graphics.draw(healPod3,64,64)
	
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
					if dungeon_terrain[proloc[3]][currentY][currentX] == 0 then
						love.graphics.draw(dungeon_wall,16 + 32 * (x + 5),16 + 32 * (y + 5))
					elseif dungeon_terrain[proloc[3]][currentY][currentX] == 1 then
						love.graphics.draw(dungeon_floor,16 + 32 * (x + 5),16 + 32 * (y + 5))
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
				 	 
					if dungeon_features[proloc[3]][currentY][currentX] == 1 then
						love.graphics.draw(stairsDown,16 + 32 * (x + 5),16 + 32 * (y + 5))

					elseif dungeon_features[proloc[3]][currentY][currentX] == 2 then
						love.graphics.draw(stairsUp,16 + 32 * (x + 5),16 + 32 * (y + 5))

					elseif dungeon_features[proloc[3]][currentY][currentX] == 3 then
						love.graphics.draw(treasure1,16 + 32 * (x + 5),16 + 32 * (y + 5))

					elseif dungeon_features[proloc[3]][currentY][currentX] == 4 then
						love.graphics.draw(treasure2,16 + 32 * (x + 5),16 + 32 * (y + 5))

					elseif dungeon_features[proloc[3]][currentY][currentX] == 5 then
						love.graphics.draw(healPod3,16 + 32 * (x + 5),16 + 32 * (y + 5))
					elseif dungeon_features[proloc[3]][currentY][currentX] == 6 then
						love.graphics.draw(healPod2,16 + 32 * (x + 5),16 + 32 * (y + 5))
					elseif dungeon_features[proloc[3]][currentY][currentX] == 7 then
						love.graphics.draw(healPod1,16 + 32 * (x + 5),16 + 32 * (y + 5))
					elseif dungeon_features[proloc[3]][currentY][currentX] == 8 then
						love.graphics.draw(rock,16 + 32 * (x + 5),16 + 32 * (y + 5))
					end
				end
			end
		end
	end -- end feature drawing		
	
	love.graphics.draw(screenborder1,0,0) -- draw a border around the map
		
	love.graphics.draw(proface, 16 + 32 * 5,16 + 32 * 5) -- draw the character
	
	if gameStatusMessage then
		love.graphics.print(gameStatusMessage,32,400)
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

		love.graphics.print("Save Game",416,332)
		
		if gameMaincursor < 5 then
			love.graphics.draw(menuSelector,396, 35 + 50 * (gameMaincursor - 1))
		else 
			love.graphics.draw(menuSelector,396, 335)
		end

	
	elseif subkey == "mainScrap" then
		love.graphics.print("Restore PP",416,82)
		love.graphics.print("Upgrade Attribute",416,132)
		love.graphics.print("Upgrade Skill",416,182)
		
		love.graphics.draw(menuSelector,396,85 + 50 * (gameScrapcursor - 1))
	

	elseif subkey == "mainCheck" then
		love.graphics.print("Checking...",416,82)
	
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
		local nextwepcost = nextwep * 1000
		
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
		local nextarmcost = nextarm * 1000
		
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
		local nextspdcost = nextspd * 1000
		
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
		local nextcost = (proskills.heal + 1) * 1500
		
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
		local nextcost = (proskills.harm + 1) * 1500
		
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
		local nextcost = (proskills.shield + 1) * 1500
		
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
			love.graphics.print("Heal is maxed!",416,32)
		end	
	
	end -- end the whole damn scrapview drawing stack
	
end -- end viewGame

function skillHealCheck()
	if prostats.currentPP >= 2 and prostats.currentHP < prostats.maxHP then
		prostats.currentPP = prostats.currentPP - 2
	
		local toheal = prostats.currentHP + 10 * proskills.heal

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
	
	local floor = proloc[3]
	
	if prostats.currentPP >= 6 then 
		if dungeon_features[proloc[3]][proloc[2] + 1][proloc[1]] == 8 
			or dungeon_features[proloc[3]][proloc[2] - 1][proloc[1]] == 8
			or dungeon_features[proloc[3]][proloc[2]][proloc[1] + 1] == 8
 			or dungeon_features[proloc[3]][proloc[2]][proloc[1] - 1] == 8 then
 			
 			for y = -1,1 do -- so right now this destroys everything around the player if one of the things is a rock
 				for x = -1,1 do -- that's.. not great! but there's no actual case where it matters so I'm running with it
 					dungeon_features[floor][proloc[2] + y][proloc[1] + x] = 0
 				end
 			end
 			gameStatusMessage = "You removed the rock."
 			prostats.currentPP = prostats.currentPP - 6
 		else
 			gameStatusMessage = "There's nothing to use that on here."
 		end
 	else
		gameStatusMessage = "You don't have enough power."
	end
	
end

function skillShieldCheck()
	gameStatusMessage = "There's no need for that now."
end


function featureCheck() -- see if the player is on a feature, and do something if they are

	local floor = proloc[3]
	local here = dungeon_features[proloc[3]][proloc[2]][proloc[1]]
	
	print("floor: "..proloc[3].." y: "..proloc[2].." x: "..proloc[1])
	print("Here is: "..here)
	
	if here == 0 then
		gameStatusMessage = "Nothing interesting here."
		print("nothing")
		print(" ")
	elseif here == 1 then
		proloc[3] = proloc[3] + 1
		print("stairs down")
	elseif here == 2 then
		proloc[3] = proloc[3] - 1
		print("stairs up")
	elseif here == 3 then -- there has got to be a better way to do this
	print("treasure")
		if floor == 1 then -- 1st floor treasures
		print("on floor 1")
			if proloc[2] == 29 and proloc[1] == 3 then
				print("1st treasure")
				gameStatusMessage = "You found 1000 scrap."
				prostats.scrap = prostats.scrap + 1000
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0 -- that's the direct, can't we use an alias?
				print("Here is now: "..here)

			elseif proloc[2] == 23 and proloc[1] == 3 then
				gameStatusMessage = "You found 750 scrap."
				prostats.scrap = prostats.scrap + 750
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0
				
			elseif proloc[2] == 23 and proloc[1] == 19 then
				gameStatusMessage = "You found 500 scrap."
				prostats.scrap = prostats.scrap + 500
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0
				
			elseif proloc[2] == 13 and proloc[1] == 25 then
				gameStatusMessage = "You found some schematics. Your maximum speed increases."
				prostats.speedmax = 5
				proitems.speed = "yes"
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0
			
			elseif proloc[2] == 27 and proloc[1] == 24 then
				gameStatusMessage = "You found a battery upgrade. Your maximum power increases."
				prostats.maxPP = 20
				dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 0
				proitems.battery = "yes"
			end
					
		elseif floor == 2 then
		
		end -- end regular treasure
		
	-- elseif here == 4 then -- note: cyber chests.
	
	elseif here == 5 then
		--print("healing pad")
		if prostats.currentHP == prostats.maxHP then
			gameStatusMessage = "You are currently undamaged."
		elseif prostats.currentHP + 50 < prostats.maxHP then
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

			for i,v in ipairs(healPads) do
				if healPads[i][1] == proloc[1] and healPads[i][2] == proloc[2] and healPads[i][3] == proloc[3] then
					healPads[i][4] = 0
				end
			end	
			dungeon_features[proloc[3]][proloc[2]][proloc[1]] = 7

		end
		
	elseif here == 6 or here == 7 then
		print("not yet")
		gameStatusMessage = "The heal pad isn't recharged yet."
	
	end		
	-- note: no check for 8 or 9, since those block movement and cannot be stood on. use custom messages for those.
	
end -- ending featureCheck()

function healPadRegen()
local padnum = 0
	for i,v in ipairs(healPads) do
		padnum = padnum + 1
		print("checking pad "..padnum)
		if healPads[i][4] < 50 then
			healPads[i][4] = healPads[i][4] + 1
			print("Pad "..padnum.." + 1!")
		end
			
		if healPads[i][4] >= 25 and healPads[i][4] < 50 then
			dungeon_features[healPads[i][3]][healPads[i][2]][healPads[i][1]] = 6
			
		elseif healPads[i][4] == 50 then
			dungeon_features[healPads[i][3]][healPads[i][2]][healPads[i][1]] = 5
		end
	end

end

function combatCheck() -- begin the check to see if a random encounter happens -- but it's all combat, I guess? rework for later iteration of the game
--	math.randomseed(os.time()) -- make things more random -- hopefully

	combatCount = combatCount + 1
	
	attack = love.math.random(1,25) + combatCount -- this should be made local later; global now for ease of debugging

	if attack > 49 then
		keyInput = "frozen" -- I'm not sure if there'd be enough time for someone to hit a key between the time this starts and the time combat actually come sup, but.. might as well freeze the keys just in case
		combatSelection()
		view = "combat"
		keyInput = "okay"
		combatCount = 0
	end	
end -- end combatCheck


function combatSelection()
--	math.randomseed(os.time())
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
--	math.randomseed(os.time())
	
	combatDealDamage()
	
	if combatTarget == "bat" then
		if batstats.currentHP > 0 then
			combatTakeDamage()
		end
	
	elseif combatTarget == "rat" then
		if ratstats.currentHP > 0 then
			combatTakeDamage()
		end
	end
		
	combatMenu = "messages"
	
end

function combatProScare()
--	math.randomseed(os.time())
	
	if love.math.random(1,100) > 25 then
		view = "game"
		combatTarget = "empty" -- I don't know if this is necessary
	else 
		combatTakeDamage()
	end
	

end

function combatProHeal()
--	math.randomseed(os.time())
	
	prostats.currentPP = prostats.currentPP - 2
	
	local toheal = prostats.currentHP + 10 * proskills.heal

	if toheal < prostats.maxHP then
		prostats.currentHP = toheal
		combatStatusMessage1 = "You repaired "..toheal.." damage."
	else 
		prostats.currentHP = prostats.maxHP
		combatStatusMessage1 = "You healed all your damage."
	end

	combatTakeDamage()

end

function combatProHarm()
--	math.randomseed(os.time())

	prostats.currentPP = prostats.currentPP - 6
	
	local harm = 10 * proskills.harm
	
	if combatTarget == "bat" then
		batstats.currentHP = batstats.currentHP - harm
		if batstats.currentHP <= 0 then
			view = "game"
			prostats.scrap = prostats.scrap + 20 -- you get more scrap with Harm
			prostats.shield = 0
		else 
			combatTakeDamage()
		end
	end
	
	if combatTarget == "rat" then
		ratstats.currentHP = ratstats.currentHP - harm
		if ratstats.currentHP <= 0 then
			view = "game"
			prostats.scrap = prostats.scrap + 30  -- see above
			prostats.shield = 0
		else
			combatTakeDamage()
		end
	end

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
	
	combatStatusMessage1 = "You put up an energy field and the enemy attacks."
	combatStatusMessage2 = "You have "..prostats.shield.." shield points remaining."
	combatMenu = "messages"
	combatselect = 1
	combatskillselect = 1
	
end

function combatDealDamage()

--	math.randomseed(os.time())

	local damage = love.math.random(5,10) + prostats.weapon + math.ceil(0.5 * prostats.speed) -- need something different for speed

	if combatTarget == "bat" then
		batstats.currentHP = batstats.currentHP - damage
		if batstats.currentHP <= 0 then 
			combatCleanup()
		end
	end
	
	if combatTarget == "rat" then
		ratstats.currentHP = ratstats.currentHP - damage
		if ratstats.currentHP <= 0 then
			combatCleanup()
		end
	end
	
	combatStatusMessage1 = "You dealt "..damage.." to the enemy."

end


function combatTakeDamage()

--	math.randomseed(os.time())

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
	end
	
	if prostats.currentHP <= 0 then
		view = "gameover"
	end
	
	combatMenu = "top"
	combatselect = 1
	combatskillselect = 1

end

function combatCleanup()

	if combatTarget == "bat" then
		prostats.scrap = prostats.scrap + 10
	elseif combatTarget == "rat" then
		prostats.scrap = prostats.scrap + 20
	end
	
	combatTarget = "empty"
	
	prostats.shield = 0
	combatMenu = "top"
	combatselect = 1
	combatskillselect = 1
	
	view = "game"
end

function viewCombat()


	-- draw the target's icon -- the boss part needs to be fixed for double bosses
	if combatTarget == "bat" then
		love.graphics.draw(batPic,200,16,0,4,4)
	elseif combatTarget == "rat" then
		love.graphics.draw(ratPic,200,16,0,4,4)
	elseif combatTarget == "boss" then
		love.graphics.draw(bossPic,128,16,0,4,4)
	end
	
	if combatTargetBonus == "boss" then
		love.graphics.draw(bossPic,512,16,0,4,4)		
	end
	
	love.graphics.draw(combatBorder,0,0) -- draw the border for the screen
	

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
		love.graphics.print(combatStatusMessage1,32,350)
		love.graphics.print(combatStatusMessage2,32,400)
	end
	
	
	-- show hit points and power points and shield level (make this better presentation later)
	love.graphics.print(prostats.currentHP,32,450)
	love.graphics.print(prostats.currentPP,82,450)
	love.graphics.print(prostats.shield,132,450)
	
	if combatTarget == "bat" then
		love.graphics.print(batstats.currentHP,32,32)
	end
	if combatTarget == "rat" then
		love.graphics.print(ratstats.currentHP,32,32)
	end

end

function viewGameOver()
	love.graphics.printf("THE END?!",0,240,640,"center")

end

function love.draw() -- decide what to draw on the screen
	if view == "title" then
		viewTitle()
	end
	
	if view == "game" then
		viewGame()
	end
	
	if view == "combat" then
		viewCombat()
	end
	
	if view == "gameover" then
		viewGameOver()
	end
end -- end love.draw


function love.keypressed(key)
	if keyInput == "okay" then -- allow inputs only when keys aren't frozen

		if view == "title" then
			keysTitle(key)
		elseif view == "game" then
			keysGame(key)
		elseif view == "combat" then
			keysCombat(key)
		elseif view == "gameover" then
			keysGameOver(key)
		end

	end

end -- end love.keypressed