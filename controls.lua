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
			if dungeon_terrain[proloc[3]][proloc[2] - 1] then
				if dungeon_terrain[proloc[3]][proloc[2] - 1][proloc[1]] == 1 then
					proloc[2] = proloc[2] - 1
					combatCheck()
				end
			end
			proface = protagonist_back
		end
	
		if key == "down" then
			if dungeon_terrain[proloc[3]][proloc[2] + 1] then
				if dungeon_terrain[proloc[3]][proloc[2] + 1][proloc[1]] == 1 then
					proloc[2] = proloc[2] + 1
					combatCheck()
				end
			end
			proface = protagonist_front
		end
	
		if key == "left" then
			if dungeon_terrain[proloc[3]][proloc[2]][proloc[1] - 1] then
				if dungeon_terrain[proloc[3]][proloc[2]][proloc[1] - 1] == 1 then
					proloc[1] = proloc[1] - 1
					combatCheck()
				end
			end
			proface = protagonist_left
		end
	
		if key == "right" then
			if dungeon_terrain[proloc[3]][proloc[2]][proloc[1] + 1] then
				if dungeon_terrain[proloc[3]][proloc[2]][proloc[1] + 1] == 1 then
					proloc[1] = proloc[1] + 1
					combatCheck()
				end
			end
			proface = protagonist_right
		end
	
		if key == "m" then
			subkey = "main"
		end	
		
		-- debug keys
		if key == "a" then
			prostats.scrap = prostats.scrap + 100
		end
		
		if key == "s" then
			prostats.scrap = prostats.scrap + 1000
		end
		
		if key == "z" then
			prostats.scrap = prostats.scrap - 100
		end
		
		if key == "x" then
			prostats.scrap = prostats.scrap - 1000
		end

	
	 -- end subkey = none


	elseif subkey == "main" then
	
		if key == "escape" then
			subkey = "none"
			gameMaincursor = 1
			gameStatusMessage = nil
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
				if prostats.currentPP < prostats.maxPP and prostats.scrap >= 10 then
					scrapPPcursor = 2
				end
			end
		end
		
		if key == "return" then
			if scrapPPcursor == 1 then
				subkey = "mainScrap"
			elseif scrapPPcursor == 2 then
						prostats.currentPP = prostats.currentPP + 1
						prostats.scrap = prostats.scrap - 10
						subkey = "mainScrap"
			end
		end
				
	--end
	
	elseif subkey == "scrapAttributes" then
		if key == "escape" then
			subkey = "mainScrap"
		
		
		elseif key == "up" then
			if scrapAttcursor > 1 then
				scrapAttcursor = scrapAttcursor - 1
			end
		
		
		elseif key == "down" then
			if scrapAttcursor < 3 then
				scrapAttcursor = scrapAttcursor + 1
			end
		
		
		elseif key == "return" then
			if scrapAttcursor == 1 then
				subkey = "weaponCheck"
			elseif scrapAttcursor == 2 then
				subkey = "armorCheck"
			elseif scrapAttcursor == 3 then
				subkey = "speedCheck"
			end
			scrapAttcursor = 1
		end
