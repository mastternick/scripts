require("Inspired" )
require("IsFacing" )

if GetObjectName(GetMyHero()) ~= "Tryndamere" then return end

local Tryndamere = MenuConfig("Crazy Trynda v1.5", "Tryndamere")
	  Tryndamere:Menu("c", "Auto")
			Tryndamere.c:Boolean("Q", "Use Auto Q", true)
			Tryndamere.c:Slider("AutoQ","Q when Health is < ", 15, 1, 100, 1)
			Tryndamere.c:Slider("AreaQ","Area Q",375,1,2500,5)
			Tryndamere.c:Boolean("R", "Use Auto R", true)
			Tryndamere.c:Slider("AutoR", "R when Health is < ", 35, 1, 100, 1)
			Tryndamere.c:Slider("AreaR","Area R",650,1,2500,5)
			
			
	  Tryndamere:Menu("ifac","W")
			Tryndamere.ifac:Boolean("IFAC","Use W",true)
		
	  Tryndamere:Menu("i","Items")
			Tryndamere.i:Boolean("I","Use items",true)
			Tryndamere.i:Boolean("BOTRG","Use BOTRG",true)
		
	  Tryndamere:Menu("ia","Farm")
			Tryndamere.ia:Boolean("IA","Use Hydra farm",true)
			
	 
	 Tryndamere:Menu("s","Survive")
			Tryndamere.s:Boolean("S","Anti ignite",true)
			Tryndamere.s:Slider("AutoR", "R when Health is < ", 10, 1, 100, 1)
     
	 Tryndamere:Menu("ig", "Ignite")
			Tryndamere.ig:Boolean("IG", "Ignite", true)	
			Tryndamere.ig:Boolean("LIG", "Long Ignite", true)
			Tryndamere.ig:Boolean("LIGBOTRG", "Long BOTRG+Ignite", true)
			
	  Tryndamere:Menu("dr", "Draws")
			Tryndamere.dr:Boolean("DR", "Draw Ult ", true)
			Tryndamere.dr:Boolean("DE", "Draw E ", true)
			Tryndamere.dr:Boolean("LIG", "Long Ignite", true)
			Tryndamere.dr:Boolean("LIGBOTRG", "Long BOTRG+Ignite", true)
		
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
	local EPred = GetPredictionForPlayer(GetOrigin(myHero),enemy,GetMoveSpeed(enemy),1700,250,650,70,true,false)
	local HydraDmg = (CalcDamage(myHero, enemy, 0, GetBonusDmg(myHero) + GetBonusAP(myHero) + GetBaseDamage(myHero)))*0.6
	local ignitedmg = 20*GetLevel(myHero)+45 + GetHPRegen(enemy)*2.5
	local botrgdmg = GetCurrentHP(enemy)/10
	local valrs = (Tryndamere.s.AutoR:Value()/100)

	
	 if IOW:Mode() == "Combo" then	
	
	----W-----------
		if Tryndamere.ifac.IFAC:Value() and Ready(_W) and ValidTarget(enemy, 400) and not ValidTarget(enemy,200) and not IsFacing(enemy)
			then CastSpell(_W)
			end		
	
	----E kill----
		if Ready(_E) and GotBuff(myHero,"UndyingRage")==0 and EPred.HitChance == 1 and ValidTarget(enemy,660) and hpenemy < dmgenemy  then
			CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
			end

	
	----E + A = kill----
		if Ready(_E) and GotBuff(myHero,"UndyingRage")==0 and EPred.HitChance == 1 and ValidTarget(enemy,660) and hpenemy < dmgenemy + myherodmg  then
			CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
			end
			
			----E + A + ignite = kill----
		if Ready(_E) and Ignite ~= nil and IsReady(Ignite) and GotBuff(myHero,"UndyingRage")==0 and EPred.HitChance == 1 and ValidTarget(enemy,660) and hpenemy < dmgenemy + ignitedmg + myherodmg  then
			CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
			end

	end
	
	
	-------- Auto R -----------
	if Ready(_R) and Tryndamere.c.R:Value()  	
		and hp < valr and EnemiesAround(myHeroPos(), posr)  > 0 
			then 
			CastSpell(_R)   				
		end
		
		
		---- ------- Items ------------
		local botrg = GetItemSlot(myHero,3153)
		local bilgewater = GetItemSlot(myHero,3144)
		local youmuu = GetItemSlot(myHero,3142)
		local hydra = GetItemSlot(myHero, 3074)
		local tiamat = GetItemSlot(myHero, 3077)
		
		
		--Blade of the Ruined King--
		if CanUseSpell(myHero, botrg) == READY and botrg ~= 0  and ValidTarget(enemy, 250) and Tryndamere.i.I:Value() and Tryndamere.i.BOTRG:Value() and not IsRecalling(myHero) then
        CastTargetSpell(enemy, botrg)
		
        end
		--Bilgewater Cutlass--
        if CanUseSpell(myHero, bilgewater) == READY  and ValidTarget(enemy, 225) and Tryndamere.i.I:Value() and bilgewater ~= 0  and not IsRecalling(myHero) then
        CastTargetSpell(enemy, bilgewater)
        end
		--Youmuu's Ghostblade--
        if CanUseSpell(myHero, youmuu) == READY  and ValidTarget(enemy, 175) and Tryndamere.i.I:Value() and not IsRecalling(myHero) and youmuu ~= 0 then
        CastSpell(youmuu)
        end	
		--Ravenous Hydra--
		if CanUseSpell(myHero, hydra) == READY and ValidTarget(enemy, 385) and Tryndamere.i.I:Value() and not IsRecalling(myHero) and GetItemSlot(myHero, 3074) ~= 0 then
		CastSpell(hydra)
		end
		--Tiamat--
		if CanUseSpell(myHero, tiamat) == READY and ValidTarget(enemy, 400) and Tryndamere.i.I:Value() and not IsRecalling(myHero) and tiamat ~= 0 then
		CastSpell(tiamat)
		end
		
			
		
		
	
	
			-------- Anti IGNITE ----------
				
	if CanUseSpell(myHero, _R) == READY and Tryndamere.s.S:Value() and hp < valrs 
			then 
			CastSpell(_R)   				
		end
		
		----------- Auto Q -------------
	if IsReady(_Q) and Tryndamere.c.Q:Value() and GotBuff(myHero,"UndyingRage")==0 and	hp < valq and EnemiesAround(myHeroPos(), posq) < 1 and not IsRecalling(myHero)
			then CastSpell(_Q)    	
		end

		
		----IGNITE----
		if Ignite ~= nil and IsReady(Ignite)  and Tryndamere.ig.IG:Value() then
				if 20*GetLevel(myHero)+45 > GetCurrentHP(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) and not ValidTarget(enemy, 400) then
				CastTargetSpell(enemy, Ignite)
				end
			end
			
			----IGNITE Last----
		if Ignite ~= nil and IsReady(Ignite) and Tryndamere.ig.IG:Value() then
				if 20*GetLevel(myHero)+45 > GetCurrentHP(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) and hp < 0.10 then
				CastTargetSpell(enemy, Ignite)
				end
		
		
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
	
