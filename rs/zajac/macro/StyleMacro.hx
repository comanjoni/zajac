package rs.zajac.macro;
import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * Macro for modifying components that are extending StyledComponent.
 * It is adding getters and setters on style properties that are not defined by developer.
 * If getter or setter is defined by developer it must respect following rule:
	 * getter must get value from _stlye Map and the best way for that is using
	 * _getStyleProperty private method.
	 * setter must set value in _style Map and the best way for that is using
	 * _setStyleProperty private method.
 * @author Aleksandar Bogdanovic
 */
class StyleMacro {

	private static function buildGetter(name, fieldName, varType, varValue, pos): Field {
		var field: Field;
		var template = macro : {
			private function getter() {
				return _getStyleProperty("fieldName", null);
			}
		}
		
		switch (template) {
			case TAnonymous(fields):
				field = fields[0];
			default:
		}
		
		field.pos = pos;
		field.name = name;
		
		switch (field.kind) {
			case FFun(func):
				func.expr.pos = pos;
				func.ret = varType;
				switch (func.expr.expr) {
					case EBlock(lines):
						lines[0].pos = pos;
						switch (lines[0].expr) {
							case EReturn(retExpr):
								retExpr.pos = pos;
								switch (retExpr.expr) {
									case ECall(call, params):
										call.pos = pos;
										params[0].pos = pos;
										params[0].expr = EConst(CString(fieldName));
										if (varValue != null) {
											params[1].pos = pos;
											params[1].expr = varValue.expr;
										}
									default:
								}
							default:
						}
					default:
				}
			default:
		}
		
		return field;
	}
	
	private static function buildSetter(name, fieldName, varType, pos): Field {
		var field: Field;
		var template = macro : {
			private function setter(v) {
				return _setStyleProperty("fieldName", v);
			}
		}
		
		switch (template) {
			case TAnonymous(fields):
				field = fields[0];
			default:
		}
		
		field.pos = pos;
		field.name = name;
		
		switch (field.kind) {
			case FFun(func):
				func.expr.pos = pos;
				func.ret = varType;
				func.args[0].type = varType;
				switch (func.expr.expr) {
					case EBlock(lines):
						lines[0].pos = pos;
						switch (lines[0].expr) {
							case EReturn(retExpr):
								retExpr.pos = pos;
								switch (retExpr.expr) {
									case ECall(call, params):
										call.pos = pos;
										params[0].pos = pos;
										params[0].expr = EConst(CString(fieldName));
									default:
								}
							default:
						}
					default:
				}
			default:
		}
		
		return field;
	}
	
	private static function buildPropertyFromVar(field: Field): Array<Field> {
		var fields: Array<Field> = new Array<Field>();
		
		var getterName = "get_" + field.name;
		var setterName = "set_" + field.name;
		
		switch (field.kind) {
			case FVar(varType, varValue):
				fields.push(buildGetter(getterName, field.name, varType, varValue, field.pos));
				fields.push(buildSetter(setterName, field.name, varType, field.pos));
				field.kind = FProp(getterName, setterName, varType);
				fields.push(field);
			default:
		}
		
		
		return fields;
	}
	
	private static function buildPropertyFromProp(field: Field, getter: Field, setter: Field): Array<Field> {
		var fields: Array<Field> = new Array<Field>();
		
		var getterName;
		var setterName; 
		
		switch (field.kind) {
			case FProp(propGetter, propSetter, propType, propValue):
				
				if (getter == null) {
					getterName = "get_" + field.name;
					fields.push(buildGetter(getterName, field.name, propType, propValue, field.pos));
				} else {
					getterName = getter.name;
					fields.push(getter);
				}
				
				if (setter == null) {
					setterName = "set_" + field.name;
					fields.push(buildSetter(setterName, field.name, propType, field.pos));
				} else {
					setterName = setter.name;
					fields.push(setter);
				}
				
				field.kind = FProp(getterName, setterName, propType);
				fields.push(field);
			default:
		}
		
		return fields;
	}
	
