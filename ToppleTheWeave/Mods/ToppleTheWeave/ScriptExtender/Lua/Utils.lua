function Utils.Stringify(obj)
  return Ext.Json.Stringify(obj)
end

function Utils.Info(message)
  Ext.Utils.Print(Strings.INFO_TAG .. message)
end

function Utils.Warn(message)
  Ext.Utils.PrintWarning(Strings.WARN_TAG .. message)
end

function Utils.InsertToTable(arr, entry, count)
  for i = 1, count do
    table.insert(arr, entry)
  end
end

function Utils.IsVoloDead()
  return PersistentVars['IsVoloDead'] or false
  --return Globals.Vars.IsVoloDead or false
end