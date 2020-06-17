package ;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
using StringTools;
using ERegTools;

/**
 * ...
 * @author YellowAfterlife
 */
class Test {
	public var path:String;
	public var gmlPath:String;
	public var cp:String;
	public var args:Array<String>;
	public var allowedScripts:Array<String> = null;
	public var requiredScripts:Array<String> = null;
	public var requiredCode:Array<String> = null;
	public var forbiddenCode:Array<String> = null;
	public function new(path:String) {
		this.path = path;
		cp = path.replace("/", ".");
		gmlPath = 'bin/$path.gml';
		args = [
			'-debug',
			'-dce', 'full',
			'-lib', 'sfhx',
			'-lib', 'sfgml',
			'-cp', 'src',
			'-D', 'sfgml_next',
			'-D', 'sfgml_version=2.3',
			'-D', 'sf-std-package=std',
			'-D', 'sfgml_local=l_',
			'-main', cp,
			'-js', gmlPath,
		];
	}
	static var rxFunc = ~/\nfunction (\w+)/g;
	public function run():Bool {
		var canGMAC = GMAC.init();
		
		//
		Sys.print('Compiling $path from Haxe to GML...');
		var hp = new Process("haxe", args);
		if (hp.exitCode() != 0) {
			Sys.println(" error!");
			var s = hp.stdout.readAll().toString().rtrim();
			if (s != "") Sys.println(s);
			s = hp.stderr.readAll().toString().rtrim();
			if (s != "") Sys.println(s);
			hp.close();
			return false;
		} else {
			Sys.println(" OK!");
			hp.close();
		}
		
		//
		if (allowedScripts != null || requiredScripts != null
			|| requiredCode != null || forbiddenCode != null
		) try {
			var gml = File.getContent(gmlPath);
			if (requiredCode != null) for (snip in requiredCode) {
				if (!gml.contains(snip)) throw 'Missing snippet `$snip`';
			}
			if (forbiddenCode != null) for (snip in forbiddenCode) {
				if (gml.contains(snip)) throw 'Forbidden snippet `$snip`';
			}
			if (allowedScripts != null) rxFunc.each(gml, function(rx:EReg) {
				var fn = rx.matched(1);
				if (allowedScripts.indexOf(fn) < 0) throw 'Unexpected script $fn';
			});
			if (requiredScripts != null) {
				for (fn in requiredScripts) {
					if (gml.indexOf('\nfunction $fn(') < 0) throw 'Missing script $fn';
				}
			}
		} catch (x:Dynamic) {
			Sys.println("Verify failure: " + x);
			return false;
		}
		
		//
		if (!canGMAC) {
			Sys.println("Skipping GM compile...");
			return true;
		}
		var userpath = GMAC.userpath;
		var dir = Sys.getCwd();
		if (dir.endsWith("/") || dir.endsWith("\\")) dir = dir.substr(0, dir.length - 1);
		var rt = GMAC.runtime;
		var basep = '$rt\\BaseProject\\BaseProject.yyp';
		var gmac = '$rt\\bin\\GMAssetCompiler.exe';
		File.copy(gmlPath, '$dir/verify/scripts/verify/verify.gml');
		Sys.print('Compiling $path to executable...');
		var gmacp = [
			'/c',
			'/mv=1',
			'/zpex',
			'/iv=0',
			'/rv=0',
			'/bv=0',
			'/j=8',
			'/gn=verify',
			'/td=$dir\\bin\\temp',
			'/cd=$dir\\bin\\cwd',
			'/zpuf=$userpath',
			'/m=windows', '/tgt=64', '/nodnd',
			'/cfg=Default',
			'/o=$dir\\bin\\out',
			'/sh=True',
			'/cvm',
			'/baseproject=$basep',
			'$dir\\verify\\verify.yyp',
			'/v', '/bt=run', '/rt=vm',
		];
		var p = new Process(gmac, gmacp);
		if (p.exitCode() != 0) {
			Sys.println(" error!");
			var out = p.stdout.readAll().toString();
			var found = false;
			~/\nError[ \t]*:[ \t]*(.+)/g.each(out, function(rx:EReg) {
				Sys.println("Compile error: " + rx.matched(1));
				found = true;
			});
			if (!found) {
				Sys.println("Couldn't figure out what the error is. Here's the entire log:");
				Sys.println(out);
			}
			p.close();
			return false;
		} else {
			Sys.println(" OK!");
			p.close();
		}
		
		//
		Sys.print('Running $path...');
		var runOut = '$dir\\bin\\out\\out.txt';
		if (FileSystem.exists(runOut)) FileSystem.deleteFile(runOut);
		var ec = Sys.command('$rt\\windows\\Runner.exe', [
			'-game', '$dir\\bin\\out\\verify.win',
			'-headless',
			'-output', runOut,
			'-debugoutput', runOut,
		]);
		if (ec != 0) {
			Sys.println(" error!");
			var out = File.getContent(runOut);
			~/(#{92}[\s\S]+?#{92})/g.each(out, function(rx:EReg) {
				Sys.println(rx.matched(1));
			});
			return false;
		} else Sys.println(" OK!");
		//
		return true;
	}
}