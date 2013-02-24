package rs.zajac.ui;
import rs.zajac.core.SingletonFactory;
import rs.zajac.skins.ISkin;
import nme.display.Sprite;
import nme.display.DisplayObject;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.ColorTransform;
import nme.Lib;


/**
 * Private functionality for validating farmework components.
 * @author Aleksandar Bogdanovic
 */
private class BaseComonentUtil {
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	/**
	 * Component uid source.
	 */
	static private var _componentUID: Int = 666;
	
	/**
	 * Components that wiill be validated on next enter frame.
	 */
	static private var _invalidComponents: Hash<BaseComponent> = new Hash<BaseComponent>();
	
	/**
	 * Sprite that dispatches enter frame event.
	 */
	static private var _validator: Sprite;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	/**
	 * Generate uid for new framework component.
	 * @return	component uid
	 */
	static public function nextComponentUID(): String {
		return StringTools.hex(_componentUID++);
	}
	
	/**
	 * Add component to be validate on next enter frame.
	 * @param	component
	 */
	static public function invalidComponent(component: BaseComponent): Void {
		if (_invalidComponents.exists(component.componentUID)) return;
		_invalidComponents.set(component.componentUID, component);
		_createValidator();
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************

	/**
	 * Go through all components added with invalidComponent and validate them.
	 * @param	evt
	 */
	static private function _validateComponents(evt: Event): Void {
		var c_components: Hash<BaseComponent> = _invalidComponents;
		_invalidComponents = new Hash<BaseComponent>();
		_destroyValidator();
		
		for (c in c_components.iterator()) {
			c.validate();
		}
	}
	
	/**
	 * Create sprite that dispatches enter frame event.
	 */
	static private function _createValidator(): Void {
		if (_validator != null) return;
		_validator = new Sprite();
		_validator.addEventListener(Event.ENTER_FRAME, _validateComponents);
		Lib.current.stage.addChild(_validator);
	}
	
	/**
	 * Destroy sprite that dispathces enter frame event.
	 */
	static private function _destroyValidator(): Void {
		if (_validator == null) return;
		_validator.removeEventListener(Event.ENTER_FRAME, _validateComponents);
		Lib.current.stage.removeChild(_validator);
		_validator = null;
	}
	
}

/**
 * Root ui component of framework. It supports states, skins an it is able to validate itself after changes.
 * @author Aleksandar Bogdanovic
 */
class BaseComponent extends Sprite {
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	/**
	 * Unique component identiier in framework.
	 */
	public var componentUID(default, null): String;
	
	/**
	 * Current component state.
	 */
	public var state(get_state, set_state): String;
	
	/**
	 * Skin class.
	 */
	public var skinClass(get_skinClass, set_skinClass): Class<ISkin>;
	
	/**
	 * Component that draws states.
	 */
	public var skin(get_skin, set_skin): ISkin;
	
	/**
	 * Replacement for width that can not be overriden.
	 */
	public var Width(get_Width, set_Width): Float;
	
	/**
	 * If Width is not set 3rd party (or is cleared), this value will be used as width.
	 */
	public var defaultWidth(default, set_defaultWidth): Float = 0;
	
	/**
	 * Replacement for height that can not be overriden.
	 */
	public var Height(get_Height, set_Height): Float;
	
	/**
	 * If Height is not set 3rd party (or is cleared), this value will be used as height.
	 */
	public var defaultHeight(default, set_defaultHeight): Float = 0;
	
	public var enabled(default, set_enabled): Bool = true;
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	/**
	 * Map with look of each state.
	 */
	private var _states: Hash<DisplayObject>;
	
	/**
	 * Reference to current visible look.
	 */
	private var _currentState: DisplayObject;
	
	private var _skinClass: Class<ISkin>;
	private var _skin: ISkin;
	
	/**
	 * True means that there are changes in skin and in next enter frame new looks should be drawn.
	 */
	private var _dirtySkin: Bool = true;
	
	/**
	 * True means that component has new state and in next frame appropriate lok will be applied.
	 */
	private var _dirtyState: Bool = true;
	
	/**
	 * Width value set by 3rd party. Null means that Width value is not set an component will use defaultWidth.
	 */
	private var _Width: Null<Float> = null;
	
	/**
	 * Height value set by 3rd party. Null means that Height value is not set an component will use defaultHeight.
	 */
	private var _Height: Null<Float> = null;
	
	// Used for enabled to remember mouseEnabled and mouseChildren values before disabled component disable them
	private var _originalMouseEnabled:Bool;
	private var _originalMouseChildren:Bool;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		componentUID = BaseComonentUtil.nextComponentUID();
		_states = new Hash<DisplayObject>();
		invalid();
		initialize();
	}
	
	/**
	 * Add component in validation list for validating on next enter frame.
	 */
	public function invalid(): Void {
		BaseComonentUtil.invalidComponent(this);
	}
	
