package arpci.commands;

import arpci.SysTool.*;

class TestCommand {

	private var env:Env;

	public function new(env:Env) {
		this.env = env;
	}

	public function execute():Void {
		switch (env.backend) {
			case "openfl":
				executeOpenFl();
			case _:
				executeHaxe();
		}
	}

	private function executeOpenFl():Void {
		throw "Don't know how to test openfl";
	}

	private function executeHaxe():Void {
		var cmd:Array<String> = [
			"haxe",
			"-lib picotest",
			"-lib hamcrest",
			"-lib arp_support",
			'-cp ${env.arpSupportLibPath}tests', // Some components rely on ArpSupport tests
			"-lib arp_domain",
			'-cp ${env.arpDomainLibPath}tests', // Some components rely on ArpDomain tests
			"-lib arp_hittest",
			"-cp tests",
			'--main ${env.testMain}',
			"-debug",
			"-D arp_debug",
			"-D arp_macro_real_position",
			"-D picotest_safemode",
			"-D picotest_show_stack",
			"-D picotest_show_trace",
			"-D picotest_show_ignore",
			'-D picotest_junit=bin/report/${env.fullName}.xml',
		];

		for (v in switch env.target {
			case "swf":
				['-swf bin/${env.fullName}.swf -swf-version 11.6 -swf-header 800:600:60', '--macro "picotest.PicoTest.warn()"'];
			case "js":
				['-js bin/${env.fullName}.js', '--macro "picotest.PicoTest.warn(\\"browser\\")"'];
			case "neko":
				['-neko bin/${env.fullName}.n', "-D picotest_thread", '--macro "picotest.PicoTest.warn()"'];
			case "cpp":
				['-cpp bin/${env.fullName}_cpp', "-D picotest_thread", '--macro "picotest.PicoTest.warn()"'];
			case _:
				throw 'unknown target ${env.target}';
		}) cmd.push(v);

		if (env.backend != null) {
			for (v in [
				"-lib arp_engine",
				"-lib arp_thirdparty",
				'--macro "arpx.ArpEngineMacros.init()"',
				'--macro "include(\\"arp\\", true)"',
				'--macro "include(\\"arpx\\", true, [\\"arpx.impl\\"])"'
			]) cmd.push(v);
			for (v in switch env.backend {
				case "flash", "sys", "stub":
					['-D arp_backend_${env.backend}'];
				case "heaps":
					['-D arp_backend_${env.backend}', "-lib heaps"];
				case "js":
					['-D arp_display_backend_stub', '-D arp_input_backend_js', '-D arp_audio_backend_js', '-D arp_socket_backend_stub', '-D arp_storage_backend_js'];
				case _:
					throw 'unknown backend ${env.backend}';
			}) cmd.push(v);
		}

		exec(cmd.join(" "));
	}
}
