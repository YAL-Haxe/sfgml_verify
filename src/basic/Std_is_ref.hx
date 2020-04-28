package basic;
import VerifyTools.*;

/**
 * Testing more
 * @test
 * @author YellowAfterlife
 */
class Std_is_ref {
	public static inline function main() {
		var v:Dynamic, t:Dynamic;
		//
		v = gml.NativeType.toBool(true); // `true` compiles to `1`, misleadingly
		assert(Std.is(v, Bool), "Bool");
		t = Bool;
		assert(Std.is(v, t), "ref:Bool");
		//
		v = 4;
		assert(Std.is(v, Float), "Float");
		t = Float;
		assert(Std.is(v, t), "ref:Float");
		//
		v = 2;
		assert(Std.is(v, Int), "Int");
		t = Int;
		assert(Std.is(v, t), "ref:Int");
		//
		v = "hi";
		assert(Std.is(v, String), "String");
		t = String;
		assert(Std.is(v, t), "ref:String");
		//
		v = [];
		assert(Std.is(v, Array), "Array");
		t = Array;
		assert(Std.is(v, t), "ref:Array");
		
		//
		v = new Child();
		assert(Std.is(v, Child), "child is Child");
		assert(Std.is(v, Parent), "child is Parent");
		//
		v = new Parent();
		assert(!Std.is(v, Child), "parent is not Child");
		assert(Std.is(v, Parent), "parent is Parent");
		//
		v = E.A(1);
		assert(Std.is(v, E), "Enum inst.");
		t = E;
		assert(Std.is(v, t), "ref:Enum inst.");
		
		//
		v = Parent;
		assert(Std.is(v, Class), "Class");
		//
		v = E;
		assert(Std.is(v, Enum), "Enum");
	}
}
class Parent {
	public function new() {
		
	}
}
class Child extends Parent {
	
}
enum E {
	A(a:Int);
}