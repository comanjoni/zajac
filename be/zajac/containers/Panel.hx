package be.zajac.containers;
#if code_completion

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class Panel extends be.zajac.ui.StyledComponent {

	var backgroundColor: Int;
	var backgroundAlpha: Float;
	var borderColor: Int;
	
	var mouseWheelStep: Float;
	
	var elasticEdges: Bool;
	
	var content(default, null): nme.display.Sprite;
	var verticalSlider(default, null): be.zajac.ui.Slider;
	var horizontalSlider(default, null): be.zajac.ui.Slider;
	
	function getContentSize(): nme.geom.Point;
	
	function updateScrollRect(): Void;
	
	function invalidScroll(): Void;
	
}

#elseif (android || ios)
typedef Panel = be.zajac.containers.mobile.Panel;
#else
typedef Panel = be.zajac.containers.desktop.Panel;
#end