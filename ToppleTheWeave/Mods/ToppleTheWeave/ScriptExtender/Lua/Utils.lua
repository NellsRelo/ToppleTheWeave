function Utils.Stringify(obj)
  return Ext.Json.Stringify(obj)
end

function Utils.Info(message)
  Ext.Utils.Print(Strings.INFO_TAG .. message)
end

function Utils.Warn(message)
  Ext.Utils.PrintWarning(Strings.WARN_TAG .. message)
end
