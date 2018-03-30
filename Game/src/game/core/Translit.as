package game.core 
{
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Translit 
	{
		public static var currentLng:String;		
		
		public static var xmlLng:XML;		
		
		
		// Загрузить языковый файл
		public static function loadLng(lngDir:String):void
		{
			currentLng = Capabilities.language;	
			if (currentLng == "xu") currentLng = "en";
			
			//currentLng = "en";
			
			var byteArray:ByteArray = new Source(lngDir + currentLng + ".txt").getSource();
			
			if (!byteArray) byteArray = new Source(lngDir + "en.txt").getSource();
			
			xmlLng = new XML(byteArray);
			
			/*var lng:String = fileName.slice(0, fileName.length - 4);
			
			for (var i:int = lng.length; i > 0; i--)
			{
				if (lng.charAt(i) == File.separator || lng.charAt(i) == "/")
				{
					lng = lng.slice(i + 1, lng.length);	
					break;
				}
			}
			
			currentLng = lng;	*/		
		}
		
		// Взять строку по ее ID
		public static function getString(id:String):String
		{
			if (!xmlLng) throw new Error("Language file is not loaded!");
			
			return xmlLng.child(id);
		}
		
		
	}

}