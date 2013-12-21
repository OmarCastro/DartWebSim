part of webdriver;

class WebDriverSession extends Object with WebDriverAjax{
  String id;
  WebDriverSession(String url, Map content){
    this.url = url;
    this.id = content["sessionId"];
  }
  
  Future _post(String path,[Object data = const {}]) => _request("POST","/session/$id/$path",data);
  Future _get(String path) => _request("GET","/session/$id/$path",const {});
  Future _delete(String path,[Object data = const {}]) => _request("DELETE","/session/$id/$path",data);
  Future _put(String path,[Object data = const {}]) => _request("PUT","/session/$id/$path",data);
  
  
  /** Close the session. */
  Future close() => _delete('');

  /** Get the session capabilities. See [newSession] for details. */
  Future<Map> getCapabilities() => _get('');

  /**
   * Configure the amount of time in milliseconds that a script can execute
   * for before it is aborted and a Timeout error is returned to the client.
   */
  Future setScriptTimeout(t) =>
      _post('timeouts', { 'type': 'script', 'ms': t });

  /*Future<String> setImplicitWaitTimeout(t) =>
      simplePost('timeouts', { 'type': 'implicit', 'ms': t });*/

  /**
   * Configure the amount of time in milliseconds that a page can load for
   * before it is aborted and a Timeout error is returned to the client.
   */
  Future setPageLoadTimeout(t) =>
      _post('timeouts', { 'type': 'page load', 'ms': t });

  /**
   * Set the amount of time, in milliseconds, that asynchronous scripts
   * executed by /session/:sessionId/execute_async are permitted to run
   * before they are aborted and a Timeout error is returned to the client.
   */
  Future setAsyncScriptTimeout(t) =>
      _post('timeouts/async_script', { 'ms': t });

  /**
   * Set the amount of time the driver should wait when searching for elements.
   * When searching for a single element, the driver should poll the page until
   * an element is found or the timeout expires, whichever occurs first. When
   * searching for multiple elements, the driver should poll the page until at
   * least one element is found or the timeout expires, at which point it should
   * return an empty list.
   *
   * If this command is never sent, the driver should default to an implicit
   * wait of 0ms.
   */
  Future setImplicitWaitTimeout(t) =>
      _post('timeouts/implicit_wait', { 'ms': t });

  /**
   * Retrieve the current window handle.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<String> getWindowHandle() => _get('window_handle');

  /**
   * Retrieve a [WebDriverWindow] for the specified window. We don't
   * have to use a Future here but do so to be consistent.
   */
  /*Future<WebDriverWindow> getWindow([handle = 'current']) {
    var completer = new Completer();
    completer.complete(new WebDriverWindow.fromUrl('${_url}/window/$handle'));
    return completer.future;
  }*/

  /** Retrieve the list of all window handles available to the session. */
  Future<List<String>> getWindowHandles() => _get('window_handles');

  
  /**
   * Retrieve the URL of the current page.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<String> getUrl() => _get('url');

  /**
   * Navigate to a new URL.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future setUrl(String url) => _post('url', { 'url': url });

  /**
   * Navigate forwards in the browser history, if possible.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future navigateForward() => _post('forward');

  /**
   * Navigate backwards in the browser history, if possible.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future navigateBack() => _post('back');

  /**
   * Refresh the current page.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future refresh() => _post('refresh');
  

  /**
   * Inject a snippet of JavaScript into the page for execution in the context
   * of the currently selected frame. The executed script is assumed to be
   * synchronous and the result of evaluating the script is returned to the
   * client.
   *
   * The script argument defines the script to execute in the form of a
   * function body. The value returned by that function will be returned to
   * the client. The function will be invoked with the provided args array
   * and the values may be accessed via the arguments object in the order
   * specified.
   *
   * Arguments may be any JSON-primitive, array, or JSON object. JSON objects
   * that define a WebElement reference will be converted to the corresponding
   * DOM element. Likewise, any WebElements in the script result will be
   * returned to the client as WebElement JSON objects.
   *
   * Potential Errors: NoSuchWindow, StaleElementReference, JavaScriptError.
   */
  Future execute(String script, [List args]) {
    if (args == null) args = [];
    return _post('execute', { 'script': script, 'args': args });
  }

