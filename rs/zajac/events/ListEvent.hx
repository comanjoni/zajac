package rs.zajac.events;
import nme.events.Event;

/**
 * Events dispatched from List component.
 * @author Aleksandar Bogdanovic
 */
class ListEvent extends Event {

	inline public static var SELECT: String = 'SELECT';
	
	/**
	 * Data created (selected) in this event.
	 */
	public var data(default, null): Dynamic;
	
	public function new(type: String, bubbles: Bool = false, cancelable: Bool = false, data: Dynamic = null) {
		super(type, bubbles, cancelable);
		this.data = data;
	}
	
}