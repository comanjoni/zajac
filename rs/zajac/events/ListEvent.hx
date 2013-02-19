package be.zajac.events;
import nme.events.Event;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class ListEvent extends Event {

	inline public static var SELECT: String = 'le_select';
	
	public var data(default, null): Dynamic;
	
	public function new(type: String, bubbles: Bool = false, cancelable: Bool = false, data: Dynamic = null) {
		super(type, bubbles, cancelable);
		this.data = data;
	}
	
}