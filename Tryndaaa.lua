require("Inspired" )

if GetObjectName(GetMyHero()) ~= "Tryndamere" then return end

local Tryndamere = MenuConfig("Crazy Trynda v1.5", "Tryndamere")
	  Tryndamere:Menu("c", "Auto")
			Tryndamere.c:Boolean("Q", "Use Auto Q", true)
			Tryndamere.c:Slider("AutoQ","Q when Health is < ", 15, 1, 100, 1)
			Tryndamere.c:Slider("AreaQ","Area Q",375,1,2500,5)
			Tryndamere.c:Boolean("R", "Use Auto R", true)
			Tryndamere.c:Slider("AutoR", "R when Health is < ", 35, 1, 100, 1)
			Tryndamere.c:Slider("AreaR","Area R",650,1,2500,5)
	  Tryndamere:Menu("i","Items")
		Tryndamere.i:Boolean("I","Use items",true)
	  Tryndamere:Menu("ia","Item farm")
		Tryndamere.ia:Boolean("IA","Use Hydra farm",true)
	  Tryndamere:Menu("s","Surrvive")
		Tryndamere.s:Boolean("S","Anti ignite",true)
      Tryndamere:Menu("ig", "Ignite")
			Tryndamere.ig:Boolean("IG", "Ignite", true)			
	  Tryndamere:Menu("dr", "Draws")
			Tryndamere.dr:Boolean("DR", "Draw Ult ", true)
			Tryndamere.dr:Boolean("DE", "Draw E ", true)
		
local stackExpireTime = nil
		