	/**
	 * Invalidate skin.
	 */
	public function invalidSkin(): Void {
		if (_dirtySkin) return;
		_dirtySkin = true;
		invalid();
	}
	
	/**
	 * Invalidate state.
	 */
	public function invalidState(): Void {
		if (_dirtyState) return;
		_dirtyState = true;
		invalid();
	}
	
	/**
	 * Apply all changes that made component invalid.
	 */
	public function validate(): Void {
		_validateSkin();
		_validateState();
	}
	
	/**
	 * Set Width and Height.
	 * @param	w	Width.
	 * @param	h	Height.
	 */
	public function setSize(w: Float, h: Float): Void {
		var c_resize: Bool = false;
		if (_Width != w) {
			_Width = w;
			c_resize = true;
		}
		if (_Height != h) {
			_Height = h;
			c_resize = true;
		}
		if (c_resize) {
			invalidSkin();
			dispatchEvent(new Event(Event.RESIZE));
		}
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
	/**
	 * This method is empty in BaseComponent and should be overriden in subclasses for initializing component.
	 * It is called from constructor so developer should be careful.
	 * Why initializing component in this method and not in constructor?
	 * If someone extends component because of functionality and want to use different visible elements in
	 * new component he/she won't ba able to ommit calling super constructor. Calling initialize from
	 * superclass is not mandatory so elements from superclass won't be created.
	 */
	private function initialize(): Void { }
	
	/**
	 * Draw new looks for each state.
	 * @return True if there were changes and are applied. Oterwise false.
	 */
	private function _validateSkin(): Bool {
		if (_dirtySkin && skin != null) {
			skin.draw(this, _states);
			_dirtySkin = false;
			_dirtyState = true;
			return true;
		}
		return false;
	}
	
	/**
	 * Set appropriate look for current component state.
	 * @return	True if look is changed. Otherwise False.
	 */
	private function _validateState(): Bool {
		if (_dirtyState) {
			if (_currentState != null) {
				removeChild(_currentState);
			}
			_currentState = _states.get(state);
			if (_currentState != null) {
				addChildAt(_currentState, 0);
			}
			_dirtyState = false;
			return true;
		}
		return false;
	}
	
	//******************************
	//		GETTERS AND SETTERS
	//******************************
	
	private function get_state(): String {
		return state;
	}
	private function set_state(v: String): String {
		if (v != state) {
			state = v;
			invalidState();
		}
		return state;
	}
	
	private function get_skinClass(): Class<ISkin> {
		return _skinClass;
	}
	private function set_skinClass(v: Class<ISkin>): Class<ISkin> {
		if (v != _skinClass) {
			_skin = null;
			_skinClass = v;
			invalidSkin();
		}
		return v;
	}
	
	private function get_skin(): ISkin {
		if (_skin == null && _skinClass != null) {
			_skin = SingletonFactory.getInstance(_skinClass);
		}
		return _skin;
	}
	private function set_skin(v: ISkin): ISkin {
		if (v != _skin) {
			_skinClass = null;
			_skin = v;
			invalidSkin();
		}
		return _skin;
	}
	
	private function get_Width(): Float {
		return _Width == null ? defaultWidth : _Width;
	}
	private function set_Width(v: Float): Float {
		if (v != _Width) {
			_Width = v;
			invalidSkin();
			dispatchEvent(new Event(Event.RESIZE));
		}
		return v;
	}
	
	private function set_defaultWidth(v: Float): Float {
		if (defaultWidth != v) {
			defaultWidth = v;
			if (_Width == null) {
				invalidSkin();
				dispatchEvent(new Event(Event.RESIZE));
			}
		}
		return v;
	}
	
	private function get_Height(): Float {
		return _Height == null ? defaultHeight : _Height;
	}
	private function set_Height(v: Float): Float {
		if (v != _Height) {
			_Height = v;
			invalidSkin();
			dispatchEvent(new Event(Event.RESIZE));
		}
		return v;
	}
	
	private function set_defaultHeight(v: Float): Float {
		if (defaultHeight != v) {
			defaultHeight = v;
			if (_Height == null) {
				invalidSkin();
				dispatchEvent(new Event(Event.RESIZE));
			}
		}
		return v;
	}
	
	private function set_enabled(v: Bool): Bool {
		if (v != enabled) {
			enabled = v;
			if (v == true) {
				mouseEnabled = _originalMouseEnabled;
				mouseChildren = _originalMouseChildren;
				transform.colorTransform = new ColorTransform();
			}else {
				transform.colorTransform = new ColorTransform(.4, .4, .4, 1, 100, 100, 100);
				_originalMouseEnabled = mouseEnabled;
				_originalMouseChildren = mouseChildren;
				mouseEnabled = false;
				mouseChildren = false;
			}
		}
		return v;
	}
	
}