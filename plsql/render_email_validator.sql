------------------------------------------------------------------------
-- S&H Software Solutions
-- Email Validator - Oracle APEX Item Plugin
-- ------------------------------------------------------------------
-- Component : Render procedure
-- Version   : 3.1.0 (adds button disable-until-valid via static ID;
--             plus-addressing attribute replaced by button control -
--             blocking "+" is now done via the local-part pattern)
-- Date      : 2026-08-01
-- Author    : S&H Software Solutions
-- License   : MIT License. This code is free and open to use, modify,
--             and redistribute, with or without attribution, for
--             personal or commercial projects.
------------------------------------------------------------------------

PROCEDURE render_email_validator (
    p_item       IN            apex_plugin.t_item
  , p_plugin     IN            apex_plugin.t_plugin
  , p_param      IN            apex_plugin.t_item_render_param
  , p_result     IN OUT NOCOPY apex_plugin.t_item_render_result
)
IS
    ------------------------------------------------------------------
    -- Declarations (attribute numbers match the plugin configuration)
    ------------------------------------------------------------------
    v_element_id        VARCHAR2(4000) := p_item.name;
    v_current_value     VARCHAR2(4000) := p_param.value;
    v_icon              VARCHAR2(255)  := p_item.icon_css_classes;

    -- Basic validation
    v_require_value     VARCHAR2(1)    := NVL(p_item.attribute_01, 'N');
    v_button_id         VARCHAR2(255)  := p_item.attribute_02;
    v_auto_lowercase    VARCHAR2(1)    := NVL(p_item.attribute_03, 'N');
    v_reject_spaces     VARCHAR2(1)    := NVL(p_item.attribute_11, 'N');
    v_single_at         VARCHAR2(1)    := NVL(p_item.attribute_12, 'N');

    -- Structural checks
    v_req_local         VARCHAR2(1)    := NVL(p_item.attribute_13, 'N');
    v_req_domain        VARCHAR2(1)    := NVL(p_item.attribute_14, 'N');
    v_no_double_dots    VARCHAR2(1)    := NVL(p_item.attribute_15, 'N');
    v_no_local_edge     VARCHAR2(1)    := NVL(p_item.attribute_16, 'N');
    v_no_domain_edge    VARCHAR2(1)    := NVL(p_item.attribute_17, 'N');
    v_require_tld       VARCHAR2(1)    := NVL(p_item.attribute_18, 'N');

    -- Pattern checks (Y/N gate + pattern value)
    v_tld_check         VARCHAR2(1)    := NVL(p_item.attribute_24, 'N');
    v_domain_check      VARCHAR2(1)    := NVL(p_item.attribute_25, 'N');
    v_local_check       VARCHAR2(1)    := NVL(p_item.attribute_04, 'N');
    v_tld_pattern       VARCHAR2(500)  := p_item.attribute_19;
    v_domain_pattern    VARCHAR2(500)  := p_item.attribute_20;
    v_local_pattern     VARCHAR2(500)  := p_item.attribute_21;

    -- Length checks (Y/N gate + number value)
    v_min_check         VARCHAR2(1)    := NVL(p_item.attribute_22, 'N');
    v_max_check         VARCHAR2(1)    := NVL(p_item.attribute_23, 'N');
    v_min_length        VARCHAR2(10)   := p_item.attribute_07;
    v_max_length        VARCHAR2(10)   := p_item.attribute_08;

    -- Domain lists (Y/N gate + list value)
    v_restrict_wlist    VARCHAR2(1)    := NVL(p_item.attribute_06, 'N');
    v_block_disposable  VARCHAR2(1)    := NVL(p_item.attribute_05, 'N');
    v_domain_whitelist  VARCHAR2(4000) := p_item.attribute_09;
    v_disposable_list   VARCHAR2(4000) := p_item.attribute_10;
