package game.core 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import game.utils.Geom;
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Camera extends Sprite
	{
		public var target:GameObject;
		
		public var scene:Scene;		
		
		public var cam:Sprite;
		
		public var camWidth:Number;
		public var camHeight:Number;

		private var _position:Position;
		
		public var leftBorder:Number;
		public var topBorder:Number;
		
		public var horizontalSpeed:Number;
		public var verticalSpeed:Number;
		
		public var isMoving:Boolean;
		
		public function Camera(scene:Scene) 
		{			
			addEventListener(Event.ADDED_TO_STAGE, onCreate);			
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);  			
			
			this.scene = scene;
			
			position = new Position(this.x, this.y);			
			
			cam = new Sprite();			
		}
		
		private function onCreate(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onCreate);
			addEventListener(Event.ENTER_FRAME, onUpdate);
			//addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}		
		
		private function onDestroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeEventListener(Event.ENTER_FRAME, onUpdate);
			//removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		/*public function onKeyDown(e:KeyboardEvent):void
		{  //trace(e.keyCode);
			switch (e.keyCode)
			{      
				case 37 : moveLeft(8);				
				break; // Влево
				
				case 39 : moveRight(8); 
				break; // Вправо
				
				case 38 : moveUp(8);
				break; // Вверх
				
				case 40 : moveDown(8);
				break; // Вниз
			}
		}*/
		
		private function onUpdate(e:Event):void 
		{
			if (!scene) return;		
			
			//this.stage.focus = this;
             
            var w:Number = cam.width * cam.scaleX;
            var h:Number = cam.height * cam.scaleY;
             
            var sX:Number = this.stage.stageWidth / w;
            var sY:Number = this.stage.stageHeight / h;
			
			camWidth = this.stage.stageWidth;
			camHeight = this.stage.stageHeight;
			
			cam.graphics.beginFill(0xFF0000, 1);
            cam.graphics.drawRect(-camWidth * .5, -camHeight * .5, camWidth, camHeight);
            cam.graphics.endFill();
          
            var matrix:Matrix = this.transform.matrix.clone();
            matrix.invert();
            matrix.scale(this.scaleX, this.scaleY);
            //matrix.translate(w * 0.5, h * 0.5);
            matrix.scale(sX, sY);
			
            scene.transform.matrix = matrix;
            scene.transform.colorTransform = this.transform.colorTransform;
            scene.filters = this.filters;
			
			move();
			//zoom();
		}
		
		// Перемещять камеру
		public function move():void
		{
			// Установка левой границы смещения
			if (Game.scene.width <= this.stage.stageWidth) horizontalSpeed = 0;
			leftBorder = Game.scene.width - this.stage.stageWidth;
			if (leftBorder < 0) leftBorder *= -1;
			
			// Установка правой границы смещения
			if (Game.scene.height <= this.stage.stageHeight) verticalSpeed = 0;
			topBorder = Game.scene.height - this.stage.stageHeight;	
			if (topBorder < 0) topBorder *= -1;
			
			// Движение влево - вправо
			if (this.x >= 0 && this.x <= leftBorder)
			{				
				this.x += horizontalSpeed;
			}
			
			if (this.x < 0)
			{
				horizontalSpeed = 0;
				this.x = 0;
			}			
			
			if (this.x > leftBorder) 
			{
				horizontalSpeed = 0;
				this.x = leftBorder;
			}	
			
			// Движение вверх - вниз
			if (this.y >= 0 && this.y <= topBorder)
			{				
				this.y += verticalSpeed;
			}
			
			if (this.y < 0)
			{
				verticalSpeed = 0;
				this.y = 0;
			}
			
			if (this.y > topBorder)
			{
				verticalSpeed = 0;
				this.y = topBorder;
			}
			
			// Применить торможениек камере
			if (horizontalSpeed > 0.1 || horizontalSpeed < -0.1) horizontalSpeed *= 0.9; else horizontalSpeed = 0;
			if (verticalSpeed > 0.1 || verticalSpeed < -0.1) verticalSpeed *= 0.9; else verticalSpeed = 0;
		}
		
		// Движение к заданной точке
		public function moveTo(point:Point):void
		{
			var a:Point = new Point(this.x, this.y);
			var b:Point = new Point(point.x - camWidth / 2, point.y - camHeight / 2);
			var c:Point = new Point(b.x, a.y);
			
			horizontalSpeed = Geom.getDistance(a, c);
			verticalSpeed = Geom.getDistance(b, c);
		}
		
		// Движение к позиции обьекта
		public function moveToObject(object:GameObject):void
		{
			
		}
		
		// Следовать за обьектом
		public function fallowObject(target:GameObject):void
		{
			
		}
		
		// Перемещять камеру влево
		public function moveLeft(speed:Number):void
		{
			horizontalSpeed = -1 * speed;
		}
		
		// Перемещять камеру вправо
		public function moveRight(speed:Number):void
		{			
			horizontalSpeed = speed;
		}		
		
		// Перемещять камеру вверх
		public function moveUp(speed:Number):void
		{
			verticalSpeed = -1 * speed;
		}
		
		// Перемещять камеру вниз
		public function moveDown(speed:Number):void
		{
			verticalSpeed = speed;
		}		
		
		public function flowingZoom(scale:Number):void
		{
			
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Управление зумом камеры
		public function zoomIn():void
		{
			cam.scaleX = cam.scaleY -= 0.1;
		}
		
		public function zoomOut():void
		{
			cam.scaleX = cam.scaleY += 0.1;
		}		
		
		public function normalZoom():void
		{
			cam.scaleX = cam.scaleY = 1;
		}
		
		public function get position():Position 
		{
			return new Position(this.x, this.y);
		}
		
		public function set position(value:Position):void 
		{
			_position = value;
			this.x = value.x;
			this.y = value.y;
		}
		
	}

}