  /**
   * Inject a snippet of JavaScript into the page for execution in the context
   * of the currently selected frame. The executed script is assumed to be
   * asynchronous and must signal that it is done by invoking the provided
   * callback, which is always provided as the final argument to the function.
   * The value to this callback will be returned to the client.
   *
   * Asynchronous script commands may not span page loads. If an unload event
   * is fired while waiting for a script result, an error should be returned
   * to the client.
   *
   * The script argument defines the script to execute in the form of a function
   * body. The function will be invoked with the provided args array and the
   * values may be accessed via the arguments object in the order specified.
   * The final argument will always be a callback function that must be invoked
   * to signal that the script has finished.
   *
   * Arguments may be any JSON-primitive, array, or JSON object. JSON objects
   * that define a WebElement reference will be converted to the corresponding
   * DOM element. Likewise, any WebElements in the script result will be
   * returned to the client as WebElement JSON objects.
   *
   * Potential Errors: NoSuchWindow, StaleElementReference, Timeout (controlled
   * by the [setAsyncScriptTimeout] command), JavaScriptError (if the script
   * callback is not invoked before the timout expires).
   */
  Future executeAsync(String script, [List args]) {
    if (args == null) args = [];
    return _post('execute_async', { 'script': script, 'args': args });
  }

  /**
   * Take a screenshot of the current page (PNG).
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<List<int>> getScreenshot([fname]) {
    /*var completer = new Completer();
    return _get('screenshot', completer, (r, v) {
      var image = Base64Decoder.decode(v);
      if (fname != null) {
        writeBytesToFile(fname, image);
      }
      completer.complete(image);
    });*/
  }

  /**
   * List all available IME (Input Method Editor) engines on the machine.
   * To use an engine, it has to be present in this list.
   *
   * Potential Errors: ImeNotAvailableException.
   */
  Future<List<String>> getAvailableImeEngines() =>
      _get('ime/available_engines');

  /**
   * Get the name of the active IME engine. The name string is
   * platform specific.
   *
   * Potential Errors: ImeNotAvailableException.
   */
  Future<String> getActiveImeEngine() => _get('ime/active_engine');

  /**
   * Indicates whether IME input is active at the moment (not if
   * it's available).
   *
   * Potential Errors: ImeNotAvailableException.
   */
  Future<bool> getIsImeActive() => _get('ime/activated');

  /**
   * De-activates the currently-active IME engine.
   *
   * Potential Errors: ImeNotAvailableException.
   */
  Future deactivateIme() => _post('ime/deactivate');

  /**
   * Make an engine that is available (appears on the list returned by
   * getAvailableEngines) active. After this call, the engine will be added
   * to the list of engines loaded in the IME daemon and the input sent using
   * sendKeys will be converted by the active engine. Note that this is a
   * platform-independent method of activating IME (the platform-specific way
   * being using keyboard shortcuts).
   *
   * Potential Errors: ImeActivationFailedException, ImeNotAvailableException.
   */
  Future activateIme(String engine) =>
      _post('ime/activate', { 'engine': engine });

  /**
   * Change focus to another frame on the page. If the frame id is null,
   * the server should switch to the page's default content.
   * [id] is the Identifier for the frame to change focus to, and can be
   * a string, number, null, or JSON Object.
   *
   * Potential Errors: NoSuchWindow, NoSuchFrame.
   */
  Future setFrameFocus(id) => _post('frame', { 'id': id });

  /**
   * Change focus to another window. The window to change focus to may be
   * specified by [name], which is its server assigned window handle, or
   * the value of its name attribute.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future setWindowFocus(name) => _post('window', { 'name': name });

  /**
   * Close the current window.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future closeWindow() => _delete('window');

  /**
   * Retrieve all cookies visible to the current page.
   *
   * The returned List contains Maps with the following keys:
   *
   * 'name' - The name of the cookie.
   *
   * 'value' - The cookie value.
   *
   * The following keys may optionally be present:
   *
   * 'path' - The cookie path.
   *
   * 'domain' - The domain the cookie is visible to.
   *
   * 'secure' - Whether the cookie is a secure cookie.
   *
   * 'expiry' - When the cookie expires, seconds since midnight, 1/1/1970 UTC.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<List<Map>> getCookies() => _get('cookie');

  /**
   * Set a cookie. If the cookie path is not specified, it should be set
   * to "/". Likewise, if the domain is omitted, it should default to the
   * current page's domain. See [getCookies] for the structure of a cookie
   * Map.
   */
  Future setCookie(Map cookie) => _post('cookie', { 'cookie': cookie });

  /**
   * Delete all cookies visible to the current page.
   *
   * Potential Errors: InvalidCookieDomain (the cookie's domain is not
   * visible from the current page), NoSuchWindow, UnableToSetCookie (if
   * attempting to set a cookie on a page that does not support cookies,
   * e.g. pages with mime-type text/plain).
   */
  Future deleteCookies() => _delete('cookie');

  /**
   * Delete the cookie with the given [name]. This command should be a no-op
   * if there is no such cookie visible to the current page.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future deleteCookie(String name) => _delete('cookie/$name');

  /**
   * Get the current page source.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<String> getPageSource() => _get('source');

  /**
   * Get the current page title.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<String> getPageTitle() => _get('title');

  /**
   * Search for an element on the page, starting from the document root. The
   * first matching located element will be returned as a WebElement JSON
   * object (a [Map] with an 'ELEMENT' key whose value should be used to
   * identify the element in further requests). The [strategy] should be
   * one of:
   *
   * 'class name' - Returns an element whose class name contains the search
   *    value; compound class names are not permitted.
   *
   * 'css selector' - Returns an element matching a CSS selector.
   *
   * 'id' - Returns an element whose ID attribute matches the search value.
   *
   * 'name' - Returns an element whose NAME attribute matches the search value.
   *
   * 'link text' - Returns an anchor element whose visible text matches the
   *   search value.
   *
   * 'partial link text' - Returns an anchor element whose visible text
   *   partially matches the search value.
   *
   * 'tag name' - Returns an element whose tag name matches the search value.
   *
   * 'xpath' - Returns an element matching an XPath expression.
   *
   * Potential Errors: NoSuchWindow, NoSuchElement, XPathLookupError (if
   * using XPath and the input expression is invalid).
   */
  Future<Map> findElement(String strategy, String searchValue) =>
      _post('element', { 'using': strategy, 'value' : searchValue });

  /**
   * Search for multiple elements on the page, starting from the document root.
   * The located elements will be returned as WebElement JSON objects. See
   * [findElement] for the locator strategies that each server supports.
   * Elements are be returned in the order located in the DOM.
   *
   * Potential Errors: NoSuchWindow, XPathLookupError.
   */
  Future<List<String>> findElements(String strategy, String searchValue) =>
      _post('elements', { 'using': strategy, 'value' : searchValue });

  /**
   * Get the element on the page that currently has focus. The element will
   * be returned as a WebElement JSON object.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<String> getElementWithFocus() => _post('element/active');

  /**
   * Search for an element on the page, starting from element with id [id].
   * The located element will be returned as WebElement JSON objects. See
   * [findElement] for the locator strategies that each server supports.
   *
   * Potential Errors: NoSuchWindow, XPathLookupError.
   */
  Future<String>
      findElementFromId(String id, String strategy, String searchValue) =>
          _post('element/$id/element',
              { 'using': strategy, 'value' : searchValue });

  /**
   * Search for multiple elements on the page, starting from the element with
   * id [id].The located elements will be returned as WebElement JSON objects.
   * See [findElement] for the locator strategies that each server supports.
   * Elements are be returned in the order located in the DOM.
   *
   * Potential Errors: NoSuchWindow, XPathLookupError.
   */
  Future<List<String>>
      findElementsFromId(String id, String strategy, String searchValue) =>
          _post('element/$id/elements',
              { 'using': strategy, 'value' : searchValue });
  /**
   * Click on an element specified by [id].
   *
   * Potential Errors: NoSuchWindow, StaleElementReference, ElementNotVisible
   * (if the referenced element is not visible on the page, either hidden
   * by CSS, or has 0-width or 0-height).
   */
  Future clickElement(String id) => _post('element/$id/click');

  /**
   * Submit a FORM element. The submit command may also be applied to any
   * element that is a descendant of a FORM element.
   *
   * Potential Errors: NoSuchWindow, StaleElementReference.
   */
  Future submit(String id) => _post('element/$id/submit');

  /** Returns the visible text for the element.
   *
   * Potential Errors: NoSuchWindow, StaleElementReference.
   */
  Future<String> getElementText(String id) => _get('element/$id/text');

  /**
   * Send a sequence of key strokes to an element.
   *
   * Any UTF-8 character may be specified, however, if the server does not
   * support native key events, it will simulate key strokes for a standard
   * US keyboard layout. The Unicode Private Use Area code points,
   * 0xE000-0xF8FF, are used to represent pressable, non-text keys:
   *
   * NULL - U+E000
   *
   * Cancel - U+E001
   *
   * Help - U+E002
   *
   * Backspace - U+E003
   *
   * Tab - U+E004
   *
   * Clear - U+E005
   *
   * Return - U+E006
   *
   * Enter - U+E007
   *
   * Shift - U+E008
   *
   * Control - U+E009
   *
   * Alt - U+E00A
   *
   * Pause - U+E00B
   *
   * Escape - U+E00C
   *
   * Space - U+E00D
   *
   * Pageup - U+E00E
   *
   * Pagedown - U+E00F
   *
   * End - U+E010
   *
   * Home - U+E011
   *
   * Left arrow - U+E012
   *
   * Up arrow - U+E013
   *
   * Right arrow - U+E014
   *
   * Down arrow - U+E015
   *
   * Insert - U+E016
   *
   * Delete - U+E017
   *
   * Semicolon - U+E018
   *
   * Equals - U+E019
   *
   * Numpad 0..9 - U+E01A..U+E023
   *
   * Multiply - U+E024
   *
   * Add - U+E025
   *
   * Separator - U+E026
   *
   * Subtract - U+E027
   *
   * Decimal - U+E028
   *
   * Divide - U+E029
   *
   * F1..F12 - U+E031..U+E03C
   *
   * Command/Meta U+E03D
   *
   * The server processes the key sequence as follows:
   *
   * - Each key that appears on the keyboard without requiring modifiers is
   *   sent as a keydown followed by a key up.
   *
   * - If the server does not support native events and must simulate key
   *   strokes with JavaScript, it will generate keydown, keypress, and keyup
   *   events, in that order. The keypress event is only fired when the
   *   corresponding key is for a printable character.
   *
   * - If a key requires a modifier key (e.g. "!" on a standard US keyboard),
   *   the sequence is: modifier down, key down, key up, modifier up, where
   *   key is the ideal unmodified key value (using the previous example,
   *   a "1").
   *
   * - Modifier keys (Ctrl, Shift, Alt, and Command/Meta) are assumed to be
   *  "sticky"; each modifier is held down (e.g. only a keydown event) until
   *   either the modifier is encountered again in the sequence, or the NULL
   *   (U+E000) key is encountered.
   *
   * - Each key sequence is terminated with an implicit NULL key.
   *   Subsequently, all depressed modifier keys are released (with
   *   corresponding keyup events) at the end of the sequence.
   *
   * Potential Errors: NoSuchWindow, StaleElementReference, ElementNotVisible.
   */
  Future sendKeyStrokesToElement(String id, List<String> keys) =>
      _post('element/$id/value', { 'value': keys });

  /**
   * Send a sequence of key strokes to the active element. This command is
   * similar to [sendKeyStrokesToElement] command in every aspect except the
   * implicit termination: The modifiers are not released at the end of the
   * call. Rather, the state of the modifier keys is kept between calls,
   * so mouse interactions can be performed while modifier keys are depressed.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future sendKeyStrokes(List<String> keys) => _post('keys', { 'value': keys });

  /**
   * Query for an element's tag name, as a lower-case string.
   *
   * Potential Errors: NoSuchWindow, StaleElementReference.
   */
  Future<String> getElementTagName(String id) => _get('element/$id/name');

  /**
   * Clear a TEXTAREA or text INPUT element's value.
   *
   * Potential Errors: NoSuchWindow, StaleElementReference, ElementNotVisible,
   * InvalidElementState.
   */
  Future clearValue(String id) => _post('/element/$id/clear');

  /**
   * Determine if an OPTION element, or an INPUT element of type checkbox
   * or radiobutton is currently selected.
   *
   * Potential Errors: NoSuchWindow, StaleElementReference.
   */
  Future<bool> isSelected(String id) => _get('element/$id/selected');

  /**
   * Determine if an element is currently enabled.
   *
   * Potential Errors: NoSuchWindow, StaleElementReference.
   */
  Future<bool> isEnabled(String id) => _get('element/$id/enabled');

  /**
   * Get the value of an element's attribute, or null if it has no such
   * attribute.
   *
   * Potential Errors: NoSuchWindow, StaleElementReference.
   */
  Future<String> getAttribute(String id, String attribute) =>
      _get('element/$id/attribute/$attribute');

  /**
   * Test if two element IDs refer to the same DOM element.
   *
   * Potential Errors: NoSuchWindow, StaleElementReference.
   */
  Future<bool> areSameElement(String id, String other) =>
      _get('element/$id/equals/$other');

  /**
   * Determine if an element is currently displayed.
   *
   * Potential Errors: NoSuchWindow, StaleElementReference.
   */
  Future<bool> isDiplayed(String id) => _get('element/$id/displayed');

  /**
   * Determine an element's location on the page. The point (0, 0) refers to
   * the upper-left corner of the page. The element's coordinates are returned
   * as a [Map] object with x and y properties.
   *
   * Potential Errors: NoSuchWindow, StaleElementReference.
   */
  Future<Map> getElementLocation(String id) => _get('element/$id/location');

  /**
   * Determine an element's size in pixels. The size will be returned as a
   * [Map] object with width and height properties.
   *
   * Potential Errors: NoSuchWindow, StalElementReference.
   */
  Future<Map> getElementSize(String id) => _get('element/$id/size');

  /**
   * Query the value of an element's computed CSS property. The CSS property
   * to query should be specified using the CSS property name, not the
   * JavaScript property name (e.g. background-color instead of
   * backgroundColor).
   *
   * Potential Errors: NoSuchWindow, StaleElementReference.
   */
  Future<String> getElementCssProperty(String id, String property) =>
      _get('element/$id/css/$property');

  /**
   * Get the current browser orientation ('LANDSCAPE' or 'PORTRAIT').
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<String> getBrowserOrientation() => _get('orientation');

  /**
   * Gets the text of the currently displayed JavaScript alert(), confirm(),
   * or prompt() dialog.
   *
   * Potential Errors: NoAlertPresent.
   */
  Future<String> getAlertText() => _get('alert_text');

  /**
   * Sends keystrokes to a JavaScript prompt() dialog.
   *
   * Potential Errors: NoAlertPresent.
   */
  Future sendKeyStrokesToPrompt(String text) =>
      _post('alert_text', { 'text': text });

  /**
   * Accepts the currently displayed alert dialog. Usually, this is equivalent
   * to clicking on the 'OK' button in the dialog.
   *
   * Potential Errors: NoAlertPresent.
   */
  Future acceptAlert() => _post('accept_alert');

  /**
   * Dismisses the currently displayed alert dialog. For confirm() and prompt()
   * dialogs, this is equivalent to clicking the 'Cancel' button. For alert()
   * dialogs, this is equivalent to clicking the 'OK' button.
   *
   * Potential Errors: NoAlertPresent.
   */
  Future dismissAlert() => _post('dismiss_alert');

  /**
   * Move the mouse by an offset of the specificed element. If no element is
   * specified, the move is relative to the current mouse cursor. If an
   * element is provided but no offset, the mouse will be moved to the center
   * of the element. If the element is not visible, it will be scrolled
   * into view.
   */
  Future moveTo(String id, int x, int y) =>
      _post('moveto', { 'element': id, 'xoffset': x, 'yoffset' : y});

  /**
   * Click a mouse button (at the coordinates set by the last [moveTo] command).
   * Note that calling this command after calling [buttonDown] and before
   * calling [buttonUp] (or any out-of-order interactions sequence) will yield
   * undefined behaviour).
   *
   * [button] should be 0 for left, 1 for middle, or 2 for right.
   */
  Future clickMouse([button = 0]) => _post('click', { 'button' : button });

  /**
   * Click and hold the left mouse button (at the coordinates set by the last
   * [moveTo] command). Note that the next mouse-related command that should
   * follow is [buttonDown]. Any other mouse command (such as [click] or
   * another call to [buttonDown]) will yield undefined behaviour.
   *
   * [button] should be 0 for left, 1 for middle, or 2 for right.
   */
  Future buttonDown([button = 0]) => _post('click', { 'button' : button });

  /**
   * Releases the mouse button previously held (where the mouse is currently
   * at). Must be called once for every [buttonDown] command issued. See the
   * note in [click] and [buttonDown] about implications of out-of-order
   * commands.
   *
   * [button] should be 0 for left, 1 for middle, or 2 for right.
   */
  Future buttonUp([button = 0]) => _post('click', { 'button' : button });

  /** Double-clicks at the current mouse coordinates (set by [moveTo]). */
  Future doubleClick() => _post('doubleclick');

  /** Single tap on the touch enabled device on the element with id [id]. */
  Future touchClick(String id) => _post('touch/click', { 'element': id });

  /** Finger down on the screen. */
  Future touchDown(int x, int y) => _post('touch/down', { 'x': x, 'y': y });

  /** Finger up on the screen. */
  Future touchUp(int x, int y) => _post('touch/up', { 'x': x, 'y': y }); 

  /** Finger move on the screen. */
  Future touchMove(int x, int y) => _post('touch/move', { 'x': x, 'y': y });

  /**
   * Scroll on the touch screen using finger based motion events. If [id] is
   * specified, scrolling will start at a particular screen location.
   */
  Future touchScroll(int xOffset, int yOffset, [String id = null]) {
    if (id == null) {
      return _post('touch/scroll', { 'xoffset': xOffset, 'yoffset': yOffset });
    } else {
      return _post('touch/scroll',
          { 'element': id, 'xoffset': xOffset, 'yoffset': yOffset });
    }
  }

  /** Double tap on the touch screen using finger motion events. */
  Future touchDoubleClick(String id) =>
      _post('touch/doubleclick', { 'element': id });

  /** Long press on the touch screen using finger motion events. */
  Future touchLongClick(String id) =>
      _post('touch/longclick', { 'element': id });

  /**
   * Flick on the touch screen using finger based motion events, starting
   * at a particular screen location. [speed] is in pixels-per-second.
   */
  Future touchFlickFrom(String id, int xOffset, int yOffset, int speed) =>
          _post('touch/flick',
              { 'element': id, 'xoffset': xOffset, 'yoffset': yOffset,
                        'speed': speed });

  /**
   * Flick on the touch screen using finger based motion events. Use this
   * instead of [touchFlickFrom] if you don'tr care where the flick starts.
   */
  Future touchFlick(int xSpeed, int ySpeed) =>
      _post('touch/flick', { 'xSpeed': xSpeed, 'ySpeed': ySpeed });

  /**
   * Get the current geo location. Returns a [Map] with latitude,
   * longitude and altitude properties.
   */
  Future<Map> getGeolocation() => _get('location');

  /** Set the current geo location. */
  Future setLocation(double latitude, double longitude, double altitude) =>
          _post('location',
              { 'latitude': latitude,
                'longitude': longitude,
                'altitude': altitude });

  /**
   * Only a few drivers actually support the JSON storage commands.
   * Currently it looks like this is the Android and iPhone drivers only.
   * For the rest, we can achieve a similar effect with Javascript
   * execution. The flag below is used to control whether to do this.
   */
  bool useJavascriptForStorageAPIs = true;

  /**
   * Get all keys of the local storage. Completes with [null] if there
   * are no keys or the keys could not be retrieved.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<List<String>> getLocalStorageKeys() {
    if (useJavascriptForStorageAPIs) {
      return execute(
          'var rtn = [];'
          'for (var i = 0; i < window.localStorage.length; i++)'
          '  rtn.push(window.localStorage.key(i));'
          'return rtn;'); 
    } else {
      return _get('local_storage');
    }
  }

  /**
   * Set the local storage item for the given key.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future setLocalStorageItem(String key, String value) {
    if (useJavascriptForStorageAPIs) {
      return execute('window.localStorage.setItem(arguments[0], arguments[1]);',
          [key, value]); 
    } else {
      return _post('local_storage', { 'key': key, 'value': value });
    }
  }

  /**
   * Clear the local storage.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future clearLocalStorage() {
    if (useJavascriptForStorageAPIs) {
      return execute('return window.localStorage.clear();');
    } else {
      return _delete('local_storage');
    }
  }

  /**
   * Get the local storage item for the given key.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<String> getLocalStorageValue(String key) {
    if (useJavascriptForStorageAPIs) {
      return execute('return window.localStorage.getItem(arguments[0]);',
          [key]); 
    } else {
      return _get('local_storage/key/$key');
    }
  }

  /**
   * Delete the local storage item for the given key.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future deleteLocalStorageValue(String key) {
    if (useJavascriptForStorageAPIs) {
      return execute('return window.localStorage.removeItem(arguments[0]);',
          [key]); 
    } else {
      return _delete('local_storage/key/$key');
    }
  }

  /**
   * Get the number of items in the local storage.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<int> getLocalStorageCount() {
    if (useJavascriptForStorageAPIs) {
      return execute('return window.localStorage.length;'); 
    } else {
      return _get('local_storage/size');
    }
  }

  /**
   * Get all keys of the session storage.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<List<String>> getSessionStorageKeys() {
    if (useJavascriptForStorageAPIs) {
      return execute(
          'var rtn = [];'
          'for (var i = 0; i < window.sessionStorage.length; i++)'
          '  rtn.push(window.sessionStorage.key(i));'
          'return rtn;'); 
    } else {
      return _get('session_storage');
    }
  }

  /**
   * Set the sessionstorage item for the given key.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future setSessionStorageItem(String key, String value) {
    if (useJavascriptForStorageAPIs) {
      return execute(
          'window.sessionStorage.setItem(arguments[0], arguments[1]);',
              [key, value]); 
    } else {
      return _post('session_storage', { 'key': key, 'value': value });
    }
  }

  /**
   * Clear the session storage.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future clearSessionStorage() {
    if (useJavascriptForStorageAPIs) {
      return execute('window.sessionStorage.clear();');
    } else {
      return _delete('session_storage');
    }
  }

  /**
   * Get the session storage item for the given key.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<String> getSessionStorageValue(String key) {
    if (useJavascriptForStorageAPIs) {
      return execute('return window.sessionStorage.getItem(arguments[0]);',
          [key]); 
    } else {
      return _get('session_storage/key/$key');
    }
  }

  /**
   * Delete the session storage item for the given key.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future deleteSessionStorageValue(String key) {
    if (useJavascriptForStorageAPIs) {
      return execute('return window.sessionStorage.removeItem(arguments[0]);',
          [key]); 
    } else {
      return _delete('session_storage/key/$key');
    }
  }

  /**
   * Get the number of items in the session storage.
   *
   * Potential Errors: NoSuchWindow.
   */
  Future<String> getSessionStorageCount() {
    if (useJavascriptForStorageAPIs) {
      return execute('return window.sessionStorage.length;');
    } else {
      return _get('session_storage/size');
    }
  }

  /**
   * Get available log types ('client', 'driver', 'browser', 'server').
   * This works with Firefox but Chrome returns a 500 response due to a 
   * bad cast.
   */
  Future<List<String>> getLogTypes() => _get('log/types');

  /**
   * Get the log for a given log type. Log buffer is reset after each request.
   * Each log entry is a [Map] with these fields:
   *
   * 'timestamp' (int) - The timestamp of the entry.
   * 'level' (String) - The log level of the entry, for example, "INFO".
   * 'message' (String) - The log message.
   *
   * This works with Firefox but Chrome returns a 500 response due to a 
   * bad cast.
   */
  Future<List<Map>> getLogs(String type) => _post('log', { 'type': type });
}