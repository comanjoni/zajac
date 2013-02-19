package rs.zajac.containers;
#if code_completion

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class Panel extends rs.zajac.ui.StyledComponent {
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************

	var backgroundColor: Int;
	var backgroundAlpha: Float;
	var borderColor: Null<Int>;
	var scrollSize: Float;
	
	var verticalScroll: rs.zajac.ui.Scroll;
	var horizontalScroll: rs.zajac.ui.Scroll;
	
	var mouseWheelStep: Float;
	
	public var contentRect(get_contentRect, null): nme.geom.Rectangle;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	function updateScrollRect(): Void;
	
	function invalidScroll(): Void;
	
}

#elseif mobile
typedef Panel = rs.zajac.containers.mobile.Panel;
#else
typedef Panel = rs.zajac.containers.desktop.Panel;
#end