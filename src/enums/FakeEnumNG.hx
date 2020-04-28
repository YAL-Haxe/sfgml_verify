package enums;
import VerifyTools.*;
/**
	Fake (parameter-less) enums should be compiled straight to their indexes.
	We will also replace most Type.* helpers with direct access if possible.
	@test
	@onlyScripts [
		"std_Type_enumParameters",
		"std_gml_internal_ArrayImpl_indexOf",
		"std_gml_internal_ArrayImpl_copy"
	]
	@requiredCode [
		"enum F {",
		"FN.A"
	]
	@forbiddenCode globalvar mt_
	@author YellowAfterlife
**/
class FakeEnumNG {
	public static inline function main() {
		var f:FN = FN.A;
		f = FN.C;
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
		assertEq(Type.createEnum(FN, "C"), C, "Type.createEnum");
		assertEq(Type.createEnumIndex(FN, 2), C, "Type.createEnumIndex");
		assertArrayEq(Type.getEnumConstructs(FN), ["A", "B", "C", "D"], "Type.getEnumConstructs");
	}
}
@:nativeGen enum FN {
	A;
	B;
	C;
	D;
}