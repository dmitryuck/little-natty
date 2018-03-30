package game.core 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Denis 'Jack' Vinogradsky
	 */
	public class AnimationController 
	{
		private var _owner:MovieClip;
		protected var _fps:int = 30;
		protected var _frameKoef:Number = 1000 / 30;
		protected var _forvard:Number = 1;//forvard=1,reverse=-1
 
		protected var _startPauseTime:Number ;
		protected var _paused:Boolean = false;
 
		////////Current play params
		protected var _started:Boolean = false;
		protected var _toFrame:int = 0;
		protected var _frames:int;
		protected var _startFrame:int = 0;
		protected var _startTime:int = 0;
		protected var _loop:Boolean = false;
 
		protected var _linkedAnimation:Array = null;
 
		public var onEnd:Function = null;
 
 
		protected var _labels:Dictionary = null;
 
		protected function collectLabels():void
		{
			if (!_labels)
			{
				_labels = new Dictionary();
				var labels:Array = _owner.currentLabels;
				var o:Object=null;
				for (var i:uint = 0; i < labels.length; i++) {
					var label:FrameLabel = labels[i];
					if (o)
						o.end = label.frame-1;
					o = { name:label.name, start:label.frame };
					_labels[label.name] = o;
 
				}	
				if(o)
					o.end = owner.totalFrames;
			}
 
		}
		
		/**
		 * 
		 * @param	owner - казатель на объект с анимацией
		 * @param	fps -  оригинальный fps из настроек Flash IDE
		 */
		public function AnimationController(owner:MovieClip,fps:int=30) 
		{
			_owner = owner;
			_owner.stop();
			this.fps = fps;
			collectLabels();
		}
		
		/**
		 * На всякий случай:) Принудительная очистка контроллера
		 */
		public function release():void
		{
			stopUpdate();
			_owner = null;
		}
		
		/**
		 * Остановить текущую аниамцию
		 */
		public function stop():void
		{
			if (!_started) return;
			
			_started = false;
			
			stopUpdate();
			
			if (onEnd != null)
			{
				onEnd();
				onEnd = null;
			}
		}
		
		/**
		 * Проигрывать интервал анимации в цикле, заданный номерами кадров.
		 * @param	toFrame Номер кадра конца интервала анимации. Может быть меньше, чем номер первого кадра - тогда анимация будт играться в обратную сторону
		 * @param	startFrame Номер первого кадра анимации. 
		 * @param	onEnd callback завершения, функция с сигнатурой function ():void
		 */
		public function playToLoop(toFrame:Number = 0,startFrame:Number=0,onEnd:Function=null):void
		{
			sysPlay(toFrame, startFrame, true,onEnd);
		}
		
		/**
		 * Проигрывать интервал анимации заданный номерами кадров.
		 * @param	toFrame Номер кадра конца интервала анимации. Может быть меньше, чем номер первого кадра - тогда анимация будт играться в обратную сторону
		 * @param	startFrame Номер первого кадра анимации. 
		 * @param	onEnd callback завершения, функция с сигнатурой function ():void
		 */
		public function playTo(toFrame:Number = 0,startFrame:Number=0,onEnd:Function=null):void
		{
			sysPlay(toFrame, startFrame, false,onEnd);
		}
		
		/**
		 * Проверка наличия кадра с заданным именем.
		 * @param	name Название кадра
		 * @return true- если такой кадр есть
		 */
		public function hasLabel(name:String):Boolean
		{
			var o:Object = _labels[name];
			return o != null;
		}
		
		/**
		 * Проигрывает "именованную" поданимацию. Под этим подразумивается последовательность кадров от именованного кадра до следующего именованного кадра или конца анимации
		 * @param	name Имя кадра. Если name=null, то проигрывается полная анимация
		 * @param	onEnd callback завершения, функция с сигнатурой function ():void
		 * @return Возвращает false, если нет анимации с таким именем.
		 */
		public function play(name:String=null,onEnd:Function=null):Boolean
		{
			if (!name)
			{
				sysPlay(1, _owner.totalFrames, false,onEnd);
			}
			else
			{
				var o:Object = _labels[name];
				
				if (!o) return false;
				
				sysPlay(o.end, o.start, false,onEnd);
			}
			return true;
		}
		
		/**
		 * Аналогично play, но проигрывает аниамцию наоборот
		 * @param	name Имя кадра. Если name=null, то проигрывается полная анимация
		 * @param	onEnd callback завершения, функция с сигнатурой function ():void
		 * @return Возвращает false, если нет анимации с таким именем.
		 */
		public function playReverse(name:String=null,onEnd:Function=null):Boolean
		{
			if (!name)
			{
				sysPlay(_owner.totalFrames, 1, false,onEnd);
			}
			else
			{
				var o:Object = _labels[name];
				if (!o)
					return false;
				sysPlay(o.start, o.end, false,onEnd);
			}
			return true;
		}
		
		/**
		 * Анологично play, но проигрывает аниамцию в цикле
		 * @param	name Имя кадра. Если name=null, то проигрывается полная анимация
		 * @param	onEnd callback завершения, функция с сигнатурой function ():void
		 * @return Возвращает false, если нет анимации с таким именем.
		 */
		public function playLoop(name:String=null,onEnd:Function=null):Boolean
		{
			if (!name)
			{
				sysPlay(1, _owner.totalFrames, true,onEnd);
			}
			else
			{
				var o:Object = _labels[name];
				if (!o)
					return false;
				sysPlay(o.end, o.start, true,onEnd);
			}
			return true;
		}
		
		/**
		 * Анологично play, но проигрывает аниамцию в цикле и наоборот
		 * @param	name Имя кадра. Если name=null, то проигрывается полная анимация
		 * @param	onEnd callback завершения, функция с сигнатурой function ():void
		 * @return Возвращает false, если нет анимации с таким именем.
		 */
		public function playReverseLoop(name:String=null,onEnd:Function=null):Boolean
		{
			if (!name)
			{
				sysPlay(_owner.totalFrames, 1, true,onEnd);
			}
			else
			{
				var o:Object = _labels[name];
				if (!o)
					return false;
 
				sysPlay(o.start, o.end, true,onEnd);
			}
			return true;
		}
 
		/**
		 * Связать с другой анимацией. Принимает клип. Анимация связной анимацией будет управляться этим же контроллером
		 * @param	clip указатель на MoviClip с подключаемой анимацией
		 */
		public function linkAnimation(clip:MovieClip):void
		{
			if (!_linkedAnimation)
				_linkedAnimation = new Array();
			_linkedAnimation.push(clip);
			clip.gotoAndStop(_owner.currentFrame);
		}
		
		/**
		 * Автоматически связывает все дочернии клипы.
		 * @param	parent Контейнер, дочернии элементы которого надо привязать. По умолчанию(null), основной клип контроллера.
		 */
		public function linkAllChildAnimation(parent:MovieClip=null):void
		{
 
			if (parent == null)
			{
				parent = _owner;
			}
			else
			{
				linkAnimation(parent);
			}
			sysLinkAllChild(_owner);
		}
		
		private function sysLinkAllChild(o:DisplayObjectContainer):void
		{
			var n:int = o.numChildren;
			for (var i:int = 0; i < n; i++)
			{
				var doc:DisplayObjectContainer = o.getChildAt(i) as DisplayObjectContainer;
				var no:MovieClip = doc as MovieClip;
				if (no&&no.totalFrames>1)
					linkAnimation(no);
				if(doc)
					sysLinkAllChild(doc);
			} 
		}
		
		private function startUpdate():void
		{
			_owner.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
 
		private function stopUpdate():void
		{
			_owner.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (_paused) return;
			
			var tm:int = getTimer();
			
			if (_started)
			{ 
				var time:Number = tm - _startTime;
				var frame:int = (int(time / _frameKoef + .5) * _forvard);
				if (_loop)
				{
					frame = frame % (_frames + 1) + _startFrame; 
				}
				else
				{
					frame = frame  + _startFrame; 
 
					if ((_forvard==1&&frame >= _toFrame) || (_forvard==-1&&frame <= _toFrame))
					{
						frame = _toFrame;
						stop();
					}
				}
				_owner.gotoAndStop(frame );
				if (_linkedAnimation)
				{
					for each(var mc:MovieClip in _linkedAnimation)
						mc.gotoAndStop(frame);
				}
			}
		}
		
		private function sysPlay(toFrame:Number , startFrame:Number , loop:Boolean ,onEnd:Function):void
		{
			this.onEnd = onEnd;
			_loop = loop;
			if (toFrame == 0)
				toFrame = _owner.totalFrames;
			_toFrame = toFrame;
			_startFrame = startFrame;
 
			if (_startFrame > 0)
				_owner.gotoAndStop(_startFrame);
			else
			{
				_startFrame = _owner.currentFrame;
				if (_startFrame == toFrame)
				{
					_startFrame = 1;
					_owner.gotoAndStop(1);
				}				
			}
			_frames = _toFrame-_startFrame;
			if (_frames>0)
			{
				_forvard = 1; 
			}
			else
			{
				_forvard = -1;
				_frames = -_frames;
			}
			_startTime = getTimer();
			if(!_started)
				startUpdate();
			_started = true;
		}
 
		///Указатель на клип, которым управлет контроллер
		public function get owner():MovieClip { return _owner; }
 
		public function get fps():int { return _fps; }
 
		public function set fps(value:int):void 
		{
			_fps = value;
			_frameKoef = 1.0 / Number(value) * 1000.0;
		}
		
		public function get paused():Boolean { return _paused; }
		
		///Включение/выключение паузы
		public function set paused(value:Boolean):void 
		{
			if (_paused != value)
			{
				if (value)
				{
					_startPauseTime = getTimer();
				}
				else
				{
					var d:int = getTimer() - _startPauseTime;
					_startTime += d;
				}
			}
			_paused = value;
		}
		
		///Количество именованных анимаций
		public function get labelsCount():int
		{
			return _owner.currentLabels.length;
		}
		
		///Ассоциативный массив именованных анимаций. Ключ- имя анимации(кадра), значение - объект с полями:name-имя анимации, start -стартовый кадр анимации, end-конечный кадр анимации.
		public function get labels():Dictionary { return _labels; }
	}
}