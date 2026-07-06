local fs = require("@std/fs")
local json = require("@std/json")
local path = require("@std/path")

local function sync(pesdePath: path.Pathlike, packagePath: path.Pathlike)
	local project = json.deserialize(fs.readFileToString(packagePath)) :: any
	assert(project ~= nil, "Failed to deserialize package.json")

	local version = project.version :: string?
	assert(version ~= nil, "Failed to get project version")

	local packageContents = fs.readFileToString(pesdePath)
	local newPackageContents = string.gsub(packageContents, 'version = "(.-)"', `version = "{version}"`, 1)

	fs.writeStringToFile(pesdePath, newPackageContents)
end

-- TODO: search for these files
sync("./pesde.toml", "./package.json")
