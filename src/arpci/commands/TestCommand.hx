package arpci.commands;

import arpci.SysTool.*;

class TestCommand {

	private var env:Env;

	public function new(env:Env) {
		this.env = env;
	}

	public function execute():Void {
		// FIXME somehow run picotest
		var cmd:String = [
			"haxe",
			"-lib picotest",
			"-lib hamcrest",
			"-lib arp_support",
			"-lib arp_domain",
			"-lib arp_hittest",
			"-lib arp_engine",
			"-lib arp_thirdparty",
			"-cp tests",
			'--main ${env.testMain}',
			"-debug",
			"-D arp_debug",
			"-D arp_macro_real_position",
			"-D picotest_safemode",
			"-D picotest_show_stack",
			"-D picotest_show_trace",
			"-D picotest_show_ignore",
			'--macro "arpx.ArpEngineMacros.init()"',
			'--macro "include(\\"arp\\", true)"',
			'--macro "include(\\"arpx\\", true, [\\"arpx.impl\\"])"',
			'-D arp_backend_${env.backend}',
			"-swf test.swf",
			"-swf-version 11.6",
			"-swf-header 800:600:60",
			'--macro "picotest.PicoTest.warn()"'
		].join(" ");
		exec(cmd);
	}
}
