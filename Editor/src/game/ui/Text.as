package game.ui 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Monkgol
	 */
	public class Text extends TextField 
	{
		public var textFormat:TextFormat; 
		
		public function Text(text:String, font:String = null, size:Object = null, color:Object = null, selectable:Boolean = false, multiline:Boolean = false) 
		{
			textFormat = new TextFormat(font, size, color, true);		
			
			this.text = text;
			
			this.selectable = selectable;
			this.multiline = multiline;
			//this.embedFonts = true;
			this.setTextFormat(textFormat);			
		}
		
	}

}