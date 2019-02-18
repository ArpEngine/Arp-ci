package arpci;

import sys.io.Process;

class SysTool {

	public static function getEnvOrDefault(s:String, defaultValue:String):String {
		var value:String = Sys.getEnv(s);
		return if (value != null) value else defaultValue;
	}

	public static function setCwd(dir:String):Void {
		stderr('cd $dir');
		Sys.setCwd(dir);
	}

	public static function stderr(line:String):Void {
		Sys.stderr().writeString('$line\n');
		Sys.stderr().flush();
	}

	public static function exec(cmd:String):Void {
		stderr(cmd);
		Sys.command(cmd);
	}

	public static function execA(cmd:String):Void {
		stderr('echo a | $cmd');
		var proc = new Process(cmd);
		proc.stdin.writeString("a\n");
		proc.exitCode();
	}
}
