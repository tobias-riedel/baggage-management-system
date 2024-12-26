//*****************************************************************************
//*****************************************************************************
/*
 * This file contains most functions needed for the Baggage Management System
 * (BMS) to work.
 *
 * @date	2015-06-11
 * @author	Tobias Riedel
 * @version	1.6
 */
//*****************************************************************************
//*****************************************************************************

const aniTime = 1020;
const cssAnimatedBag = "animatedBag";
const cssMovedBag = "movedBag";

const bagIcons = [
  "img/bag_black.png",
  "img/bag_black2.png",
  "img/bag_brown.png",
  "img/bag_brown2.png",
  "img/bag_light_brown.png",
];

// image offsets
let offsetX = 0;
let offsetY = 0;

// set global variable to do frequent updates of the image
let isImageUpdateEnabled = true;
// set global variable to mark a specific bag in the image
let markedBag = 0;

// UI element array for repositioning after reload
let uiElements = {};
const defaultUIElements = {};

// the global terminal ID
let terminalID = 0;

//*****************************************************************************
const getTerminalID = function () {
  return terminalID;
};
//*****************************************************************************
const setTerminalID = function (id) {
  terminalID = id;
};
//*****************************************************************************
// prevent unwanted caching for constantly refreshed page requests
const getQueryURL = function () {
  return "query.ajax.php?t=" + Math.random() + new Date().getTime();
};
const getImageURL = function () {
  return "bags.img.php?t=" + Math.random() + new Date().getTime();
};
//*****************************************************************************
/*
 * This function sets default values for the settings and saves them.
 */
function setDefaults() {
  if (load("setting.showBagIDs") == null) {
    store("setting.showBagIDs", false);
  }
  if (load("setting.use3d") == null) {
    store("setting.use3d", true);
  }
  if (load("setting.showRenderTime") == null) {
    store("setting.showRenderTime", false);
  }
  if (load("setting.showStats") == null) {
    store("setting.showStats", true);
  }
  if (load("setting.useAnimations") == null) {
    store("setting.useAnimations", true);
  }
  if (load("setting.animationIcon") == null) {
    store("setting.animationIcon", "random");
  }
  if (load("setting.log.fontSize") == null) {
    var s = $("#log").css("font-size");
    s = Math.floor(s.substr(0, s.indexOf("px")));
    store("setting.log.fontSize", s);
  }
  if (load("setting.theme") == null) {
    store("setting.theme", "bms_light");
  }
  if (load("setting.renderStyle") == null) {
    store("setting.renderStyle", "rect");
  }
}
//*****************************************************************************
/*
 * This function parses XML as a workaround.
 *
 * @param	String		haystack	the text to parse from
 * @param	String		tag			the tag to get the text from between
 * @return	String					the parsed text
 * @date	2008-09-05
 * @author	Tobias Riedel
 * @version	1.1
 */
function parse(haystack, tag) {
  // prepare tags
  tagBegin = "<" + tag + ">";
  tagEnd = "</" + tag + ">";

  // parse
  return haystack.substring(
    haystack.indexOf(tagBegin) + tagBegin.length,
    haystack.indexOf(tagEnd)
  );
}
//*****************************************************************************
/*
 * This function adds new entries to the log.
 *
 * @param	String		text		the text to be added
 * @param	DOM-element	c			the container's name to display the text in
 * @param	Boolean		isTimestamp	if true, use time stamp; otherwise do not display time stamp
 * @date	2008-09-05
 * @author	Tobias Riedel
 * @version	1.0
 */
