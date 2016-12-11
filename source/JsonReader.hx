class JsonReader {
	macro public static function readJson(path: String) {
		var value = sys.io.File.getContent(path),
			json = haxe.Json.parse(value);
		return macro $v{json};
	}
}