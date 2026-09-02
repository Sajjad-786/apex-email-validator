/* ======================================================================
   S&H Software Solutions
   Email Validator - Oracle APEX Item Plugin
   ----------------------------------------------------------------------
   Component : Client-side behavior
   Version   : 3.3.0 (shared title registry across S&H plugins, hidden
               inputs no longer block controlled buttons, hint box no
               longer collapses to the button's own width)
   Date      : 2026-08-06
   Author    : S&H Software Solutions
   License   : MIT License. This code is free and open to use, modify,
               and redistribute, with or without attribution, for
               personal or commercial projects.
   ----------------------------------------------------------------------
   NOTE: Client-side checks are UX feedback only. The authoritative
   validation must run server-side in the plugin's Validation
   Procedure, since JavaScript can be disabled or bypassed. The same
   applies to the blocked button.
   ====================================================================== */

// ------------------------------------------------------------------
// Shared across all S&H plugins: lets multiple validators controlling
// the SAME button combine their title text instead of overwriting
// each other. Guarded so it's safe to include in every plugin file
// (email_validator.js and password_validator.js both define this
// block identically - the first one to load wins, harmlessly).
// ------------------------------------------------------------------
if (!window.shRegisterBtnBlocker) {
  window.shBtnRegistry = {};

  window.shRegisterBtnBlocker = function (pButtonId, pKey, pMessage) {
    if (!pButtonId) { return; }
    var reg = window.shBtnRegistry;
    reg[pButtonId] = reg[pButtonId] || {};

    if (pMessage) {
      reg[pButtonId][pKey] = pMessage;
    } else {
      delete reg[pButtonId][pKey];
    }

    var button = document.getElementById(pButtonId);
    if (!button) { return; }

    var messages = Object.keys(reg[pButtonId]).map(function (k) {
      return reg[pButtonId][k];
    });

    if (messages.length > 0) {
      button.setAttribute("title", messages.join(" · "));
    } else {
      button.removeAttribute("title");
    }
  };
}

