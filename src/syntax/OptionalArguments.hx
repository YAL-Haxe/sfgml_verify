package syntax;
import VerifyTools.*;

/**
 * @test
 * @author YellowAfterlife
 */
class OptionalArguments {
	public static inline function main() {
		var simple = new TestSimple(1, "hi");
		assertEq(simple.a, 1, "TestSimple.a == 1");
		assertEq(simple.b, "hi", "TestSimple.b == 'hi'");
		simple.hi1(1);
		simple.hi1(1, "hi");
		//
		var child = new TestChild(3, "hello");
		assertEq(child.a, 3, "TestChild.a == 3");
		assertEq(child.b, "hello", "TestChild.b == 'hello'");
		//
		var child2 = new TestChild2(4, "hello");
		assertEq(child2.a, 4, "TestChild2.a == 4");
		assertEq(child2.b, "hello", "TestChild2.b == 'hello'");
		//
		var e:EnumTest;
		e = EnumTest.Req(1, "hi");
		assertDynArrayEq(e.getParameters(), [1, "hi"], "EnumTest.Req(1, 'hi')");
		e = EnumTest.Opt(1);
		assertDynArrayEq(e.getParameters(), [1, null], "EnumTest.Opt(1)");
		e = EnumTest.Opt(1, "hi");
		assertDynArrayEq(e.getParameters(), [1, "hi"], "EnumTest.Opt(1, 'hi')");
	}
}
class TestSimple {
	public var a:Int;
	public var b:String;
	public function new(a:Int, b:String) {
		this.a = a;
		this.b = b;
	}
	public function hi1(one:Int, hi:String = "hi") {
		assertEq(one, 1, "TestSimple.hi1.1");
		assertEq(hi, "hi", "TestSimple.hi1.hi");
	}
}
class TestParent {
	public var a:Int;
	public function new(a:Int) {
		this.a = a;
	}
}
class TestChild extends TestParent {
	public var b:String;
	public function new(a:Int, b:String = "hi") {
		super(a);
		this.b = b;
	}
}
class TestParent2 {
	public var a:Int;
	public var b:String;
	public function new(a:Int, b:String = "hi") {
		this.a = a;
		this.b = b;
	}
}
class TestChild2 extends TestParent2 {
	public function new(a:Int, b:String = "heyo") {
		super(a, b);
	}
}
enum EnumTest {
	Req(a:Int, b:String);
	Opt(a:Int, ?b:String);
}