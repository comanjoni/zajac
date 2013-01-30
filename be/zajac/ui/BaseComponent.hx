package be.zajac.ui;
import be.zajac.core.SingletonFactory;
import be.zajac.skins.ISkin;
import nme.display.Sprite;
import nme.display.DisplayObject;
import nme.events.Event;
import nme.geom.ColorTransform;
import nme.Lib;

private class BaseComonentUtil {
	
	static private var _componentUID: Int = 1;
	/**
	 * Unique identifier creator for BaseComponent.
	 * @return	String unique identifier.
	 */
	static public function nextComponentUID(): String {
		return StringTools.hex(_componentUID++);
	}
	
	

	static private var _invalidComponents: Hash<BaseComponent> = new Hash<BaseComponent>();
	static private var _validator: Sprite;
	
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
	
	/**
	 * Add component which changes should be validated on next enter frame event.
	 * @param	component	Invalid ui component.
	 */
	static public function invalidComponent(component: BaseComponent): Void {
		if (_invalidComponents.exists(component.componentUID)) return;
		_invalidComponents.set(component.componentUID, component);
		_createValidator();
	}
}

/**
 * Root ui component of framework. It supports states, skins an it is able to validate itself after changes.
 * @author Aleksandar Bogdanovic
 */
class BaseComponent extends Sprite {
	
	/**
	 * Unique component identiier in framework.
	 */
	public var componentUID(default, null): String;
	
	//used for enabled to remember mouseEnabled and mouseChildren values before disabled component disable them
	private var _originalMouseEnabled:Bool;
	private var _originalMouseChildren:Bool;
	
	public var enabled(default, set_enabled): Bool = true;
	public function set_enabled(v: Bool): Bool {
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
	
		
	
	/**
	 * Hash map of skins for each state.
	 */
	private var _states: Hash<DisplayObject>;
	
	/**
	 * Current visible state.
	 */
	private var _currentState: DisplayObject;
	
	
	/**
	 * Add current component in validation list for validating on next enter frame.
	 */
	public function invalid(): Void {
		BaseComonentUtil.invalidComponent(this);
	}
	
	
	private var _dirtySkin: Bool = true;
	
	/**
	 * Invalidate skin.
	 */
	public function invalidSkin(): Void {
		if (_dirtySkin) return;
		_dirtySkin = true;
		invalid();
	}
	
	/**
	 * Draw new skins for states.
	 * @return	true if there was update, otherwise false.
	 */
	private function _validateSkin(): Bool {
		if (_dirtySkin && skin != null) {
			skin.draw(this, _states);
			#if js
				var c_state: DisplayObject;
				for (key in _states.keys()) {
					c_state = _states.get(key);
					if (!contains(c_state)) {
						addChildAt(c_state, 0);
						c_state.alpha = 0;
					}
				}
			#end
			_dirtySkin = false;
			return true;
		}
		return false;
	}
	
	
	private var _dirtyState: Bool = true;
	
	/**
	 * Invalidate state.
	 */
	public function invalidState(): Void {
		if (_dirtyState) return;
		_dirtyState = true;
		invalid();
	}
	
	/**
	 * Set DisplayObject for current state.
	 * @return
	 */
	private function _validateState(): Bool {
		if (_dirtyState && _states.exists(state)) {
			#if js
				if (_currentState != null) {
					_currentState.alpha = 0;
				}
				_currentState = _states.get(state);
				_currentState.alpha = 1;
			#else
				if (_currentState != null) {
					removeChild(_currentState);
				}
				_currentState = _states.get(state);
				addChildAt(_currentState, 0);
			#end
			_dirtyState = false;
			return true;
		}
		return false;
	}
	
	/**
	 * Put component in valid state based on changes.
	 */
	public function validate(): Void {
		_dirtyState = _validateSkin() || _dirtyState;
		_validateState();
	}
	
	
	/**
	 * Current component state.
	 */
	public var state(default, _setState): String;
	private function _setState(v: String): String {
		if (v != state) {
			state = v;
			invalidState();
		}
		return state;
	}
	
	
	
	private var _skinClass: Class<ISkin>;
	private var _skin: ISkin;
	
	/**
	 * Skin class.
	 */
	public var skinClass(get_skinClass, set_skinClass): Class<ISkin>;
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
	
	/**
	 * Component that draws states.
	 */
	public var skin(get_skin, set_skin): ISkin;
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
	
	
	/**
	 * Replacement for width that can not be overriden.
	 */
	private var defaultWidth: Float = 0;
	private var _Width: Null<Float> = null;
	public var Width(get_Width, set_Width): Float = 0;
	private function get_Width(): Float {
		if (_Width == null) {
			return defaultWidth;
		}
		return _Width;
	}
	private function set_Width(v: Float): Float {
		if (v != _Width) {
			_Width = v;
			invalidSkin();
			dispatchEvent(new Event(Event.RESIZE));
		}
		return v;
	}
	
	
	/**
	 * Replacement for height that can not be overriden.
	 */
	private var defaultHeight: Float = 0;
	private var _Height: Null<Float> = null;
	public var Height(get_Height, set_Height): Float = 0;
	private function get_Height(): Float {
		if (_Height == null) {
			return defaultHeight;
		}
		return _Height;
	}
	private function set_Height(v: Float): Float {
		if (v != _Height) {
			_Height = v;
			invalidSkin();
			dispatchEvent(new Event(Event.RESIZE));
		}
		return v;
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
	
	
	public function new() {
		super();
		componentUID = BaseComonentUtil.nextComponentUID();
		_states = new Hash<DisplayObject>();
		_dirtySkin = true;
		_dirtyState = true;
		invalid();
		initialize();
	}
	
	private function initialize(): Void { }
	
}