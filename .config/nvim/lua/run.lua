local M = {}
BASHCOMP_SRC = '/etc/bash_completion'
BASHCOMP_FUNCS = {}
LAST_CMD = nil

--- Check if a string starts with another string.
-- @DOC_text_gears_string_startswith_EXAMPLE@
-- @tparam string str String to search
-- @treturn boolean `true` if string starts with specified string
-- @tparam string sub String to check for.
-- @staticfct gears.string.startswith
local function startswith(str, sub)
  return str and (string.sub(str, 1, string.len(sub)) == sub) or false
end

local function bash_escape(str)
  str = str:gsub(" ", "\\ ")
  str = str:gsub("%[", "\\[")
  str = str:gsub("%]", "\\]")
  str = str:gsub("%(", "\\(")
  str = str:gsub("%)", "\\)")
  return str
end

--- Use shell completion system to complete commands and filenames.
-- @param string command The command line.
-- @tparam number cur_pos The cursor position.
-- @tparam number ncomp The element number to complete.
-- @tparam[opt=based on SHELL] string shell The shell to use for completion.
--   Supports "bash" and "zsh".
-- @treturn string The new command.
-- @treturn number The new cursor position.
-- @treturn table The table with all matches.
function SHELL_COMPLETION(command, cur_pos, shell)
  local wstart = 1
  --- @type integer | nil
  local wend = 1
  local words = {}
  local cword_index = 0
  local i = 1
  local comptype = "file"

  local oil = require("oil")
  local cwd = oil.get_current_dir()

  local old_command = command
  local _, end_cmd_name = string.find(command, 'R!?%s+')
  command = string.sub(command, (end_cmd_name or 0) + 1)
  cur_pos = cur_pos - (#old_command - #command)

  while wend <= #command do
    wend = command:find(" ", wstart)
    if not wend then wend = #command + 1 end
    table.insert(words, command:sub(wstart, wend - 1))
    if cur_pos >= wstart and cur_pos <= wend + 1 then
      cword_index = i
    end
    wstart = wend + 1
    i = i + 1
  end

  if cword_index == 1 then
    comptype = "command"
  end

  local shell_cmd
  if not shell then
    local env_shell = os.getenv('SHELL')
    if not env_shell then
      shell = 'bash'
    elseif env_shell:match('zsh$') then
      shell = 'zsh'
    else
      shell = 'bash'
    end
  end
  if shell == 'zsh' then
    if comptype == "file" then
      -- NOTE: ${~:-"..."} turns on GLOB_SUBST, useful for expansion of
      -- "~/" ($HOME).  ${:-"foo"} is the string "foo" as var.
      shell_cmd = "/usr/bin/env zsh -c 'local -a res; res=( ${~:-"
          .. string.format('%q', words[cword_index]) .. "}*(N) ); "
          .. "print -ln -- ${res[@]}'"
    else
      -- Check commands, aliases, builtins, functions and reswords.
      -- Adds executables and non-empty dirs from $PWD (pwd_exe).
      shell_cmd = "/usr/bin/env zsh -c 'local -a res pwd_exe; " ..
          "pwd_exe=(*(N*:t) *(NF:t)); " ..
          "res=( " ..
          "\"${(k)commands[@]}\" \"${(k)aliases[@]}\" \"${(k)builtins[@]}\" \"${(k)functions[@]}\" " ..
          "\"${(k)reswords[@]}\" " ..
          "./${^${pwd_exe}} " ..
          "); " ..
          "print -ln -- ${(M)res[@]:#" .. string.format('%q', words[cword_index]) .. "*}'"
    end
  else
    if BASHCOMP_FUNCS[words[1]] then
      -- fairly complex command with inline bash script to get the possible completions
      shell_cmd = "/usr/bin/env bash -c 'source " .. BASHCOMP_SRC .. "; " ..
          (cwd ~= nil and "cd \"" .. vim.fn.fnamemodify(cwd, ":p") .. "\";" or "") ..
          "__print_completions() { for ((i=0;i<${#COMPREPLY[*]};i++)); do echo ${COMPREPLY[i]}; done }; " ..
          "COMP_WORDS=(" .. command .. "); COMP_LINE=\"" .. command .. "\"; " ..
          "COMP_COUNT=" .. cur_pos .. "; COMP_POINT=" .. cur_pos .. "; COMP_CWORD=" .. cword_index - 1 .. "; " ..
          BASHCOMP_FUNCS[words[1]] .. "; __print_completions'"
    else
      shell_cmd = "/usr/bin/env bash -c 'compgen -A " .. comptype .. " "
          .. string.format('%q', words[cword_index] or '') .. "'"
    end
  end
  local c, err = io.popen(shell_cmd .. " | sort -u")
  local output = {}
  if c then
    while true do
      local line = c:read("*line")
      if not line then break end
      if startswith(line, "./") and vim.fn.isdirectory(line) then
        line = line .. "/"
      end
      table.insert(output, bash_escape(line))
    end

    c:close()
  else
    vim.notify(err or "", vim.log.levels.ERROR)
  end

  return table.concat(output, '\n')
end

function BASHCOMP_LOAD(src)
  if src then BASHCOMP_SRC = src end
  local c, err = io.popen("/usr/bin/env bash -c 'source " .. BASHCOMP_SRC .. "; complete -p'")
  if c then
    while true do
      local line = c:read("*line")
      if not line then break end
      -- if a bash function is used for completion, register it
      if line:match(".* -F .*") then
        BASHCOMP_FUNCS[line:gsub(".* (%S+)$", "%1")] = line:gsub(".*-F +(%S+) .*$", "%1")
      end
    end
    c:close()
  else
    vim.notify(err or "", vim.log.levels.ERROR)
  end
end

local run_cmd = function(opts)
  local cmd = opts.args
  if cmd ~= nil and string.match(cmd, "%S") then
    local bang = opts.bang
    local flags = {}
    if bang then
      table.insert(flags, '-mode=terminal')
    end
    local flags_str = ""
    for _, value in ipairs(flags) do
      flags_str = flags_str .. " " .. value
    end
    cmd = string.format(' %s %s', flags_str, cmd)
  else
    if LAST_CMD ~= nil then
      cmd = LAST_CMD
    else
      error("Empty")
    end
  end
  LAST_CMD = cmd
  vim.cmd['AsyncRun'](cmd)
end

M.setup = function()
  BASHCOMP_LOAD()

  vim.cmd([[
fun! CompleteShell(argLead, cmdLine, curPos)
  return v:lua.SHELL_COMPLETION(a:cmdLine, a:curPos + 1)
endfun
]])

  vim.api.nvim_create_user_command('R', run_cmd, {
    nargs = "*",
    complete = "custom,CompleteShell",
    bang = true
  })
end

return M
