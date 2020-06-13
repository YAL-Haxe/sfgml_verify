package ;
import gml.NativeArray;
import gml.NativeType;
/**
 * ...
 * @author YellowAfterlife
 */
class VerifyTools {
	public static inline function error(m:String):Void {
		gml.Lib.error(m, true);
	}
	public static inline function assertEq<T>(val:T, want:T, label:String) {
		if (val != want) error("Assertion failed for " + label + "! Expected `"
			+ NativeType.toString(want) + "`, got `"
			+ NativeType.toString(val) + "` (" + NativeType.typeof(val) + ")");
	}
	public static inline function assert(val:Bool, label:String) {
		if (!val) error("Assertion failed for " + label + "!");
	}
	public static inline function assertArrayEq<T>(val:Array<T>, want:Array<T>, label:String) {
		if (!NativeArray.equals(val, want)) error("Assertion failed for " + label + "! Expected `"
			+ NativeType.toString(want) + "`, got `"
			+ NativeType.toString(val) + "` (" + NativeType.typeof(val) + ")");
	}
	public static inline function assertDynArrayEq(val:Array<Dynamic>, want:Array<Dynamic>, label:String) {
		return assertArrayEq(val, want, label);
	}
	public static inline function assertEnumEq<T:EnumValue>(val:T, want:T, label:String) {
		if (!Type.enumEq(val, want)) error("Assertion failed for " + label + "! Expected `"
			+ NativeType.toString(want) + "`, got `"
			+ NativeType.toString(val) + "` (" + NativeType.typeof(val) + ")");
	}
}