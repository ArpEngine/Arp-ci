package arpci;

import sys.io.Process;

import arpci.SysTool.*;

class Env {

	public var project(default, null):String;
	public var prBranch(default, null):String = "master";
	public var target(default, null):String = "swf";
	public var testMain(default, null):String = "arp.ArpSupportAllTests";
	public var backend(default, null):String = null;

	public var fullName(default, null):String;

	public function new() {
		this.guessProject("ArpSupport");
		this.prBranch = getEnvOrDefault("ARPCI_PR_BRANCH", "master");
		this.target = getEnvOrDefault("ARPCI_TARGET", "swf");
		this.testMain = getEnvOrDefault("ARPCI_MAIN", "arp.ArpSupportAllTests");
		this.backend = getEnvOrDefault("ARPCI_BACKEND", null);

		calculateDerivedProperties();
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

	private function calculateDerivedProperties():Void {
		this.fullName ='arp_${this.target}';
		if (this.backend != null) this.fullName += '_${this.backend}';
	}
}
