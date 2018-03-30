package game.ui
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class VerticalScrollbar extends Sprite
	{		
		public static const PRESSED:String = "pressed";
		public static const RELEASED:String = "released";
		public static const SCROLLING:String = "scrolling";
		
		private var thumb:Sprite;
		private var track:Sprite;
		private var window:Sprite;
		private var content:Sprite;
		private var up:Sprite;
		private var down:Sprite;
		
		private var yOffset:Number;
		private var topLimit:Number;
		private var thumbRange:Number;
		private var bottomLimit:Number;
		private var _scrollPercent:Number;
		private var contentRange:Number;
		private var speed:Number
		private var wheelSpeed:Number;
		
		
		public function VerticalScrollbar(thumb:Sprite,
															track:Sprite,
															window:Sprite = null,
															content:Sprite = null,
															up:Sprite = null,
															down:Sprite = null)
		{
			this.thumb = thumb;
			this.track = track;
			this.window = window;
			this.content = content;
			this.up = up;
			this.down = down;
			
			yOffset = 0;
			topLimit = this.track.y;
			thumbRange = track.height - thumb.height;
			bottomLimit = track.y + thumbRange;
			if(content && window) contentRange = content.height - window.height;
			_scrollPercent = 0;
			speed = 0.01;
			wheelSpeed = 0.02;
			
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumb_onMouseDown);
			if(down) down.addEventListener(MouseEvent.MOUSE_DOWN, down_onMouseDown);
			if (up) up.addEventListener(MouseEvent.MOUSE_DOWN, up_onMouseDown);
			//turn on mouse wheel by default (calls the class's public setter method, below)
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
		}
		
		public function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			this.wheelEnabled = true;
			
			//content.addChild(window);
			
			window.addChild(up);
			//up.x = window.width - up.width;
			
			window.addChild(down);
			
			window.addChild(thumb);
			
			addChild(window);
			addChild(content);
			
		}
		
		private function stage_onMouseWheel(event:MouseEvent):void
		{
			_scrollPercent -= event.delta * wheelSpeed;
			//set boundaries:
			if (_scrollPercent > 1) _scrollPercent = 1;
			if (_scrollPercent < 0) _scrollPercent = 0;
			if(content && window) content.y = window.y - (_scrollPercent * contentRange);
			thumb.y = _scrollPercent * thumbRange + track.y;
			
			dispatchEvent(new Event(VerticalScrollbar.SCROLLING));
		}
		private function thumb_onMouseDown(event:MouseEvent):void
		{
			yOffset = thumb.parent.mouseY - thumb.y;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
			
			dispatchEvent(new Event(VerticalScrollbar.PRESSED));
		}
		
		private function stage_onMouseMove(event:MouseEvent):void {
			thumb.y = thumb.parent.mouseY - yOffset;
			//restrict the movement of the thumb:
			if (thumb.y < topLimit) thumb.y = topLimit;
			if (thumb.y > bottomLimit) thumb.y = bottomLimit;
			//calculate scrollPercent and make it do stuff:
			_scrollPercent = (thumb.y - track.y) / thumbRange;
			if(content && window) content.y = window.y - (_scrollPercent * contentRange);
			event.updateAfterEvent();
			
			dispatchEvent(new Event(VerticalScrollbar.SCROLLING));
		}
		
		private function stage_onMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
			
			dispatchEvent(new Event(VerticalScrollbar.RELEASED));
		}
		
		private function down_onMouseDown(event:MouseEvent):void
		{
			stage.addEventListener(Event.ENTER_FRAME, scrollDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopScrollingDown);
			
			dispatchEvent(new Event(VerticalScrollbar.PRESSED));
		}
		
		private function scrollDown(event:Event):void
		{
			_scrollPercent += speed;
			if(_scrollPercent > 1) _scrollPercent = 1;
			if(content && window) content.y = window.y - (_scrollPercent * contentRange);
			thumb.y = _scrollPercent * thumbRange + track.y;
			
			dispatchEvent(new Event(VerticalScrollbar.SCROLLING));
		}
		
		private function stopScrollingDown(event:MouseEvent):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, scrollDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopScrollingDown);
			
			dispatchEvent(new Event(VerticalScrollbar.RELEASED));
		}
		
		function up_onMouseDown(event:MouseEvent):void 
		{
			stage.addEventListener(Event.ENTER_FRAME, scrollUp)
			stage.addEventListener(MouseEvent.MOUSE_UP, stopScrollingUp);
			
			dispatchEvent(new Event(VerticalScrollbar.PRESSED));
		}
		
		private function scrollUp(event:Event):void
		{
			_scrollPercent -= speed;
			if(_scrollPercent < 0)_scrollPercent = 0;
			if(content && window) content.y = window.y - (_scrollPercent * contentRange);
			thumb.y = _scrollPercent * thumbRange + track.y;
			
			dispatchEvent(new Event(VerticalScrollbar.SCROLLING));
		}
		
		private function stopScrollingUp(event:MouseEvent):void 
		{
			stage.removeEventListener(Event.ENTER_FRAME, scrollUp)
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopScrollingUp);
			
			dispatchEvent(new Event(VerticalScrollbar.RELEASED));
		}
		
		public function get scrollPercent():Number 
		{
			return _scrollPercent;
		}
		
		public function setVisible(value:Boolean):void
		{
			thumb.visible = value;
			track.visible = value;
			
			if (up) up.visible = value;
			if (down) down.visible = value;
		}
		
		public function isVisible():Boolean
		{
			return (track.visible && thumb.visible);
		}
		
		public function reset():void
		{
			thumb.y = track.y;
			if (content && window) content.y = window.y;
			_scrollPercent = 0;
		}
		
		public function set wheelEnabled(value:Boolean):void 
		{
			if (value == true) {
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, stage_onMouseWheel);
			} else {
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL, stage_onMouseWheel);
			}
		}
	}
}