function log(text, c, useTimestamp) {
  // optional parameters
  c = typeof c === "undefined" ? "#log" : c;
  useTimestamp = typeof useTimestamp === "undefined" ? true : useTimestamp;

  var $c = $(c);

  // get some date information
  var timestamp = new Date();
  if ((year = timestamp.getYear()) < 2000) year += 1900;
  if ((month = timestamp.getMonth() + 1) < 10) month = "0" + month;
  if ((day = timestamp.getDate()) < 10) day = "0" + day;
  if ((hours = timestamp.getHours()) < 10) hours = "0" + hours;
  if ((minutes = timestamp.getMinutes()) < 10) minutes = "0" + minutes;
  if ((seconds = timestamp.getSeconds()) < 10) seconds = "0" + seconds;

  // set timeformat
  var timeformat =
    year +
    "-" +
    month +
    "-" +
    day +
    " " +
    hours +
    ":" +
    minutes +
    ":" +
    seconds;
  var msg = useTimestamp
    ? ($c.val().length != 0 ? "\n" : "") + "[" + timeformat + "] " + text
    : text;

  // add log entry to the bottom of the log
  $c.append(msg);

  // scroll textarea down
  var textarea = $c.get(0);
  textarea.scrollTop = textarea.scrollHeight;
}
//*****************************************************************************
/*
 * This function retrieves the baggage list using Ajax.
 *
 * @param	String		requestUrl		the url the request shall be sent to
 * @date	2008-09-09
 * @author	Tobias Riedel
 * @version	1.2
 */
function retrieveBaggageList(requestUrl) {
  $.get(requestUrl, { action: "getBaggageList" }, function (data) {
    logEntry = parse(data, "QUERY");
    bagList = parse(data, "BAG_LIST");
    enableSelect = parse(data, "ENABLE_SELECT");

    log(logEntry);
    $("#bagList").html(bagList);

    if (enableSelect) {
      $("#bagList").removeAttr("disabled");
    } else {
      $("#bagList").attr("disabled", "disabled");
    }
  });
  $("#getBag")
    .attr("src", "img/gui/list-remove-disabled.png")
    .attr("disabled", "disabled");
}
//*****************************************************************************
/*
 * This function sets the event scheduler and updates its switch using Ajax.
 *
 * @param	Srring		event			the event to be set
 * @param	integer		value			the value the event shall be set to
 * @param	String		requestUrl		the url the request shall be sent to
 * @date	2008-09-05
 * @author	Tobias Riedel
 * @version	1.0
 */
function setEvent(event, value, requestUrl) {
  $.get(
    requestUrl,
    { action: "setEvent", perform: event, value: value },
    function (data) {
      log(data);
    }
  );

  getEvent(event, requestUrl);
}
//*****************************************************************************
/*
 * This function gets information about events and updates their switch.
 *
 * @param	Srring		event			the event to be checked
 * @param	String		requestUrl		the url the request shall be sent to
 * @date	2008-09-05
 * @author	Tobias Riedel
 * @version	1.0
 */
function getEvent(event, requestUrl) {
  $.get(requestUrl, { action: "getEvent", perform: event }, function (data) {
    log($("EVENT QUERY", data).text());

    var isEnabled = parseInt([$("EVENT STATE", data).text()]) == 1;
    var newVal = isEnabled ? 0 : 1;

    switch (event) {
      case "autoMode":
        $("#btnAutoMode")
          .attr(
            "src",
            isEnabled
              ? "img/gui/media-repeat-active.png"
              : "img/gui/media-repeat.png"
          )
          .val(newVal);
        break;
      case "scheduler":
        $("#btnScheduler")
          .attr(
            "src",
            isEnabled
              ? "img/gui/media-play-active.png"
              : "img/gui/media-play.png"
          )
          .val(newVal);
        break;
      case "24hLimit":
        $("#btn24hLimit")
          .attr("src", isEnabled ? "img/gui/24h-active.png" : "img/gui/24h.png")
          .val(newVal);
        break;
      default:
    }
  });
}
//*****************************************************************************
/*
 * This function animates the bags.
 *
 * @param	String		requestUrl		the url the request shall be sent to
 * @date	2014-04-16
 * @author	Tobias Riedel
 * @version	1.0
 */
