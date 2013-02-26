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
	@style public var backgroundColor: Int;
	
	/**
	 * Styled proerty defining panel background alpha.
	 */
	@style public var backgroundAlpha: Float;
	
	/**
	 * Styled property defining panel border color. If it's null
	 * border will not be drawn.
	 */
	@style public var borderColor: Null<Int>;
	
	/**
	 * Styled property defining size of scroll.
	 * Width of vertical scroll and height of horizontal scroll.
	 */
	@style public var scrollSize: Float;
	
	/**
	 * Returns instance of vertical scroll.
	 */
	public var verticalScroll: rs.zajac.ui.Scroll;
	
	/**
	 * Returns instance of horizontal scroll.
	 */
	public var horizontalScroll: rs.zajac.ui.Scroll;
	
	/**
	 * Scrolling step size for one mouse wheel event.
	 */
	public var mouseWheelStep: Float;
	
	/**
	 * Position and size of content for children.
	 */
	public var contentRect(default, null): nme.geom.Rectangle;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	/**
	 * Update scroll rectangle bounds of content for children. 
	 */
	public function updateScrollRect(): Void {}
		
	/**
	 * Set scroll flag to dirty state so it can be updated in next frame.
	 */
	public function invalidScroll(): Void {}
	
}

#elseif mobile
typedef Panel = rs.zajac.containers.mobile.Panel;
#else
typedef Panel = rs.zajac.containers.desktop.Panel;
#end