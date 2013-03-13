Zajac, HaXe UI Framework
================================
Cross platform UI framework for HaXe NME. Backbone of all components
is StyledComponent that provides ability for styling over CSS.
StyledComponent doesn't require specific base, it is designed to
be added on any DisplayObjectContainer.

Supported targets: cpp, flash, neko

Tested on: iOS, Android, Blackberry, Windows, Flash

Documentation: http://www.zajac.rs/doc/

Example: https://github.com/stolex/testzajac

Demo: http://zajac.rs/demo/

Features
-------------------------
* Framework does not require initialization.
* Componens does not require specific base. They are designed to be added on any DisplayObjectContainer.
* Styling over CSS.
* Easy to create new components that can be styled over CSS.
* Skins are are using vector graphics.
* User interface follows platform.
* Default component and font size is calculated from device capabilities.

UI components
-------------------------
* Button
* CheckBox
* ColorPalette
* ColorPicker
* ComboBox
* Label
* List
* PreloaderCircle
* RadioButton
* Scroll
* Slider
* TextInput
* Panel

Instalation
-------------------------
Command line from lib.haxe.org

	haxelib install zajac

Command line from git (most up to date)

	haxelib git zajac https://github.com/comanjoni/zajac.git

Adding to application.nmml:

	<haxelib name="zajac" />
	
Making new styleable component
-------------------------
Styleable component must comply with the following:

* Extend StyledComponent
* Add @style metadata before variable that should be set from CSS
* Create skin for component

Example:

	package rs.zajac.test;
	class Test extends StyledComponent, implements ISkin {
		@style public var color: Int = 0;
		public function new() {
			super();
			defaultWidth = defaultHeight = 10;
		}
		override public function initialize(): Void {
			skin = this;
		}
		public function draw(client: BaseComponent, states: Hash<DisplayObject>): Void {
			var c: Test = cast(client);
			c.graphics.beginFill(c.color);
			c.graphics.drawRect(0, 0, c.Width, c.Height);
			c.graphics.endFill();
		}
	}

In this example Test class is its own skin. On each change of color variable
draw method will be called and component will redraw background.
	
Adding CSS
-------------------------
Framework is currently able to read CSS only from assets. First step is to
create CSS file in assets. Default CSS for Test component can be defined
using full class name.

	rs.zajac.test.Test {
		color: #ff0000;
	}

Save this in file "assets/css/test.css". And add assets path in application.nmml:

	<assets path="assets/css" rename="css" />

Next step is to tell StyleManager to use test.css. This need to be done in main 
class before usage of any framework component.
	
	StyleManager.addResource('css/test.css');

If specific CSS configuration is needed on specific instances of Test class, it is
possible to make CSS definition that can be used by name.

	.someStyle {
		color: #00ff00;
	}

And apply it to specific Test instance in code:

	var t: Test = new Test();
	t.styleName = 'someStyle';

Using existing components
-------------------------
In this example we'll use Button and make skin for it:

	var b: Button = new Button();
	addChild(b);

Default css for Button:

	rs.zajac.ui.Button {
		color: #ffffff;
		background-color: #666666;
		roundness: 10;
	}

Value of style property that is added from code overrides all before set values.
Style property values have priorities depending on way they are set. Value with
higher priority overrides value with lower. Here is list:

* Priority 1 - in class defined value
	* @style public var test: Int = 1;

* Priority 2 - CSS default definition for component
	* name.space.package.Test { test: 2 }
	
* Priority 3 - CSS definition by name
	* css: .someStyle { test: 3 }
	* code: instance.styleName = 'someStyle';
	
* Priority 4 - value set from code
	* instance.test = 4;

Licence
-------------------------
    Copyright (c) 2013 Stojan Ilic and Aleksandar Bogdanovic

    Permission is hereby granted, free of charge, to any person obtaining a 
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
