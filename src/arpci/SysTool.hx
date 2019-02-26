package arpci;

import haxe.macro.Expr.ExprOf;

class SysTool {

	public macro static function getEnvOrDefault(s:ExprOf<String>, defaultValue:ExprOf<String>):ExprOf<String> {
		return macro @mergeBlock {
			var value:String = Sys.getEnv($e{s});
			if (value != null) value else (() -> $e{defaultValue})();
		}
	}

	public static function setCwd(dir:String):Void {
		stderr('cd $dir');
		Sys.setCwd(dir);
	}

	public static function stderr(line:String):Void {
		Sys.stderr().writeString('$line\n');
		Sys.stderr().flush();
	}

	public static function exec(cmd:String):Int {
		stderr(cmd);
		return Sys.command(cmd);
	}
}
