package rs.zajac.util;
import rs.zajac.ui.BaseComponent;
import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;
import nme.display.Stage;
import nme.geom.Point;

/**
 * Set of methods for measuring display components.
 * @author Aleksandar Bogdanovic
 */
class ComponentUtil {

	private function new() { }
	
	/**
	 * Get size of component. Support 3 types of components:
	 * <ul>
	 * <li>- BaseComponent</li>
	 * <li>- Stage</li>
	 * <li>- Other DisplayObject</li>
	 * </ul>
	 * @param	obj	Component for measuring.
	 * @return	Point containing size: x = width, y = height.
	 */
	static public function size(obj: DisplayObject): Point {
		if (Std.is(obj, BaseComponent)) {
			var b: BaseComponent = cast(obj);
			return new Point(b.Width, b.Height);
		}
		
		if (Std.is(obj, Stage)) {
			var s: Stage = cast(obj);
			return new Point(s.stageWidth, s.stageHeight);
		}
		
		return new Point(obj.width, obj.height);
	}
	
	/**
	 * Minimal size of rect that wraps all visible components in container.
	 * @param	container
	 * @return	Point containing size: x = width, y = height.
	 */
	static public function visibleContentSize(container: DisplayObjectContainer): Point {
		var c_total: Point = new Point(0, 0);
		var c_size: Point;
		var c_obj: DisplayObject;
		
		for (i in 0...container.numChildren) {
			c_obj = container.getChildAt(i);
			if (c_obj.visible) {
				c_size = size(c_obj);
				c_total.x = Math.max(c_total.x, c_obj.x + c_size.x);
				c_total.y = Math.max(c_total.y, c_obj.y + c_size.y);
			}
		}
		
		return c_total;
	}
	
}