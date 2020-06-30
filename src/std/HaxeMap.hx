package std;
import VerifyTools.*;
import haxe.ds.Map;

/**
 * @test
 * @author YellowAfterlife
 */
@:keep class HaxeMap {
	public static inline function main() {
		//
		var m = new Map();
		m[3] = "hi!";
		assertEq(m[3], "hi!", 'm[3] == "hi!"');
		m[4] = null;
		m.remove(4);
		assertArrayEq([for (k in m.keys()) k], [3], 'm.keys() == [3]');
		//
		var sm = new Map();
		sm["hi"] = "hello!";
		assertEq(sm["hi"], "hello!", 'sm["hi"] == "hello!"');
		sm["bok"] = null;
		sm.remove("bok");
		assertArrayEq([for (k in sm.keys()) k], ["hi"], 'sm.keys() == ["hi"]');
	}
}