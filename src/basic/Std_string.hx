package basic;

/**
 * If we are using Std.string, we expect it to be in the output.
 * @test
 * @onlyScripts std_Std.stringify
 * @author YellowAfterlife
 */
class Std_string {
	public static inline function main() {
		Std.string(gml.Mathf.random(1));
	}
}