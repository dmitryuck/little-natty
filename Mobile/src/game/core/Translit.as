package game.core 
{
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	import game.utils.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Translit 
	{
		public static var currentLng:String;		
		
		public static var xmlLng:XML;
		
		private static var availableLngs:Array = ["cs", "de", "en", "es", "fr", "it", "ru", "sv"];
		
		
		// Загрузить языковый файл
		public static function loadLng(lngDir:String):void
		{
			for (var i:int = 0; i < Capabilities.languages.length; i++)
			{
				var currLang:String = Capabilities.languages[i].toString().toLowerCase();
				
				for (var n:int = 0; n < availableLngs.length; n++)
				{
					var currAvailLang:String = availableLngs[n];
					
					var myPattern:RegExp = new RegExp(currAvailLang);
					
					if (currLang.match(myPattern))
					{
						var byteArray:ByteArray = new Source(lngDir + currAvailLang + ".txt").getSource();
			
						xmlLng = new XML(byteArray);
						
						return;
					}
				}
			}
			
	
			var byteArray:ByteArray = new Source(lngDir + "en" + ".txt").getSource();
			
			xmlLng = new XML(byteArray);
		}
		
		// Взять строку по ее ID
		public static function getString(id:String):String
		{
			if (!xmlLng) throw new Error("Language file is not loaded!");
			
			return xmlLng.child(id);
		}
		
		
	}

}