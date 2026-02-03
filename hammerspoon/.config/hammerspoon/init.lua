hs.loadSpoon("AClock")

hs.hotkey.bind({ "cmd", "alt" }, "C", function()
	spoon.AClock:toggleShow()
end)

hs.hotkey.bind({ "ctrl", "alt" }, "Right", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x + (max.w / 2)
	f.y = max.y
	f.w = max.w / 2
	f.h = max.w
	win:setFrame(f)
end)

hs.hotkey.bind({ "ctrl", "alt" }, "Left", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w / 2
	f.h = max.w
	win:setFrame(f)
end)

hs.hotkey.bind({ "ctrl", "alt" }, "Return", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w
	f.h = max.w
	win:setFrame(f)
end)

require("polish")
