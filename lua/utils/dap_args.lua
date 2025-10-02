-- lua/utils/dap_args.lua
local M = {}

-- parse a single input line into args[]
function M.parse_args(input)
  local args, cur, in_q = {}, {}, nil
  local i, n = 1, #input
  while i <= n do
    local c = input:sub(i,i)
    if in_q then
      if c == "\\" then
        if i < n then
          table.insert(cur, input:sub(i+1,i+1))
          i = i + 2
        else
          i = i + 1
        end
      elseif c == in_q then
        in_q = nil
        i = i + 1
      else
        table.insert(cur, c); i = i + 1
      end
    else
      if c == "'" or c == '"' then
        in_q = c; i = i + 1
      elseif c:match("%s") then
        if #cur > 0 then
          table.insert(args, table.concat(cur)); cur = {}
        end
        i = i + 1
      elseif c == "\\" then
        if i < n then
          table.insert(cur, input:sub(i+1,i+1))
          i = i + 2
        else
          i = i + 1
        end
      else
        table.insert(cur, c); i = i + 1
      end
    end
  end
  if #cur > 0 then table.insert(args, table.concat(cur)) end
  return args
end

-- optional: expand ~ and $VAR
function M.expand_arg(s)
  if s:sub(1,1) == "~" then
    s = vim.fn.expand("~") .. s:sub(2)
  end
  s = s:gsub("%$([%w_]+)", function(name)
    return vim.fn.getenv(name) or "$"..name
  end)
  return s
end

function M.prompt_args()
  local line = vim.fn.input("Arguments: ")
  if not line or line == "" then return {} end
  local parsed = M.parse_args(line)
  for i, a in ipairs(parsed) do
    parsed[i] = M.expand_arg(a)
  end
  return parsed
end

return M
