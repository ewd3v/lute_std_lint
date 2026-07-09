# lute_std_lint
A [Lute lint](https://lute.luau.org/cli/lint/) rule to check for disallowed [standard library](https://lute.luau.org/std/) references

## Why?

When using [Luau](https://luau.org/) packages it's nice to know what standard libraries the package depends on to tell if it will run under a specific Luau runtime without testing first. While package maintainers can [document this](#required-libraries), they might also want to enforce this list so they can guarantee it's accurate. This lint helps you achieve that.

## Installation

### [pesde](https://pesde.dev/) (recommended)

```bash
pesde add ewdev/lute_std_lint --dev --target luau
```

### Manual

Just copy over the [/src/init.luau](https://github.com/ewd3v/lute_std_lint/blob/main/src/init.luau) file and store it somewhere.

## Usage

Create a `.config.luau` file with the following contents:

```luau
return {
    lute = {
        lint = {
            rulepaths = { "luau_packages/lute_std_lint.luau" }, -- assuming you're using pesde
        },
    },
}
```

Then run:

```bash
lute lint src
```

Lute will now warn you if you're using any std library that isn't explicitly allowed... But wait, how do you do that?

It's simple! Just add an "allow" option to the lint where you specify what std's want you want use:

```luau
return {
    lute = {
        lint = {
            rulepaths = { "luau_packages/lute_std_lint.luau" },
            ruleconfigs = {
                ["std"] = {
                    options = {
                        allow = {
                            "path", -- allows @std/path, but not @std/path/win32
                            "syntax/types", -- allows @std/syntax/types, but not @std/syntax itself
                            "test.*", -- allows @std/test, @std/test/assert, and anything else under @std/test
                        },
                    },
                },
            },
        },
    },
}
```

More examples on how to configure Lute lints: https://lute.luau.org/cli/lint/#c-config-config

## Options

- **allow**: A list of [Lua patterns](https://www.lua.org/manual/5.3/manual.html#6.4.1) for allowed std libraries. If any match fully the std library is considered allowed. These patterns do not need to match the std alias (i.e `@std`), and is instead configured with the option below. (default: `{}`)
- **std_prefix**: The alias the std libraries are required under. (default: `"@std"`)

## Required libraries

- [@std](https://lute.luau.org/std/)
    - [path](https://lute.luau.org/std/path/)
    - [stringext](https://lute.luau.org/std/stringext.html)
    - [syntax](https://lute.luau.org/std/syntax/)
        - [query](https://lute.luau.org/std/syntax/query.html)
        - [utils](https://lute.luau.org/std/syntax/utils/)
