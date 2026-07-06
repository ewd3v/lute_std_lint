local failure = require("@std/test/failure")
local path = require("@std/path")
local process = require("@std/process")
local test = require("@std/test")

local lintPath = path.parse("src/init.luau")
local testsPath = path.parse("tests")

local function lint(folderName: string)
	local folderPath = path.join(testsPath, folderName)
	local configPath = path.join(folderPath, ".config.luau")
	local result = process.run({
		"lute",
		"lint",
		"--no-default-lints",
		"--rules",
		path.format(lintPath),
		"--config",
		path.format(configPath),
		path.format(folderPath),
	})

	return result
end

local function assertLint(folderName: string, expectedResult: boolean)
	local result = lint(folderName)
	if result.ok == expectedResult then
		return
	end

	local msg = if expectedResult == true
		then `Expected test {folderName} to succeed, but it failed`
		else `Expected test {folderName} to fail, but it succeeded`

	error(failure.assertion(`{msg}:\n{result.stdout}\n{result.stderr}`, 3))
end

local function wrapLint(folderName: string, expectedResult: boolean)
	test.case(folderName, function()
		assertLint(folderName, expectedResult)
	end)
end

wrapLint("no_config", false)
wrapLint("allow_fs", true)
wrapLint("allow_system_not_platform", false)
wrapLint("allow_syntax_all", true)
