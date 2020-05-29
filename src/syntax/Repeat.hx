package syntax;
import VerifyTools.*;

/**
	If a for-loop doesn't use the int iterator, we may replace it with a repeat-loop instead.
	This test verifies that this is being done as expected.
	@test
	@requiredCode repeat (n) a++;
	@forbiddenCode while
	@author YellowAfterlife
**/
class Repeat {
	static function test1(n:Int) {
		var a = 0;
		for (_ in 0 ... n) {
			a += 1;
		}
		assertEq(a, n, 'a == $n');
	}
	static function test2(n:Int) {
		var a = 0, b = 0;
		for (_ in 0 ... n) {
			a += 1;
			b += 1;
		}
		assertEq(a, n, 'a == $n');
		assertEq(b, n, 'b == $n');
	}
	public static inline function main() {
		test1(4);
		test2(4);
	}
}