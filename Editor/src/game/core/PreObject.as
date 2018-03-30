package game.core 
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.Sprite;
	
	import nape.phys.Body;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class PreObject extends Sprite 
	{
		public var tag:String;	
		public var type:String;
		
		public var fileName:String;	
		
		private var _position:Position;
		private var _scale:Number;
		
		
		public function PreObject(fileName:String = "", name:String = "", tag:String = "") 
		{
			this.type = "";
			this.fileName = fileName;
			this.name = name;
			this.tag = tag;			
		}	
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Установка свойств
		public function get scale():Number 
		{			
			return this.scaleX;
		}
		
		public function set scale(value:Number):void 
		{			
			this.scaleX = this.scaleY = value;
		}		
		
		// Изменение позиции обьекта
		public function get position():Position 
		{
			_position.x = this.x;
			_position.y = this.y;
			
			return _position;
		}
		
		public function set position(value:Position):void 
		{
			this.x = value.x;
			this.y = value.y;
			
			_position = value;			
		}
		
	}

}