function GetDrawText(enemy)


		----------- Items ------------
		botrg = GetItemSlot(myHero,3153)
		hydra = GetItemSlot(myHero, 3074)
		tiamat = GetItemSlot(myHero, 3077)

 local botrgdmg = GetCurrentHP(enemy)/10
 local hpenemy = GetCurrentHP(enemy)+GetDmgShield(enemy)
 local dmgenemy = CalcDamage(myHero, enemy, 0,  30 + 30*GetCastLevel(myHero,_E) + GetBonusDmg(myHero) + GetBonusAP(myHero) + GetBaseDamage(myHero))
 local myherodmg = (GetBonusDmg(myHero) + GetBonusAP(myHero) + GetBaseDamage(myHero))
 local HydraDmg = (CalcDamage(myHero, enemy, 0, GetBonusDmg(myHero) + GetBonusAP(myHero) + GetBaseDamage(myHero)))*0.6
 local ignitedmg = 20*GetLevel(myHero)+45 + GetHPRegen(enemy)*2.5
 local IGNITE_ready = Ignite ~= nil and IsReady(Ignite) 
 local E_ready = CanUseSpell(myHero,_E) == READY
 local BOTRG_ready = CanUseSpell(myHero, botrg) == READY and botrg ~= 0
 local HYDRA_ready = CanUseSpell(myHero, hydra) == READY and hydra ~= 0
 local Tiamat_ready = CanUseSpell(myHero,tiamat) == READY and tiamat ~= 0

	
		if ignitedmg > hpenemy and IGNITE_ready then
		return 'Ignite = Kill', ARGB(255, 200, 160, 0)
		
		elseif hpenemy < dmgenemy and E_ready then
		return 'E = Kill'	, ARGB(255, 200, 160, 0)
		
		elseif hpenemy < dmgenemy + myherodmg and E_ready then
		return 'E + A = Kill'	, ARGB(255, 200, 160, 0)
		
		elseif hpenemy < dmgenemy + 2*myherodmg and E_ready then
		return 'E + AA = Kill'	, ARGB(255, 200, 160, 0)
		
		elseif hpenemy < dmgenemy + botrgdmg and E_ready and BOTRG_ready then
		return 'E + BOTRG = Kill'	, ARGB(255, 200, 160, 0)
		
		elseif hpenemy < dmgenemy + botrgdmg + myherodmg and E_ready and BOTRG_ready then
		return 'E + BOTRG + A = Kill'	, ARGB(255, 200, 160, 0)
		
		elseif E_ready and BOTRG_ready and HYDRA_ready and hpenemy < dmgenemy + botrgdmg + HydraDmg then
		return 'E + BOTRG + Hydra = Kill'	, ARGB(255, 200, 160, 0)
		
		elseif E_ready and BOTRG_ready and HYDRA_ready and hpenemy < dmgenemy + botrgdmg + HydraDmg + myherodmg then
		return 'E + BOTRG + Hydra + A = Kill'	, ARGB(255, 200, 160, 0)
		
		elseif E_ready and BOTRG_ready and HYDRA_ready and IGNITE_ready and hpenemy < dmgenemy + botrgdmg + HydraDmg + ignitedmg then
		return 'E + BOTRG + Hydra + Ignite = Kill'	, ARGB(255, 200, 160, 0)
		
		elseif E_ready and BOTRG_ready and HYDRA_ready and IGNITE_ready and hpenemy < dmgenemy + botrgdmg + HydraDmg + ignitedmg + myherodmg then
		return 'E + BOTRG + Hydra + A + Ignite = Kill'	, ARGB(255, 200, 160, 0)
		
		elseif E_ready and Tiamat_ready and hpenemy < dmgenemy + HydraDmg then 
		return 'E + Tiamat = Kill', ARGB(255, 200, 160, 0)
		
		elseif E_ready and Tiamat_ready and hpenemy < dmgenemy + HydraDmg + myherodmg then 
		return 'E + Tiamat + A = Kill', ARGB(255, 200, 160, 0)
		
		elseif E_ready and HYDRA_ready and hpenemy < dmgenemy + HydraDmg then 
		return 'E + Hydra = Kill', ARGB(255, 200, 160, 0)
		
		elseif E_ready and HYDRA_ready and hpenemy < dmgenemy + HydraDmg + myherodmg then 
		return 'E + Hydra + A = Kill', ARGB(255, 200, 160, 0)
		
		elseif E_ready and Tiamat_ready and IGNITE_ready and hpenemy < dmgenemy + ignitedmg + HydraDmg then
		return 'Ignite + E + Tiamat = Kill', ARGB(255, 200, 160, 0)
		
		elseif E_ready and HYDRA_ready and IGNITE_ready and hpenemy < dmgenemy + ignitedmg + HydraDmg then
		return 'Ignite + E + Hydra = Kill', ARGB(255, 200, 160, 0)
		
		elseif E_ready and IGNITE_ready and BOTRG_ready and hpenemy < ignitedmg + botrgdmg then
		return 'Use E and Ignite + BOTRG = Kill', ARGB(255, 200, 160, 0)

	else
		return '-_-' , ARGB(255, 200, 160, 0)
 
 end
 end
 
 
OnDraw(function(myHero)
	
	if  stackExpireTime then
		local time = stackExpireTime - GetGameTimer()
		if time > 0 then
			DrawText("R expire in : "..string.format("%.1f",time).."s", 40,600,200,0xffffd700)
		end
	end
	
	for _, enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) then
		    local enemyPos = GetOrigin(enemy)
			local drawpos = WorldToScreen(1,enemyPos.x, enemyPos.y, enemyPos.z)
			local enemyText, color = GetDrawText(enemy)
			DrawText(enemyText, 20, drawpos.x, drawpos.y, color)
		end
	end


end)
	
	
PrintChat("<font color='#FF0000'> Crazy Trynda v1.5 </font><font color='#FFFF00'> by mastternick <font color='#66CC66'>(thank you all nice people for inspiration)</font>")
