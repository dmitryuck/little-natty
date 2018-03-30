package game.ui 
{
	import flash.display.Sprite;
	import game.core.Position;
	import game.core.Size;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Window extends Component 
	{
		
		public function Window(fileName:String, name:String) 
		{
			super(fileName, name);			
		}
		
		// Добавить новый компонент
		public function addComponent(component:Component):Component
		{
			return Component(this.addChild(component));
		}
		
		// Удалить компонент
		public function removeComponent(component:Component):void
		{
			if (component) this.removeChild(component);
		}
		
		// Получить компонент по имени
		public function getComponentByName(name:String):Component
		{
			return Component(this.getChildByName(name));
		}
		
		// Скрыть компонент
		public function hideComponent(component:Component):void
		{
			if (component && component.visible) component.visible = false;
		}
		
		// Показать компонент
		public function showComponent(component:Component):void
		{
			if (component && !component.visible) component.visible = true;
		}
		
		// Скрыть окно
		public function hideWindow():void
		{
			if (this.visible) this.visible = false;
		}
		
		// Показать окно
		public function showWindow():void
		{
			if (!this.visible) this.visible = true;
		}		
		
	}

}