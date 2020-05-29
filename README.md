# sfgml_verify
This is a small set of tests for checking that various aspects of sfgml work correctly.

Generally the tests are two-part:

1. Verifying that the code _looks_ right (e.g. has no unnecessary functions)
2. Verifying that the code _runs_ right (compiles and passes assertion tests for related APIs)

For the second part you will need a copy of GameMaker Studio >= 2.3 installed
(is [in beta](https://www.yoyogames.com/blog/565/gamemaker-studio-2-version-2-3-beta-release) as of writing this text),
either on Windows or via WINE. If you do not, the code will only be checked for the first part.

## Format
Each test is represented by one or more Haxe files.

The entrypoint file should have `@test` among its header comments,
optionally followed by additional parameters to pass to the compiler.

You may supply arguments as plain string or (possibly multi-line) JSON array:
```haxe
/**
 * @test
 * Runs with no additional parameters
*/
/**
 * @test -D some
 * Runs with ["-D", "some"]
*/
/**
@test [
  "-D",
  "Some"
]
Also runs with ["-D", "some"]
**/
```
Other allowed `@meta` tags are:

- `@requiredCode`: Snippets of code that must appear in the output. Intended for testing that construct of interest prints as such.
- `@forbiddenCode`: Snippets of code that must **not** appear in the output. Intended for testing that something is correctly culled/optimized away.
- `@allowedScripts`: Defines a list of (final) script names allowed to be in the output. Some of these can be missing, but there may be no other scripts.
- `@requiredScripts`: Defines a list of (final) script names allowed to be in the output. There can be more scripts, but these must appear among them.
- `@onlyScripts`: Combines two of above into a strict filter.

## Technical

The tool works as following:
```
For each .hx file in src/ directory (recursive) with a @test tag,
  Run the Haxe compiler (with sfgml), producing a matching `bin/path.gml`;
  If successful,
    Copy the .gml file into the `verify` GameMaker project, replacing the `verify` script;
    Run the GameMaker compiler to generate a debug binary in `bin/out/`;
    If successful, run the debug binary for assertion tests;
        If successful, consider the test passed.
```