--	end
	
	elseif subkey == "weaponCheck" then
	
		local weaponcost = (prostats.weapon + 1) * 1000
		
		if key == "escape" then
			subkey = "scrapAttributes"
			
		elseif key == "up" then
			if menuYNcursor == 2 then
				menuYNcursor = 1
			end
		
		elseif key == "down" then
			if menuYNcursor == 1 then
				if prostats.weapon < prostats.weaponmax and prostats.scrap >= weaponcost then
					menuYNcursor = 2
				end
			end
				
		elseif key == "return" then
			if menuYNcursor == 1 then
				subkey = "scrapAttributes"
			elseif menuYNcursor == 2 then
				prostats.weapon = prostats.weapon + 1
				prostats.scrap = prostats.scrap - weaponcost
				menuYNcursor = 1
				subkey = "scrapAttributes"
			end
		end

	elseif subkey == "armorCheck" then
	
		local armorcost = (prostats.armor + 1) * 1000
		
		if key == "escape" then
			subkey = "scrapAttributes"
			
		elseif key == "up" then
			if menuYNcursor == 2 then
				menuYNcursor = 1
			end
		
		elseif key == "down" then
			if menuYNcursor == 1 then
				if prostats.armor < prostats.armormax and prostats.scrap >= armorcost then
					menuYNcursor = 2
				end
			end
				
		elseif key == "return" then
			if menuYNcursor == 1 then
				subkey = "scrapAttributes"
			elseif menuYNcursor == 2 then
				prostats.armor = prostats.armor + 1
				prostats.scrap = prostats.scrap - armorcost
				menuYNcursor = 1 -- set this back to the default position
				subkey = "scrapAttributes"
			end
		end

	elseif subkey == "speedCheck" then
	
		local speedcost = (prostats.speed + 1) * 1000
		
		if key == "escape" then
			subkey = "scrapAttributes"
			
		elseif key == "up" then
			if menuYNcursor == 2 then
				menuYNcursor = 1
			end
		
		elseif key == "down" then
			if menuYNcursor == 1 then
				if prostats.speed < prostats.speedmax and prostats.scrap >= speedcost then
					menuYNcursor = 2
				end
			end
				
		elseif key == "return" then
			if menuYNcursor == 1 then
				subkey = "scrapAttributes"
			elseif menuYNcursor == 2 then
				prostats.speed = prostats.speed + 1
				prostats.scrap = prostats.scrap - speedcost
				menuYNcursor = 1 -- set this back to the default position
				subkey = "scrapAttributes"
			end
		end
				
	elseif subkey == "scrapSkills" then
		if key == "escape" then
			subkey = "mainScrap"
		
		
		elseif key == "up" then
			if scrapSkillcursor > 1 then
				scrapSkillcursor = scrapSkillcursor - 1
			end
		
		
		elseif key == "down" then
			if scrapSkillcursor < 3 then
				scrapSkillcursor = scrapSkillcursor + 1
			end
		
		
		elseif key == "return" then
			if scrapSkillcursor == 1 then
				subkey = "healCheck"
			elseif scrapSkillcursor == 2 then
				subkey = "harmCheck"
			elseif scrapSkillcursor == 3 then
				subkey = "shieldCheck"
			end
			scrapSkillcursor = 1
		end

	elseif subkey == "healCheck" then

		local cost = (proskills.heal + 1) * 1500
		
		if key == "escape" then
			subkey = "scrapSkills"
			
		elseif key == "up" then
			if menuYNcursor == 2 then
				menuYNcursor = 1
			end
		
		elseif key == "down" then
			if menuYNcursor == 1 then
				if proskills.heal < 2 and prostats.scrap >= cost then
					menuYNcursor = 2
				end
			end
				
		elseif key == "return" then
			if menuYNcursor == 1 then
				subkey = "scrapSkills"
			elseif menuYNcursor == 2 then
				proskills.heal = proskills.heal + 1
				prostats.scrap = prostats.scrap - cost
				menuYNcursor = 1 -- set this back to the default position
				subkey = "scrapSkills"
			end
		end
		
	elseif subkey == "harmCheck" then
		local cost = (proskills.harm + 1) * 1000
		
		if key == "escape" then
			subkey = "scrapSkills"
			
		elseif key == "up" then
			if menuYNcursor == 2 then
				menuYNcursor = 1
			end
		
		elseif key == "down" then
			if menuYNcursor == 1 then
				if proskills.harm < 2 and prostats.scrap >= cost then
					menuYNcursor = 2
				end
			end
				
		elseif key == "return" then
			if menuYNcursor == 1 then
				subkey = "scrapSkills"
			elseif menuYNcursor == 2 then
				proskills.harm = proskills.harm + 1
				prostats.scrap = prostats.scrap - cost
				menuYNcursor = 1 -- set this back to the default position
				subkey = "scrapSkills"
			end
		end
		
	elseif subkey == "shieldCheck" then
		local cost = (proskills.shield + 1) * 1000
		
		if key == "escape" then
			subkey = "scrapSkills"
			
		elseif key == "up" then
			if menuYNcursor == 2 then
				menuYNcursor = 1
			end
		
		elseif key == "down" then
			if menuYNcursor == 1 then
				if proskills.shield < 2 and prostats.scrap >= cost then
					menuYNcursor = 2
				end
			end
				
		elseif key == "return" then
			if menuYNcursor == 1 then
				subkey = "scrapSkills"
			elseif menuYNcursor == 2 then
				proskills.shield = proskills.shield + 1
				prostats.scrap = prostats.scrap - cost
				menuYNcursor = 1 -- set this back to the default position
				subkey = "scrapSkills"
			end
		end
--	end
	
	-- skill keys
	elseif subkey == "mainSkills" then
		if key == "escape" then
			subkey = "main"
			gameSkillcursor = 1
				
		elseif key == "up" then
			if gameSkillcursor > 1 then
				gameSkillcursor = gameSkillcursor - 1
			end
		
		
		elseif key == "down" then
			if gameSkillcursor < 3 then
				gameSkillcursor = gameSkillcursor + 1
			end
		
		
		elseif key == "return" then
			if gameSkillcursor == 1 then
				skillHealCheck()
			elseif gameSkillcursor == 2 then
				skillHarmCheck()
			elseif gameSkillcursor == 3 then
				skillShieldCheck()
			end
		end

		
	elseif subkey == "mainCheck" then -- use terrain feature if possible, or display a message
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
--[[	if key == "escape" then
		love.event.quit()
	end
--]]
	
	if combatMenu == "top" then
		if key == "right" then
			if combatselect < 3 then
				combatselect = combatselect + 1
			end
		end
		
		if key == "left" then
			if combatselect > 1 then
				combatselect = combatselect - 1
			end
		end
	
		if key == "return" then
			if combatselect == 1 then
				combatProAttack()
			
			elseif combatselect == 2 then
				combatMenu = "skill"
				
			elseif combatselect == 3 then
				combatProScare()
			end
		end
	
	
	elseif combatMenu == "skill" then

		if key == "escape" then
			combatMenu = "top"
		end


		if key == "right" then
			if combatselectskill < 3 then
				combatselectskill = combatselectskill + 1
			end
		end
		
	
		if key == "left" then
			if combatselectskill > 1 then
				combatselectskill = combatselectskill - 1
			end
		end

		
		if key == "return" then
			if combatselectskill == 1 then
				if prostats.currentPP >= 2 then
					combatProHeal()
				end
			elseif combatselectskill == 2 then
				if prostats.currentPP >= 6 then
					if proskills.harm > 0 then
						combatProHarm()
					end
				end
			elseif combatselectskill == 3 then
				if prostats.currentPP >= 4 then
					if proskills.shield > 0 then
						combatProShield()
					end
				end
			end
		end
	end
	
end -- end keysCombat

function keysGameOver(key)
	if key == "escape" then
		love.event.quit()
	end
end -- end keysGameOver