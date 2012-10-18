package be.zajac.ui;
import be.zajac.core.FWCore;
import be.zajac.skins.ISkin;
import nme.display.Sprite;
import nme.display.DisplayObject;
import nme.events.Event;

private class BaseComonentUtil {
	
	static private var _componentUID: Int = 1;
	/**
	 * Unique identifier creator for BaseComponent.
	 * @return	String unique identifier.
	 */
	static public function nextComponentUID(): String {
		return StringTools.hex(_componentUID++);
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
		FWCore.invalidComponent(this);
	}
	
	
	private var _dirtySkin: Bool = true;
	
	/**
	 * Invalidate skin.
	 */
	public function invalidSkin(): Void {
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
	public var state(_getState, _setState): String;
	private function _getState(): String {
		return state;
	}
	private function _setState(v: String): String {
		if (v != state) {
			state = v;
			invalidState();
		}
		return state;
	}
	
	
	/**
	 * Component that draws states.
	 */
	public var skin(_getSkin, _setSkin): ISkin;
	private function _getSkin(): ISkin {
		return skin;
	}
	private function _setSkin(v: ISkin): ISkin {
		if (v != skin) {
			skin = v;
			invalidSkin();
		}
		return skin;
	}
	
	
	/**
	 * Replacement for width that can not be overriden.
	 */
	public var Width(getWidth, setWidth): Float = 0;
	private function getWidth(): Float {
		return Width;
	}
	private function setWidth(v: Float): Float {
		if (v != Width) {
			Width = v;
			invalidSkin();
		}
		return Width;
	}
	
	
	/**
	 * Replacement for height that can not be overriden.
	 */
	public var Height(getHeight, setHeight): Float = 0;
	private function getHeight(): Float {
		return Height;
	}
	private function setHeight(v: Float): Float {
		if (v != Height) {
			Height = v;
			invalidSkin();
		}
		return Height;
	}
	
	
	/**
	 * Set Width and Height.
	 * @param	w	Width.
	 * @param	h	Height.
	 */
	public function setSize(w: Float, h: Float): Void {
		Width = w;
		Height = h;
	}
	
	
	public function new() {
		super();
		componentUID = BaseComonentUtil.nextComponentUID();
		_states = new Hash<DisplayObject>();
		_dirtySkin = true;
		_dirtyState = true;
		invalid();
	}
	
}