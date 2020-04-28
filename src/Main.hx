package;

import haxe.Json;
import haxe.io.Path;
import neko.Lib;
import sys.FileSystem;
import sys.io.File;
using StringTools;

/**
 * ...
 * @author YellowAfterlife
 */
class Main {
	static var testsOK = 0;
	static var testsFailed = 0;
	static var rxArgs = ~/^[ \t]*(?:\*[ \t]*)?@test[ \t]*([^\r\n]*)/m;
	static var getDocArrayMap:Map<String, EReg> = new Map();
	static function getDocArray(tag:String, gml:String, ctx:String, joinLine:Bool = false) {
		var rx = getDocArrayMap[tag];
		if (rx == null) {
			rx = new EReg("\n[ \t]*"
				+ "(?:\\*[ \t]*)?"
				+ "@" + tag
				+ "[ \t]*("
					+ '\\[\\s*"[\\s\\S]*?"\\s*\\]'
				+ "|[^\r\n]*"
			+ ")", "g");
			getDocArrayMap[tag] = rx;
		}
		if (!rx.match(gml)) return null;
		var val = rx.matched(1).trim();
		var args:Array<String>;
		if (val.charAt(0) == "[") {
			try {
				return Json.parse(val);
			} catch (x:Dynamic) {
				Sys.println('Error parsing $ctx @$tag: $x');
				return null;
			}
		} else {
			if (joinLine) {
				return [val];
			} else {
				return val != "" ? val.split(" ") : [];
			}
		}
	}
	static function rec(dir:String) {
		for (rel in FileSystem.readDirectory(dir)) {
			var full = dir + '/' + rel;
			if (FileSystem.isDirectory(full)) {
				rec(full);
			} else if (Path.extension(rel).toLowerCase() == "hx") {
				var src = File.getContent(full);
				var args = getDocArray("test", src, full);
				if (args == null) continue;
				if (!rxArgs.match(src)) continue;
				var cp = Path.withoutExtension(full.substring("src/".length));
				var test = new Test(cp);
				test.args = test.args.concat(args);
				//
				var only = getDocArray("onlyScripts", src, full);
				if (only != null) {
					test.allowedScripts = only;
					test.requiredScripts = only;
				} else {
					test.allowedScripts = getDocArray("allowedScripts", src, full);
					test.requiredScripts = getDocArray("requiredScripts", src, full);
				}
				//
				test.requiredCode = getDocArray("requiredCode", src, full, true);
				test.forbiddenCode = getDocArray("forbiddenCode", src, full, true);
				//
				if (test.run()) {
					testsOK++;
				} else testsFailed++;
			}
		} // for file, can continue
	}
	static function main() {
		rec("src");
		var tot = testsFailed + testsOK;
		Sys.println('$tot tests total, $testsOK succeeded, $testsFailed failed.');
		Sys.println('Bye!');
		Sys.exit(testsFailed == 0 ? 0 : 1);
	}
	
}