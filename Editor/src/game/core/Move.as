package game.core 
{
	import com.greensock.TweenMax;
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Move extends TweenMax 
	{
		public var moveAwake:Boolean;		
		public var freePointSelect:Boolean;
		public var isMoving:Boolean;
		
		//public var points:Vector.<MovePoint>;
		
		public function Move(target:Object, duration:Number, vars:Object) 
		{
			super(target, duration, vars);
		}		
		
		public function moveTo():void
		{
			
		}
		
		public function moveNextPoint():void
		{
			
		}
		
		public function movePrevPoint():void 
		{
			
		}
	}

}