function animateBags(requestUrl) {
  $.get(requestUrl, { action: "animate" }, function (data) {
    logEntry = parse(data, "QUERY");
    bagList = parse(data, "HTML");

    $("#bagsScript").html(bagList);
  });
}
//*****************************************************************************
/*
 * This function inserts and moves the bags.
 *
 * @param	Integer		id		the ID of the bag
 * @param	Integer		x		the x position of the bag
 * @param	Integer		y		the y position of the bag
 * @param	Integer		z		the z position of the bag
 * @param	Integer		w		the width of the bag image in pixels
 * @param	Integer		h		the height of the bag image in pixels
 * @param	Integer		ox		the x-offset of the bag image in pixels
 * @param	Integer		oy		the y-offset of the bag image in pixels
 * @param	Integer		zi		the z-index of the bag image
 */
function putBag(id, x, y, z, w, h, ox, oy, zi) {
  var x2 = x * w - z * ox + 5 - getImageOffsetX();
  var y2 = y * h - z * oy + 23 - getImageOffsetY();
  var w2 = w + ox;
  var h2 = h + oy;

  var bagImgVal = $('input[name="animationIcon"]:checked').val();
  var bagImg = bagImgVal;
  var sel = "#bag_" + id;
  var $elem = $(sel);

  if ($elem.length > 0) {
    // Move existing bag.
    $elem
      .animate(
        {
          left: x2,
          top: y2,
        },
        aniTime,
        "linear"
      )
      .css("z-index", zi)
      .dequeue();

    $elem.addClass(cssMovedBag);
  } else {
    // Insert new bag.
    if (bagImgVal == "random") {
      bagImg = bagIcons[Math.floor(Math.random() * bagIcons.length)];
    }

    $("#bags").append(
      '<img src="' +
        bagImg +
        '" class="' +
        cssAnimatedBag +
        " " +
        cssMovedBag +
        '" id="bag_' +
        id +
        '" width="' +
        w2 +
        '" height="' +
        h2 +
        '" style="position: absolute; left: ' +
        x2 +
        "px; top: " +
        y2 +
        'px; opacity: 0;"/>'
    );
    $(sel).fadeTo(300, 0.9);
  }
}
//*****************************************************************************
/*
 * This function removes obsolete bags.
 */
function flushBags() {
  $("." + cssAnimatedBag)
    .not("." + cssMovedBag)
    .each(function () {
      var w = Math.round($(this).width());

      $(this).animate(
        {
          left: "-=" + w + "px",
          opacity: 0,
        },
        aniTime,
        "linear",
        function () {
          $(this).remove();
        }
      );
    });

  $("." + cssMovedBag).removeClass(cssMovedBag);
}
//*****************************************************************************
/*
 * This function removes all animated bags.
 */
function stopAnimateBags() {
  $(".animatedBag").fadeOut(aniTime, function () {
    $(this).remove();
  });
}
//*****************************************************************************
/*
 * This function sets the offsets for images.
 *
 * @date	2014-05-02
 * @author	Tobias Riedel
 * @version	1.0
 */
function setImageOffset() {
  var initX = 20;
  var initY = 100;
  $("#bags").html(
    '<IMG ID="offsetImg" SRC="img/terminal.png" WIDTH="29" HEIGHT="29" STYLE="visibility: hidden; POSITION: absolute; LEFT: ' +
      initX +
      "px; TOP: " +
      initY +
      'px;"/>'
  );

  var $el = $("#offsetImg");
  setImageOffsetX($el.position().left - initX);
  setImageOffsetY($el.position().top - initY);

  $el.remove();
}
//*****************************************************************************
/*
 * This function gets the X offset for images.
 *
 * @date	2014-05-02
 * @author	Tobias Riedel
 * @version	1.0
 */
function getImageOffsetX() {
  return offsetX;
}
//*****************************************************************************
/*
 * This function sets the X offset for images.
 *
 * @param	x		Integer		the x value to be set for the offset
 * @date	2014-05-02
 * @author	Tobias Riedel
 * @version	1.0
 */
function setImageOffsetX(x) {
  offsetX = x;
}
//*****************************************************************************
/*
 * This function gets the Y offset for images.
 *
 * @date	2014-05-02
 * @author	Tobias Riedel
 * @version	1.0
 */
