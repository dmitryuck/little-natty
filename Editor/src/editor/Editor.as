package editor 
{
	import deng.fzip.FZip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import game.core.*;
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Editor
	{		
		// Создать архив с ресурсами
		public static function packAssets():void
		{
			Game.assets = new FZip();
			
			var assetsPath:File = new File(Project.projectPath + "assets" + File.separator);
			var files:Array = getFilesInDir(assetsPath);			
			
			var fileStream:FileStream = new FileStream();
			var fileContent:ByteArray = new ByteArray();
			
			for (var i:int = 0; i < files.length; i++)
			{
				var fullFilePath:String = files[i];
				var currentFile:File = new File(fullFilePath);
				
				if (currentFile.name != "assets.zip" && currentFile.name != "Thumbs.db" && currentFile.name != ".DS_Store.DS_STORE")
				{
					fileStream.open(currentFile, FileMode.READ);
					fileStream.readBytes(fileContent);
				
					var fileInZip:String = fullFilePath.slice(fullFilePath.indexOf("assets"), fullFilePath.length);					
					
					function replace(path:String):String
					{
						return path.replace(/\\/, "/");
					}
					
					for (var n:int = 0; n < fileInZip.length; n++)
					{
						if (fileInZip.charAt(n) == "\\")
						{
							fileInZip = replace(fileInZip);					
						}				
					}					
					
					Game.assets.addFile(fileInZip, fileContent, false);
				
					fileStream.close();
					fileContent.clear();
				}
			}			
			
			// Файл архив с ассетами
			var assetsPack:File = new File(Project.projectPath + "assets" + File.separator + "assets.zip");
			
			if (assetsPack.exists) assetsPack.deleteFile();
			
			fileStream.open(assetsPack, FileMode.WRITE);
			Game.assets.serialize(fileStream);
			fileStream.close();
		}	
		
		// Получить массив файлов в дирректории
		public static function getFilesInDir(dir:File):Array
		{
			var str:Array = new Array();
			
			function scan(dir:File):void
			{
				for each(var lstFile:File in dir.getDirectoryListing())
				{
					if(lstFile.isDirectory)
					{
						scan(lstFile);
					}
					else
					{
						if (lstFile.name != "Thumbs.db" && lstFile.name != ".DS_Store.DS_STORE") str.push(lstFile.nativePath);
					}
				}
			}			
			scan(dir);
			return str;
		}		
		
	}

}