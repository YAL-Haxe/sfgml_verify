package basic;
import VerifyTools.*;
import gml.NativeType;

/**
 * Testing common shortcuts for Std.is.
 * The only function in output is expected to be StdTypeImpl.isIntNumber,
 * which we will not eliminate as it has to reference the input multiple times.
 * 
 * @test
 * @onlyScripts std_gml_internal_StdTypeImpl_isIntNumber
 * @forbiddenCode ["var mt_"]
 * @author YellowAfterlife
 */
class Std_is {
	public static inline function main() {
		var v:Dynamic;
		//
		v = NativeType.toBool(true); // `true` compiles to `1`, misleadingly
		assert(Std.is(v, Bool), "Bool");
		//
		v = 4;
		assert(Std.is(v, Float), "Float");
		//
		v = 2;
		assert(Std.is(v, Int), "Int");
		//
		v = "hi";
		assert(Std.is(v, String), "String");
		//
		v = [];
		assert(Std.is(v, Array), "Array");
	}
}
