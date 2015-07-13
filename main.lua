love.graphics.setDefaultFilter("nearest","nearest")

require "controls"
require "maps"
require "assets"

view = "title"
ganestate = "saved"

-- check to see if any of these could be moved/made local 
proloc = {7,32,1}
proface = protagonist_front
combatCount = 0
attack = 0 -- this needs to be made local later
combatTarget = "empty"
combatTargetBonus = "empty"
keyInput = "okay"
combatpicktarget = 0
combatMenu = "fight"

-- stats
prostats = {100,10,0} -- HP, power points, experience
batstats = {100,0}
ratstats = {100,0}
bossstats = {100,10}

function love.load()
	love.window.setMode(640,480)
end

function viewTitle() -- the title/start screen
	love.graphics.printf("ROBOT QUEST",0,240,640,"center")
	love.graphics.printf("[N]ew Game",0,300,640,"center")
	love.graphics.draw(protagonist_front,0,0)
	love.graphics.draw(dungeon_floor,64,0)
	love.graphics.draw(dungeon_wall,96,0)
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
						love.graphics.draw(dungeon_wall,32 * (x + 5),32 * (y + 5))
					elseif floor1_terrain[currentY][currentX] == 1 then
						love.graphics.draw(dungeon_floor,32 * (x + 5),32 * (y + 5))
					end
				end
			end
		end
	end -- end terrain drawing
	
	-- draw terrain features (treasure chests, portals, et cetera)
	
	-- end feature drawing
	
	love.graphics.draw(proface, 32 * 5,32 * 5)
	
	love.graphics.print("x: "..proloc[1],300,300)
	love.graphics.print("y: "..proloc[2],350,300)
	
	love.graphics.print("Combat count: "..combatCount,300,325)
	love.graphics.print("Attack roll: "..attack,300,350)
	
	love.graphics.print("HP: "..prostats[1],500,120)
	love.graphics.print("XP: "..prostats[3],500,150)

	

end -- end viewGame


function combatCheck() -- begin the check to see if a random encounter happens -- but it's all combat, I guess? rework for later iteration of the game
	math.randomseed(os.time()) -- make things more random

	combatCount = combatCount + 1
	
	attack = math.random(1,25) + combatCount -- this should be made local later; global now for ease of debugging

	if attack > 49 then
		keyInput = "frozen"
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
	elseif combatpicktarget < 51 then
		combatTarget = "bat"
		batstats[1] = math.random(10,30)
	elseif combatpicktarget >= 51 then
		combatTarget = "rat"
		ratstats[1] = math.random(25,50)
	end
	
end -- end combatSelection

function combatProAttack()
	math.randomseed(os.time())
	
	if combatTarget == "bat" then
		batstats[1] = batstats[1] - math.random(5,10)
		if batstats[1] <= 0 then
			view = "game"
			prostats[3] = prostats[3] + 10
		else prostats[1] = prostats[1] - math.random(1,5)
		end
	end
	
	if combatTarget == "rat" then
		ratstats[1] = ratstats[1] - math.random(5,10)
		if ratstats[1] <= 0 then
			view = "game"
			prostats[3] = prostats[3] + 20
		else prostats[1] = prostats[1] - math.random(5,10)
		end
	end
	
	if prostats[1] <= 0 then
		view = "gameover"
	end
		
end

function combatProScare()
	math.randomseed(os.time())
	
	if math.random(1,100) > 25 then
		view = "game"
		combatTarget = "empty" -- I don't know if this is necessary
	else prostats[1] = prostats[1] - math.random(1,10)
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
	love.graphics.print(prostats[1],32,450)
	love.graphics.print(prostats[2],64,450)
	
	if combatTarget == "bat" then
		love.graphics.print(batstats[1],32,32)
	end
	if combatTarget == "rat" then
		love.graphics.print(ratstats[1],32,32)
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