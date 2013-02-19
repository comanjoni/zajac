package rs.zajac.ui;
import rs.zajac.core.SingletonFactory;
import rs.zajac.skins.ISkin;
import nme.display.Sprite;
import nme.display.DisplayObject;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.ColorTransform;
import nme.Lib;

private class BaseComonentUtil {
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	static private var _componentUID: Int = 666;
	static private var _invalidComponents: Hash<BaseComponent> = new Hash<BaseComponent>();
	static private var _validator: Sprite;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	// Unique identifier creator for BaseComponent.
	static public function nextComponentUID(): String {
		return StringTools.hex(_componentUID++);
	}
	
	// Add component which changes should be validated on next enter frame event.
	static public function invalidComponent(component: BaseComponent): Void {
		if (_invalidComponents.exists(component.componentUID)) return;
		_invalidComponents.set(component.componentUID, component);
		_createValidator();
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************

	static private function _validateComponents(evt: Event): Void {
		var c_components: Hash<BaseComponent> = _invalidComponents;
		_invalidComponents = new Hash<BaseComponent>();
		_destroyValidator();
		
		for (c in c_components.iterator()) {
			c.validate();
		}
	}
	
	static private function _createValidator(): Void {
		if (_validator != null) return;
		_validator = new Sprite();
		_validator.addEventListener(Event.ENTER_FRAME, _validateComponents);
		Lib.current.stage.addChild(_validator);
	}
	
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
	
	// Unique component identiier in framework.
	public var componentUID(default, null): String;
	
	// Current component state.
	public var state(get_state, set_state): String;
	
	// Skin class.
	public var skinClass(get_skinClass, set_skinClass): Class<ISkin>;
	
	// Component that draws states.
	public var skin(get_skin, set_skin): ISkin;
	
	// Replacement for width that can not be overriden.
	public var Width(get_Width, set_Width): Float;
	public var defaultWidth: Float = 0;
	
	// Replacement for height that can not be overriden.
	public var Height(get_Height, set_Height): Float;
	public var defaultHeight: Float = 0;
	
	public var enabled(default, set_enabled): Bool = true;
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	// Hash map with skins for each state.
	private var _states: Hash<DisplayObject>;
	
	// Current visible state.
	private var _currentState: DisplayObject;
	
	private var _skinClass: Class<ISkin>;
	private var _skin: ISkin;
	
	private var _dirtySkin: Bool = true;
	private var _dirtyState: Bool = true;
	
	private var _Width: Null<Float> = null;
	private var _Height: Null<Float> = null;
	
	// Used for enabled to remember mouseEnabled and mouseChildren values before disabled component disable them
	private var _originalMouseEnabled:Bool;
	private var _originalMouseChildren:Bool;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	// Constructor.
	public function new() {
		super();
		componentUID = BaseComonentUtil.nextComponentUID();
		_states = new Hash<DisplayObject>();
		invalid();
		initialize();
	}
	
	// Add current component in validation list for validating on next enter frame.
	public function invalid(): Void {
		BaseComonentUtil.invalidComponent(this);
	}
	
	// Invalidate skin.
	public function invalidSkin(): Void {
		if (_dirtySkin) return;
		_dirtySkin = true;
		invalid();
	}
	
	// Invalidate state.
	public function invalidState(): Void {
		if (_dirtyState) return;
		_dirtyState = true;
		invalid();
	}
	
	// Put component in valid state based on changes.
	public function validate(): Void {
		_validateSkin();
		_validateState();
	}
	
	// Set Width and Height.
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
	
	// Overridable.
	private function initialize(): Void { }
	
	//Draw new skins for states.
	private function _validateSkin(): Bool {
		if (_dirtySkin && skin != null) {
			skin.draw(this, _states);
			_dirtySkin = false;
			_dirtyState = true;
			return true;
		}
		return false;
	}
	
	// Set DisplayObject for current state.
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