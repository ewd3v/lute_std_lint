local lintTypes = require("@lint/types")
local path = require("@std/path")
local query = require("@std/syntax/query")
local stringext = require("@std/stringext")
local syntax = require("@std/syntax")
local utils = require("@std/syntax/utils")

local name = "std"
local target = "https://github.com/ewd3v/lute_std_lint"

local STD_PREFIX = "@std"

local function isStdAllowed(allowedPatterns: { string }, std: string): boolean
	for _, pattern in allowedPatterns do
		-- Check if pattern matches the *whole* string
		if string.match(std, pattern) == std then
			return true
		end
	end

	return false
end

local function lint(
	ast: syntax.AstStatBlock,
	sourcepath: path.Path?,
	context: lintTypes.RuleContext
): { lintTypes.LintViolation }
	local allowedStds: { string } = {}
	if context.options ~= nil and type(context.options.allow) == "table" then
		for _, std in context.options.allow do
			if type(std) ~= "string" then
				continue
			end

			table.insert(allowedStds, std)
		end
	end

	local stdPrefix = STD_PREFIX
	if context.options ~= nil and type(context.options.std_prefix) == "string" then
		stdPrefix = context.options.std_prefix
	end

	local fullStdPrefix = stdPrefix .. "/"

	return query
		.findAllFromRoot(ast, utils.isRequireCall)
		:mapToArray(function(node: syntax.AstExprCall): lintTypes.LintViolation?
			local targetNode = node.arguments[1].node
			local stringNode = utils.isExprConstantString(targetNode)
			if stringNode == nil then
				return nil
			end

			local requireTarget = stringNode.token.text
			if not stringext.hasPrefix(requireTarget, fullStdPrefix) then
				return nil
			end

			local std = stringext.removePrefix(requireTarget, fullStdPrefix)
			if isStdAllowed(allowedStds, std) then
				return nil
			end

			return {
				lintname = name,
				location = stringNode.location,
				message = `"{requireTarget}" is not an allowed std library`,
				severity = "error",
				sourcepath = sourcepath,
				target = target,
			}
		end)
end

local rule: lintTypes.LintRule = {
	name = name,
	lint = lint,
}

return table.freeze(rule)
