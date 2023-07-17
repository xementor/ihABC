local M = {}

function M.printTable(table)
  for el, vl in pairs(table) do
    print(el, vl)
  end
end

return M
