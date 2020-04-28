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
	@forbiddenCode enum F {
	@author YellowAfterlife
**/
class FakeEnum {
	public static inline function main() {
		var f:F = F.A;
		f = F.C;
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
		assertEq(Type.createEnum(F, "C"), C, "Type.createEnum");
		assertEq(Type.createEnumIndex(F, 2), C, "Type.createEnumIndex");
		assertArrayEq(Type.getEnumConstructs(F), ["A", "B", "C", "D"], "Type.getEnumConstructs");
	}
}
enum F {
	A;
	B;
	C;
	D;
}