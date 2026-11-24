-- ~/.config/rex/init.lua

-- Earlier bindings
rex.bind("cmd+k", "pane.send_key", { key = "ctrl+l" }) -- clear screen
rex.bind("alt+cmd+k", "session.switch") -- session switcher moved
rex.bind("cmd+shift+r", "client.config.reload")

-- Global (Ctrl+B prefix)
rex.mode("wm", { exclusive = true })
rex.bind("ctrl+b>w", "client.mode.enter", { name = "wm" })
rex.bind("ctrl+b>b", "client.sidebar.toggle")
rex.bind("ctrl+b>p", "client.palette.toggle")

-- Window mode (Esc leaves)
rex.bind("wm/n", "pane.split.auto")
rex.bind("wm/x", "pane.close")
rex.bind("wm/z", "pane.zoom")
rex.bind("wm/shift+z", "pane.zoom")
rex.bind("wm/=", "pane.balance")
rex.bind("wm/-", "pane.resize", { direction = "left" })
rex.bind("wm/shift+=", "pane.resize", { direction = "right" }) -- "+"

for k, d in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
	rex.bind("wm/" .. k, "pane.focus." .. d) -- navigate
	rex.bind("wm/shift+" .. k, "pane.move." .. d) -- H/J/K/L move pane
end

-- >>> rdxt (managed by rdxt setup; rdxt setup --undo removes it) >>>
dofile("/Users/zihaan/.config/rex/plugins/rdxt/init.lua").setup({ bin = "/opt/homebrew/bin/rdxt" })
-- <<< rdxt <<<

-- >>> Rex File Tools (managed) >>>
dofile((os.getenv("HOME") or "") .. "/.config/rex/plugins/file-tools/init.lua")
-- <<< Rex File Tools (managed) <<<
