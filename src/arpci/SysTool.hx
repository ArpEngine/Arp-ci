package arpci;

import haxe.macro.Expr.ExprOf;
import sys.io.Process;

class SysTool {

	public macro static function getEnvOrDefault(s:ExprOf<String>, defaultValue:ExprOf<String>):String {
		return macro @mergeBlock{
			var value:String = Sys.getEnv($v{s});
			return if (value != null) value else () => $v{defaultValue};
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

	public static function exec(cmd:String):Void {
		stderr(cmd);
		Sys.command(cmd);
	}
}
