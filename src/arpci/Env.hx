package arpci;

import sys.io.Process;

import arpci.SysTool.*;

class Env {

	public var project(default, null):String;
	public var prBranch(default, null):String = "master";
	public var target(default, null):String = "flash";
	public var testMain(default, null):String = "arp.ArpSupportAllTests";
	public var backend(default, null):String = "flash";

	public function new() {
		this.guessProject("ArpSupport");
		this.prBranch = getEnvOrDefault("ARPCI_PR_BRANCH", "master");
		this.target = getEnvOrDefault("ARPCI_TARGET", "flash");
		this.testMain = getEnvOrDefault("ARPCI_MAIN", "arp.ArpSupportAllTests");
		this.backend = getEnvOrDefault("ARPCI_BACKEND", "flash");
	}

	private function guessProject(defaultValue:String):Void {
		var remotes:String = new Process('git remote -v').stdout.readAll().toString();
		var ereg = new EReg('^.*\\s+(https://github\\.com/ArpEngine/.*\\.git)\\s+\\(fetch\\)', 'g');
		if (ereg.match(remotes)) {
			var gitRepo = ereg.matched(1);
			this.project = gitRepo.split("/").pop().split(".")[0];
			stderr('gitRepo: $gitRepo');
			stderr('project: $project');
		} else {
			this.project = defaultValue;
		}
	}
}
