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
combatMenu = "fight" -- what menu option you currently have selected


gameMaincursor = 1 -- blehhhhh these shouldn't be global
gameItemcursor = 1
gameSkillscursor = 1
gameScrapcursor = 1

-- stats
prostats = {["currentHP"] = 100, ["maxHP"] = 100, ["currentPP"] = 10, ["maxPP"]=10, ["scrap"]=0, ["weapon"] = 0, ["armor"] = 0, ["speed"] = 0} -- trying string keys 
proskills = {["heal"] = 1, ["harm"] = 0, ["shield"] = 0} -- spells, essentially. they use pp. 0 don't have it, level 2 should be max. 
proinventory = {["bluekey"] = "no", ["weapon"] = "no", ["armor"] = "no", ["speed"] = "no"}
batstats = {["currentHP"] = 15, ["maxHP"] = 15}
ratstats = {["currentHP"] = 30, ["maxHP"] = 30}
bossstats = {["currentHP"] = 100, ["maxHP"] = 100, ["currentPP"] = 10, ["maxPP"]=10 }

function love.load()
	love.window.setMode(640,480)
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

	-- draw the terrain
	for y = -5,5 do
		currentY = proloc[2] + y
		if floor1_terrain[currentY] then
			for x = -5,5 do
				currentX = proloc[1] + x
				if floor1_terrain[currentY][currentX] then
					if floor1_terrain[currentY][currentX] == 0 then
						love.graphics.draw(dungeon_wall,16 + 32 * (x + 5),16 + 32 * (y + 5))
					elseif floor1_terrain[currentY][currentX] == 1 then
						love.graphics.draw(dungeon_floor,16 + 32 * (x + 5),16 + 32 * (y + 5))
					end
				end
			end
		end
	end -- end terrain drawing
	
	-- draw terrain features (treasure chests, portals, et cetera)
	for y = -5,5 do
		currentY = proloc[2] + y
		if floor1_features[currentY] then
			for x = -5,5 do
				currentX = proloc[1] + x
				
				if floor1_features[currentY][currentX] then
					if floor1_features[currentY][currentX] == 1 then
						love.graphics.draw(stairsDown,16 + 32 * (x + 5),16 + 32 * (y + 5))

					elseif floor1_features[currentY][currentX] == 2 then
						love.graphics.draw(stairsUp,16 + 32 * (x + 5),16 + 32 * (y + 5))

					elseif floor1_features[currentY][currentX] == 3 then
						love.graphics.draw(treasure1,16 + 32 * (x + 5),16 + 32 * (y + 5))

					elseif floor1_features[currentY][currentX] == 4 then
						love.graphics.draw(treasure2,16 + 32 * (x + 5),16 + 32 * (y + 5))

					elseif floor1_features[currentY][currentX] == 5 then
						love.graphics.draw(healPod3,16 + 32 * (x + 5),16 + 32 * (y + 5))
					elseif floor1_features[currentY][currentX] == 6 then
						love.graphics.draw(healPod2,16 + 32 * (x + 5),16 + 32 * (y + 5))
					elseif floor1_features[currentY][currentX] == 7 then
						love.graphics.draw(healPod1,16 + 32 * (x + 5),16 + 32 * (y + 5))
					end
				end
			end
		end
	end -- end feature drawing		
	
	love.graphics.draw(screenborder1,0,0) -- draw a border around the map
		
	love.graphics.draw(proface, 16 + 32 * 5,16 + 32 * 5) -- draw the character
	
	
	if subkey == "none" then -- draw the normal stats you see
	
		love.graphics.print("HP: "..prostats.currentHP.."/"..prostats.maxHP,416,32)
		love.graphics.print("PP: "..prostats.currentPP.."/"..prostats.maxPP,416,82)
		love.graphics.print("Scrap: "..prostats.scrap,416,132)
		love.graphics.print("[M]enu",416,332)
		
	end -- end none-subkey
	
	
	if subkey == "main" then -- draw the menu overtop

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

	end -- end main-subkey
	
	if subkey == "mainScrap" then
		love.graphics.print("Restore PP",416,82)
		love.graphics.print("Upgrade Attribute",416,132)
		love.graphics.print("Upgrade Skill",416,182)
		
		love.graphics.draw(menuSelector,396,85 + 50 * (gameScrapcursor - 1))
	end

	if subkey == "mainCheck" then
		love.graphics.print("Checking...",416,82)
	end
	
	if subkey == "mainItems" then
		love.graphics.print("Items...",416,82)
	end
	
	if subkey == "mainSkills" then
		love.graphics.print("Skills...",416,82)
	end
	
	-- scrap submenu
	if subkey == "scrapPP" then
		love.graphics.print("make PPPPPP",416,82)
	end
	
	if subkey == "scrapAttributes" then
		love.graphics.print("upgrade stuff!",416,82)
	end
	
	if subkey == "scrapSkills" then
		love.graphics.print("upgrade other stuff!!",416,82)
	end
	

