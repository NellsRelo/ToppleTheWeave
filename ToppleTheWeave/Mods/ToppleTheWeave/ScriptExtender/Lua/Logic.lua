function ShiftPersistentVarToModVar(varName)
  if PersistentVars[varName] ~= nil then
    Globals.Vars[varName] = PersistentVars[varName]
    PersistentVars[varName] = nil
  end
end

function DestabilizingWeave(caster, spell)
  local IsVolatile = Ext.Math.Random(0, 4)
  if IsVolatile == 1 then
    local effectIdx = Ext.math.Random(0, 120)
    _P("Volatile effect! Rolling a " .. effectIdx)
    if effectIdx <= 5 then Osi.RemoveSpell(caster, spell) end
    if effectIdx > 5 and effectIdx <= 15 then
      Osi.CreateProjectileStrikeAt(caster,
        Globals.Projectiles[Ext.Math.Random(1, #Globals.Projectiles)])
    end
    if effectIdx > 15 and effectIdx <= 25 then
      Osi.CreateExplosionAt(caster,
        Globals.Explosions[Ext.Math.Random(1, #Globals.Explosions)], Ext.Math.Random(1, 6))
    end
    if effectIdx > 25 and effectIdx <= 35 then
      Osi.ApplyStatus(caster,
        Globals.Statuses[Ext.Math.Random(1, #Globals.Statuses)], Ext.Math.Random(1, 8))
    end
    if effectIdx > 35 and effectIdx <= 45 then Osi.RemoveSummons(caster, 0) end
    if effectIdx > 45 and effectIdx <= 50 then Osi.ResetCooldowns(caster) end
    if effectIdx > 50 and effectIdx <= 60 then Osi.Unequip(caster, Osi.GetEquippedWeapon(caster)) end
    if effectIdx > 60 and effectIdx <= 70 then
      Osi.CreatePuddle(caster,
        Globals.Puddles[Ext.Math.Random(1, #Globals.Puddles)], Ext.Math.Random(0, 4), Ext.Math.Random(4, 12),
        Ext.Math.Random(0, 4), Ext.Math.Random(0, 4), Ext.Math.Random(0, 30), Ext.Math.Random(0, 10000))
    end
    if effectIdx > 70 and effectIdx <= 80 then
      Osi.CreateSurface(caster,
        Globals.Puddles[Ext.Math.Random(1, #Globals.Puddles)], Ext.Math.Random(0, 4), Ext.Math.Random(4, 12),
        Ext.Math.Random(0, 4), Ext.Math.Random(4, 12), Ext.Math.Random(0, 100))
    end
    if effectIdx > 80 and effectIdx <= 85 then Osi.EndTurn(caster) end
    if effectIdx > 85 and effectIdx <= 85 then Osi.PartyAddGold(caster, Ext.Math.Random(-100, 1000)) end
    if effectIdx > 115 and effectIdx <= 119 then Osi.RemoveAllTadpolePowers(caster) end
    if effectIdx == 120 then Osi.Die(caster) end
  end
end

function OnSessionLoaded()
  Ext.Vars.RegisterModVariable(ToppleTheWeave.UUID, "IsVoloDead", {
    Server = false, Client = false, SyncToClient = true
  })
  Utils.Info(Strings.INFO_MOD_LOADED)
  ShiftPersistentVarToModVar('IsVoloDead')
  if not Utils.IsVoloDead() then
    Utils.Info(Strings.INFO_MOD_LOADED_ALIVE)
  else
    Utils.Info(Strings.INFO_MOD_LOADED_DEAD)
  end
end

Ext.Osiris.RegisterListener("Died", 1, "after", function(char)
  if char == Globals.volo then
    Utils.Info(Strings.INFO_VOLO_IS_NOW_DEAD)
    Globals.Vars.IsVoloDead = true
    Osi.OpenMessageBox(GetHostCharacter(), Strings.INFO_VOLO_IS_NOW_DEAD)
  end
end)

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, _, _, _)
  if IsVoloDead() then
    if Osi.IsCharacter(caster) == 1 and Osi.HasPassive(caster, "TTW_WildMagic_UnstableWeave") == 0 then
      Osi.AddPassive(caster, "TTW_WildMagic_UnstableWeave")
    elseif Osi.HasPassive(caster, "TTW_WildMagic_UnstableWeave") == 1 then
      DestabilizingWeave(caster, spell)
    end
  end
end)

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