BEGIN

    ------------------------------------------------------------------
    -- Step 1: HTML - open wrapper carrying the full configuration
    ------------------------------------------------------------------
    sys.htp.p (
        '<span class="sh-eml-wrapper" id="' || v_element_id || '_SH_EMAIL"'
        || ' data-require="'            || v_require_value   || '"'
        || ' data-button-id="'          || apex_escape.html_attribute(NVL(v_button_id, '')) || '"'
        || ' data-auto-lowercase="'     || v_auto_lowercase  || '"'
        || ' data-reject-spaces="'      || v_reject_spaces   || '"'
        || ' data-single-at="'          || v_single_at       || '"'
        || ' data-req-local="'          || v_req_local       || '"'
        || ' data-req-domain="'         || v_req_domain      || '"'
        || ' data-no-double-dots="'     || v_no_double_dots  || '"'
        || ' data-no-local-edge="'      || v_no_local_edge   || '"'
        || ' data-no-domain-edge="'     || v_no_domain_edge  || '"'
        || ' data-require-tld="'        || v_require_tld     || '"'
        || ' data-tld-check="'          || v_tld_check       || '"'
        || ' data-domain-check="'       || v_domain_check    || '"'
        || ' data-local-check="'        || v_local_check     || '"'
        || ' data-tld-pattern="'        || apex_escape.html_attribute(NVL(v_tld_pattern, ''))    || '"'
        || ' data-domain-pattern="'     || apex_escape.html_attribute(NVL(v_domain_pattern, '')) || '"'
        || ' data-local-pattern="'      || apex_escape.html_attribute(NVL(v_local_pattern, ''))  || '"'
        || ' data-min-check="'          || v_min_check       || '"'
        || ' data-max-check="'          || v_max_check       || '"'
        || ' data-min-length="'         || NVL(v_min_length, '') || '"'
        || ' data-max-length="'         || NVL(v_max_length, '') || '"'
        || ' data-restrict-whitelist="' || v_restrict_wlist  || '"'
        || ' data-block-disposable="'   || v_block_disposable || '"'
        || ' data-domain-whitelist="'   || apex_escape.html_attribute(NVL(v_domain_whitelist, '')) || '"'
        || ' data-disposable-list="'    || apex_escape.html_attribute(NVL(v_disposable_list, ''))  || '">'
    );

    ------------------------------------------------------------------
    -- Step 2: HTML - input element with standard APEX field classes
    ------------------------------------------------------------------
    sys.htp.p (
        '<input type="email" id="' || v_element_id || '" name="' || v_element_id || '"'
        || ' value="' || apex_escape.html_attribute(v_current_value) || '"'
        || CASE WHEN p_item.placeholder IS NOT NULL
                THEN ' placeholder="' || apex_escape.html_attribute(p_item.placeholder) || '"'
           END
        || CASE WHEN v_require_value = 'Y'
                THEN ' aria-required="true"'
           END
        || ' autocomplete="off"'
        -- "apex-item-has-icon" reserves the left padding the icon sits in;
        -- only added when an icon is actually configured.
        || ' class="text_field apex-item-text sh-eml-input'
        || CASE WHEN v_icon IS NOT NULL THEN ' apex-item-has-icon' END
        || '">'
    );

    -- Icon element, rendered the same way a native APEX text item does.
    -- The base "fa" class is added automatically when the configured
    -- value only contains the icon name (e.g. "fa-user"), matching
    -- how APEX handles the icon attribute for built-in items.
-- Icon container matching the native APEX structure: a wrapper div
-- carries the accent background box, the inner span carries the glyph.
IF v_icon IS NOT NULL THEN
    sys.htp.p('<div class="apex-item-icon-container">');
    sys.htp.p(
        '<span class="apex-item-icon '
        || CASE WHEN INSTR(v_icon, 'fa ') = 0 AND INSTR(v_icon, 'fa-') = 1
                THEN 'fa ' END
        || apex_escape.html_attribute(v_icon)
        || '" aria-hidden="true"></span>'
    );
    sys.htp.p('</div>');
END IF;

    ------------------------------------------------------------------
    -- Step 3: HTML - popup skeleton. Rule list and notices are both
    -- filled by JS (needed for bilingual DE/EN support).
    ------------------------------------------------------------------
    sys.htp.p('<span class="sh-eml-popover">');
    sys.htp.p('<span class="sh-eml-popover-title"></span>');
    sys.htp.p('<span class="sh-eml-rule-list"></span>');
    sys.htp.p('<span class="sh-eml-notice-list"></span>');
    sys.htp.p('</span>'); -- .sh-eml-popover
    sys.htp.p('</span>'); -- .sh-eml-wrapper

    ------------------------------------------------------------------
    -- Step 4: JS init call
    ------------------------------------------------------------------
    apex_javascript.add_onload_code (
        p_code => 'shEmailValidator.init("' || v_element_id || '");'
    );

    p_result.item_rendered := TRUE;

END render_email_validator;