local MODSTRINGS = {
	BOSSES = {
		ATRIUM_GATE_COOLDOWN= "Gate Cooldown",
		ATRIUM_GATE_DESTABLE= "Atrium Reset",
		FRUITFLY			= "Fruitfly",
	},
	WIDGET = {
		SEC_LEFT		= "%d seconds",
		MIN_SEC_LEFT	= "%dm %02d",
		DAYS_LEFT		= "%.2f days",
		NO_HOUND		= "No Attack\nPredicted",
		NO_BOSS			= "No Boss\nPredicted",
		NO_RIFT			= "No Rift\nPredicted",
		DISABLED		= "Prediction\ndisabled",
		HOUND_CURRENT	= "Attack!",
		RIFT_WAVE_LEFT	= "%d waves left",
		RIFT_EXPANDING	= "Expanding!"
	}
}

if GLOBAL ~= nil and GLOBAL.POT_GENERATION == false then
	local env = env
	GLOBAL.setfenv(1, GLOBAL)

	local modtranslator = Translator()

	local currentLocale = LOC.GetLocale()
	if currentLocale ~= nil then
		local file = env.MODROOT .. "modlanguages/" .. currentLocale.strings
		if resolvefilepath_soft(file) then
			modtranslator:LoadPOFile(file, currentLocale.code)
		end
	end

	-- modified from translator.lua
	local function TranslateModStringTable( base, tbl )
		for k,v in pairs(tbl) do
			local path = base.."."..k
			if type(v) == "table" then
				TranslateModStringTable(path, v)
			else
				local str = modtranslator:GetTranslatedString(path)
				if str and str ~= "" then
					tbl[k] = str
				end
			end
		end
	end

	TranslateModStringTable("MODSTRINGS", MODSTRINGS)
end

return MODSTRINGS
