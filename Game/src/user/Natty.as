package  user
{
	import fl.motion.easing.Linear;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.ui.Window;
	
	import game.core.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Natty extends GameObject
	{		
		public var idleTimer:Timer;
		
		public function Natty(fileName:String, name:String, tag:String) 
		{
			super(fileName, name, tag);
		}
		
		public static function getNearestObjects():void
		{
			// Если рядом выход - завершить уровень
			if (isNear("exit")) Exit.tryComplete();
			
			// Если рядом краб
			if (Game.scene.name == "level_3" || Game.scene.name == "level_5")
			{
				if (isNear("crab")) Crab.showDialog();
			}
			
			// Если рядом червячек
			if (Game.scene.name == "level_8" || Game.scene.name == "level_10" || Game.scene.name == "level_12")
			{
				if (isNear("slizen")) Slizen.showDialog();
			}
			
			// Если рядом попугай
			if (Game.scene.name == "level_15" || Game.scene.name == "level_17" || Game.scene.name == "level_20")
			{
				if (isNear("popugay")) Popugay.showDialog();
			}
			
			// Если рядом ключ
			if (Game.scene.name == "level_4")
			{
				if (isNear("key")) getItem("key");
			}
			
			// Если рядом грог
			if (Game.scene.name == "level_16")
			{
				if (isNear("grog")) getItem("grog");
			}
			
			// Если рядом банан
			if (Game.scene.name == "level_18" || Game.scene.name == "level_19")
			{
				if (isNear("banan")) getItem("banan");
			}
			
			// Если рядом карта
			if (Game.scene.name == "level_21" || Game.scene.name == "level_22" || Game.scene.name == "level_23" || Game.scene.name == "level_24")
			{
				if (isNear("karta")) getItem("karta");
			}
		}
		
		// Взять итем
		public static function getItem(itemTag:String):void
		{
			var item:GameObject = Game.scene.getObjectByTag(itemTag);
			
			var itemPosition:Position = new Position(0, 0, item.position);
			var itemName:String = item.name;
			
			Game.scene.destroyObject(item);
			
			var itemWnd:Window;
			
			switch(itemTag)
			{
				case "key": itemWnd = Game.loadWindow(new Position(), "itemWnd", ItemFound, "graphics/comix/nashel_kluch.swf");
				break;
				
				case "grog": itemWnd = Game.loadWindow(new Position(), "itemWnd", ItemFound, "graphics/comix/nashel_grog.swf");
				break;
				
				case "banan": if (Game.scene.name == "level_18") itemWnd = Game.loadWindow(new Position(), "itemWnd", ItemFound, "graphics/comix/nashel_banan_1.swf");
										else if (Game.scene.name == "level_19") itemWnd = Game.loadWindow(new Position(), "itemWnd", ItemFound, "graphics/comix/nashel_banan_2.swf");
				break;
				
				case "karta": if (Game.scene.name == "level_21") itemWnd = Game.loadWindow(new Position(), "itemWnd", ItemFound, "graphics/comix/nashel_kartu_1.swf");
										else if (Game.scene.name == "level_22") itemWnd = Game.loadWindow(new Position(), "itemWnd", ItemFound, "graphics/comix/nashel_kartu_2.swf");
										else if (Game.scene.name == "level_23") itemWnd = Game.loadWindow(new Position(), "itemWnd", ItemFound, "graphics/comix/nashel_kartu_3.swf");
										else if (Game.scene.name == "level_24") itemWnd = Game.loadWindow(new Position(), "itemWnd", ItemFound, "graphics/comix/nashel_kartu_4.swf");
				break;
			}
			
			itemWnd.addEventListener(Event.REMOVED_FROM_STAGE, onItemWndDestroyed);
			
			// Окно комикса когда нашел удалено
			function onItemWndDestroyed(e:Event):void
			{			
				var newFruit:String = Main.generateFruit();					
				item = Game.scene.createObject(itemPosition, Fruit, "graphics/fruits/" + newFruit + ".swf", itemName, newFruit);
				item.addEventListener(ObjectEvent.OBJECT_LOADED, onItemLoaded);
				
				function onItemLoaded(e:ObjectEvent):void
				{
					item.removeEventListener(ObjectEvent.OBJECT_LOADED, onItemLoaded);
					
					item.hideObject();
					
					var bornEffect:ChildObject = item.addChildObject(new Position(0, 0), null, "graphics/effects/fruit_born.swf", "fruit_born");
					bornEffect.addEventListener(ObjectEvent.OBJECT_LOADED, onBornLoaded);
					
					function onBornLoaded(e:ObjectEvent):void
					{
						bornEffect.removeEventListener(ObjectEvent.OBJECT_LOADED, onBornLoaded);
						
						bornEffect.playAnimation("idle", false, onBornEnd);
						
						function onBornEnd():void
						{
							item.removeChildObject(bornEffect);					
							item.showObject();
							
							Exit(Game.scene.getObjectByTag("exit")).open();
							
							var currentSceneClass:Class = Main.getCurrentSceneClass();
							currentSceneClass(Game.scene).canComplete = true;
						}
					}
				}			
			}
		}
		
		// Находится черепаха возле обьекта
		public static function isNear(objectTag:String):Boolean
		{			
			var object:GameObject = Game.scene.getObjectByTag(objectTag);
			
			if (!object) return false;
			
			var currentName:String = object.name;
			
			var upFruitName1:String = Main.getUpFruit(currentName);
			var downFruitName1:String = Main.getDownFruit(currentName);
			var leftFruitName1:String = Main.getLeftFruit(currentName);
			var rightFruitName1:String = Main.getRightFruit(currentName);
			
			var upFruit1:GameObject = Game.scene.getObjectByName(upFruitName1);
			var upFruitTag1:String = upFruit1 ? upFruit1.tag : "";
			
			var downFruit1:GameObject = Game.scene.getObjectByName(downFruitName1);
			var downFruitTag1:String = downFruit1 ? downFruit1.tag : "";
			
			var leftFruit1:GameObject = Game.scene.getObjectByName(leftFruitName1);
			var leftFruitTag1:String = leftFruit1 ? leftFruit1.tag : "";
			
			var rightFruit1:GameObject = Game.scene.getObjectByName(rightFruitName1);
			var rightFruitTag1:String = rightFruit1 ? rightFruit1.tag : "";
			
			if (upFruitTag1 == "natty" || downFruitTag1 == "natty" || leftFruitTag1 == "natty" || rightFruitTag1 == "natty") return true; else return false;
			
			return false;
		}
		
		// Проверить рядом стоящие фрукты на схожесть
		public static function getNearbyFruits():void
		{
			// Перемещять черепаху если рядом есть три под ряд одинаковые
			function nattyMove(obj1:GameObject, obj2:GameObject, obj3:GameObject):void
			{
				if (!Main.fruitsActive) return;
				
				Audio.playSound("sounds/fruits_combined.mp3", onBeginMove);
				
				function onBeginMove():void
				{
					Audio.playSound("sounds/natty_move.mp3");
				}
				
				Main.fruitsActive = false;				
				
				var natty:GameObject = Game.scene.getObjectByTag("natty");
				
				natty.sendToFront();
				
				natty.addEventListener(Event.ENTER_FRAME, onNattyUpdate);
				
				// Скрыть фрукты при контакте с черепахой
				function onNattyUpdate(e:Event):void
				{
					if (natty.hitTestObject(obj1)) 
					{
						if (obj1.displayObject.visible)
						{
							Audio.playSound("sounds/eat.mp3");
							
							var nName:String = natty.name;
							natty.name = obj1.name;
						
							Natty.getNearestObjects();
							natty.name = nName;
						}
						
						obj1.hideObject();
					}
					
					if (natty.hitTestObject(obj2))
					{
						if (obj2.displayObject.visible)
						{
							Audio.playSound("sounds/eat.mp3");
							
							var nName:String = natty.name;
							natty.name = obj2.name;
						
							Natty.getNearestObjects();
							natty.name = nName;
						}
						
						obj2.hideObject();						
					}
					
					if (natty.hitTestObject(obj3))
					{
						if (obj3.displayObject.visible)
						{
							Audio.playSound("sounds/eat.mp3");
						}
						
						obj3.hideObject();
						
						//natty.name = obj3.name;
					}
				}
				
				var nattyPosition:Position = new Position(0, 0, natty.position);
				var nattyName:String = natty.name;
				
				natty.moveTo(new Position(0, 0, obj1.position), 2, Linear.easeNone, true, onComplete, new Position(0, 0, obj2.position), new Position(0, 0, obj3.position));
				natty.playAnimation("walking");
				
				function onComplete():void
				{
					natty.removeEventListener(Event.ENTER_FRAME, onNattyUpdate);
					natty.stopAnimation();					
					
					var objectName3:String = obj3.name;
					var newFruit1:String = Main.generateFruit();
					
					var fruit1:GameObject = Game.scene.createObject(nattyPosition, Fruit, "graphics/fruits/" + newFruit1 + ".swf", nattyName, newFruit1);
					fruit1.addEventListener(ObjectEvent.OBJECT_LOADED, onFruitLoaded1);					
					
					function onFruitLoaded1(e:ObjectEvent):void
					{
						fruit1.removeEventListener(ObjectEvent.OBJECT_LOADED, onFruitLoaded1);
						
						fruit1.hideObject();
						
						var bornEffect:ChildObject = fruit1.addChildObject(new Position(0, 0), null, "graphics/effects/fruit_born.swf", "fruit_born");
						bornEffect.addEventListener(ObjectEvent.OBJECT_LOADED, onBornLoaded);
						
						function onBornLoaded(e:ObjectEvent):void
						{
							bornEffect.removeEventListener(ObjectEvent.OBJECT_LOADED, onBornLoaded);
							
							bornEffect.playAnimation("idle", false, onBornEnd);
							
							function onBornEnd():void
							{
								fruit1.removeChildObject(bornEffect);
								fruit1.showObject();
								
								Audio.playSound("sounds/fruit_born.mp3");
							}
						}
					}
					
					// Генерировать второй фрукт
					var fruitPosition2:Position = obj1.position;
					
					var newFruit2:String = Main.generateFruit();
					var fruit2:GameObject = Game.scene.createObject(fruitPosition2, Fruit, "graphics/fruits/" + newFruit2 + ".swf", obj1.name, newFruit2);
					fruit2.addEventListener(ObjectEvent.OBJECT_LOADED, onFruitLoaded2);
					
					function onFruitLoaded2(e:ObjectEvent):void
					{
						fruit2.removeEventListener(ObjectEvent.OBJECT_LOADED, onFruitLoaded2);
						
						fruit2.hideObject();
						
						var bornEffect:ChildObject = fruit2.addChildObject(new Position(0, 0), null, "graphics/effects/fruit_born.swf", "fruit_born");
						bornEffect.addEventListener(ObjectEvent.OBJECT_LOADED, onBornLoaded);
						
						function onBornLoaded(e:ObjectEvent):void
						{
							bornEffect.removeEventListener(ObjectEvent.OBJECT_LOADED, onBornLoaded);
							
							bornEffect.playAnimation("idle", false, onBornEnd);
							
							function onBornEnd():void
							{
								fruit2.removeChildObject(bornEffect);
								fruit2.showObject();
							}
						}
					}
					
					// Генерировать третий фрукт
					var fruitPosition3:Position = obj2.position;					

					var newFruit3:String = Main.generateFruit();
					var fruit3:GameObject = Game.scene.createObject(fruitPosition3, Fruit, "graphics/fruits/" + newFruit3 + ".swf", obj2.name, newFruit3);
					fruit3.addEventListener(ObjectEvent.OBJECT_LOADED, onFruitLoaded3);
					
					function onFruitLoaded3(e:ObjectEvent):void
					{
						fruit3.removeEventListener(ObjectEvent.OBJECT_LOADED, onFruitLoaded3);
						
						fruit3.hideObject();
						
						var bornEffect:ChildObject = fruit3.addChildObject(new Position(0, 0), null, "graphics/effects/fruit_born.swf", "fruit_born");
						bornEffect.addEventListener(ObjectEvent.OBJECT_LOADED, onBornLoaded);
						
						function onBornLoaded(e:ObjectEvent):void
						{
							bornEffect.removeEventListener(ObjectEvent.OBJECT_LOADED, onBornLoaded);
							
							bornEffect.playAnimation("idle", false, onBornEnd);
							
							function onBornEnd():void
							{
								fruit3.removeChildObject(bornEffect);
								fruit3.showObject();
								
								//getNearbyFruits();
							}
						}
					}
					
					Game.scene.destroyObject(Game.scene.getObjectByName(obj3.name));
					Game.scene.destroyObject(Game.scene.getObjectByName(obj2.name));					
					Game.scene.destroyObject(Game.scene.getObjectByName(obj1.name));
					
					natty.name = objectName3;					
					
					getNearestObjects();					
					
					Main.fruitsActive = true;
				}
			}
			
			var currentName:String = Game.scene.getObjectByTag("natty").name;
			
			var upFruitName1:String = Main.getUpFruit(currentName);
			var downFruitName1:String = Main.getDownFruit(currentName);
			var leftFruitName1:String = Main.getLeftFruit(currentName);
			var rightFruitName1:String = Main.getRightFruit(currentName);	
			
			var upFruit1:GameObject = Game.scene.getObjectByName(upFruitName1);
			var upFruitTag1:String = upFruit1 ? upFruit1.tag : "";
			
			var downFruit1:GameObject = Game.scene.getObjectByName(downFruitName1);
			var downFruitTag1:String = downFruit1 ? downFruit1.tag : "";
			
			var leftFruit1:GameObject = Game.scene.getObjectByName(leftFruitName1);
			var leftFruitTag1:String = leftFruit1 ? leftFruit1.tag : "";
			
			var rightFruit1:GameObject = Game.scene.getObjectByName(rightFruitName1);
			var rightFruitTag1:String = rightFruit1 ? rightFruit1.tag : "";
			
			
			// Действия над верхним фруктом 2 порядка
			if (upFruit1)
			{				
				var upFruitName2:String = Main.getUpFruit(upFruitName1);				
				var leftFruitName2:String = Main.getLeftFruit(upFruitName1);
				var rightFruitName2:String = Main.getRightFruit(upFruitName1);
				
				var upFruit2:GameObject = Game.scene.getObjectByName(upFruitName2);
				var upFruitTag2:String = upFruit2 ? upFruit2.tag : "";
				
				var leftFruit2:GameObject = Game.scene.getObjectByName(leftFruitName2);
				var leftFruitTag2:String = leftFruit2 ? leftFruit2.tag : "";
				
				var rightFruit2:GameObject = Game.scene.getObjectByName(rightFruitName2);
				var rightFruitTag2:String = rightFruit2 ? rightFruit2.tag : "";
				
				// Действия над верхним фруктом 3 порядка
				if (upFruit2 && upFruitTag2 == upFruitTag1)
				{					
					var upFruitName3:String = Main.getUpFruit(upFruitName2);					
					var leftFruitName3:String = Main.getLeftFruit(upFruitName2);
					var rightFruitName3:String = Main.getRightFruit(upFruitName2);	
					
					var upFruit3:GameObject = Game.scene.getObjectByName(upFruitName3);
					var upFruitTag3:String = upFruit3 ? upFruit3.tag : "";
					
					var leftFruit3:GameObject = Game.scene.getObjectByName(leftFruitName3);
					var leftFruitTag3:String = leftFruit3 ? leftFruit3.tag : "";
					
					var rightFruit3:GameObject = Game.scene.getObjectByName(rightFruitName3);
					var rightFruitTag3:String = rightFruit3 ? rightFruit3.tag : "";
					
					if (upFruit3 && upFruitTag3 == upFruitTag2)
					{
						nattyMove(upFruit1, upFruit2, upFruit3);
					}
					
					if (leftFruit3 && leftFruitTag3 == upFruitTag2)
					{
						nattyMove(upFruit1, upFruit2, leftFruit3);
					}
					
					if (rightFruit3 && rightFruitTag3 == upFruitTag2)
					{
						nattyMove(upFruit1, upFruit2, rightFruit3);
					}
				}
				
				// Действия над левым фруктом 3 порядка
				if (leftFruit2 && leftFruitTag2 == upFruitTag1)
				{					
					var upFruitName3:String = Main.getUpFruit(leftFruitName2);					
					var leftFruitName3:String = Main.getLeftFruit(leftFruitName2);
					//var downFruitName3:String = Main.getDownFruit(leftFruitName2);
					
					var upFruit3:GameObject = Game.scene.getObjectByName(upFruitName3);
					var upFruitTag3:String = upFruit3 ? upFruit3.tag : "";
					
					var leftFruit3:GameObject = Game.scene.getObjectByName(leftFruitName3);
					var leftFruitTag3:String = leftFruit3 ? leftFruit3.tag : "";
					
					/*var downFruit3:GameObject = Game.scene.getObjectByName(downFruitName3);
					var downFruitTag3:String = downFruit3 ? downFruit3.tag : "";*/
					
					if (upFruit3 && upFruitTag3 == leftFruitTag2)
					{
						nattyMove(upFruit1, leftFruit2, upFruit3);
					}
					
					if (leftFruit3 && leftFruitTag3 == leftFruitTag2)
					{
						nattyMove(upFruit1, leftFruit2, leftFruit3);
					}
					
					/*if (downFruit3 && downFruitTag3 == leftFruitTag2)
					{
						nattyMove(upFruit1, leftFruit2, downFruit3);
					}*/
				}
				
				// Действия над правым фруктом 3 порядка
				if (rightFruit2 && rightFruitTag2 == upFruitTag1)
				{					
					var upFruitName3:String = Main.getUpFruit(rightFruitName2);					
					//var downFruitName3:String = Main.getLeftFruit(rightFruitName2);
					var rightFruitName3:String = Main.getRightFruit(rightFruitName2);
					
					var upFruit3:GameObject = Game.scene.getObjectByName(upFruitName3);
					var upFruitTag3:String = upFruit3 ? upFruit3.tag : "";
					
					/*var downFruit3:GameObject = Game.scene.getObjectByName(downFruitName3);
					var downFruitTag3:String = downFruit3 ? downFruit3.tag : "";*/
					
					var rightFruit3:GameObject = Game.scene.getObjectByName(rightFruitName3);
					var rightFruitTag3:String = rightFruit3 ? rightFruit3.tag : "";
					
					if (upFruit3 && upFruitTag3 == rightFruitTag2)
					{
						nattyMove(upFruit1, rightFruit2, upFruit3);
					}
					
					/*if (downFruit3 && downFruitTag3 == rightFruitTag2)
					{
						nattyMove(upFruit1, rightFruit2, downFruit3);
					}*/
					
					if (rightFruit3 && rightFruitTag3 == rightFruitTag2)
					{
						nattyMove(upFruit1, rightFruit2, rightFruit3);
					}
				}				
			}
			
			// Действия над нижним фруктом 2 порядка
			if (downFruit1)
			{				
				var downFruitName2:String = Main.getDownFruit(downFruitName1);				
				var leftFruitName2:String = Main.getLeftFruit(downFruitName1);
				var rightFruitName2:String = Main.getRightFruit(downFruitName1);
				
				var downFruit2:GameObject = Game.scene.getObjectByName(downFruitName2);
				var downFruitTag2:String = downFruit2 ? downFruit2.tag : "";
				
				var leftFruit2:GameObject = Game.scene.getObjectByName(leftFruitName2);
				var leftFruitTag2:String = leftFruit2 ? leftFruit2.tag : "";
				
				var rightFruit2:GameObject = Game.scene.getObjectByName(rightFruitName2);
				var rightFruitTag2:String = rightFruit2 ? rightFruit2.tag : "";
				
				// Действия над нижним фруктом 3 порядка
				if (downFruit2 && downFruitTag2 == downFruitTag1)
				{					
					var downFruitName3:String = Main.getDownFruit(downFruitName2);					
					var leftFruitName3:String = Main.getLeftFruit(downFruitName2);
					var rightFruitName3:String = Main.getRightFruit(downFruitName2);
					
					var downFruit3:GameObject = Game.scene.getObjectByName(downFruitName3);
					var downFruitTag3:String = downFruit3 ? downFruit3.tag : "";
					
					var leftFruit3:GameObject = Game.scene.getObjectByName(leftFruitName3);
					var leftFruitTag3:String = leftFruit3 ? leftFruit3.tag : "";
					
					var rightFruit3:GameObject = Game.scene.getObjectByName(rightFruitName3);
					var rightFruitTag3:String = rightFruit3 ? rightFruit3.tag : "";
					
					if (downFruit3 && downFruitTag3 == downFruitTag2)
					{
						nattyMove(downFruit1, downFruit2, downFruit3);
					}
					
					if (leftFruit3 && leftFruitTag3 == downFruitTag2)
					{
						nattyMove(downFruit1, downFruit2, leftFruit3);
					}
					
					if (rightFruit3 && rightFruitTag3 == downFruitTag2)
					{
						nattyMove(downFruit1, downFruit2, rightFruit3);
					}
				}
				
				// Действия над левым фруктом 3 порядка
				if (leftFruit2 && leftFruitTag2 == downFruitTag1)
				{					
					//var upFruitName3:String = Main.getUpFruit(leftFruitName2);					
					var leftFruitName3:String = Main.getLeftFruit(leftFruitName2);
					var downFruitName3:String = Main.getDownFruit(leftFruitName2);
					
					/*var upFruit3:GameObject = Game.scene.getObjectByName(upFruitName3);
					var upFruitTag3:String = upFruit3 ? upFruit3.tag : "";*/
					
					var leftFruit3:GameObject = Game.scene.getObjectByName(leftFruitName3);
					var leftFruitTag3:String = leftFruit3 ? leftFruit3.tag : "";
					
					var downFruit3:GameObject = Game.scene.getObjectByName(downFruitName3);
					var downFruitTag3:String = downFruit3 ? downFruit3.tag : "";
					
					/*if (upFruit3 && upFruitTag3 == leftFruitTag2)
					{
						nattyMove(downFruit1, leftFruit2, upFruit3);
					}*/
					
					if (leftFruit3 && leftFruitTag3 == leftFruitTag2)
					{
						nattyMove(downFruit1, leftFruit2, leftFruit3);
					}
					
					if (downFruit3 && downFruitTag3 == leftFruitTag2)
					{
						nattyMove(downFruit1, leftFruit2, downFruit3);
					}
				}
				
				// Действия над правым фруктом 3 порядка
				if (rightFruit2 && rightFruitTag2 == downFruitTag1)
				{					
					//var upFruitName3:String = Main.getUpFruit(downFruitName2);					
					var downFruitName3:String = Main.getDownFruit(rightFruitName2);
					var rightFruitName3:String = Main.getRightFruit(rightFruitName2);
					
					/*var upFruit3:GameObject = Game.scene.getObjectByName(upFruitName3);
					var upFruitTag3:String = upFruit3 ? upFruit3.tag : "";*/
					
					var downFruit3:GameObject = Game.scene.getObjectByName(downFruitName3);
					var downFruitTag3:String = downFruit3 ? downFruit3.tag : "";
					
					var rightFruit3:GameObject = Game.scene.getObjectByName(rightFruitName3);
					var rightFruitTag3:String = rightFruit3 ? rightFruit3.tag : "";
					
					/*if (upFruit3 && upFruitTag3 == rightFruitTag2)
					{
						nattyMove(downFruit1, rightFruit2, upFruit3);
					}*/
					
					if (downFruit3 && downFruitTag3 == rightFruitTag2)
					{
						nattyMove(downFruit1, rightFruit2, downFruit3);
					}
					
					if (rightFruit3 && rightFruitTag3 == rightFruitTag2)
					{
						nattyMove(downFruit1, rightFruit2, rightFruit3);
					}
				}				
			}
			
			// Действия над левым фруктом 2 порядка
			if (leftFruit1)
			{				
				var downFruitName2:String = Main.getDownFruit(leftFruitName1);				
				var leftFruitName2:String = Main.getLeftFruit(leftFruitName1);
				var upFruitName2:String = Main.getUpFruit(leftFruitName1);
				
				var downFruit2:GameObject = Game.scene.getObjectByName(downFruitName2);
				var downFruitTag2:String = downFruit2 ? downFruit2.tag : "";
				
				var leftFruit2:GameObject = Game.scene.getObjectByName(leftFruitName2);
				var leftFruitTag2:String = leftFruit2 ? leftFruit2.tag : "";
				
				var upFruit2:GameObject = Game.scene.getObjectByName(upFruitName2);
				var upFruitTag2:String = upFruit2 ? upFruit2.tag : "";

				
				// Действия над нижним фруктом 3 порядка
				if (downFruit2 && downFruitTag2 == leftFruitTag1)
				{					
					var downFruitName3:String = Main.getDownFruit(downFruitName2);					
					var leftFruitName3:String = Main.getLeftFruit(downFruitName2);
					//var rightFruitName3:String = Main.getRightFruit(downFruitName2);
					
					var downFruit3:GameObject = Game.scene.getObjectByName(downFruitName3);
					var downFruitTag3:String = downFruit3 ? downFruit3.tag : "";
					
					var leftFruit3:GameObject = Game.scene.getObjectByName(leftFruitName3);
					var leftFruitTag3:String = leftFruit3 ? leftFruit3.tag : "";
					
					/*var rightFruit3:GameObject = Game.scene.getObjectByName(rightFruitName3);
					var rightFruitTag3:String = rightFruit3 ? rightFruit3.tag : "";*/
					
					if (downFruit3 && downFruitTag3 == downFruitTag2)
					{
						nattyMove(leftFruit1, downFruit2, downFruit3);
					}
					
					if (leftFruit3 && leftFruitTag3 == downFruitTag2)
					{
						nattyMove(leftFruit1, downFruit2, leftFruit3);
					}
					
					/*if (rightFruit3 && rightFruitTag3 == rightFruitTag2)
					{
						nattyMove(leftFruit1, downFruit2, rightFruit3);
					}*/
				}
				
				// Действия над левым фруктом 3 порядка
				if (leftFruit2 && leftFruitTag2 == leftFruitTag1)
				{					
					var upFruitName3:String = Main.getUpFruit(leftFruitName2);					
					var leftFruitName3:String = Main.getLeftFruit(leftFruitName2);
					var downFruitName3:String = Main.getDownFruit(leftFruitName2);
					
					var upFruit3:GameObject = Game.scene.getObjectByName(upFruitName3);
					var upFruitTag3:String = upFruit3 ? upFruit3.tag : "";
					
					var leftFruit3:GameObject = Game.scene.getObjectByName(leftFruitName3);
					var leftFruitTag3:String = leftFruit3 ? leftFruit3.tag : "";
					
					var downFruit3:GameObject = Game.scene.getObjectByName(downFruitName3);
					var downFruitTag3:String = downFruit3 ? downFruit3.tag : "";
					
					if (upFruit3 && upFruitTag3 == leftFruitTag2)
					{ 
						nattyMove(leftFruit1, leftFruit2, upFruit3);
					}
					
					if (leftFruit3 && leftFruitTag3 == leftFruitTag2)
					{ 
						nattyMove(leftFruit1, leftFruit2, leftFruit3);
					}
					
					if (downFruit3 && downFruitTag3 == leftFruitTag2)
					{
						nattyMove(leftFruit1, leftFruit2, downFruit3);
					}
				}
				
				// Действия над верхним фруктом 3 порядка
				if (upFruit2 && upFruitTag2 == leftFruitTag1)
				{					
					var upFruitName3:String = Main.getUpFruit(upFruitName2);					
					//var downFruitName3:String = Main.getDownFruit(upFruitName2);
					var leftFruitName3:String = Main.getLeftFruit(upFruitName2);
					
					var upFruit3:GameObject = Game.scene.getObjectByName(upFruitName3);
					var upFruitTag3:String = upFruit3 ? upFruit3.tag : "";
						
					/*var downFruit3:GameObject = Game.scene.getObjectByName(downFruitName3);
						var downFruitTag3:String = downFruit3 ? downFruit3.tag : "";*/
						
					var leftFruit3:GameObject = Game.scene.getObjectByName(leftFruitName3);
					var leftFruitTag3:String = leftFruit3 ? leftFruit3.tag : "";
					
					if (upFruit3 && upFruitTag3 == upFruitTag2)
					{
						nattyMove(leftFruit1, upFruit2, upFruit3);
					}
					
					/*if (downFruit3 && downFruitTag3 == downFruitTag2)
					{
						nattyMove(leftFruit1, upFruit2, downFruit3);
					}*/
					
					if (leftFruit3 && leftFruitTag3 == upFruitTag2)
					{
						nattyMove(leftFruit1, upFruit2, leftFruit3);
					}
				}				
			}
			
			// Действия над правым фруктом 2 порядка
			if (rightFruit1)
			{				
				var downFruitName2:String = Main.getDownFruit(rightFruitName1);				
				var rightFruitName2:String = Main.getRightFruit(rightFruitName1);
				var upFruitName2:String = Main.getUpFruit(rightFruitName1);
				
				var rightFruit2:GameObject = Game.scene.getObjectByName(rightFruitName2);
				var rightFruitTag2:String = rightFruit2 ? rightFruit2.tag : "";
				
				var downFruit2:GameObject = Game.scene.getObjectByName(downFruitName2);
				var downFruitTag2:String = downFruit2 ? downFruit2.tag : "";
				
				var upFruit2:GameObject = Game.scene.getObjectByName(upFruitName2);
				var upFruitTag2:String = upFruit2 ? upFruit2.tag : "";

				
				// Действия над нижним фруктом 3 порядка
				if (downFruit2 && downFruitTag2 == rightFruitTag1)
				{					
					var downFruitName3:String = Main.getDownFruit(downFruitName2);					
					//var leftFruitName3:String = Main.getLeftFruit(downFruitName2);
					var rightFruitName3:String = Main.getRightFruit(downFruitName2);
					
					var downFruit3:GameObject = Game.scene.getObjectByName(downFruitName3);
					var downFruitTag3:String = downFruit3 ? downFruit3.tag : "";
						
					/*var leftFruit3:GameObject = Game.scene.getObjectByName(leftFruitName3);
					var leftFruitTag3:String = leftFruit3 ? leftFruit3.tag : "";*/
						
					var rightFruit3:GameObject = Game.scene.getObjectByName(rightFruitName3);
					var rightFruitTag3:String = rightFruit3 ? rightFruit3.tag : "";
					
					if (downFruit3 && downFruitTag3 == downFruitTag2)
					{
						nattyMove(rightFruit1, downFruit2, downFruit3);
					}
					
					/*if (leftFruit3 && leftFruitTag3 == leftFruitTag2)
					{
						nattyMove(rightFruit1, downFruit2, leftFruit3);
					}*/
					
					if (rightFruit3 && rightFruitTag3 == downFruitTag2)
					{
						nattyMove(rightFruit1, downFruit2, rightFruit3);
					}
				}
				
				// Действия над правым фруктом 3 порядка
				if (rightFruit2 && rightFruitTag2 == rightFruitTag1)
				{					
					var upFruitName3:String = Main.getUpFruit(rightFruitName2);					
					var rightFruitName3:String = Main.getRightFruit(rightFruitName2);
					var downFruitName3:String = Main.getDownFruit(rightFruitName2);
					
					var upFruit3:GameObject = Game.scene.getObjectByName(upFruitName3);
					var upFruitTag3:String = upFruit2 ? upFruit3.tag : "";
						
					var rightFruit3:GameObject = Game.scene.getObjectByName(rightFruitName3);
					var rightFruitTag3:String = rightFruit3 ? rightFruit3.tag : "";
						
					var downFruit3:GameObject = Game.scene.getObjectByName(downFruitName3);
					var downFruitTag3:String = downFruit3 ? downFruit3.tag : "";
					
					if (upFruit3 && upFruitTag3 == rightFruitTag2)
					{
						nattyMove(rightFruit1, rightFruit2, upFruit3);
					}
					
					if (rightFruit3 && rightFruitTag3 == rightFruitTag2)
					{
						nattyMove(rightFruit1, rightFruit2, rightFruit3);
					}
					
					if (downFruit3 && downFruitTag3 == rightFruitTag2)
					{
						nattyMove(rightFruit1, rightFruit2, downFruit3);
					}
				}
				
				// Действия над верхним фруктом 3 порядка
				if (upFruit2 && upFruitTag2 == rightFruitTag1)
				{					
					var upFruitName3:String = Main.getUpFruit(upFruitName2);					
					//var downFruitName3:String = Main.getDownFruit(upFruitName2);
					var rightFruitName3:String = Main.getRightFruit(upFruitName2);
					
					var upFruit3:GameObject = Game.scene.getObjectByName(upFruitName3);
					var upFruitTag3:String = upFruit3 ? upFruit3.tag : "";
						
					/*var downFruit3:GameObject = Game.scene.getObjectByName(downFruitName3);
					var downFruitTag3:String = downFruit3 ? downFruit3.tag : "";*/
						
					var rightFruit3:GameObject = Game.scene.getObjectByName(rightFruitName3);
					var rightFruitTag3:String = rightFruit3 ? rightFruit3.tag : "";
					
					if (upFruit3 && upFruitTag3 == upFruitTag2)
					{
						nattyMove(rightFruit1, upFruit2, upFruit3);
					}
					
					/*if (downFruit3 && downFruitTag3 == downFruitTag2)
					{
						nattyMove(rightFruit1, upFruit2, downFruit3);
					}*/
					
					if (rightFruit3 && rightFruitTag3 == upFruitTag2)
					{
						nattyMove(rightFruit1, upFruit2, rightFruit3);
					}
				}				
			}
		}
		
		override protected function onClick(e:MouseEvent):void 
		{
			if (e.target == this)
			{
				
			}
		}
		
		// Проигрывать анимацию бездействия
		public function onIdleTimer(e:TimerEvent):void
		{
			//var natty:GameObject = Game.scene.getObjectByTag("natty");
			if (Main.fruitsActive) playAnimation("idle", false);			
		}
		
		override protected function onCreate(e:ObjectEvent):void 
		{
			super.onCreate(e);
			
			this.sendToFront();
			
			idleTimer = new Timer(3000);
			idleTimer.addEventListener(TimerEvent.TIMER, onIdleTimer);
			idleTimer.start();
		}		
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
			
			idleTimer.removeEventListener(TimerEvent.TIMER, onIdleTimer);
		}
		
	}

}