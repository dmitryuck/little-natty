package game.ui
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.core.ComponentEvent;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	
	public class Button extends Component
	{
		public var normalState:String;
		public var downState:String;
		public var disabledState:String;
		
		public var text:Text;
		
		private var _enabled:Boolean = true;
		
		public var buttonClick:Function;
		
		
		public function Button(fileName:String, name:String, buttonClick:Function = null, text:Text = null, downState:String = "", disabledState:String = "")
		{
			super(fileName, name);			
			
			this.normalState = fileName;
			this.downState = downState;
			this.disabledState = disabledState;
			
			this.buttonClick = buttonClick;
			
			this.text = text;			
		}
		
		// Кнопка создана
		override protected function onCreate(e:ComponentEvent):void 
		{
			super.onCreate(e);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			addEventListener(MouseEvent.CLICK, onClick);			
			
			if (text)
			{
				text.x = this.width / 2 - text.width / 2;
				text.y = this.height / 2 - text.height / 2;
				
				addChild(text);
				
				
				trace(text.x);
				trace(text.y);
			}
		}
		
		// Кнопка удалена
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
			
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		// Кнопка нажата
		protected function onMouseDown(e:MouseEvent):void 
		{
			if (enabled && downState) setSource(downState);
		}
		
		// Кнопка отпущена
		protected function onMouseUp(e:MouseEvent):void 
		{
			if (enabled && fileName != normalState) setSource(normalState);
		}
		
		// НАжатие на кнопку
		protected function onClick(e:MouseEvent):void 
		{			
			if (enabled && buttonClick != null) buttonClick();
		}
		
		// Установка свойств
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			if (value && disabledState)
			{
				setSource(normalState); 
				//addEventListener(MouseEvent.CLICK, onClick);
			} else
			{
				setSource(disabledState);
				//removeEventListener(MouseEvent.CLICK, onClick);
			}
			
			_enabled = value;
		}
		
	}
}