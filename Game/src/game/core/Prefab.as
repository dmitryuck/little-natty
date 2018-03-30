package game.core 
{

	/**
	 * ...
	 * @author Monkgol
	 */
	public class Prefab extends PreObject
	{		
		public var gameObjects:Vector.<GameObject>;
		
		
		public function Prefab(type:String = "", fileName:String = "", name:String = "", tag:String = "") 
		{
			super(fileName, name, tag);
			
			this.type = type;
			
			gameObjects = new Vector.<GameObject>;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Добавить обьект
		public function addToPrefab(gameObject:GameObject):void
		{
			gameObjects.push(gameObject);
		}
		
		// Удалить обьект
		public function removeFromPrefab(gameObject:GameObject):void
		{
			var i:int = 0;
			for each (var object:GameObject in gameObjects)
			{
				if (object == gameObject)
				{
					gameObjects[i] = null;
					break;
				}
				i ++;
			}
		}
		
		// Применить изменения ко всем обьектам которые подключены к этому префабу
		public function update(gameObject:GameObject):void
		{
			for each (var object:GameObject in gameObjects)
			{
				if (object && object != gameObject)
				with (object)
				{					
					type = this.type;					
					tag = this.tag;				
					
					scale = this.scale;	
					
					fileName = this.fileName;
					
					setSource(this.fileName);
				}
			}
		}
		
	}

}