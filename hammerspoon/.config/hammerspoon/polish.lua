local function readApiKey(path)
	local file = io.open(path, "r")
	if not file then
		return nil, "File not found: " .. path
	end
	local content = file:read("*a") -- read all
	file:close()
	return content
end

local apiKey, err = readApiKey(".openai.key")

if apiKey then
	apiKey = apiKey:gsub("%s+", "") -- remove whitespaces and newlines
else
	hs.alert("Error: " .. err)
end

local systemPrompt = [[
Verbessere diesen Text stilistisch, grammatikalisch und sorge für einen guten Lesefluß.
Behalte den Sinn bei. Antworte nur mit dem korrigierten Text – ohne Kommentare, Formatierungen oder zusätzliche Hinweise.
]]

function polishText()
	local inputText = hs.pasteboard.getContents()

	if not inputText or inputText == "" then
		hs.alert.show("⚠️ Zwischenablage ist leer!")
		return
	end

	hs.alert.show("Sende Text an OpenAI...")

	local body = hs.json.encode({
		model = "gpt-4o-mini",
		messages = {
			{ role = "system", content = systemPrompt },
			{ role = "user",   content = inputText },
		},
		temperature = 0,
	})

	hs.http.asyncPost("https://api.openai.com/v1/chat/completions", body, {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. apiKey,
	}, function(code, responseBody, headers)
		if code == 200 then
			local data = hs.json.decode(responseBody)
			local result = data.choices[1].message.content
			hs.pasteboard.setContents(result)
			hs.alert.show("✅ Text verbessert und kopiert!")
			print(result)
		else
			hs.alert.show("Fehler: " .. tostring(code))
			print(responseBody)
		end
	end)
end

-- Optional: Hotkey zum Ausführen
hs.hotkey.bind({ "cmd", "alt" }, "P", polishText)
