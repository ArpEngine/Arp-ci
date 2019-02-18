package arpci.commands;

import sys.io.Process;
import arpci.SysTool.*;

class SyncCommand {

	private var env:Env;

	public function new(env:Env) {
		this.env = env;
	}

	public function execute():Void {
		exec('haxelib newrepo');

		// because we will manually install them...
		// execA("haxelib update");

		haxelibInstall("picotest", "kaikoga/PicoTest", "develop", "src");
		// latest official release of hamcrest is broken
		// execA("haxelib install hamcrest");
		haxelibInstall("hamcrest", "kaikoga/hamcrest-haxe", "patch-haxe4-p5", "src");

		haxelibInstall("arp_support", "ArpEngine/ArpSupport");
		haxelibInstall("arp_domain", "ArpEngine/ArpDomain");
		haxelibInstall("arp_hittest", "ArpEngine/ArpHitTest");
		haxelibInstall("arp_engine", "ArpEngine/ArpEngine");
		haxelibInstall("arp_thirdparty", "ArpEngine/ArpThirdparty");

		// and we have to install myself, because we made a newrepo
		haxelibInstall("arp_ci", "ArpEngine/Arp-ci", "master");
	}

	private function haxelibInstall(haxelib:String, path:String, branch:String = null, srcPath:String = null):Void {
		if (env.project == path.split("/").pop()) {
			execA('haxelib dev $haxelib .');
		} else {
			var gitRepo:String = 'https://github.com/$path.git';
			if (branch == null) {
				var lsRemote:String = new Process('git ls-remote $gitRepo').stdout.readAll().toString();
				if (new EReg('^.*\\s+refs/heads/${env.prBranch}$', 'g').match(lsRemote)) {
					branch = env.prBranch;
				} else {
					branch = "master";
				}
			}
			if (srcPath == null) srcPath = "";
			execA('haxelib git $haxelib $gitRepo $branch $srcPath');
		}
	}
}
