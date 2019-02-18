package arpci.setup;

import runci.targets.Flash as FlashTarget;

class SetupMac {

	public static function main() {
		// install homebrew
		Sys.command('/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"');

		// prepare everything else
		FlashTarget.setupFlashPlayerDebugger();

		// install common haxelibs
		Sys.command("haxelib install picotest hamcrest");
	}
}
