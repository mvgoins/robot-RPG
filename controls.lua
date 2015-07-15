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
	
	 -- end subkey = none


	elseif subkey == "main" then
	
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
	-- end subkey-main
	
	
	elseif subkey == "mainItems" then
		if key == "escape" then
			subkey = "main"
		end
	

	-- scrap top menu
	elseif subkey == "mainScrap" then
		if key == "escape" then
			subkey = "main"
		end
		
		if key == "up" then
			if gameScrapcursor > 1 then
				gameScrapcursor = gameScrapcursor - 1
			end
		end
		
		if key == "down" then
			if gameScrapcursor < 3 then
				gameScrapcursor = gameScrapcursor + 1
			end
		end 
		
		if key == "return" then
			if gameScrapcursor == 1 then
				subkey = "scrapPP"
			elseif gameScrapcursor == 2 then
				subkey = "scrapAttributes"
			elseif gameScrapcursor == 3 then
				subkey = "scrapSkills"
			end
		end
		
	-- end mainScrap
	
	-- scrap submenu keys
	elseif subkey == "scrapPP" then
		if key == "escape" then
			subkey = "mainScrap"
		end
		
		if key == "up" then
			if scrapPPcursor == 2 then
				scrapPPcursor = 1
			end
		end
		
		if key == "down" then
			if scrapPPcursor == 1 then
				scrapPPcursor = 2
			end
		end
		
		if key == "return" then
			if scrapPPcursor == 1 then
				subkey = "mainScrap"
			elseif scrapPPcursor == 2 then
				if prostats.scrap > 9 then
					if prostats.currentPP < prostats.maxPP then
						prostats.currentPP = prostats.currentPP + 1
						prostats.scrap = prostats.scrap - 10
					end
				end
			end
		end
				
	--end
	
	elseif subkey == "scrapAttributes" then
		if key == "escape" then
			subkey = "mainScrap"
		
		
		elseif key == "up" then
			if scrapAttcursor == 2 then
				scrapAttcursor = 1
			end
		
		
		elseif key == "down" then
			if scrapAttcursor == 1 then
				scrapAttcursor = 2
			end
		
		
		elseif key == "return" then
			if scrapAttcursor == 1 then
				subkey = "weaponCheck"
			elseif scrapAttcursor == 2 then
				subkey = "armorCheck"
			elseif scrapAttcursor == 3 then
				subkey = "speedCheck"
			end
		end
--	end
	
	elseif subkey == "weaponCheck" then
		if key == "escape" then
			subkey = "scrapAttributes"
			
		elseif key == "up" then
			if menuYNcursor == 2
				menuYNcursor = 1
			end
		
		elseif key == "down" then
			if menuYNcursor == 1 then
				menuYNcursor = 2
			end
			
		elseif key == "return" then
			if menuYNcursor == 1 then
				subkey = "scrapAttributes"
			elseif menuYNcursor == 2 then
				if prostats.weapon < prostats.weaponmax then
					if prostats.scrap >= (prostats.weapon + 1) * 1000
						prostats.weapon = prostats.weapon + 1
					end
				end
			end
				
	elseif subkey == "scrapSkills" then
		if key == "escape" then
			subkey = "mainScrap"
		end
--	end
	
	-- skill keys
	elseif subkey == "mainSkills" then
		if key == "escape" then
			subkey = "main"
		end
	--end
	
	elseif subkey == "mainCheck" then
		if key == "escape" then
			subkey = "main"
		end
	
	-- navigate save menu
	elseif subkey == "mainSave" then
		if key == "escape" then
			subkey = "main"
		end

	end -- end the whole big if-elseif pile
	
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