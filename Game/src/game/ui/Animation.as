package game.ui 
{
	import flash.display.MovieClip;
	import game.core.AnimationController;
	import game.core.ComponentEvent;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Animation extends Component 
	{
		public var animationController:AnimationController;
		
		public function Animation(fileName:String, frameLabel:String, loop:Boolean = true, onEnd:Function = null) 
		{
			super(fileName);
			
			addEventListener(ComponentEvent.COMPONENT_LOADED, onLoaded);
			
			function onLoaded(e:ComponentEvent):void
			{
				removeEventListener(ComponentEvent.COMPONENT_LOADED, onLoaded);
				
				playAnimation(frameLabel, loop, onEnd);
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Управление анимацией
		// Проиграть анимацию
		public function playAnimation(frameLabel:String, loop:Boolean = true, onEnd:Function = null):void
		{
			if (displayObject is MovieClip)
			{				
				if (!animationController) animationController = new AnimationController(MovieClip(displayObject));
				
				if (loop) animationController.playLoop(frameLabel, onEnd); else animationController.play(frameLabel, onEnd);
			}
		}
		
		// Остановить проигрываемую анимацию
		public function stopAnimation():void
		{
			//if (animationController) {
				//trace("works only with trace()");
				animationController.stop();
			//}
		}		
		
	}

}