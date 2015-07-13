function keysTitle(key)
	if key == "escape" then
		love.event.quit()
	end

	if key == "n" then
		view = "game"
	end
end

function keysGame(key)
	if key == "escape" then
		love.event.quit()
	end
	
	if key == "up" then
		if floor1_terrain[proloc[2] - 1] then
			if floor1_terrain[proloc[2] - 1][proloc[1]] == 1 then
				proloc[2] = proloc[2] - 1
				combatCheck()
			end
		end
		proface = protagonist_back
	end
	
	if key == "down" then
		if floor1_terrain[proloc[2] + 1] then
			if floor1_terrain[proloc[2] + 1][proloc[1]] == 1 then
				proloc[2] = proloc[2] + 1
				combatCheck()
			end
		end
		proface = protagonist_front
	end
	
	if key == "left" then
		if floor1_terrain[proloc[2]][proloc[1] - 1] then
			if floor1_terrain[proloc[2]][proloc[1] - 1] == 1 then
				proloc[1] = proloc[1] - 1
				combatCheck()
			end
		end
		proface = protagonist_left
	end
	
	if key == "right" then
		if floor1_terrain[proloc[2]][proloc[1] + 1] then
			if floor1_terrain[proloc[2]][proloc[1] + 1] == 1 then
				proloc[1] = proloc[1] + 1
				combatCheck()
			end
		end
		proface = protagonist_right
	end
end

function keysCombat(key)
	if key == "escape" then
		love.event.quit()
	end
	
	if combatMenu == "fight" then
		if key == "return" then
			combatProAttack()
		elseif key == "right" then
			combatMenu = "intimidate"
		end
	end
	
	if combatMenu == "intimidate" then
		if key == "return" then
			combatProScare()
		elseif key == "left" then
			combatMenu = "fight"
		end
	end
	
end -- end keysCombat

function keysGameOver(key)
	if key == "escape" then
		love.event.quit()
	end
end -- end keysGameOver