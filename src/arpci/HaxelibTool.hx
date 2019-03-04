package arpci;

import sys.io.File;
import sys.FileSystem;
import arpci.SysTool.*;

class HaxelibTool {

	// private static var RSYNC_VERBOSE = 'v';
	private static var RSYNC_VERBOSE = '';

	public static function restoreRepo():Void {
		var HAXELIB_CACHE = getEnvOrDefault("HAXELIB_CACHE", "");
		if (HAXELIB_CACHE == "") return;

		exec('rsync -a$RSYNC_VERBOSE $HAXELIB_CACHE/ .haxelib');
	}

	public static function cacheRepo():Void {
		var HAXELIB_CACHE = getEnvOrDefault("HAXELIB_CACHE", "");
		if (HAXELIB_CACHE == "") return;

		pruneRepo();
		exec('mkdir -p $HAXELIB_CACHE');
		exec('rsync -a$RSYNC_VERBOSE --delete .haxelib/ $HAXELIB_CACHE');
	}

	private static function pruneRepo():Void {
		for (lib in FileSystem.readDirectory(".haxelib")) {
			var versions = FileSystem.readDirectory('.haxelib/$lib');
			if (versions.remove(".dev")) {
				versions.remove("git"); // may have git repo, so just keep it
			} else {
				var currentVersion = File.getContent('.haxelib/$lib/.current');
				versions.remove(".current");
				versions.remove(currentVersion.split(".").join(","));
			}
			for (oldVersion in versions) {
				exec('rm -rf .haxelib/$lib/$oldVersion');
			}
		}
	}
}
