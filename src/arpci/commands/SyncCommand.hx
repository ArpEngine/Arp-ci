package arpci.commands;

import sys.io.Process;
import arpci.HaxelibTool.*;
import arpci.SysTool.*;

class SyncCommand {

	private var env:Env;

	public function new(env:Env) {
		this.env = env;
	}

	public function execute():Int {
		restoreRepo();
		install();
		cacheRepo();
		return 0;
	}

	public function install():Void {
		// because we will manually install them...
		// exec("haxelib update --always");

		haxelibInstall("picotest", "kaikoga/PicoTest", "develop", "src");
		// latest official release of hamcrest is broken
		// exec("haxelib install hamcrest --always");
		haxelibInstall("hamcrest", "kaikoga/hamcrest-haxe", "patch-haxe4-p5", "src");

		haxelibInstall("arp_support", "ArpEngine/ArpSupport");
		haxelibInstall("arp_domain", "ArpEngine/ArpDomain");
		haxelibInstall("arp_hittest", "ArpEngine/ArpHitTest");
		haxelibInstall("arp_engine", "ArpEngine/ArpEngine");
		haxelibInstall("arp_thirdparty", "ArpEngine/ArpThirdparty");

		haxelibInstall("hxcpp"); // for cpp target

		haxelibInstall("heaps"); // for heaps backend
	}

	private function haxelibInstall(haxelib:String, path:String = null, branch:String = null, srcPath:String = null) {
		if (path == null) {
			haxelibInstallInternal(haxelib, HaxelibPath.Haxelib);
		} else {
			var p = path.split("/");
			haxelibInstallInternal(haxelib, HaxelibPath.GitHub(p[0], p[1], branch, srcPath));
		}
	}

	private function haxelibInstallInternal(haxelib:String, path:HaxelibPath):Void {
		switch path {
			case HaxelibPath.Haxelib:
				exec('haxelib install $haxelib --always');
			case HaxelibPath.GitHub(user, repo, branch, srcPath):
				if (env.project == repo) {
					exec('haxelib dev $haxelib . --always');
					return;
				}
				var gitRepo:String = 'https://github.com/$user/$repo.git';
				var gitBranch:String = if (branch != null) branch else {
					var lsRemote:String = new Process('git ls-remote $gitRepo').stdout.readAll().toString();
					if (new EReg('^.*\\s+refs/heads/${env.prBranch}$', 'g').match(lsRemote)) {
						env.prBranch;
					} else {
						"master";
					}
				}
				var gitSrc = if (srcPath != null) srcPath else "";
				exec('haxelib git $haxelib $gitRepo $gitBranch $gitSrc --always');
		}
	}
}

enum HaxelibPath {
	Haxelib;
	GitHub(user:String, repo:String, branch:String, srcPath:String);
}