end -- end viewGame

function featureCheck() -- see if the player is on a feature, and do something if they are

end

function combatCheck() -- begin the check to see if a random encounter happens -- but it's all combat, I guess? rework for later iteration of the game
	math.randomseed(os.time()) -- make things more random

	combatCount = combatCount + 1
	
	attack = math.random(1,25) + combatCount -- this should be made local later; global now for ease of debugging

	if attack > 49 then
		keyInput = "frozen" -- I'm not sure if there'd be enough time for someone to hit a key between the time this starts and the time combat actually come sup, but.. might as well freeze the keys just in case
		combatSelection()
		view = "combat"
		keyInput = "okay"
		combatCount = 0
	end	
end -- end combatCheck


function combatSelection()
	math.randomseed(os.time())
	combatpicktarget = math.random(1,100)
	
	if proloc[1] == 30 and proloc[2] == 30 and proloc[3] == 2 then
		combatTarget = "boss"
	elseif combatpicktarget < 51 then -- bats are not coming up often enough; examine randomness (or lack of it)
		combatTarget = "bat"
		batstats.maxHP = math.random(10,15) -- bats have between 10 and 15 HP
		batstats.currentHP = batstats.maxHP
	elseif combatpicktarget >= 51 then
		combatTarget = "rat"
		ratstats.maxHP = math.random(20,30) -- rats have between 20 and 30 HP
		ratstats.currentHP = ratstats.maxHP
	end
	
end -- end combatSelection

function combatProAttack()
	math.randomseed(os.time())
	
	if combatTarget == "bat" then
		batstats.currentHP = batstats.currentHP - math.random(5,10) + prostats.weapon
		if batstats.currentHP <= 0 then
			view = "game"
			prostats.scrap = prostats.scrap + 10
		else 
			prostats.currentHP = prostats.currentHP - math.random(1,5)
			batstats.currentHP = batstats.currentHP + 1
		end
	end
	
	if combatTarget == "rat" then
		ratstats.currentHP = ratstats.currentHP - math.random(5,10) + prostats.weapon
		if ratstats.currentHP <= 0 then
			view = "game"
			prostats.scrap = prostats.scrap + 20
		else prostats.currentHP = prostats.currentHP - math.random(5,10)
		end
	end
	
	if prostats.currentHP <= 0 then
		view = "gameover"
	end
		
end

function combatProScare()
	math.randomseed(os.time())
	
	if math.random(1,100) > 25 then
		view = "game"
		combatTarget = "empty" -- I don't know if this is necessary
	else prostats.currentHP = prostats.currentHP - math.random(1,10)
	end
	
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
	love.graphics.print(combatpicktarget,300,100) -- what's going on with who shows up?
	
	-- draw the menu options
	love.graphics.print("Fight",200,400)
	love.graphics.print("Intimidate",400,400)
	
	-- draw the menu selector
	if combatMenu == "fight" then
		love.graphics.draw(combatSelector,150,400)
	elseif combatMenu == "intimidate" then
		love.graphics.draw(combatSelector,350,400)
	end
	
	-- draw hit points and power points
	love.graphics.print(prostats.currentHP,32,450)
	love.graphics.print(prostats.currentPP,64,450)
	
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