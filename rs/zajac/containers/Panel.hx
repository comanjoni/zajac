package be.zajac.containers;
#if code_completion

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class Panel extends be.zajac.ui.StyledComponent {
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************

	var backgroundColor: Int;
	var backgroundAlpha: Float;
	var borderColor: Null<Int>;
	var scrollSize: Float;
	
	var verticalScroll: be.zajac.ui.Scroll;
	var horizontalScroll: be.zajac.ui.Scroll;
	
	var mouseWheelStep: Float;
	
	public var contentRect(get_contentRect, null): nme.geom.Rectangle;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	function updateScrollRect(): Void;
	
	function invalidScroll(): Void;
	
}

#elseif (android || ios)
typedef Panel = be.zajac.containers.mobile.Panel;
#else
typedef Panel = be.zajac.containers.desktop.Panel;
#end