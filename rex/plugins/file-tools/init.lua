local terminal = "com.superlogical.terminal"

-- Single source of truth: picker, actions, bindings and commands.
local tools = {
  { id = "fe", key = "e", title = "Edit a File",
    subtitle = "Fuzzy search with bat preview → Vim",
    icon = "code", detail = "Ctrl+B F E",
    desc = "Fuzzy-find a file and open it in Neovim." },
  { id = "zi", key = "z", title = "Jump to a Directory",
    subtitle = "Interactive zoxide directory picker",
    icon = "clock", detail = "Ctrl+B F Z",
    desc = "Open the interactive zoxide picker." },
  { id = "fcd", key = "d", title = "Browse Directories",
    subtitle = "Search and jump using fd + fzf",
    icon = "folder", detail = "Ctrl+B F D",
    desc = "Choose a directory and change into it." },
  { id = "fo", key = "o", title = "Open with Default App",
    subtitle = "Open using the macOS default application",
    icon = "document", detail = "Ctrl+B F O",
    desc = "Open a selected file with its default app." },
  { id = "ff", key = "r", title = "Reveal in Finder",
    subtitle = "Locate and select an item in Finder",
    icon = "link", detail = "Ctrl+B F R",
    desc = "Reveal a selected item in Finder." },
}

local items, known = {}, {}
for _, t in ipairs(tools) do
  items[#items + 1] = { id = t.id, title = t.title, subtitle = t.subtitle,
                        icon = t.icon, detail = t.detail }
  known[t.id] = true
end

-- True only when the focused terminal's foreground process is the shell.
local function at_prompt()
  local p, err = rex.block.call(terminal, "process", {})
  if not p then return false, tostring(err) end
  local fg = p.foreground
  if fg and fg.name == "zsh" then return true end
  return false, "foreground is " .. tostring(fg and fg.name or "unknown")
end

-- Types the function name at the focused terminal's prompt.
local function send(id)
  if not known[id] then
    rex.log("error", "file-tools: unknown tool " .. tostring(id))
    return
  end
  local ok, why = at_prompt()
  if not ok then
    rex.log("warn", "file-tools: not sending " .. id .. " (" .. why .. ")")
    return
  end
  local _, err = rex.block.call(terminal, "write", { data = id .. "\r" })
  if err then
    rex.log("error", "file-tools: could not run " .. id .. ": " .. tostring(err))
  end
end

for _, t in ipairs(tools) do
  local name = "file_tool_" .. t.id
  rex.action{
    name = name, title = t.title, category = "File Tools",
    description = t.desc,
    run = function() send(t.id) end,
  }
  rex.bind("ctrl+b>f>" .. t.key, name)
end

rex.action{
  name = "file_tools_menu",
  title = "File & Directory Tools",
  category = "Navigation",
  description = "Pick one of your Zsh file and directory tools.",
  run = function()
    local choice, why, detail = rex.ui.pick{
      title = "File & Directory Tools",
      placeholder = "Search file tools…",
      confirm = "Run Tool",
      items = items,
    }
    if choice == nil then
      if why ~= "cancelled" then
        rex.log("warn", "file-tools: picker " .. tostring(why) .. " " .. (detail or ""))
      end
      return
    end
    send(choice)
  end,
}
rex.bind("ctrl+b>f>m", "file_tools_menu")
