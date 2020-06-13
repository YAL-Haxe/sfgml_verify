package syntax;
import VerifyTools.*;

/**
 * If a class field is not set, it should be `null` like on other Haxe targets.
 * @test
 * @author YellowAfterlife
 */
class UnsetClassFields {
	public var a:Int;
	public var b:String;
	public function new(a:Int) {
		this.a = a;
	}
	static function main() {
		var q = new UnsetClassFields(4);
		assertEq(q.a, 4, "q.a == 4");
		assertEq(q.b, null, "q.b == null");
	}
}