var shEmailValidator = {

  init: function (pElementId) {
    var wrapper = document.getElementById(pElementId + "_SH_EMAIL");
    if (!wrapper) {
      console.warn("shEmailValidator: wrapper not found for " + pElementId);
      return;
    }

    var input   = document.getElementById(pElementId);
    var popover = wrapper.querySelector(".sh-eml-popover");

    if (!input || !popover) {
      console.warn("shEmailValidator: incomplete markup for " + pElementId);
      return;
    }

    var ruleList   = popover.querySelector(".sh-eml-rule-list");
    var noticeList = popover.querySelector(".sh-eml-notice-list");
    var titleEl    = popover.querySelector(".sh-eml-popover-title");

    // Portal pattern: attach to <body> so no ancestor overflow or
    // stacking context can clip or cover the popover.
    document.body.appendChild(popover);

    // ------------------------------------------------------------------
    // Language: browser language starting with "de" -> German,
    // everything else -> English.
    // ------------------------------------------------------------------
    var isGerman = (navigator.language || "").toLowerCase().indexOf("de") === 0;
    function txt(pDe, pEn) { return isGerman ? pDe : pEn; }

    titleEl.textContent = txt("Validierung", "Validation");

    // ------------------------------------------------------------------
    // Configuration from data-* attributes
    // ------------------------------------------------------------------
    function attr(pName)   { return wrapper.getAttribute(pName) || ""; }
    function attrYN(pName) { return attr(pName) === "Y"; }

    var cfg = {
      require:         attrYN("data-require"),
      autoLowercase:   attrYN("data-auto-lowercase"),
      rejectSpaces:    attrYN("data-reject-spaces"),
      singleAt:        attrYN("data-single-at"),
      reqLocal:        attrYN("data-req-local"),
      reqDomain:       attrYN("data-req-domain"),
      noDoubleDots:    attrYN("data-no-double-dots"),
      noLocalEdge:     attrYN("data-no-local-edge"),
      noDomainEdge:    attrYN("data-no-domain-edge"),
      requireTld:      attrYN("data-require-tld"),
      tldCheck:        attrYN("data-tld-check"),
      domainCheck:     attrYN("data-domain-check"),
      localCheck:      attrYN("data-local-check"),
      tldPattern:      attr("data-tld-pattern"),
      domainPattern:   attr("data-domain-pattern"),
      localPattern:    attr("data-local-pattern"),
      minCheck:        attrYN("data-min-check"),
      maxCheck:        attrYN("data-max-check"),
      minLength:       parseInt(attr("data-min-length"), 10),
      maxLength:       parseInt(attr("data-max-length"), 10),
      restrictWlist:   attrYN("data-restrict-whitelist"),
      blockDisposable: attrYN("data-block-disposable"),
      buttonId:        attr("data-button-id")
    };

    // ------------------------------------------------------------------
    // Visibility guard: true only while the input is actually
    // rendered (not display:none, not inside a hidden ancestor such
    // as an unopened inline dialog). Used so a hidden field never
    // blocks a controlled button the user can't even see the field
    // for.
    // ------------------------------------------------------------------
    function isInputVisible() {
      return !!(input.offsetWidth || input.offsetHeight || input.getClientRects().length);
    }

    // ------------------------------------------------------------------
    // Optional controlled button
    // ------------------------------------------------------------------
    var controlledButton = cfg.buttonId ? document.getElementById(cfg.buttonId) : null;
    var buttonHint = null;

    if (cfg.buttonId && !controlledButton) {
      console.warn("shEmailValidator: button with static ID '" + cfg.buttonId + "' not found");
    }

    if (controlledButton) {
      // Intercept clicks in the capture phase so the block takes effect
      // before the button's own inline onclick (apex.submit) can fire.
      controlledButton.addEventListener("click", function (pEvent) {
        if (controlledButton.classList.contains("sh-eml-btn-blocked")) {
          pEvent.preventDefault();
          pEvent.stopImmediatePropagation();
        }
      }, true);

      // Hint element attached to <body> (portal pattern, same as the
      // popover) so no ancestor layout or overflow can affect it.
      buttonHint = document.createElement("div");
      buttonHint.className = "sh-eml-btn-hint sh-shared-btn-hint";
      // Shared marker so other S&H plugins (e.g. Password validator)
      // can recognize a hint box that targets the same button and
      // stack below it instead of overlapping it. Keep this attribute
      // name identical across plugins: data-sh-hint-button.
      buttonHint.setAttribute("data-sh-hint-button", cfg.buttonId);
      buttonHint.innerHTML = '<span class="sh-eml-btn-hint-icon"></span><span></span>';
      document.body.appendChild(buttonHint);

      // Plugin-agnostic visibility check (works regardless of which
      // CSS class another plugin uses to toggle its own hint box).
      function isElementVisible(pEl) {
        if (pEl === buttonHint) { return false; }
        var style = window.getComputedStyle(pEl);
        return style.display !== "none" && style.visibility !== "hidden";
      }

      // Positions the hint directly beneath the button - stacks below
      // any other currently visible hint box that also targets this
      // same button (e.g. from the Password validator plugin), instead
      // of overlapping it. Width is floored at a sensible minimum so a
      // small/compact button (e.g. a top-right icon button) doesn't
      // force the message text to wrap into a tall, many-line box.
      function positionButtonHint() {
        var rect = controlledButton.getBoundingClientRect();
        var top  = rect.bottom + 6;

        var others = document.querySelectorAll(
          '.sh-shared-btn-hint[data-sh-hint-button="' + cfg.buttonId + '"]'
        );
        others.forEach(function (pEl) {
          if (isElementVisible(pEl)) {
            var otherRect = pEl.getBoundingClientRect();
            top = Math.max(top, otherRect.bottom + 6);
          }
        });

        var hintWidth = Math.max(rect.width, 240);
        var hintLeft  = rect.left;
        if (hintLeft + hintWidth > window.innerWidth - 8) {
          hintLeft = Math.max(8, window.innerWidth - hintWidth - 8);
        }

        buttonHint.style.top   = top + "px";
        buttonHint.style.left  = hintLeft + "px";
        buttonHint.style.width = hintWidth + "px";
      }

      controlledButton.addEventListener("mouseenter", function () {
        if (controlledButton.classList.contains("sh-eml-btn-blocked")) {
          positionButtonHint();
          buttonHint.classList.add("sh-eml-btn-hint-visible");
        }
      });

      controlledButton.addEventListener("mouseleave", function () {
        buttonHint.classList.remove("sh-eml-btn-hint-visible");
      });

      // The hint is absolutely positioned, so its offset parent must
      // establish a positioning context - otherwise it anchors to the
      // page instead of sitting right under the button.
      if (getComputedStyle(controlledButton.parentNode).position === "static") {
        controlledButton.parentNode.style.position = "relative";
      }

      // Keep the hint glued under the button (and under any other
      // stacked hint) while the page scrolls or resizes.
      window.addEventListener("scroll", function () {
        if (buttonHint.classList.contains("sh-eml-btn-hint-visible")) {
          positionButtonHint();
        }
      }, true);

      window.addEventListener("resize", function () {
        if (buttonHint.classList.contains("sh-eml-btn-hint-visible")) {
          positionButtonHint();
        }
      });
    }

    function parseDomainList(pRaw) {
      if (!pRaw) { return []; }
      return pRaw.split(",")
        .map(function (d) { return d.trim().toLowerCase(); })
        .filter(function (d) { return d.length > 0; });
    }

    var whitelistDomains  = parseDomainList(attr("data-domain-whitelist"));
    var disposableDomains = parseDomainList(attr("data-disposable-list"));

    // ------------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------------
    function splitEmail(pValue) {
      var at = pValue.indexOf("@");
      if (at === -1) { return { local: pValue, domain: "", tld: "" }; }
      var local  = pValue.substring(0, at);
      var domain = pValue.substring(at + 1);
      var lastDot = domain.lastIndexOf(".");
      var tld = lastDot === -1 ? "" : domain.substring(lastDot + 1);
      return { local: local, domain: domain, tld: tld };
    }

    function safeRegexTest(pPattern, pValue) {
      try {
        return new RegExp(pPattern).test(pValue);
      } catch (e) {
        console.warn("shEmailValidator: invalid pattern configured: " + pPattern);
        return false;
      }
    }

    // ------------------------------------------------------------------
    // Rule definitions
    // ------------------------------------------------------------------
    var rules = [
      {
        active: cfg.require,
        message: txt("Feld darf nicht leer sein", "Field must not be empty"),
        test: function (v) { return v.trim().length > 0; }
      },
      {
        active: cfg.rejectSpaces,
        message: txt("Keine Leerzeichen oder Steuerzeichen erlaubt",
                     "No spaces or control characters allowed"),
        test: function (v) { return !/[\s\u0000-\u001F\u007F]/.test(v); }
      },
      {
        active: cfg.singleAt,
        message: txt("Muss genau ein @-Zeichen enthalten",
                     "Must contain exactly one @ symbol"),
        test: function (v) {
          if (v.trim().length === 0) { return true; }
          return (v.match(/@/g) || []).length === 1;
        }
      },
      {
        active: cfg.reqLocal,
        message: txt("Name vor dem @ fehlt", "Name before @ is missing"),
        test: function (v) {
          if (v.trim().length === 0 || v.indexOf("@") === -1) { return true; }
          return splitEmail(v).local.length > 0;
        }
      },
      {
        active: cfg.reqDomain,
        message: txt("Domain nach dem @ fehlt", "Domain after @ is missing"),
        test: function (v) {
          if (v.trim().length === 0 || v.indexOf("@") === -1) { return true; }
          return splitEmail(v).domain.length > 0;
        }
      },
      {
        active: cfg.noDoubleDots,
        message: txt("Keine doppelten Punkte (..) erlaubt",
                     "No consecutive dots (..) allowed"),
        test: function (v) { return v.indexOf("..") === -1; }
      },
      {
        active: cfg.noLocalEdge,
        message: txt("Teil vor dem @ darf nicht mit Punkt beginnen oder enden",
                     "Part before @ must not start or end with a dot"),
        test: function (v) {
          var local = splitEmail(v).local;
          if (local.length === 0) { return true; }
          return local.charAt(0) !== "." && local.charAt(local.length - 1) !== ".";
        }
      },
      {
        active: cfg.noDomainEdge,
        message: txt("Domain darf nicht mit Punkt oder Bindestrich beginnen oder enden",
                     "Domain must not start or end with a dot or hyphen"),
        test: function (v) {
          var domain = splitEmail(v).domain;
          if (domain.length === 0) { return true; }
          var first = domain.charAt(0);
          var last  = domain.charAt(domain.length - 1);
          return first !== "." && first !== "-" && last !== "." && last !== "-";
        }
      },
      {
        active: cfg.requireTld,
        message: txt("Domain braucht eine Endung (z. B. .de, .com)",
                     "Domain must contain a top-level domain (e.g. .de, .com)"),
        test: function (v) {
          var domain = splitEmail(v).domain;
          if (domain.length === 0) { return true; }
          return domain.indexOf(".") !== -1;
        }
      },
      {
        active: cfg.tldCheck && cfg.tldPattern.length > 0,
        message: txt("Domain-Endung ist ungültig", "Top-level domain is invalid"),
        test: function (v) {
          var tld = splitEmail(v).tld;
          if (tld.length === 0) { return true; }
          return safeRegexTest(cfg.tldPattern, tld);
        }
      },
      {
        active: cfg.localCheck && cfg.localPattern.length > 0,
        message: txt("Teil vor dem @ enthält unzulässige Zeichen",
                     "Part before @ contains invalid characters"),
        test: function (v) {
          var local = splitEmail(v).local;
          if (local.length === 0) { return true; }
          return safeRegexTest(cfg.localPattern, local);
        }
      },
      {
        active: cfg.domainCheck && cfg.domainPattern.length > 0,
        message: txt("Domain enthält unzulässige Zeichen",
                     "Domain contains invalid characters"),
        test: function (v) {
          var domain = splitEmail(v).domain;
          if (domain.length === 0) { return true; }
          return safeRegexTest(cfg.domainPattern, domain);
        }
      },
      {
        active: cfg.minCheck && !isNaN(cfg.minLength),
        message: txt("Mindestens " + cfg.minLength + " Zeichen erforderlich",
                     "At least " + cfg.minLength + " characters required"),
        test: function (v) {
          return v.trim().length === 0 || v.trim().length >= cfg.minLength;
        }
      },
      {
        active: cfg.maxCheck && !isNaN(cfg.maxLength),
        message: txt("Höchstens " + cfg.maxLength + " Zeichen erlaubt",
                     "No more than " + cfg.maxLength + " characters allowed"),
        test: function (v) { return v.trim().length <= cfg.maxLength; }
      },
      {
        active: cfg.restrictWlist,
        message: txt("Domain ist nicht auf der erlaubten Liste",
                     "Domain is not on the allowed list"),
        test: function (v) {
          var domain = splitEmail(v).domain.toLowerCase();
          if (domain.length === 0) { return true; }
          return whitelistDomains.length === 0 || whitelistDomains.indexOf(domain) !== -1;
        }
      },
      {
        active: cfg.blockDisposable,
        message: txt("Wegwerf-E-Mail-Anbieter sind nicht erlaubt",
                     "Disposable email providers are not allowed"),
        test: function (v) {
          var domain = splitEmail(v).domain.toLowerCase();
          if (domain.length === 0) { return true; }
          return disposableDomains.indexOf(domain) === -1;
        }
      }
    ];

    var activeRules = rules.filter(function (r) { return r.active; });

    // ------------------------------------------------------------------
    // Notices (blue info rows), built once
    // ------------------------------------------------------------------
    function buildNotices() {
      var notices = [];

      if (cfg.autoLowercase) {
        notices.push(txt("Automatische Kleinschreibung ist aktiv",
                         "Automatic lowercase is active"));
      }

      if (cfg.maxCheck && !isNaN(cfg.maxLength)) {
        notices.push(txt("Maximal " + cfg.maxLength + " Zeichen",
                         "Maximum " + cfg.maxLength + " characters"));
      }

      if (cfg.restrictWlist && whitelistDomains.length > 0) {
        var shown = whitelistDomains.slice(0, 3).join(", ");
        var rest  = whitelistDomains.length - 3;
        var listText = rest > 0
          ? shown + txt(" und " + rest + " weitere", " and " + rest + " more")
          : shown;
        notices.push(txt("Erlaubte Domains: ", "Allowed domains: ") + listText);
      }

      noticeList.innerHTML = "";
      notices.forEach(function (n) {
        var row = document.createElement("span");
        row.className = "sh-eml-notice";
        var icon = document.createElement("i");
        icon.className = "sh-eml-notice-icon";
        var text = document.createElement("span");
        text.textContent = n;
        row.appendChild(icon);
        row.appendChild(text);
        noticeList.appendChild(row);
      });

      noticeList.classList.toggle("sh-eml-has-notices", notices.length > 0);
    }

    buildNotices();

    // ------------------------------------------------------------------
    // Rendering: failed rules only; green line when all pass
    // ------------------------------------------------------------------
    function renderList(pValue) {
      var failed = activeRules.filter(function (r) { return !r.test(pValue); });

      ruleList.innerHTML = "";

      if (pValue.trim().length === 0 && !cfg.require) {
        var neutral = document.createElement("span");
        neutral.className = "sh-eml-neutral";
        neutral.textContent = txt("Tippen zum Validieren", "Start typing to validate");
        ruleList.appendChild(neutral);
        return failed;
      }

      if (failed.length === 0) {
        var ok = document.createElement("span");
        ok.className = "sh-eml-success";
        ok.innerHTML = '<i class="sh-eml-success-icon"></i><span>'
          + txt("Alle Validierungen bestanden", "All validations passed")
          + '</span>';
        ruleList.appendChild(ok);
        return failed;
      }

      failed.forEach(function (r) {
        var row = document.createElement("span");
        row.className = "sh-eml-error";
        var icon = document.createElement("i");
        icon.className = "sh-eml-error-icon";
        var text = document.createElement("span");
        text.textContent = r.message;
        row.appendChild(icon);
        row.appendChild(text);
        ruleList.appendChild(row);
      });

      return failed;
    }

    function updateAll() {
      var failed = renderList(input.value);
      var invalid = failed.length > 0
        && !(input.value.trim().length === 0 && !cfg.require);
      input.classList.toggle("sh-eml-invalid", invalid);

      if (controlledButton) {
        // A field that isn't currently visible (e.g. sitting inside
        // an unopened inline dialog) must never block a button the
        // user can't even see the field for.
        var isBlocked = isInputVisible() && failed.length > 0;

        // Not using the "disabled" property: browsers suppress mouse
        // events (and therefore tooltips) on disabled elements.
        controlledButton.classList.toggle("sh-eml-btn-blocked", isBlocked);
        controlledButton.setAttribute("aria-disabled", isBlocked ? "true" : "false");

        var hintText = txt("Bitte zuerst eine gültige E-Mail-Adresse eingeben",
                           "Please enter a valid email address first");

        // Registers/unregisters this instance's message on the shared
        // button title registry instead of overwriting the button's
        // title attribute directly (see top of file).
        window.shRegisterBtnBlocker(cfg.buttonId, pElementId, isBlocked ? hintText : null);

        if (buttonHint) {
          buttonHint.lastElementChild.textContent = hintText;
          // Hide immediately when the button becomes usable, even if
          // the cursor is still hovering over it.
          if (!isBlocked) {
            buttonHint.classList.remove("sh-eml-btn-hint-visible");
          }
        }
      }
    }

    function positionPopover() {
      var rect = input.getBoundingClientRect();
      popover.style.top   = (rect.bottom + 6) + "px";
      popover.style.left  = rect.left + "px";
      popover.style.width = rect.width + "px";
    }

    // ------------------------------------------------------------------
    // Auto-lowercase transformation
    // ------------------------------------------------------------------
    if (cfg.autoLowercase) {
      input.addEventListener("input", function () {
        var start = input.selectionStart;
        var end   = input.selectionEnd;
        var lower = input.value.toLowerCase();

        if (lower !== input.value) {
          input.value = lower;
          try {
            input.setSelectionRange(start, end);
          } catch (e) {
            // some browsers don't support this on type="email" - not critical
          }
        }
      });
    }

    // ------------------------------------------------------------------
    // Events
    // ------------------------------------------------------------------
    input.addEventListener("focus", function () {
      positionPopover();
      popover.classList.add("sh-eml-popover-open");
      updateAll();
    });

    input.addEventListener("input", function () {
      updateAll();
      if (popover.classList.contains("sh-eml-popover-open")) {
        positionPopover();
      }
    });

    input.addEventListener("blur", function () {
      setTimeout(function () {
        popover.classList.remove("sh-eml-popover-open");
      }, 150);
      updateAll();
    });

    window.addEventListener("scroll", function () {
      if (popover.classList.contains("sh-eml-popover-open")) {
        positionPopover();
      }
    }, true);

    window.addEventListener("resize", function () {
      if (popover.classList.contains("sh-eml-popover-open")) {
        positionPopover();
      }
    });

    // Re-run validation the moment this input becomes visible/hidden
    // again (e.g. an inline dialog being opened or closed). Without
    // this, a field that is hidden at page-load time would stay stuck
    // in whatever blocked/unblocked state it had on first render,
    // even after the dialog later reveals it.
    if (controlledButton && window.IntersectionObserver) {
      var shEmlVisObserver = new IntersectionObserver(function () {
        updateAll();
      });
      shEmlVisObserver.observe(input);
    }

    updateAll();
  }

};