function ShiftPersistentVarToModVar(varName)
  if PersistentVars[varName] ~= nil then
    Globals.Vars[varName] = PersistentVars[varName]
    PersistentVars[varName] = nil
  end
end

function DestabilizingWeave(caster, spell)
  local IsVolatile = Ext.Math.Random(0, 4)
  if IsVolatile == 1 then
    Osi.ShowNotification(caster, Strings.MSG_VOLATILE_FORCE)
    local effectIdx = Ext.Math.Random(0, 120)
    if effectIdx <= 5 then
      Osi.RemoveSpell(caster, spell)
      Osi.ShowNotification(caster, Strings.MSG_UNLEARN_SPELL)
    end
    if effectIdx > 5 and effectIdx <= 15 then
      Osi.CreateProjectileStrikeAt(caster,
        Globals.Projectiles[Ext.Math.Random(1, #Globals.Projectiles)])
      Osi.ShowNotification(caster, Strings.MSG_UNLEASHED_PROJECTILE)
    end
    if effectIdx > 15 and effectIdx <= 25 then
      Osi.CreateExplosion(caster,
        Globals.Explosions[Ext.Math.Random(1, #Globals.Explosions)], Ext.Math.Random(1, 6))
      Osi.ShowNotification(caster, Strings.MSG_EXPLOSION)
    end
    if effectIdx > 25 and effectIdx <= 35 then
      Osi.ApplyStatus(caster,
        Globals.Statuses[Ext.Math.Random(1, #Globals.Statuses)], Ext.Math.Random(1, 8))
      Osi.ShowNotification(caster, Strings.MSG_STATUS)
    end
    if effectIdx > 35 and effectIdx <= 45 then
      Osi.RemoveSummons(caster, 0)
      Osi.ShowNotification(caster, Strings.MSG_DESUMMON)
    end
    if effectIdx > 45 and effectIdx <= 50 then
      Osi.ResetCooldowns(caster)
      Osi.ShowNotification(caster, Strings.MSG_RESET_COOLDOWN)
    end
    -- if effectIdx > 50 and effectIdx <= 60 then
    --   Osi.Unequip(caster, Osi.GetEquippedWeapon(caster))
    --   Osi.ShowNotification(caster, Strings.MSG_UNEQUIP)
    -- end
    if effectIdx > 50 and effectIdx <= 70 then
      local puddle = Globals.Puddles[Ext.Math.Random(1, #Globals.Puddles)]
      Osi.CreatePuddle(caster, puddle, Ext.Math.Random(0, 4), Ext.Math.Random(4, 12),
        Ext.Math.Random(0, 4), Ext.Math.Random(4, 30), Ext.Math.Random(0, 10000))
      Osi.ShowNotification(caster, Strings.MSG_CREATE_PUDDLE)
    end
    if effectIdx > 70 and effectIdx <= 80 then
      local surface = Globals.Puddles[Ext.Math.Random(1, #Globals.Puddles)]
      Osi.CreateSurface(caster, surface, Ext.Math.Random(0, 4), Ext.Math.Random(4, 12))
      Osi.ShowNotification(caster, Strings.MSG_CREATE_SURFACE)
    end
    if effectIdx > 80 and effectIdx <= 85 then
      Osi.EndTurn(caster)
      Osi.ShowNotification(caster, Strings.MSG_END_TURN)
    end
    if effectIdx > 85 and effectIdx <= 85 then
      local moneyModifier = Ext.Math.Random(-100, 1000)
      if moneyModifier > 0 then
        Osi.ShowNotification(caster, Strings.MSG_GAINED_MONEY)
      elseif moneyModifier == 0 then
        Osi.ShowNotification(caster, Strings.MSG_NO_MONEY)
      else
        Osi.ShowNotification(caster, Strings.MSG_LOST_MONEY)
      end
      Osi.PartyAddGold(caster, moneyModifier)
    end
    if effectIdx > 115 and effectIdx <= 119 then
      Osi.ShowNotification(caster, Strings.MSG_REMOVE_TADPOLE)
      Osi.RemoveAllTadpolePowers(caster)
    end
    if effectIdx == 120 then
      Osi.ShowNotification(caster, Strings.MSG_YOU_DIED)
      Osi.Die(caster)
    end
  end
end

function OnSessionLoaded()
  Utils.Info(Strings.INFO_MOD_LOADED)
  --ShiftPersistentVarToModVar('IsVoloDead')
  if not Utils.IsVoloDead() then
    Utils.Info(Strings.INFO_MOD_LOADED_ALIVE)
  else
    Utils.Info(Strings.INFO_MOD_LOADED_DEAD)
  end
end

Ext.Osiris.RegisterListener("Died", 1, "after", function(char)
  if char == Globals.volo then
    Utils.Info(Strings.INFO_VOLO_IS_NOW_DEAD)
    --Globals.Vars.IsVoloDead = true
    PersistentVars['IsVoloDead'] = true
    Osi.OpenMessageBox(GetHostCharacter(), Strings.INFO_VOLO_IS_NOW_DEAD)
  end
end)

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, _, _, _)
  if Utils.IsVoloDead() then
    if Osi.IsCharacter(caster) == 1 and Osi.HasPassive(caster, "TTW_WildMagic_UnstableWeave") == 0 then
      Osi.AddPassive(caster, "TTW_WildMagic_UnstableWeave")
    elseif Osi.HasPassive(caster, "TTW_WildMagic_UnstableWeave") == 1 then
      DestabilizingWeave(caster, spell)
    end
  end
end)

Ext.Events.DealDamage:Subscribe(function(e)
  if Utils.IsVoloDead() and e.Functor.Magical then
    local IsVolatile = Ext.Math.Random(1, 4)
        if IsVolatile == 1 then
      Osi.ShowNotification(Osi.GetIdentity(e.Caster.Uuid.EntityUuid, 1), Strings.MSG_VOLATILE_FORCE_DAMAGE_TYPE)
      e.Functor.DamageType = Globals.DamageTypes[Ext.Math.Random(1, #Globals.DamageTypes)]
    end
  end
end)

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
