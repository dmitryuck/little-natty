package user 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.ui.Button;
	import game.ui.Window;
	
	import game.core.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Fruit extends GameObject 
	{
		
		public function Fruit(fileName:String, name:String, tag:String) 
		{
			super(fileName, name, tag);
			
			function setTag(fileName:String):String
			{
				var tag:String = fileName.slice(0, fileName.length - 4);
				
				for (var i:int = tag.length; i > 0; i--)
				{
					if (tag.charAt(i) == "/")
					{
						tag = tag.slice(i + 1, tag.length);					
						break;
					}
				}
				
				return tag;
			}
			
			this.tag = setTag(fileName);
		}
		
		override protected function onClick(e:MouseEvent):void 
		{
			if (e.target == this)
			{
				if (Main.fruitsActive) 
				{
					if (Main.wandActive)
					{
						Audio.playSound("sounds/wand_activate.mp3", playBorn);
						
						function playBorn():void
						{
							Audio.playSound("sounds/fruit_born.mp3");
						}
						
						var currentFruit:GameObject = this;
						
						var anim:ChildObject = currentFruit.addChildObject(new Position(), null, "graphics/effects/stars.swf", "fruit_wand");
						anim.addEventListener(ObjectEvent.OBJECT_LOADED, onAnimLoaded);
						
						function onAnimLoaded(e:ObjectEvent):void
						{
							removeEventListener(ObjectEvent.OBJECT_LOADED, onAnimLoaded);
							anim.playAnimation("idle", false, onAnimEnd);
							
							function onAnimEnd():void
							{
								currentFruit.removeChildObject(anim);
								currentFruit.hideObject();
								
								var born:ChildObject = currentFruit.addChildObject(new Position(), null, "graphics/effects/fruit_born.swf", "born");
								born.addEventListener(ObjectEvent.OBJECT_LOADED, onBornLoaded);
								
								function onBornLoaded(e:ObjectEvent):void
								{
									born.removeEventListener(ObjectEvent.OBJECT_LOADED, onBornLoaded);										
									born.playAnimation("idle", false, onBornEnd);
									
									function onBornEnd():void
									{
										currentFruit.hideObject();
										
										var newFruit:String = Main.generateFruit();
						
										var fruit:GameObject = Game.scene.createObject(currentFruit.position, Fruit, "graphics/fruits/" + newFruit + ".swf", currentFruit.name, newFruit);
										fruit.addEventListener(ObjectEvent.OBJECT_LOADED, onFruitLoaded);
					
										function onFruitLoaded(e:ObjectEvent):void
										{
											fruit.removeEventListener(ObjectEvent.OBJECT_LOADED, onFruitLoaded);
											
											Game.scene.destroyObject(currentFruit);	
										}
									}									
								}							
							}
						}
						
						Main.setWand(Main.wand - 1);
						
						if (Main.wand > 0) Button(Game.findWindow("interface").getComponentByName("btn_wand")).unCheck();
						
						Main.wandActive = false;					
					} else
					{		
						
						Main.selectFruit(this);				
					
						// Если фрукты рядом переместить
						if (Main.isSelectedFruitNearby())
						{
							Audio.playSound("sounds/fruit_change_position.mp3");
							
							Main.changeFruitPosition(positionChanged);
							
							Main.setStep(Main.step - 1);
							
							function positionChanged():void
							{
								if (Main.step > 0)  Main.fruitsActive = true;
								
								Main.resetSelectedFruits();
								
								Natty.getNearbyFruits();							
							}
						}
					}
				}
			}			
		}
		
		override protected function onCreate(e:ObjectEvent):void 
		{
			super.onCreate(e);
		}		
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);			
		}
		
	}

}