function getImageOffsetY() {
  return offsetY;
}
//*****************************************************************************
/*
 * This function sets the Y offset for images.
 *
 * @param	y		Integer		the y value to be set for the offset
 * @date	2014-05-02
 * @author	Tobias Riedel
 * @version	1.0
 */
function setImageOffsetY(y) {
  offsetY = y;
}
//*****************************************************************************
/*
 * This function disables or re-enables the content of the website.
 *
 * @param	o		if set to true, the contents of the website are enabled;
 *					otherwise they are disabled.
 */
function setModality(o) {
  if (o == true) {
    $(".modalOverlay").fadeOut(400, function () {
      $(this).remove();
    });
  } else {
    $("body").append('<div class="modalOverlay"></div>');
    $(".modalOverlay").hide().fadeTo(400, 1);
  }
}
//*****************************************************************************
/*
 * Get the state of the image updater.
 *
 * @returns			the image updater state.
 */
function isImageUpdaterEnabled() {
  return isImageUpdateEnabled;
}
//*****************************************************************************
/*
 * Enable or disable the image updater.
 *
 * @param	val		if set to true, the image of the BMS will be constantly updated;
 *					otherwise no updates.
 */
function setImageUpdaterEnabled(val) {
  isImageUpdateEnabled = val == true;
}
//*****************************************************************************
/*
 * This function renders the BMS image once.
 */
function renderImage() {
  var labels = load("setting.showBagIDs");
  var use3d = load("setting.use3d");
  var useAnimations = load("setting.useAnimations");
  var renderTime = load("setting.showRenderTime");
  var stats = load("setting.showStats");
  var textColor = $("fieldset").css("color");
  var renderStyle = load("setting.renderStyle");

  // prevent flickering when loading the image by pre-loading it
  var imgSrc =
    getImageURL() +
    "&mark=" +
    markedBag +
    "&labels=" +
    labels +
    "&use3d=" +
    use3d +
    "&useAnimations=" +
    useAnimations +
    "&rtime=" +
    renderTime +
    "&stats=" +
    stats +
    "&textColor=" +
    textColor +
    "&renderStyle=" +
    renderStyle;
  $("#bagImg").attr("src", imgSrc);
  /*
	$(new Image()).attr('src', imgSrc).load(function() {
		$('#bagImg').attr('src', this.src);
	});
	*/

  $iconInputs = $('input[name="animationIcon"]');
  if (useAnimations) {
    $iconInputs.removeAttr("disabled");
    animateBags(getQueryURL());
  } else {
    $iconInputs.attr("disabled", "disabled");
    stopAnimateBags();
  }
}
//*****************************************************************************
/*
 * This function updates the image frequently.
 *
 * @date	2013-12-19
 * @author	Tobias Riedel
 * @version	1.2
 */
function imageUpdater() {
  if (isImageUpdaterEnabled()) {
    renderImage();
  }

  // repeat
  setTimeout("imageUpdater()", aniTime);
}
//*****************************************************************************
/*
 * This function restores the UI from a former session.
 *
 * @date	2014-05-02
 * @author	Tobias Riedel
 * @version	1.0
 */
