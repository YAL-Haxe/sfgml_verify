package ;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author YellowAfterlife
 */
class GMAC {
	public static var isReady:Bool = false;
	public static var isAvailable:Bool = true;
	public static var userpath:String;
	public static var runtime:String;
	public static function init() {
		if (isReady) return isAvailable;
		isReady = true;
		var env = Sys.environment();
		
		// figure out directory name:
		var appdata = env["APPDATA"];
		var app:String = null;
		for (suffix in ["-Beta"]) {
			var consideration = "GameMakerStudio2" + suffix;
			if (FileSystem.exists('$appdata/$consideration')) {
				app = consideration;
				break;
			}
		}
		if (app == null) {
			Sys.println("Doesn't seem like you have a matching version of GameMaker Studio 2 installed.");
			Sys.println("That means that we can't compile-run GM side of tests.");
			isAvailable = false;
			return false;
		} else Sys.println('App name: $app');
		
		//
		var um = Json.parse(File.getContent('$appdata/$app/um.json'));
		var usermail:String = um.username;
		var username = usermail.substring(0, usermail.indexOf("@"));
		userpath = '$appdata/$app/${username}_${um.userID}';
		Sys.println('Userpath: $userpath');
		
		//
		var programdata = env["ProgramData"];
		var runtimeRoot = '$programdata/$app/Cache/runtimes';
		runtime = {
			var rts = FileSystem.readDirectory(runtimeRoot);
			var rti = rts.length;
			while (--rti >= 0) {
				if (FileSystem.isDirectory(runtimeRoot + "/" + rts[rti])) continue;
				rts.splice(rti, 1);
			}
			rts.sort((a, b) -> a > b ? -1 : 1);
			runtimeRoot + "/" + rts[0]; // ->
		};
		Sys.println('Runtime: $runtime');
		//
		return true;
	}
}