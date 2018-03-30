package game.core 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Position extends Point 
	{
		
		public function Position(x:int = 0, y:int = 0, point:Point = null) 
		{
			super(x, y);
			
			if (point)
			{
				this.x = point.x;
				this.y = point.y;
			}
		}		
		
	}

}