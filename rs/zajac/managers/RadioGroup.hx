package rs.zajac.managers;
import rs.zajac.ui.RadioButton;
import nme.events.Event;
import nme.events.EventDispatcher;

/**
 * used by radio buttons, but can be used outside radiobuttons to listen change events.
 * When radiobutton have set groupName radiobutton add self to radiobutton group. RadioGroup stores all buttons
 * for each group, and when one radiobutton is selected they go through all buttons from the same group and set them
 * selected state to false
 * 
 * You can listen radio group to event with name like radiogroup name. This event will be dispatched when selected button
 * on that group is changed.
 * 
 * @author Ilic S Stojan
 */

class RadioGroup extends EventDispatcher{

	private static var _instance:RadioGroup;
	
	private var _groups:Dynamic;
	
	private function new() {
		super();
		_groups = {};
	}
	
	public static function gi():RadioGroup {
		if (_instance == null) _instance = new RadioGroup();
		return _instance;
	}
	
	public function addButton(button:RadioButton, groupName:String):Void {
		var c_group:Array<RadioButton>;
		if (Reflect.hasField(_groups, groupName)) {
			c_group = Reflect.getProperty(_groups, groupName);
		}else {
			c_group = new Array<RadioButton>();
			Reflect.setProperty(_groups, groupName, c_group);
		}
		
		//TODO: check if button already exist in this group
		button.addEventListener(Event.CHANGE, onButtonSelected);
		c_group.push(button);
	}
	
	public function removeButton(button:RadioButton, ?groupName:String):Void {
		var c_group:Array<RadioButton>;
		
		button.removeEventListener(Event.CHANGE, onButtonSelected);
		
		if (Reflect.hasField(_groups, button.groupName)) {
			c_group = Reflect.getProperty(_groups, button.groupName);
			c_group.remove(button);
		}
	}
	
	//TODO: test clear group
	/**
	 * remove all buttons registered to current group
	 * @param	name - group name
	 */
	public function clearGroup(name:String):Void {
		var c_group:Array<RadioButton>;
		
		if (Reflect.hasField(_groups, name)) {
			c_group = Reflect.getProperty(_groups, name);
			while (c_group.length > 0) c_group.pop().removeEventListener(Event.CHANGE, onButtonSelected);
		}
		
		Reflect.deleteField(_groups, name);
		
	}
	
	
	
	
	
	private function onButtonSelected(e:Event):Void {
		var c_group:Array<RadioButton>;
		var i:Int;
		var c_button:RadioButton = cast(e.currentTarget, RadioButton);
		
		if (c_button == null || c_button.selected == false) return;
		
		if (Reflect.hasField(_groups, c_button.groupName)) c_group = Reflect.getProperty(_groups, c_button.groupName)
			else c_group = null;
		
		if (c_group == null) return;
		
		for (i in 0...c_group.length) {
			if (c_group[i] == c_button) continue;
			c_group[i].selected = false;
		}
		
		dispatchEvent(new Event(c_button.groupName) );
	}
	
	
	
}