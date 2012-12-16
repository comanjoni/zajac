package be.zajac.renderers;
import be.zajac.core.FWCore;
import be.zajac.ui.BaseComponent;
import nme.Assets;
import nme.display.DisplayObject;
import nme.display.Graphics;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFieldType;
import nme.text.TextFormat;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class ListItemRenderer extends AbstractListItemRenderer {

	public var textField(default, null): TextField;
	
	public function new() {
		super();
	}
	
	override public function initialize(): Void {
		super.initialize();
		
		textField = new TextField();
		textField.wordWrap = false;
		textField.background = false;
		textField.height = 20;
		textField.border = false;
		textField.mouseEnabled = false;
		textField.type = TextFieldType.DYNAMIC;
		addChild(textField);
	}
	
	override public function draw(client: BaseComponent, states:Hash<DisplayObject>): Void {
		var c_client: ListItemRenderer = cast(client);
		var c_textField: TextField = c_client.textField;
		var c_font: Font;
		var c_format: TextFormat;
		var c_gr: Graphics = c_client.graphics;
		
		#if (cpp || neko)
			c_format = c_textField.defaultTextFormat;
		#else
			c_format = c_textField.getTextFormat();
		#end
		
		c_format.color = 0xffffff;
		c_format.size = 12;

		c_font = Assets.getFont('Arial');
		if (c_font != null) {
			c_format.font = c_font.fontName;
			c_textField.embedFonts = true;
		}
		
		c_textField.defaultTextFormat = c_format;
		c_textField.width = c_client.Width;
		c_textField.height = c_client.Height;
		c_textField.text = c_client.data;
		
		c_gr.beginFill(0xff0000);
		c_gr.drawRect(0, 0, c_client.Width, c_client.Height - 1);
		c_gr.endFill();
	}
	
}