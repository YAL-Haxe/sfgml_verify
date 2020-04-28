package enums;
import VerifyTools.*;
/**
	
	@test
	@requiredCode ["\nenum "]
	@author YellowAfterlife
**/
class ParEnumNG {
	public static inline function main() {
		var e:E = E.A;
		e = E.C("a", "b");
		switch (e) {
			case C(a, b): {
				assertEq(a, "a", "match/a");
				assertEq(b, "b", "match/b");
			}
			case B(_): assert(false, "match");
			default: assert(false, "match");
		};
		assertEq(e.getIndex(), 2, ".getIndex");
		assertEq(e.getName(), "C", ".getName");
		assertEq(Type.enumIndex(e), 2, "Type.getIndex");
		assertEq(Type.enumConstructor(e), "C", "Type.enumConstructor");
		assertArrayEq(Type.enumParameters(e), ["a", "b"], "Type.enumParameters");
		assertEnumEq(Type.createEnum(E, "C", ["a", "b"]), C("a", "b"), "Type.createEnum");
		assertEnumEq(Type.createEnumIndex(E, 2, ["a", "b"]), C("a", "b"), "Type.createEnumIndex");
		assertArrayEq(Type.getEnumConstructs(E), ["A", "B", "C", "D"], "Type.getEnumConstructs");
	}
}
@:nativeGen enum E {
	A;
	B(i:Int);
	C(a:String, b:String);
	D;
}