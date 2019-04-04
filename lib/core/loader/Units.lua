local table_insert = table.insert
local utils = require("egglua.lib.utils.utils")
local fileUtils = require("egglua.lib.utils.FileUtils")

local function findFramework(units, name, path)
    if fileUtils.isExist(path .. "/config/framework.lua") then
        findFramework(plugins, fileUtils.findPath(dofile(path .. "/config/framework.lua"), "/config/config.lua"))
    end
    table_insert(units, {
        name = name,
        path = path
    })
end
return function(app)
    local coreRootPath = app.coreRootPath
    local appRootPath = app.appRootPath
    local plugins = app.plugins

    local units = {}
    utils.mergeArray(units, plugins)

    table_insert(units, {
        name = "egglua",
        path = coreRootPath
    })

    local framework = nil
    if fileUtils.isExist(appRootPath .. "/config/framework.lua") then
        framework = dofile(appRootPath .. "/config/framework.lua")
    end
    local frameworkRootPath = fileUtils.findPath(framework, "/config/config.lua")
    if not frameworkRootPath then
        error(framework .. " framework not found")
    end
    findFramework(units, framework, frameworkRootPath)

    table_insert(units, {
        name = app.appname,
        path = appRootPath
    })

    app.units = units
end