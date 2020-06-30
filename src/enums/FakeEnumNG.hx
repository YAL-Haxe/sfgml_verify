package enums;

#if !macro
import VerifyTools.*;
#end

import haxe.macro.Expr;
class Macro {
	public static macro function test(e:Expr) {
		return macro {
			var f = $e.A;
			f = $e.C;
			switch (f) {
				case C: {};
				case B: assert(false, "match");
				default: assert(false, "match");
			};
			assertEq(f.getIndex(), 2, ".getIndex");
			assertEq(f.getName(), "C", ".getName");
			assertEq(Type.enumIndex(f), 2, "Type.getIndex");
			assertEq(Type.enumConstructor(f), "C", "Type.enumConstructor");
			assertArrayEq(Type.enumParameters(f), [], "Type.enumParameters");
			assertEq(Type.createEnum($e, "C"), C, "Type.createEnum");
			assertEq(Type.createEnumIndex($e, 2), C, "Type.createEnumIndex");
			assertArrayEq(Type.getEnumConstructs($e), ["A", "B", "C", "D"], "Type.getEnumConstructs");
		};
	}
}
/**
	Fake (parameter-less) enums should be compiled straight to their indexes.
	We will also replace most Type.* helpers with direct access if possible.
	@test
	@onlyScripts [
		"std_Type.enumParameters",
		"std_gml_internal_ArrayImpl.indexOf",
		"std_gml_internal_ArrayImpl.copy"
	]
	@requiredCode [
		"enum enums_FN {",
		"enums_FN.A",
		"enums_DE_A"
	]
	@forbiddenCode globalvar mt_
	@author YellowAfterlife
**/
class FakeEnumNG {
	public static inline function main() {
		Macro.test(FN);
		Macro.test(DE);
	}
}
@:nativeGen enum FN {
	A;
	B;
	C;
	D;
}
@:doc enum DE {
	A;
	B;
	C;
	D;
}