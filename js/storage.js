//*****************************************************************************
//*****************************************************************************
/*
 * This package contains all functions needed to store data on and load data 
 * from the client side.
 *
 * @date	2014-05-02
 * @author	Tobias Riedel
 * @version	1.2
 */
 //*****************************************************************************
 //*****************************************************************************
function getCookie(c_name) {
	var i, x, y, ARRcookies = document.cookie.split(';');
	for (i = 0; i < ARRcookies.length; i++) {
		x = ARRcookies[i].substr(0,ARRcookies[i].indexOf('='));
		y = ARRcookies[i].substr(ARRcookies[i].indexOf('=') + 1);
		x = x.replace(/^\s+|\s+$/g,'');
		if (x == c_name) {
			return unescape(y);
		}
	}
}
//*****************************************************************************
function setCookie(c_name, value, exdays) {
	var exdate = new Date();
	exdate.setDate(exdate.getDate() + exdays);
	var c_value = escape(value) + ((exdays == null) ? '' : '; expires=' + exdate.toUTCString());
	document.cookie = c_name + '=' + c_value;
}
//*****************************************************************************
function areCookiesSupported() {
	setCookie('cookie', 'true');
	return getCookie('cookie') == 'true';
}
//*****************************************************************************
function isHTML5StorageSupported() {
	if (localStorage === undefined) {
		return false;
	}
	
	localStorage.setItem('localStorage', 'true');
	return localStorage.getItem('localStorage') == 'true';
}
//*****************************************************************************
function isStorageSupported() {
	return areCookiesSupported() || isHTML5StorageSupported();
}
//*****************************************************************************
function store(name, value) {
	var val = value;
	
	if (typeof val === 'object') {
		val = JSON.stringify(val);
	} else if (typeof val === 'string') {
		// Add a marker in front of the string to flag it as a string.
		val = ' ' + val;
	}

	if (areCookiesSupported()) {
		setCookie(name, val, 9999);
		return true;
	} else if (isHTML5StorageSupported()) {
		localStorage.setItem(name, val);
		return true;
	}
	
	return false;
}
//*****************************************************************************
function load(name) {

	var val = null;
	
	if (areCookiesSupported()) {
		val = getCookie(name);
	} else if (isHTML5StorageSupported()) {
		val = localStorage.getItem(name);
	}
	
	if (val === undefined) {
		return null;
	}
	
	if (isJson(val)) {
		return JSON.parse(val);
	} else if (val.indexOf(' ') === 0) {
		// Remove string flag at the beginning of the data.
		 val = val.substr(1, val.length);
	}

	return val;
}
//*****************************************************************************
function remove(name) {
	removeCookie(name);
	removeLocalStorageItem(name);
}
//*****************************************************************************
function removeLocalStorageItem(name) {
	localStorage.removeItem(name);
}
//*****************************************************************************
function removeCookie(name) {
    document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
};
//*****************************************************************************
function isJson(str) {
	try {
		JSON.parse(str);
	} catch (e) {
		return false;
	}
	return true;
}
//*****************************************************************************