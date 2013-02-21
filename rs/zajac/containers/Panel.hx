package rs.zajac.containers;
#if code_completion

/**
 * Panel consists of content for children and vertical and horisontal scrolls.
 * It should be used to wrap top-level application modules.
 * @author Aleksandar Bogdanovic
 */
class Panel extends rs.zajac.ui.StyledComponent {
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************

	/**
	 * Styled property defining panel background color.
	 */
	var backgroundColor: Int;
	
	/**
	 * Styled proerty defining panel background alpha.
	 */
	var backgroundAlpha: Float;
	
	/**
	 * Styled property defining panel border color. If it's null
	 * border will not be drawn.
	 */
	var borderColor: Null<Int>;
	
	/**
	 * Styled property defining size of scroll.
	 * Width of vertical scroll and height of horizontal scroll.
	 */
	var scrollSize: Float;
	
	/**
	 * Returns instance of vertical scroll.
	 */
	var verticalScroll: rs.zajac.ui.Scroll;
	
	/**
	 * Returns instance of horizontal scroll.
	 */
	var horizontalScroll: rs.zajac.ui.Scroll;
	
	/**
	 * Scrolling step size for one mouse wheel event.
	 */
	var mouseWheelStep: Float;
	
	/**
	 * Position and size of content for children.
	 */
	public var contentRect(get_contentRect, null): nme.geom.Rectangle;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	/**
	 * Update scroll rectangle bounds of content for children. 
	 */
	function updateScrollRect(): Void;
	
	/**
	 * Set scroll flag to dirty state so it can be updated in next frame.
	 */
	function invalidScroll(): Void;
	
}

#elseif mobile
typedef Panel = rs.zajac.containers.mobile.Panel;
#else
typedef Panel = rs.zajac.containers.desktop.Panel;
#end