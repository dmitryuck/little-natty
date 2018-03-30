package game.core 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Grid extends Sprite 
	{
		// Ширина и высота клеточки сетки
		private var size:Size;		
		
        private var points:Vector.<Point>;
		
		private var rows:int;
		private var cols:int;
		
		private var scene:Scene;
		
		private var displayObject:Shape;
		
		public var enabled:Boolean;
		
		public static const GRID_SIZE_16:String = "GRID_SIZE_16";
		public static const GRID_SIZE_32:String = "GRID_SIZE_32";
		public static const GRID_SIZE_64:String = "GRID_SIZE_64";
		
		public function Grid(scene:Scene) 
		{
			addEventListener(Event.ADDED_TO_STAGE, onCreate);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			
			this.scene = scene;
			
			points = new Vector.<Point>();
			
			setSize(Grid.GRID_SIZE_32);
			
			createGrid();			
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// События связанные со сценой
		protected function onCreate(e:Event):void
		{			
			removeEventListener(Event.ADDED_TO_STAGE, onCreate);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		protected function onMouseDown(e:MouseEvent):void 
		{
		}
		
		protected function onUpdate(e:Event):void
		{
		}
		
		protected function onDestroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeEventListener(Event.ENTER_FRAME, onUpdate);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function calcRowsCols():void
		{
			rows = Math.floor(scene.height / size.height);
			cols = Math.floor(scene.width / size.width);
		}		
		
		// Создать сетку
		public function createGrid():void
		{
			enabled = true;			

			drawGrid();
			buildPoints();
		}
		
		// Удалить сетку
		public function removeGrid():void
		{
			enabled = false;
			
			eraseGrid();
			removePoints();
		}		
         
		// Построить вектор точек
		private function buildPoints():void
		{
			calcRowsCols();
			
			for (var r:uint = 0; r < rows; r++)
			{ 
				for (var c:uint = 0; c < cols; c++)
				{
					var point:Point = new Point(size.width * c, size.height * r);
					points.push(point);
				}
			}
		}
		
		// Очистить вектор точек
		private function removePoints():void
		{
			rows = cols = 0;
			
			// Удалить точки пересечений
			for each (var point:Point in points)
			{
				if (point) point = null;
			}
		}
		
		// Рисовать сетку
        private function drawGrid():void
		{			
			var bgColor:uint = 0xE1E1E1;
			var lineColor:uint = 0x00000;
			
			calcRowsCols();
			
			if (!displayObject) displayObject = new Shape();
			
			displayObject.graphics.beginFill(bgColor, 1);
			displayObject.graphics.drawRect(0, 0, scene.width, scene.height);
			displayObject.graphics.endFill();
			
			displayObject.graphics.lineStyle(1, lineColor);
			

            for (var r:uint = 0; r < rows; r++)
			{
				displayObject.graphics.moveTo(0, size.height + size.height * r);
				displayObject.graphics.lineTo(scene.width, size.height + size.height * r);
            }
			
			for (var c:uint = 0; c < cols; c++)
			{
				displayObject.graphics.moveTo(size.width + size.width * c, 0);
				displayObject.graphics.lineTo(size.height + size.width * c, scene.height);					
            }
			
			addChild(displayObject);
        }
		
		// Стереть сетку
		private function eraseGrid():void
		{
			displayObject.graphics.clear();			
        }
		
		// Ближайщая точка
		public function getNearestPoint(x:Number, y:Number):Point
		{			
			var vector:Vector.<Point> = new Vector.<Point>();
			
			for each (var point:Point in points)
			{
				if (point && point.x <= x && point.y <= y) vector.push(point);
			}
			
			var pointX:Number = 0;
			var pointY:Number = 0;
			
			for each (var point1:Point in vector)
			{
				if (point1)
				{
					if (point1.x > pointX) pointX = point1.x;
					if (point1.y > pointY) pointY = point1.y;
				}
			}			
			
			// Если обьект перемещен в клеточку то переместить в угол клеточки
			if (pointX + size.width > x && pointY + size.height > y)
			{				
				return new Point(pointX, pointY);
				// Если обьект находиться в углу клеточки то вернуть координаты угла
			}	else return new Point(x, y);
			
			return new Point();
		}
		
		// Установить размер ячейки
		public function setSize(size:String):void
		{
			switch (size)
			{				
				case GRID_SIZE_16: this.size = new Size(16, 16);
				break;
				
				case GRID_SIZE_32: this.size = new Size(32, 32);
				break;
				
				case GRID_SIZE_64: this.size = new Size(64, 64);
				break;
			}
		}

		
    }
	
}