	macro public static function build(): Array<Field> {
		var fields: Array<Field> = new Array<Field>();
		
		var variables: Map<String,Field> = new Map<String,Field>();
		var properties: Map<String,Field> = new Map<String,Field>();
		var fieldsMap: Map<String,Field> = new Map<String,Field>();
		
		var isStyle: Bool;
		var getterName: String;
		var setterName: String;
		var getter: Field;
		var setter: Field;
		var field: Field;
		var functionMeta: Array<{ pos: Position, params: Array<Expr>, name: String }>;
		
		for (field in Context.getBuildFields()) {
			
			functionMeta = new Array<{ pos: Position, params: Array<Expr>, name: String }>();
			isStyle = false;
			for (meta in field.meta) {
				if (meta.name == 'style') {
					isStyle = true;
				} else {
					functionMeta.push(meta);
				}
			}
			
			switch (field.kind) {
				case FVar(varType, varValue):
					if (isStyle) {
						variables.set(field.name, field);
					}
					fieldsMap.set(field.name, field);
				case FProp(propGetter, propSetter, propType, propValue):
					if (isStyle) {
						properties.set(field.name, field);
					}
					fieldsMap.set(field.name, field);
				case FFun(fun):
					fieldsMap.set(field.name, field);
					if (isStyle) {
						field.meta = functionMeta;
						Context.warning('Function can not be style. Style metadata will be removed from function.', field.pos);
					}
			}
			
		}
		
		for (fieldName in variables.keys()) {
			
			getterName = "get_" + fieldName;
			if (fieldsMap.exists(getterName)) {
				Context.error('Field name "' + getterName + '" is reserved for getter of style variable ' + fieldName + '.', fieldsMap.get(getterName).pos);
			}
			
			setterName = "set_" + fieldName;
			if (fieldsMap.exists(setterName)) {
				Context.error('Field name "' + setterName + '" is reserved for setter of style variable ' + fieldName + '.', fieldsMap.get(setterName).pos);
			}
			
			fieldsMap.remove(fieldName);
			fields = fields.concat(buildPropertyFromVar(variables.get(fieldName)));
		}
		
		for (fieldName in properties.keys()) {
			field = properties.get(fieldName);
			getter = null;
			setter = null;
			
			switch (field.kind) {
				case FProp(propGetter, propSetter, varType, varValue):
					
					if ((propGetter == 'default') || (propGetter == 'dynamic')) {
						getterName = "get_" + fieldName;
						if (fieldsMap.exists(getterName)) {
							Context.error('Field name "' + getterName + '" is reserved for getter of style variable ' + fieldName + '.', fieldsMap.get(getterName).pos);
						}
					} else if ((propGetter == 'null') || (propGetter == 'never')) {
						Context.error('Style variable getter can not be ' + propGetter + '.', field.pos);
					} else if (!fieldsMap.exists(propGetter)) {
						Context.error('Style variable getter ' + propGetter + ' is missing.', field.pos);
					} else {
						getter = fieldsMap.get(propGetter);
						fieldsMap.remove(propGetter);
					}
					
					if ((propSetter == 'default') || (propSetter == 'dynamic')) {
						setterName = "set_" + fieldName;
						if (fieldsMap.exists(setterName)) {
							Context.error('Field name "' + setterName + '" is reserved for setter of style variable ' + fieldName + '.', fieldsMap.get(setterName).pos);
						}
					} else if ((propSetter == 'null') || (propSetter == 'never')) {
						Context.error('Style variable setter can not be ' + propSetter + '.', field.pos);
					} else if (!fieldsMap.exists(propSetter)) {
						Context.error('Style variable setter ' + propSetter + ' is missing.', field.pos);
					} else {
						setter = fieldsMap.get(propSetter);
						fieldsMap.remove(propSetter);
					}
					
				default:
			}
			
			fieldsMap.remove(fieldName);
			fields = fields.concat(buildPropertyFromProp(field, getter, setter));
		}
		
		for (field in fieldsMap.iterator()) {
			fields.push(field);
		}
		
		return fields;
	}
	
}