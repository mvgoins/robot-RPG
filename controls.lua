function keysTitle(key)
	if key == "escape" then
		love.event.quit()
	end

	if key == "n" then
		view = "game"
	end
end

function keysGame(key)


	if subkey == "none" then
	
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
	
	if key == "m" then
		subkey = "main"
	end
	
	end -- end subkey = none

	if subkey == "main" then
	
		if key == "escape" then
			subkey = "none"
		end
	
		if key == "up" then
			if gameMaincursor > 1 then
				gameMaincursor = gameMaincursor - 1
			end
		end
		
		if key == "down" then
			if gameMaincursor < 5 then
				gameMaincursor = gameMaincursor + 1
			end
		end 
		
		if key == "return" then
			if gameMaincursor == 1 then
				subkey = "mainCheck"
			elseif gameMaincursor == 2 then
				subkey = "mainSkills"
			elseif gameMaincursor == 3 then
				subkey = "mainScrap"
			elseif gameMaincursor == 4 then
				subkey = "mainItems"
			elseif gameMaincursor == 5 then
				subkey = "mainSave"
			end
		end
	end -- end subkey-main
	
	if subkey == "mainItems" then
		if key == "escape" then
			subkey = "main"
		end
	end

	if subkey == "mainScrap" then
		if key == "escape" then
			subkey = "main"
		end
	end
	
	if subkey == "mainSkills" then
		if key == "escape" then
			subkey = "main"
		end
	end
	
	if subkey == "mainSave" then
		if key == "escape" then
			subkey = "main"
		end
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