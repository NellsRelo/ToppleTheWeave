local volo = "S_GLO_Volo_2af25a85-5b9a-4794-85d3-0bd4c4d262fa"

function IsVoloDead()
  return PersistentVars['IsVoloDead'] or false
end

function OnSessionLoaded()
  Utils.Info(Strings.INFO_MOD_LOADED)
  if not IsVoloDead() then
    Utils.Info(Strings.INFO_MOD_LOADED_ALIVE)
  else
    Utils.Info(Strings.INFO_MOD_LOADED_DEAD)
  end
end

Ext.Osiris.RegisterListener("Died", 1, "after", function(char)
  if char == volo then
    Utils.Info(Strings.INFO_VOLO_IS_NOW_DEAD)
    PersistentVars['IsVoloDead'] = true
    Osi.OpenMessageBox(GetHostCharacter(), Strings.INFO_VOLO_IS_NOW_DEAD)
  end
end)

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, _, _, _)
  if IsVoloDead() then
    if Osi.IsCharacter(caster) == 1 and Osi.HasPassive(caster, "TTW_WildMagic_UnstableWeave") == 0 then
      Osi.AddPassive(caster, "TTW_WildMagic_UnstableWeave")
    end
  end
end)

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)

--[[
      elseif Osi.HasPassive(caster, "TTW_WildMagic_UnstableWeave") == 1 then
      local random = Ext.Math.Random(0, 1000)
      if random <= 5 then Osi.RemoveSpell(caster, spell) end
      if random > 5 and random <= 25 then Osi.CreateProjectileStrikeAt(caster, "Projectile_Fireball") end
      if random > 25 and random <= 45 then Osi.RemoveSummons(caster, 0) end
      if random > 45 and random <= 90 then Osi.ResetCooldowns(caster) end
      if random > 90 and random <= 130 then Osi.Unequip(caster, Osi.GetEquippedWeapon(caster)) end
      if random > 130 and random <= 180 then Osi.CreatePuddle(caster, "DarknessCloud", 4, 12, 2, 20, 100) end
      if random > 180 and random <= 230 then Osi.CreatePuddle(caster, "FireCloud", 3, 6, 0, 2, 100) end
      if random > 230 and random <= 380 then Osi.CreatePuddle(caster, "Fire", 4, 20, 6, 9, 100) end
      if random > 330 and random <= 381 then Osi.Die(caster) end
      if random > 880 and random <= 990 then Osi.CreateProjectileStrikeAt(caster, "Projectile_Fireball") end
      if random > 990 and random <= 995 then Osi.RemoveAllTadpolePowers(caster) end
      if random > 995 and random <= 1000 then Osi.PartyAddGold(caster, Ext.Math.Random(1, 1000)) end
    end
]]
   --
