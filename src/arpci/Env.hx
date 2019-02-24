package arpci;

import sys.io.Process;

import arpci.SysTool.*;

class Env {

	public var project(default, null):String = "ArpSupport";
	public var prBranch(default, null):String = "master";
	public var target(default, null):String = "swf";
	public var testMain(default, null):String = "arp.ArpSupportAllTests";
	public var backend(default, null):String = null;

	public var arpSupportLibPath(get, never):String;
	private function get_arpSupportLibPath():String return StringTools.trim(new Process('haxelib libpath arp_support').stdout.readAll().toString());
	public var arpDomainLibPath(get, never):String;
	private function get_arpDomainLibPath():String return StringTools.trim(new Process('haxelib libpath arp_domain').stdout.readAll().toString());

	public var fullName(default, null):String;

	public function new() {
		this.project = getEnvOrDefault("ARPCI_PROJECT", this.guessProject("ArpSupport"));
		this.prBranch = getEnvOrDefault("ARPCI_PR_BRANCH", "master");
		this.target = getEnvOrDefault("ARPCI_TARGET", "swf");
		this.testMain = getEnvOrDefault("ARPCI_MAIN", this.guessTestMain());
		this.backend = getEnvOrDefault("ARPCI_BACKEND", null);

		calculateDerivedProperties();
	}

	private function guessProject(defaultValue:String):String {
		var remotes:String = new Process('git remote -v').stdout.readAll().toString();
		var ereg = new EReg('^.*\\s+(https://.*@?github\\.com/ArpEngine/.*\\.git)\\s+\\(fetch\\)', 'g');
		var project:String;
		if (ereg.match(remotes)) {
			var gitRepo = ereg.matched(1);
			project = gitRepo.split("/").pop().split(".")[0];
			stderr('gitRepo: $gitRepo');
			stderr('project: $project');
		} else {
			project = defaultValue;
		}
		return project;
	}

	private function guessTestMain():String {
		return switch (this.project) {
			case "ArpSupport": "arp.ArpSupportAllTests";
			case "ArpDomain": "arp.ArpDomainAllTests";
			case "ArpEngine": "arpx.ArpEngineAllTests";
			case "ArpHitTest": "arp.hit.ArpHitTestAllTests";
			case "ArpThirdparty": "arpx.ArpThirdpartyAllTests";
			case _: throw 'Invalid project ${this.project}';
		}
	}

	private function calculateDerivedProperties():Void {
		this.fullName ='arp_${this.target}';
		if (this.backend != null) this.fullName += '_${this.backend}';
	}
}
