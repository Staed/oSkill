local acutil = require('acutil')

oskill = {}
oskill.bazooka = false
oskill.toggle = 0

function OSKILL_ON_INIT(addon, frame)
	addon:RegisterMsg('FPS_UPDATE','OSKILL_UPDATE')
	addon:RegisterMsg('BUFF_ADD', 'OSKILL_ON_BUFF_ADD')
	acutil.slashCommand('/oskill', OSKILL_COMMAND_HANDLER)
	
	CHAT_SYSTEM('oskill is loaded')
end

function OSKILL_ON_BUFF_ADD(frame, msg, argStr, argNum) 
	if msg ~= 'BUFF_ADD' then
		return
	end
	
	local cls = GetClassByType('Buff', argNum)
	
	if cls and cls.Name and cls.Name ~= '' and argNum == 3076 then
		oskill.bazooka = true
	else
		oskill.bazooka = false
	end
end

function OSKILL_UPDATE()
	if msg ~= 'FPS_UPDATE' then
		return
	end
	
	-- GetIES(session.GetEquipItemList():Element(8):GetObject()).ClassName:sub(0,3)
	local equipItemList = session.GetEquipItemList()
	
	-- Element(8) = RH, Element(9) = LH
	local mainType = GetIES(equipItemList:Element(8):GetObject()).ClassName:sub(0,3)
	local offType = GetIES(equipItemList:Element(9):GetObject()).ClassName:sub(0,3)
	
	local myActor = world.GetActor(session.GetMyHandle())
	local targetActor = world.GetActor(session.GetTargetHandle())
	
	-- GetSubActionState() == 38 = Idle, 41 = In Action, 39 = After animation
	
	-- NoWeapon = empty hand
	-- BOW = crossbow, TBW = bow, MUS = rifle
	-- SPR = 1h spear, TSP = 2h spear, RAP = rapier
	-- SWD = 1h sword, TSW = 2h sword
	-- STF = rod, TSF = staff, MAC = mace
	-- CAN = cannon, DAG = dagger, PST = pistol
	if (oskill.toggle == 1 and GetMyActor():GetSubActionState() == 38 and targetActor:IsDead() == 0) then
		if mainType == 'NoW' and bazooka == false then
			return
		elseif offType == 'CAN' and bazooka == true then
			geMCC.UseSkill(myActor, targetActor, 58)
		elseif mainType == 'BOW' then
			geMCC.UseSkill(myActor, targetActor, 52)
		elseif mainType == 'TBW' then
			geMCC.UseSkill(myActor, targetActor, 2)
		elseif mainType == 'MUS' then
			geMCC.UseSkill(myActor, targetActor, 55)
		elseif mainType == 'SPR' or mainType == 'RAP' or mainType == 'SWD' or mainType == 'MAC' then
			geMCC.UseSkill(myActor, targetActor, 1)
		elseif mainType == 'TSP' or mainType == 'TSW' then
			geMCC.UseSkill(myActor, targetActor, 5)
		elseif mainType == 'STF' then
			geMCC.UseSkill(myActor, targetActor, 4)
		elseif mainType == 'TSF' then
			geMCC.UseSkill(myActor, targetActor, 6)
		else
			return
		end
	elseif (oskill.toggle == 2 and GetMyActor():GetSubActionState() == 38 and targetActor:IsDead() == 0) then
		if offType == 'DAG' then
			geMCC.UseSkill(myActor, targetActor, 10)
		elseif offType == 'PST' then
			geMCC.UseSkill(myActor, targetActor, 53)
		else
			return
		end
	else
		return
	end
end

function OSKILL_COMMAND_HANDLER(words)
	if #words <= 0 then 
		return
	end
	
	local cmd = string.lower(table.remove(words, 1))

	if cmd == 'rh' then
		oskill.toggle = 1
		CHAT_SYSTEM('oskill: activated on right hand')
	elseif cmd == 'lh' then
		oskill.toggle = 2
		CHAT_SYSTEM('oskill: activated on right hand')
	elseif cmd == 'off' then
		oskill.toggle = 0
		CHAT_SYSTEM('oskill: disabled')
	else
		return
	end
end