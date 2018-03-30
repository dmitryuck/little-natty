package editor 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import game.core.Game;
	import mx.containers.Box;
	import mx.containers.HBox;
	import mx.containers.TitleWindow;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.controls.TextInput;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Options extends TitleWindow 
	{
		public var options:Box;
		
		public var cmb_script:ComboBox;
		
		public var lbl_name:Label;
		public var lbl_script:Label;
		
		public var txt_name:TextInput;
		
		
		public function Options()
		{			
			label = "Options";
			width = 400;
			height = 280;
			
			options = new Box();
			
			// Установка скрипта сцены
			lbl_script = new Label();
			lbl_script.text = "Script";
			
			cmb_script = new ComboBox();
			cmb_script.addEventListener(Event.CHANGE, onScriptChange);
			
			cmb_script.dataProvider = Main.inspector.classList;
			
			for (var i:int = 0; i < Main.inspector.classList.length; i++)
			{
				if (!Game.scene.script) cmb_script.selectedIndex = 0; else
				if (Game.scene.script == Main.inspector.classList[i]) cmb_script.selectedIndex = i;
			}
			
			var script_box:HBox = new HBox();
			script_box.addElement(lbl_script);
			script_box.addElement(cmb_script);
			
			options.addElement(script_box);			
			
			// Установка имени сцены
			lbl_name = new Label();
			lbl_name.text = "Name";
			
			txt_name = new TextInput();
			txt_name.text = Game.scene.name.search("instance") != 0 ? Game.scene.name : "";
			txt_name.addEventListener(KeyboardEvent.KEY_DOWN, onNameChange);
			
			var name_box:HBox = new HBox();
			name_box.addElement(lbl_name);
			name_box.addElement(txt_name);
			
			options.addElement(name_box);
			
			// Добавить контролы на форму
			addElement(options);			
		}
		
		private function onNameChange(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				Game.scene.name = txt_name.text;
				txt_name.text = Game.scene.name;
				
				options.setFocus();
			}
		}
		
		private function onScriptChange(e:Event):void 
		{
			Game.scene.script = cmb_script.selectedItem as String;
		}
		
	}

}