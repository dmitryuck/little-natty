package game.ui 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import game.core.ComponentEvent;
	/**
	 * ...
	 * @author Monkgol
	 */
	public class SelectBox extends Button 
	{
		public var contentSpr:Sprite;		
		
		public var upBtn:Button;
		public var downBtn:Button;
		public var thumbBtn:Button;
		
		public var valueBtn:Button
		
		public var trackCmp:Component;		
		public var windowCmp:Component;		
		
		public var data:Object;
		public var textStyle:Object;
		
		public var textCmp:Text;
		
		public var values:Array;
		//public var text:String;
		
		public var boxVisible:Boolean;
		
		public var scroll:Sprite;
		
		
		public function SelectBox(values:Array,
		
												  normalState:String,
												  downState:String,
												  
												  upBtn:Button,
												  downBtn:Button,
												  thumbBtn:Button,
												  
												  valueBtn:Button,
												  
												  trackCmp:Component,												  
												  windowCmp:Component,	
												  
												  disabledState:String = null)
		{
			super(normalState, downState, boxClick, null, disabledState);
			
			this.values = values;
			
			this.normalState = normalState;
			this.downState = downState;
			this.disabledState = disabledState;
			
			this.upBtn = upBtn;
			this.downBtn = downBtn;
			this.thumbBtn = thumbBtn;
			
			this.valueBtn = valueBtn;
			
			this.trackCmp = trackCmp;
			this.windowCmp = windowCmp;			
		}		
		
		// Создание компонента
		override protected function onCreate(e:ComponentEvent):void 
		{
			super.onCreate(e);
			
			textCmp = new Text(values[0], textStyle);
			addChild(textCmp);
			
			data = new Object();			
			contentSpr = new Sprite();			
			
			for (var i:int = 0; i < values.length; i++)
			{
				var item:Button;
				
				item = new Button(valueBtn.normalState, valueBtn.downState, null, new Text(values[i], textStyle));
				
				item.addEventListener(MouseEvent.CLICK, onValueClick);
				//item.addEventListener(Event.ADDED_TO_STAGE, onValueBtnLoaded);
				
				//function onValueBtnLoaded(e:ComponentEvent):void
				//{				
					//removeEventListener(ComponentEvent.COMPONENT_LOADED, onValueBtnLoaded);
					
					contentSpr.addChild(item);
				
					//item.y = item.height * i;
					item.y = 20 * i;
				
					data[values[i]] = item;
				//}
			}
			
			//scroll = new VerticalScrollbar(thumbBtn, trackCmp, windowCmp, contentSpr, upBtn, downBtn);			
			//scroll.y = this.height;
			//scroll.visible = false;
		}
		
		// Нажатие на значение из списка
		public function onValueClick(e:MouseEvent):void
		{
			//this.text = TextField(e.target).text;
			
			//setText(text);
		}
		
		// Удаление компонента
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
			
			// Очистка событий нажатия на кнопки
			
			for each (var btn:Button in data)
			{
				if (btn)
				{
					btn.removeEventListener(MouseEvent.CLICK, onValueClick);
					btn = null;
				}
			}
			
			data = null;
			textStyle = null;
		}		
		
		// Раскрыть/закрыть селект бокс
		public function boxClick():void
		{
			if (!scroll.parent) addChild(scroll);
			else windowCmp.visible = !windowCmp.visible;			
		}
		
	}

}