function restoreUISession() {
  // Set the control buttons status.
  $("#btn3d").attr(
    "src",
    "img/gui/3d" + (load("setting.use3d") ? "-active" : "") + ".png"
  );
  $("#btnBaggageIDs").attr(
    "src",
    "img/gui/id" + (load("setting.showBagIDs") ? "-active" : "") + ".png"
  );
  $("#btnStatistics").attr(
    "src",
    "img/gui/statistics" + (load("setting.showStats") ? "-active" : "") + ".png"
  );
  $("#btnRenderTime").attr(
    "src",
    "img/gui/render-time" +
      (load("setting.showRenderTime") ? "-active" : "") +
      ".png"
  );
  $("#btnAnimations").attr(
    "src",
    "img/gui/animations" +
      (load("setting.useAnimations") ? "-active" : "") +
      ".png"
  );

  // Save default values for UI elements.
  $("fieldset").each(function () {
    var x = Math.round($(this).offset().left);
    var y = Math.round($(this).offset().top);
    var id = $(this).data("fieldset-id");

    var el = {
      id: id,
      x: x,
      y: y,
    };

    defaultUIElements[el.id] = el;
  });

  if (!(load("setting.showQueries") != false)) {
    $('fieldset[data-fieldset-id="queries"]').hide();
  }

  var aniIcon = load("setting.animationIcon");
  if (aniIcon !== undefined) {
    $('input[name="animationIcon"][value="' + aniIcon + '"]:radio').prop(
      "checked",
      true
    );
  }

  // Reposition dragged elements.
  var storedUIElements = load("uiElements");
  if (storedUIElements == null || storedUIElements === undefined) {
    uiElements = {};
  } else {
    uiElements = storedUIElements;
    if (uiElements == null) {
      uiElements = {};
    }

    for (key in uiElements) {
      var o = uiElements[key];
      $('fieldset[data-fieldset-id="' + o.id + '"]').offset({
        left: o.x,
        top: o.y,
      });
    }
  }

  var theme = load("setting.theme");
  $("#theme").attr("href", "css/" + theme + ".css");
  $("#slctTheme").val(theme);

  // Set check boxes from last session.
  $("#checkboxShowHelpBubbles").prop(
    "checked",
    load("setting.showHelpBubbles") != false
  );
  $("#checkboxShowQueries").prop(
    "checked",
    load("setting.showQueries") != false
  );
  $("#slctRenderStyle").val(load("setting.renderStyle"));

  // Restore saved query log font size.
  $("#log").css("font-size", load("setting.log.fontSize") + "px");
}
//*****************************************************************************
/*
 * This function restores the UI to the default status.
 *
 * @date	2014-05-03
 * @author	Tobias Riedel
 * @version	1.0
 */
function restoreUIDefault() {
  // Make "queries" element visible.
  var $showQueries = $("#checkboxShowQueries");
  if (!$showQueries.prop("checked")) {
    $showQueries.prop("checked", true).trigger("change");
  }

  for (key in defaultUIElements) {
    var o = defaultUIElements[key];

    // Reposition element.
    $('fieldset[data-fieldset-id="' + o.id + '"]').animate(
      {
        left: 0,
        top: 0,
      },
      1000
    );
  }

  remove("uiElements");

  // Reset query log font size.
  $("#log").css("font-size", "");
  var logFontSize = $("#log").css("font-size");
  logFontSize = Math.floor(logFontSize.substr(0, logFontSize.indexOf("px")));
  store("setting.log.fontSize", logFontSize);

  $("#slctTheme").val("bms_light").trigger("change");
  $("#slctRenderStyle").val("rect").trigger("change");
}
//*****************************************************************************
/*
 * This function restores the UI from a former session.
 *
 * @param	el		JSON	the JSON object, containing this element's data
 * @date	2014-05-02
 * @author	Tobias Riedel
 * @version	1.0
 */
function storeUIElement($el) {
  if ($el.length == 0) {
    return;
  }

  var x = Math.round($el.offset().left);
  var y = Math.round($el.offset().top);
  var id = $el.data("fieldset-id");

  var o = {
    id: id,
    x: x,
    y: y,
  };

  uiElements[o.id] = o;
  store("uiElements", uiElements);
}
//*****************************************************************************
/*
 * This function checks all existing events once.
 */
function getEvents() {
  getEvent("24hLimit", getQueryURL());
  getEvent("autoMode", getQueryURL());
  getEvent("scheduler", getQueryURL());
}
//*****************************************************************************
/*
 * This function positions the element next to its anchor.
 *
 * @param	$el			the element to position next to its anchor
 * @param	$anchor		the anchor of the element that will be repositioned
 * @param	direction	the direction of the side where to place the element;
 *						values can be: 'top', 'bottom', 'left', 'right'
 * @param	offsetX		the x-offset to further position the element
 * @param	offsetY		the y-offset to further position the element
 */
