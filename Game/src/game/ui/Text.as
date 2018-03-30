package game.ui 
{
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import game.core.ComponentEvent;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Text extends Component 
	{
		public var text:String;
		
		public var textField:TextField;
		public var textFormat:TextFormat;
		
		
		public function Text(text:String, style:Object = null) 
		{
			super(null);
			
			this.text = text;
			
			var styleSheet:StyleSheet = new StyleSheet();			
			styleSheet.setStyle("p", style);
			
			var htmlText:String = "<p>" + text + "</p>";

			textField = new TextField();
			
			for (var key:String in style)
			{
				textField.width = style["width"];
				textField.height = style["height"];
			}
			
			textField.styleSheet = styleSheet;
			textField.htmlText = htmlText;
			
			//textField.embedFonts = true;
			
			textField.selectable = false;
			textField.multiline = true;
			textField.wordWrap = true;
			
			textField.autoSize = TextFieldAutoSize.LEFT;				
			//textField.antiAliasType = AntiAliasType.ADVANCED;
			
			/*textFormat = new TextFormat();	
			
			textFormat.size = style["size"];
			textFormat.color = style["color"];
			textFormat.font = style["fontFamily"];
				
			textFormat.align = TextFormatAlign.LEFT;
			
			textField.setTextFormat(textFormat);
			
			textField.text = text;*/

			
			/*switch (style["align"])
			{
				case "left" : textField.autoSize = TextFieldAutoSize.LEFT;
				break;
				
				case "center" : textField.autoSize = TextFieldAutoSize.CENTER;
				break;
				
				default : textField.autoSize = TextFieldAutoSize.LEFT;
			}*/
			
			addChild(textField);
		}
		
		// Установить новый текст
		public function setText(text:String):void
		{
			var htmlText:String = "<p>" + text + "</p>";
			
			textField.htmlText = htmlText;
		}
		
		public function getText():String
		{
			return text;
		}
	}

}