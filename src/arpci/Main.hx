package arpci;

import arpci.commands.*;
import arpci.SysTool.*;

class Main {

	private var env:Env;

	public static function main():Void {
		new Main().run();
	}

	public function new() return;

	public function run():Void {
		var args = Sys.args();
		var cwd = args.pop();

		if (cwd != null) SysTool.setCwd(cwd);

		this.env = new Env();

		switch (args.pop()) {
			case "sync":
				Sys.exit(new SyncCommand(env).execute());
			case "test":
				Sys.exit(new TestCommand(env).execute());
			case _:
				stderr("usage: arp_ci sync");
				stderr("       arp_ci test");
		}

	}
}