function positionNextTo($el, $anchor, direction, offsetX, offsetY) {
  var ap = $anchor.position();
  var x = ap.left - getImageOffsetX() + offsetX;
  var y = ap.top - getImageOffsetY() + offsetY;

  switch (direction) {
    case "top":
      x -= $el.width() / 2;
      y -= $anchor.height() + $el.height();
      break;
    case "bottom":
      x -= $el.width() / 2;
      y += $anchor.height();
      break;
    case "left":
      x -= $anchor.width() + $el.width();
      y -= $el.height() / 2;
      break;
    case "right":
    default:
      x += $anchor.width();
      y -= $el.height() / 2;
  }

  $el.css({ position: "absolute", left: x, top: y });
}
//*****************************************************************************
/*
 * This function adds a new bag via the given terminal ID.
 *
 * @param	terminal		the ID of the terminal where the bag is placed
 */
function addBag(terminal) {
  // attach new log entry at beginning of log
  $.get(
    getQueryURL(),
    { action: "placeBaggage", id: terminal },
    function (data) {
      log(data);
      retrieveBaggageList(getQueryURL());
    }
  );

  // animate the terminal buttons
  $('.terminalImg[value="' + terminal + '"]')
    .animate(
      {
        marginLeft: "-20px",
        opacity: 1,
      },
      250
    )
    .animate(
      {
        marginLeft: "0px",
        opacity: 0.5,
      },
      250
    );

  $("#getBag")
    .attr("src", "img/gui/list-remove-disabled.png")
    .attr("disabled", "disabled");
}
//*****************************************************************************
/*
 * This function retrieves a bag from the shelf via the given terminal and bag IDs.
 *
 * @param	bag				the ID of the bag to be retrieved
 * @param	terminal		the ID of the terminal where the bag will be retrieved
 */
function getBag(bag, terminal) {
  // retrieve the baggage list
  $.get(
    getQueryURL(),
    { action: "retrieveBaggage", bagId: bag, dest: terminal },
    function (data) {
      retrieveBaggageList(getQueryURL());
      log(data);
    }
  );

  // animate the terminal buttons
  $('.terminalImg[value="' + terminal + '"]')
    .animate(
      {
        marginLeft: "+20px",
        opacity: 1,
      },
      250
    )
    .animate(
      {
        marginLeft: "0px",
        opacity: 0.5,
      },
      250
    );

  $("#getBag")
    .attr("src", "img/gui/list-remove-disabled.png")
    .attr("disabled", "disabled");
}
//*****************************************************************************
/*
 * This function centers a container vertically and horizontally in the window.
 */
jQuery.fn.extend({
  centerContainer: function () {
    var x = ($(document).width() - $(this).width()) / 2;
    var y = ($(document).height() - $(this).height()) / 2;
    $(this).css({ left: x, top: y });

    return $(this);
  },
});
//*****************************************************************************
/*
 * This function shows dialogs.
 *
 * @param	isModaul	if set to true, enable everything element on the site;
 *						otherwise disable everything but the dialog
 */
jQuery.fn.extend({
  showDialog: function (isModal) {
    if (isModal != true) {
      setModality(false);
    }

    $(this).centerContainer().fadeIn(400);
    return $(this);
  },
});
//*****************************************************************************
/*
 * This function hides dialogs.
 */
