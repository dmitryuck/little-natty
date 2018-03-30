package user 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.core.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Robot extends GameObject 
	{		
		public function Robot(fileName:String, name:String, tag:String) 
		{
			super(fileName ,name , tag);			
		}		
		
		override protected function onClick(e:MouseEvent):void 
		{
			if (e.target == this)
			{		
				//trace(Game.scene.x);
				//trace(Game.scene.y);
				
				//trace(Game.scene.width);
				
				//Game.scene.x = 0;
				//Game.camera.moveLeft();	
				Game.camera.moveToPoint(new Point(90, 87));				
				//Game.camera.moveUp();
				//Game.camera.moveDown();
				//Game.camera.zoomIn();
			}			
		}
		
		override protected function onCreate(e:Event):void 
		{
			super.onCreate(e);
		}
		
		override protected function onUpdate(e:Event):void 
		{
			super.onUpdate(e);	
			//trace("robot");	
		}		
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
			trace("destroyed");
		}
		
	}

}