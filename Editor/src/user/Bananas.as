package user 
{
	import game.core.GameObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.core.*;
	import nape.phys.BodyType;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Bananas extends GameObject 
	{
		
		public function Bananas(fileName:String, name:String, tag:String) 
		{
			super(fileName ,name , tag);	
		}
		
		override protected function onClick(e:MouseEvent):void 
		{
			if (e.target == this)
			{
				//var a:GameObject = Game.scene.createObjectFromPrefab(new Position(400, 30), Main.p, "bananas");
				//Game.scene.destroyObjects(Game.scene.getTaggedObjects("loh"));
				
				//trace(Game.scene.getTaggedObjects("loh")[0].name);
				
				//Game.scene.destroyObject(Game.scene.getObjectByTag("loh"));
				//Game.scene.createObjectFromPrefab(Game.scene.getPrefab("prefab1"), new Position(0, 0), "robby");				
			}			
		}
		
		override protected function onCreate(e:Event):void 
		{
			super.onCreate(e);
			//addPhysics(BodyType.DYNAMIC);			
		}
		
		override protected function onUpdate(e:Event):void 
		{
			super.onUpdate(e);
		}		
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
		}
		
	}

}