OnTick(function(myHero) 
	
	for _, enemy in pairs(GetEnemyHeroes()) do
	
	local hp = (GetCurrentHP(myHero)/GetMaxHP(myHero))
	local valq = (Tryndamere.c.AutoQ:Value()/100)
	local valr = (Tryndamere.c.AutoR:Value()/100)
	local posq = Tryndamere.c.AreaQ:Value()
	local posr = Tryndamere.c.AreaR:Value()
	local hpenemy = GetCurrentHP(enemy)+GetDmgShield(enemy)
	local dmgenemy = CalcDamage(myHero, enemy, 0,  30 + 30*GetCastLevel(myHero,_E) + GetBonusDmg(myHero) + GetBonusAP(myHero) + GetBaseDamage(myHero))
	local myherodmg = (GetBonusDmg(myHero) + GetBonusAP(myHero) + GetBaseDamage(myHero))
	
	
	-------- Auto R -----------
	if CanUseSpell(myHero, _R) == READY and Tryndamere.c.R:Value()  	
		and hp < valr and EnemiesAround(myHeroPos(), posr)  > 0 
			then 
			CastSpell(_R)   				
		end
		
		-------- Anti IGNITE ----------
	if CanUseSpell(myHero, _R) == READY and Tryndamere.s.S:Value() and hp < 0.10 
			then 
			CastSpell(_R)   				
		end
		
		----------- Auto Q -------------
	if CanUseSpell(myHero, _Q) == READY and Tryndamere.c.Q:Value() and GotBuff(myHero,"UndyingRage")==0 and	hp < valq and EnemiesAround(myHeroPos(), posq) < 1 and not IsRecalling(myHero)
			then CastSpell(_Q)    	
		end
		
		----------- Items ------------
		
		--Blade of the Ruined King--
		if GetItemSlot(myHero,3153) > 0 and IsReady(GetItemSlot(myHero,3153))  and ValidTarget(enemy, 250) and Tryndamere.i.I:Value() and not IsRecalling(myHero) then
        CastTargetSpell(enemy, GetItemSlot(myHero,3153))
        end
		--Bilgewater Cutlass--
        if GetItemSlot(myHero,3144) > 0 and IsReady(GetItemSlot(myHero,3144))  and ValidTarget(enemy, 225) and Tryndamere.i.I:Value() and not IsRecalling(myHero) then
        CastTargetSpell(enemy, GetItemSlot(myHero,3144))
        end
		--Youmuu's Ghostblade--
        if GetItemSlot(myHero,3142) > 0 and IsReady(GetItemSlot(myHero,3142))  and ValidTarget(enemy, 175) and Tryndamere.i.I:Value() and not IsRecalling(myHero) then
        CastSpell(GetItemSlot(myHero,3142))
        end	
		--Ravenous Hydra--
		if GetItemSlot(myHero, 3074) > 0 and IsReady(GetItemSlot(myHero, 3074))and ValidTarget(enemy, 385) and Tryndamere.i.I:Value() and not IsRecalling(myHero) then
		CastSpell(GetItemSlot(myHero, 3074))
		end
		--Tiamat--
		if GetItemSlot(myHero, 3077) > 0 and IsReady(GetItemSlot(myHero, 3077))and ValidTarget(enemy, 400) and Tryndamere.i.I:Value() and not IsRecalling(myHero) then
		CastSpell(GetItemSlot(myHero, 3077))
		end
		
		----IGNITE----
		if Ignite and Tryndamere.ig.IG:Value() then
				if IsReady(Ignite) and 20*GetLevel(myHero)+45 > GetCurrentHP(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) and not ValidTarget(enemy, 225) then
				CastTargetSpell(enemy, Ignite)
				end
			end
		
		----Draw IGNITE----
		if Ignite and Tryndamere.ig.IG:Value() then
				if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) then
				DrawCircle(GetOrigin(enemy),225 ,1, 1, ARGB(250,255,255,0))
				
			end
		end
		
		------- smite jungle ----- pam activator ---
	
		------------ E draw ---------------
	   if CanUseSpell(myHero,_E) == READY and Tryndamere.dr.DE:Value() and  hpenemy <dmgenemy and ValidTarget(enemy, 660) then
	   DrawCircle(GetOrigin(enemy),65 ,1, 1, ARGB(222,255,255,0))
		end
		------------ E + A draw ---------------
	   if CanUseSpell(myHero,_E) == READY and Tryndamere.dr.DE:Value() and hpenemy < dmgenemy + myherodmg  and ValidTarget(enemy, 660) then
	   DrawCircle(GetOrigin(enemy),80 ,2, 2, ARGB(170,255,255,0))
	   end
		
	
	--- Last Hit with Hydra ---
	for _,mobs in pairs(minionManager.objects) do
	
	local HydraDmg = (CalcDamage(myHero, mobs, 0, GetBonusDmg(myHero) + GetBonusAP(myHero) + GetBaseDamage(myHero)))*0.6
	
	if ValidTarget(mobs, 400) and not ValidTarget(enemy, 700) and Tryndamere.ia.IA:Value() then
		--Ravenous Hydra--
		if HydraDmg > GetCurrentHP(mobs) and GetItemSlot(myHero, 3074) > 0 and IsReady(GetItemSlot(myHero, 3074))and ValidTarget(mobs, 385) then
		CastSpell(GetItemSlot(myHero, 3074))
		end
		--Tiamat--
		if HydraDmg > GetCurrentHP(mobs) and GetItemSlot(myHero, 3077) > 0 and IsReady(GetItemSlot(myHero, 3077))and ValidTarget(mobs, 400) then
		CastSpell(GetItemSlot(myHero, 3077))
		end
	end
	end
	end
end)
	
 
OnDraw(function(myHero)
	if  stackExpireTime then
		local time = stackExpireTime - GetGameTimer()
		if time > 0 then
			DrawText("R expire in : "..string.format("%.1f",time).."s", 40,600,200,0xffffd700)
		end
	end

end)
 
local eBuffName = "UndyingRage"
OnUpdateBuff(function(object,buffProc)
	if object == myHero and buffProc.Name == eBuffName then
		stackExpireTime = buffProc.ExpireTime
	end
end)

OnRemoveBuff(function(object,buffProc)
	if object == myHero and buffProc.Name == eBuffName then
		stackExpireTime = nil
	end
end)
	
	
	
	
PrintChat("<font color='#FF0000'> Crazy Trynda v1.5 </font><font color='#FFFF00'> by mastternick <font color='#66CC66'>(thank you all nice people for inspiration)</font>")
