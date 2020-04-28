package enums;
import VerifyTools.*;
/**
	
	@test
	@forbiddenCode ["\nenum "]
	@author YellowAfterlife
**/
class ParEnum {
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
	}
}
enum E {
	A;
	B(i:Int);
	C(a:String, b:String);
	D;
}