jQuery.fn.extend({
  hideDialog: function () {
    $(this).fadeOut(400);
    setModality(true);
    return $(this);
  },
});
//*****************************************************************************
//*****************************************************************************
$(function () {
  setDefaults();

  // activate the event scheduler on first start up of the session
  if (sessionStorage["visited"] != "true") {
    sessionStorage["visited"] = true;
    setEvent("scheduler", 1, getQueryURL());
  }

  // check events on startup
  getEvents();

  // get the baggage list on startup
  retrieveBaggageList(getQueryURL());

  // get the baggage list when clicking the link
  $("#buttonBaggageList").click(function (e) {
    retrieveBaggageList(getQueryURL());
  });

  // set opacity for terminal buttons
  $(".terminalImg")
    .animate(
      {
        marginLeft: "-14px",
      },
      500
    )
    .animate(
      {
        marginLeft: "0px",
        marginTop: "0px",
      },
      500
    )
    .animate(
      {
        opacity: 0.5,
      },
      500
    );

  // initialize event control
  $("#btnAutoMode").click(function (e) {
    e.preventDefault();
    setEvent("autoMode", $(this).val(), getQueryURL());
  });
  $("#btnScheduler").click(function (e) {
    e.preventDefault();
    setEvent("scheduler", $(this).val(), getQueryURL());
  });
  $("#btn24hLimit").click(function (e) {
    e.preventDefault();
    setEvent("24hLimit", $(this).val(), getQueryURL());
  });
  $("#btnNextStep").click(function (e) {
    e.preventDefault();
    $.get(getQueryURL(), { action: "moveBags" }, function (data) {
      log(data);
      renderImage();
    });
  });

  // fill shelves
  $("#buttonFillShelves").click(function (e) {
    e.preventDefault();
    num = $("#inputFillShelves").val();

    // attach new log entry at beginning of log
    $.get(getQueryURL(), { action: "fillShelves", num: num }, function (data) {
      log(data);
      retrieveBaggageList(getQueryURL());
    });
  });

  // discard baggage
  $("#discardBags").click(function (e) {
    $("#discardBaggageDialog").showDialog(false);
  });

  $("#confirmDiscardBags").click(function (e) {
    $.get(getQueryURL(), { action: "discardBaggage" }, function (data) {
      log(data);
      retrieveBaggageList(getQueryURL());
    });

    $("#discardBaggageDialog").hideDialog();
  });

  $("#cancelDiscardBags").click(function (e) {
    $("#discardBaggageDialog").hideDialog();
  });

  $("#bagImgs input.terminalImg").mouseenter(function (e) {
    var terminal = $(this).val();
    // needed for IE, because he does not accept the value-tag
    terminal = terminal.substr(terminal.length - 1, 1);
    setTerminalID(terminal);
    $("#terminalNumber").html(terminal);

    positionNextTo($("#getBaggage"), $(this), "left", 5, 0);
  });

  // Let the terminals add and retrieve baggage.
  $("#bagImgs input.terminalImg").click(function (e) {
    var id = $("#bagList").val();
    var terminal = getTerminalID();

    if (id == null) {
      addBag(terminal);
    } else {
      getBag(id, terminal);
    }
  });

  $("#addBag").click(function (e) {
    addBag(getTerminalID());
  });

  $("#getBag").click(function (e) {
    var id = $("#bagList").val();
    var terminal = getTerminalID();

    if (id != null) {
      getBag(id, terminal);
    }
  });

  // bind the newly created baggage list to mark the selected bag
  $("#bagList").change(function (e) {
    markedBag = $(this).val();
    $("#getBag").attr("src", "img/gui/list-remove.png").removeAttr("disabled");
  });

  // Make elements draggable.
  $("fieldset").draggable({
    handle: "legend",
    stop: function (event, ui) {
      storeUIElement($(this));
    },
  });

  // Adjust to image offset.
  setImageOffset();

  $(".terminalImg, fieldset .bubble").each(function () {
    var x = $(this).offset().left - getImageOffsetX();
    var y = $(this).offset().top - getImageOffsetY();
    $(this).offset({ top: y, left: x });
  });

  restoreUISession();

  // start the image updater thread
  imageUpdater();

  // Some graphical gimmick at start up.
  $('fieldset[id!="bagImgs"]').css("marginTop", "-400px").animate(
    {
      marginTop: 0,
    },
    1000
  );

  // Set the control button actions.
  $("#btn3d").click(function () {
    store("setting.use3d", !load("setting.use3d"));
    $(this).attr(
      "src",
      "img/gui/3d" + (load("setting.use3d") ? "-active" : "") + ".png"
    );
  });
  $("#btnBaggageIDs").click(function () {
    store("setting.showBagIDs", !load("setting.showBagIDs"));
    $(this).attr(
      "src",
      "img/gui/id" + (load("setting.showBagIDs") ? "-active" : "") + ".png"
    );
  });
  $("#btnStatistics").click(function () {
    store("setting.showStats", !load("setting.showStats"));
    $(this).attr(
      "src",
      "img/gui/statistics" +
        (load("setting.showStats") ? "-active" : "") +
        ".png"
    );
  });
  $("#btnRenderTime").click(function () {
    store("setting.showRenderTime", !load("setting.showRenderTime"));
    $(this).attr(
      "src",
      "img/gui/render-time" +
        (load("setting.showRenderTime") ? "-active" : "") +
        ".png"
    );
  });
  $("#btnAnimations").click(function () {
    store("setting.useAnimations", !load("setting.useAnimations"));
    $(this).attr(
      "src",
      "img/gui/animations" +
        (load("setting.useAnimations") ? "-active" : "") +
        ".png"
    );
  });

  // "About" dialog
  $("#btnAbout").click(function (e) {
    $("#aboutDialog").showDialog(false);
  });
  $("#btnCloseAboutDialog").click(function (e) {
    $("#aboutDialog").hideDialog();
  });

  // Position the popup for the animation icons.
  positionNextTo($("#terminal4Bubble"), $("#terminal4"), "right", 10, 5);
  positionNextTo($("#ctrlElemsBubble"), $("#ctrlElems"), "right", 15, 70);
  positionNextTo(
    $("#animationIconsPopup"),
    $("#btnAnimations"),
    "right",
    -3,
    0
  );
  positionNextTo($("#preferencesPopup"), $("#btnPreferences"), "right", -3, 0);

  $('input[name="animationIcon"]:radio').change(function () {
    store("setting.animationIcon", $(this).val());
  });

  $("#checkboxShowHelpBubbles").change(function () {
    store("setting.showHelpBubbles", $(this).prop("checked"));
  });
  $("#checkboxShowQueries").change(function () {
    var val = $(this).prop("checked");
    store("setting.showQueries", val);

    var $queries = $('fieldset[data-fieldset-id="queries"]');
    $queries.fadeToggle();

    if (val) {
      var o = load("uiElements").queries;
      $queries.offset({ left: o.x, top: o.y });
    } else {
      storeUIElement($queries);
    }
  });

  $("#slctTheme").change(function () {
    var val = $(this).val();
    store("setting.theme", val);
    $("#theme").attr("href", "css/" + val + ".css");
  });

  $("#slctRenderStyle").change(function () {
    var val = $(this).val();
    store("setting.renderStyle", val);
  });

  $("button#buttonResetUI").click(function () {
    restoreUIDefault();
  });

  $('input:radio[name="animationIcon"]').change(function () {
    var bagImgVal = $(this).val();
    var bagImg = bagImgVal;
    $(".animatedBag").each(function () {
      if (bagImgVal == "random") {
        bagImg = bagIcons[Math.floor(Math.random() * bagIcons.length)];
      }
      $(this).attr("src", bagImg);
    });
  });

  // help bubbles
  $(".bubble").hide();
  if (load("setting.showHelpBubbles") != false) {
    $('fieldset[data-fieldset-id="bagImage"] .bubble')
      .fadeIn(1000)
      .delay(2000)
      .fadeOut(2000);
  }

  // Close buttons for fieldsets.
  $("#btnCloseQueries").click(function () {
    $("#checkboxShowQueries").prop("checked", false).trigger("change");
  });

  // Increase/decrease query log font size.
  $("#btnLogFontSizeUp").click(function () {
    var s = load("setting.log.fontSize") + 1;
    $("#log").css("font-size", s + "px");
    store("setting.log.fontSize", s);
  });

  $("#btnLogFontSizeDown").click(function () {
    var s = load("setting.log.fontSize") - 1;
    if (s < 5) {
      s = 5;
    }
    $("#log").css("font-size", s + "px");
    store("setting.log.fontSize", s);
  });
});
