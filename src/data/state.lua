local M = {}

local json = require("json")
local defaultLocation = system.DocumentsDirectory

function M.saveTable(t, filename, location)
  local loc = location
  if not location then
    loc = defaultLocation
  end

  -- Path for the file to write
  local path = system.pathForFile(filename, loc)

  -- Open the file handle
  local file, errorString = io.open(path, "w")

  if not file then
    -- Error occurred; output the cause
    print("File error: " .. errorString)
    return false
  else
    -- Write encoded JSON data to file
    file:write(json.encode(t))
    -- Close the file handle
    io.close(file)
    return true
  end
end

function M.loadTable(filename, location)
  local loc = location
  if not location then
    loc = defaultLocation
  end

  -- Path for the file to read
  local path = system.pathForFile(filename, loc)

  -- Open the file handle
  local file, errorString = io.open(path, "r")

  if not file then
    -- Error occurred; output the cause
    print("File error: " .. errorString)
  else
    -- Read data from file
    local contents = file:read("*a")
    -- Decode JSON data into Lua table
    local t = json.decode(contents)
    -- Close the file handle
    io.close(file)
    -- Return table
    return t
  end
end

function M.getData(path)
  -- not passed path
  if not path then
    local allD = M.loadTable("data")
    if not allD then allD = {} end
    return allD
  end

  local allData = M.loadTable("data")
  local table = {}

  -- table is not exist
  if not allData then
    local lD = M.generateLevelTable(0, 1)
    table[path] = lD
    allData = table
  end

  -- if data of this path is not exist
  if not allData[path] then
    return M.generateLevelTable(0, 1)
  end

  -- table exist
  return allData[path]
end

function M.generateLevelTable(finishLevel, currentLevel)
  local t = {
    finishLevel = finishLevel, currentLevel = currentLevel
  }
  return t
end

function M.updateLevel(path, i)
  local allData = M.getData()
  local t = {}
  local levelData

  -- if data exist
  if allData[path] then
    levelData = allData[path]
    if i < levelData.currentLevel then return end
    levelData.currentLevel = i + 1
    levelData.finishLevel = i
  else
    levelData = M.generateLevelTable(0, 1)
    t[path] = levelData
    allData = t
  end

  M.saveTable(allData, "data")
end

return M
