package 
{
	import flash.filesystem.File;

	/**
	 * ...
	 * @author Monkgol
	 */
	public class Project
	{		
		// Компиляция
		// EDITOR - редактор
		// GAME - игра
		public static var project:String;		
		public static var projectPath:String;
		
		public static const GAME:String = "GAME";
		public static const EDITOR:String = "EDITOR";		
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Режими работы
		public static function setProject(type:String):void
		{
			project = type;
			
			if (type == Project.EDITOR) projectPath = getProjectPath();
		}
		
		public static function getProject():String
		{
			return project;
		}
		
		public static function isEditor():Boolean
		{
			if (getProject() == Project.EDITOR) return true;
			else return false;
		}
		
		public static function isGame():Boolean
		{
			if (getProject() == Project.GAME) return true;
			else return false;
		}
		
		// Установка директории, где расположен проект
		public static function setProjectPath():void
		{
			var appPath:File = File.applicationDirectory;			
			projectPath = appPath.nativePath.slice(0, appPath.nativePath.length - 3);
		}
		
		// Получить директорию, где расположен проект
		public static function getProjectPath():String
		{
			if (projectPath) return projectPath;
			else 
			{
				setProjectPath();
				return projectPath;
			}			
		}
		
	}

}