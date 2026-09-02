prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.0'
,p_default_workspace_id=>62521001393553892
,p_default_application_id=>112
,p_default_id_offset=>0
,p_default_owner=>'CAMPUS_DEV'
);
end;
/
 
prompt APPLICATION 112 - 01. Weiße Elfen Campus Admin
--
-- Application Export:
--   Application:     112
--   Name:            01. Weiße Elfen Campus Admin
--   Date and Time:   18:50 Wednesday September 2, 2026
--   Exported By:     SAJJAD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 223779260480124598
--   Manifest End
--   Version:         23.2.0
--   Instance ID:     709457783095702
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/item_type/email_validator
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(223779260480124598)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'EMAIL_VALIDATOR'
,p_display_name=>'Email validator'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_javascript_file_urls=>'#PLUGIN_FILES#email_validator#MIN#.js'
,p_css_file_urls=>'#PLUGIN_FILES#email_validator#MIN#.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'------------------------------------------------------------------------',
'-- S&H Software Solutions',
'-- Email Validator - Oracle APEX Item Plugin',
'-- ------------------------------------------------------------------',
'-- Component : Render procedure',
'-- Version   : 3.1.0 (adds button disable-until-valid via static ID;',
'--             plus-addressing attribute replaced by button control -',
'--             blocking "+" is now done via the local-part pattern)',
'-- Date      : 2026-08-01',
'-- Author    : S&H Software Solutions',
'-- License   : MIT License. This code is free and open to use, modify,',
'--             and redistribute, with or without attribution, for',
'--             personal or commercial projects.',
'------------------------------------------------------------------------',
'',
'PROCEDURE render_email_validator (',
'    p_item       IN            apex_plugin.t_item',
'  , p_plugin     IN            apex_plugin.t_plugin',
'  , p_param      IN            apex_plugin.t_item_render_param',
'  , p_result     IN OUT NOCOPY apex_plugin.t_item_render_result',
')',
'IS',
'    ------------------------------------------------------------------',
'    -- Declarations (attribute numbers match the plugin configuration)',
'    ------------------------------------------------------------------',
'    v_element_id        VARCHAR2(4000) := p_item.name;',
'    v_current_value     VARCHAR2(4000) := p_param.value;',
'    v_icon              VARCHAR2(255)  := p_item.icon_css_classes;',
'',
'    -- Basic validation',
'    v_require_value     VARCHAR2(1)    := NVL(p_item.attribute_01, ''N'');',
'    v_button_id         VARCHAR2(255)  := p_item.attribute_02;',
'    v_auto_lowercase    VARCHAR2(1)    := NVL(p_item.attribute_03, ''N'');',
'    v_reject_spaces     VARCHAR2(1)    := NVL(p_item.attribute_11, ''N'');',
'    v_single_at         VARCHAR2(1)    := NVL(p_item.attribute_12, ''N'');',
'',
'    -- Structural checks',
'    v_req_local         VARCHAR2(1)    := NVL(p_item.attribute_13, ''N'');',
'    v_req_domain        VARCHAR2(1)    := NVL(p_item.attribute_14, ''N'');',
'    v_no_double_dots    VARCHAR2(1)    := NVL(p_item.attribute_15, ''N'');',
'    v_no_local_edge     VARCHAR2(1)    := NVL(p_item.attribute_16, ''N'');',
'    v_no_domain_edge    VARCHAR2(1)    := NVL(p_item.attribute_17, ''N'');',
'    v_require_tld       VARCHAR2(1)    := NVL(p_item.attribute_18, ''N'');',
'',
'    -- Pattern checks (Y/N gate + pattern value)',
'    v_tld_check         VARCHAR2(1)    := NVL(p_item.attribute_24, ''N'');',
'    v_domain_check      VARCHAR2(1)    := NVL(p_item.attribute_25, ''N'');',
'    v_local_check       VARCHAR2(1)    := NVL(p_item.attribute_04, ''N'');',
'    v_tld_pattern       VARCHAR2(500)  := p_item.attribute_19;',
'    v_domain_pattern    VARCHAR2(500)  := p_item.attribute_20;',
'    v_local_pattern     VARCHAR2(500)  := p_item.attribute_21;',
'',
'    -- Length checks (Y/N gate + number value)',
'    v_min_check         VARCHAR2(1)    := NVL(p_item.attribute_22, ''N'');',
'    v_max_check         VARCHAR2(1)    := NVL(p_item.attribute_23, ''N'');',
'    v_min_length        VARCHAR2(10)   := p_item.attribute_07;',
'    v_max_length        VARCHAR2(10)   := p_item.attribute_08;',
'',
'    -- Domain lists (Y/N gate + list value)',
'    v_restrict_wlist    VARCHAR2(1)    := NVL(p_item.attribute_06, ''N'');',
'    v_block_disposable  VARCHAR2(1)    := NVL(p_item.attribute_05, ''N'');',
'    v_domain_whitelist  VARCHAR2(4000) := p_item.attribute_09;',
'    v_disposable_list   VARCHAR2(4000) := p_item.attribute_10;',
'BEGIN',
'',
'    ------------------------------------------------------------------',
'    -- Step 1: HTML - open wrapper carrying the full configuration',
'    ------------------------------------------------------------------',
'    sys.htp.p (',
'        ''<span class="sh-eml-wrapper" id="'' || v_element_id || ''_SH_EMAIL"''',
'        || '' data-require="''            || v_require_value   || ''"''',
'        || '' data-button-id="''          || apex_escape.html_attribute(NVL(v_button_id, '''')) || ''"''',
'        || '' data-auto-lowercase="''     || v_auto_lowercase  || ''"''',
'        || '' data-reject-spaces="''      || v_reject_spaces   || ''"''',
'        || '' data-single-at="''          || v_single_at       || ''"''',
'        || '' data-req-local="''          || v_req_local       || ''"''',
'        || '' data-req-domain="''         || v_req_domain      || ''"''',
'        || '' data-no-double-dots="''     || v_no_double_dots  || ''"''',
'        || '' data-no-local-edge="''      || v_no_local_edge   || ''"''',
'        || '' data-no-domain-edge="''     || v_no_domain_edge  || ''"''',
'        || '' data-require-tld="''        || v_require_tld     || ''"''',
'        || '' data-tld-check="''          || v_tld_check       || ''"''',
'        || '' data-domain-check="''       || v_domain_check    || ''"''',
'        || '' data-local-check="''        || v_local_check     || ''"''',
'        || '' data-tld-pattern="''        || apex_escape.html_attribute(NVL(v_tld_pattern, ''''))    || ''"''',
'        || '' data-domain-pattern="''     || apex_escape.html_attribute(NVL(v_domain_pattern, '''')) || ''"''',
'        || '' data-local-pattern="''      || apex_escape.html_attribute(NVL(v_local_pattern, ''''))  || ''"''',
'        || '' data-min-check="''          || v_min_check       || ''"''',
'        || '' data-max-check="''          || v_max_check       || ''"''',
'        || '' data-min-length="''         || NVL(v_min_length, '''') || ''"''',
'        || '' data-max-length="''         || NVL(v_max_length, '''') || ''"''',
'        || '' data-restrict-whitelist="'' || v_restrict_wlist  || ''"''',
'        || '' data-block-disposable="''   || v_block_disposable || ''"''',
'        || '' data-domain-whitelist="''   || apex_escape.html_attribute(NVL(v_domain_whitelist, '''')) || ''"''',
'        || '' data-disposable-list="''    || apex_escape.html_attribute(NVL(v_disposable_list, ''''))  || ''">''',
'    );',
'',
'    ------------------------------------------------------------------',
'    -- Step 2: HTML - input element with standard APEX field classes',
'    ------------------------------------------------------------------',
'    sys.htp.p (',
'        ''<input type="email" id="'' || v_element_id || ''" name="'' || v_element_id || ''"''',
'        || '' value="'' || apex_escape.html_attribute(v_current_value) || ''"''',
'        || CASE WHEN p_item.placeholder IS NOT NULL',
'                THEN '' placeholder="'' || apex_escape.html_attribute(p_item.placeholder) || ''"''',
'           END',
'        || CASE WHEN v_require_value = ''Y''',
'                THEN '' aria-required="true"''',
'           END',
'        || '' autocomplete="off"''',
'        -- "apex-item-has-icon" reserves the left padding the icon sits in;',
'        -- only added when an icon is actually configured.',
'        || '' class="text_field apex-item-text sh-eml-input''',
'        || CASE WHEN v_icon IS NOT NULL THEN '' apex-item-has-icon'' END',
'        || ''">''',
'    );',
'',
'    -- Icon element, rendered the same way a native APEX text item does.',
'    -- The base "fa" class is added automatically when the configured',
'    -- value only contains the icon name (e.g. "fa-user"), matching',
'    -- how APEX handles the icon attribute for built-in items.',
'-- Icon container matching the native APEX structure: a wrapper div',
'-- carries the accent background box, the inner span carries the glyph.',
'IF v_icon IS NOT NULL THEN',
'    sys.htp.p(''<div class="apex-item-icon-container">'');',
'    sys.htp.p(',
'        ''<span class="apex-item-icon ''',
'        || CASE WHEN INSTR(v_icon, ''fa '') = 0 AND INSTR(v_icon, ''fa-'') = 1',
'                THEN ''fa '' END',
'        || apex_escape.html_attribute(v_icon)',
'        || ''" aria-hidden="true"></span>''',
'    );',
'    sys.htp.p(''</div>'');',
'END IF;',
'',
'    ------------------------------------------------------------------',
'    -- Step 3: HTML - popup skeleton. Rule list and notices are both',
'    -- filled by JS (needed for bilingual DE/EN support).',
'    ------------------------------------------------------------------',
'    sys.htp.p(''<span class="sh-eml-popover">'');',
'    sys.htp.p(''<span class="sh-eml-popover-title"></span>'');',
'    sys.htp.p(''<span class="sh-eml-rule-list"></span>'');',
'    sys.htp.p(''<span class="sh-eml-notice-list"></span>'');',
'    sys.htp.p(''</span>''); -- .sh-eml-popover',
'    sys.htp.p(''</span>''); -- .sh-eml-wrapper',
'',
'    ------------------------------------------------------------------',
'    -- Step 4: JS init call',
'    ------------------------------------------------------------------',
'    apex_javascript.add_onload_code (',
'        p_code => ''shEmailValidator.init("'' || v_element_id || ''");''',
'    );',
'',
'    p_result.item_rendered := TRUE;',
'',
'END render_email_validator;'))
,p_default_escape_mode=>'HTML'
,p_api_version=>2
,p_render_function=>'render_email_validator'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SESSION_STATE:SOURCE:ELEMENT:PLACEHOLDER:ICON:ENCRYPT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_files_version=>125
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(224038841012843498)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_title=>unistr('\26A1 Button control')
,p_display_sequence=>5
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(223821497673619981)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_title=>unistr('\D83E\DDF1 Basic validation')
,p_display_sequence=>10
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(223821911192619981)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_title=>unistr('\D83D\DCCF Length validation')
,p_display_sequence=>60
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(223835284169511404)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_title=>unistr('\D83D\DEAB Blocked domains')
,p_display_sequence=>80
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(223835687113511404)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_title=>unistr('\2705 Approved domains')
,p_display_sequence=>70
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(224004485476113300)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_title=>unistr('\D83D\DD39 Format validation')
,p_display_sequence=>20
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(224004894479113300)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_title=>unistr('\D83D\DD24 Character validation')
,p_display_sequence=>30
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(224005309802113299)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_title=>unistr('\D83E\DDE9 Allowed patterns')
,p_display_sequence=>40
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(224005705636113299)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_title=>unistr('\2699\FE0F Value handling')
,p_display_sequence=>50
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223782414790018616)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>100
,p_prompt=>unistr('\2757 Required value')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(223821497673619981)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Required value: Enabled</pre>',
'',
unistr('\274C <code>(empty)</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Rejects an empty value.<br><br>',
'',
'When disabled, an empty field is treated as valid and none of the other rules below are checked against it.'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(224016292117024396)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>unistr('\D83D\DD18 Button Static ID')
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(224038841012843498)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Button Static ID: NEXT_BTN</pre>',
'',
unistr('Field invalid \2192 button <code>NEXT_BTN</code> disabled<br>'),
unistr('Field valid \2192 button <code>NEXT_BTN</code> enabled')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Enter the <strong>Static ID</strong> of a button that should stay disabled until this field passes every active validation rule below.<br><br>',
'',
unistr('Leave empty to turn this feature off. This is a client-side convenience only \2014 it does not replace server-side validation, since a disabled button can be re-enabled through the browser''s developer tools.')))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223784957897935316)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>unistr('\D83D\DD21 Auto lowercase')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(223821497673619981)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Auto lowercase: Enabled</pre>',
'',
'Typed: <code>User@Example.COM</code><br>',
'Stored: <code>user@example.com</code>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Automatically converts the entered value to lowercase as the user types.<br><br>',
'',
unistr('This changes what the user sees in the field \2014 it is not a validation rule and never causes the field to show an error.')))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223913713208746600)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>100
,p_prompt=>unistr('\D83D\DC64 Local check')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(224004894479113300)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Local check: Enabled',
'Local regex: ^[A-Za-z0-9!#$%&''*+/=?^_`{|}~.-]+$</pre>',
'',
unistr('\274C <code>user name@example.com</code><br>'),
unistr('\2705 <code>user+tag@example.com</code>')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Validates the part before the <strong>@</strong> against the regular expression configured under <strong>\D83D\DCC4 Local regex</strong>.<br><br>'),
'',
'When disabled, Local regex is ignored.'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223786160275925432)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>100
,p_prompt=>unistr('\D83D\DEAB Block domains')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(223835284169511404)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Block domains: Enabled',
'Blocked domains: mailinator.com, yopmail.com</pre>',
'',
unistr('\274C <code>user@mailinator.com</code><br>'),
unistr('\274C <code>user@yopmail.com</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Rejects email addresses from the domains configured under <strong>\D83D\DCDD Blocked domains</strong>.<br><br>'),
'',
'When disabled, the blocked-domain list is ignored.'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223787230512919196)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>100
,p_prompt=>unistr('\D83D\DD12 Restrict access')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(223835687113511404)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Restrict access: Enabled',
'Allowed domains: company.com, partner.org</pre>',
'',
unistr('\2705 <code>user@company.com</code><br>'),
unistr('\2705 <code>user@partner.org</code><br>'),
unistr('\274C <code>user@gmail.com</code>')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Limits accepted email addresses to the domains configured under <strong>\D83D\DCDD Allowed domains</strong>.<br><br>'),
'',
'When disabled, the allowed-domain list is ignored.'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223787921170894636)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>200
,p_prompt=>unistr('\D83D\DD22 Min. length')
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'5'
,p_max_length=>2
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(223915587946697926)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_attribute_group_id=>wwv_flow_imp.id(223821911192619981)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Min. length: 10</pre>',
'',
unistr('\2705 10 or more characters<br>'),
unistr('\274C Fewer than 10 characters')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Defines the minimum number of characters required for the complete email address, including the @ symbol and domain.<br><br>',
'',
unistr('This value is only applied when <strong>\2B07\FE0F Min. check</strong> is enabled. Enter a positive whole number.')))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223788487471877484)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>400
,p_prompt=>unistr('\D83D\DD22 Max. length')
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_default_value=>'50'
,p_max_length=>2
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(223916794477694774)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_attribute_group_id=>wwv_flow_imp.id(223821911192619981)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Max. length: 50</pre>',
'',
unistr('\2705 Up to 50 characters<br>'),
unistr('\274C More than 50 characters')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Defines the maximum number of characters allowed for the complete email address, including the @ symbol and domain.<br><br>',
'',
unistr('This value is only applied when <strong>\2B06\FE0F Max. check</strong> is enabled. Enter a positive whole number.')))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223789225820870281)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>200
,p_prompt=>unistr('\D83D\DCDD Domain list')
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'gmail.com,outlook.com,hotmail.com,yahoo.com,icloud.com,gmx.de,web.de'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(223787230512919196)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_attribute_group_id=>wwv_flow_imp.id(223835687113511404)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>company.com, partner.org, university.edu</pre>',
'',
unistr('\2705 <code>employee@company.com</code><br>'),
unistr('\2705 <code>contact@partner.org</code><br>'),
unistr('\274C <code>customer@yahoo.com</code>')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Enter the domains that are allowed when <strong>\D83D\DD12 Restrict access</strong> is enabled.<br><br>'),
'',
'Separate multiple domains with commas. Enter domain names only, without the @ symbol, protocol or URL path.'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223790510331863524)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>200
,p_prompt=>unistr('\D83D\DCDD Domain list')
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'mailinator.com,yopmail.com,10minutemail.com,guerrillamail.com,temp-mail.org'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(223786160275925432)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_attribute_group_id=>wwv_flow_imp.id(223835284169511404)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>mailinator.com, yopmail.com, 10minutemail.com</pre>',
'',
unistr('\274C <code>test@mailinator.com</code><br>'),
unistr('\274C <code>test@yopmail.com</code><br>'),
unistr('\2705 <code>test@company.com</code>')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Enter the domains that must be rejected when <strong>\D83D\DEAB Block domains</strong> is enabled.<br><br>'),
'',
'Separate multiple domains with commas. Enter domain names only, without the @ symbol, protocol or URL path.'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223878787735304049)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>200
,p_prompt=>unistr('\D83D\DEAB No spaces')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(223821497673619981)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>No spaces: Enabled</pre>',
'',
unistr('\274C <code>user @example.com</code><br>'),
unistr('\274C <code>user@ example.com</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>'Rejects the value if it contains spaces or control characters anywhere in the string.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223879684178301681)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>300
,p_prompt=>unistr('\261D\FE0F Only 1 @')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(223821497673619981)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Only 1 @: Enabled</pre>',
'',
unistr('\274C <code>userexample.com</code><br>'),
unistr('\274C <code>user@@example.com</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>'Requires the value to contain exactly one <strong>@</strong> character. Values with zero or more than one <strong>@</strong> are rejected.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223880518133290651)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>400
,p_prompt=>unistr('\D83D\DC64 Text before @')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(223821497673619981)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Text before @: Enabled</pre>',
'',
unistr('\274C <code>@example.com</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Requires at least one character before the <strong>@</strong> symbol.<br><br>',
'',
unistr('Only checked once the value contains an <strong>@</strong>; an empty field with no <strong>@</strong> at all is handled by <strong>\D83D\DEAB Required value</strong> instead.')))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223881438089288171)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>500
,p_prompt=>unistr('\D83C\DF10 Text after @')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(223821497673619981)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Text after @: Enabled</pre>',
'',
unistr('\274C <code>user@</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Requires at least one character after the <strong>@</strong> symbol.<br><br>',
'',
'Only checked once the value contains an <strong>@</strong>.'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223882391486274776)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>100
,p_prompt=>unistr('\D83D\DD39 No double dots')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(224004485476113300)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>No double dots: Enabled</pre>',
'',
unistr('\274C <code>us..er@example.com</code><br>'),
unistr('\274C <code>user@example..com</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>'Rejects the value if it contains two or more consecutive dots (<strong>..</strong>) anywhere in the string.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223883332145270308)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>16
,p_display_sequence=>200
,p_prompt=>unistr('\D83D\DC64 Local edge')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(224004485476113300)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Local edge: Enabled</pre>',
'',
unistr('\274C <code>.user@example.com</code><br>'),
unistr('\274C <code>user.@example.com</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>'Requires that the part before the <strong>@</strong> does not start or end with a dot.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223884183916267578)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>17
,p_display_sequence=>300
,p_prompt=>unistr('\D83C\DF10 Domain edge')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(224004485476113300)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Domain edge: Enabled</pre>',
'',
unistr('\274C <code>user@-example.com</code><br>'),
unistr('\274C <code>user@example.com-</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>'Requires that the domain does not start or end with a dot or a hyphen.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223885079658265723)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>18
,p_display_sequence=>600
,p_prompt=>unistr('\D83C\DFF7\FE0F Require TLD')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(223821497673619981)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Require TLD: Enabled</pre>',
'',
unistr('\274C <code>user@localhost</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>'Requires the domain to contain a top-level domain, i.e. at least one dot after the <strong>@</strong> (e.g. <strong>.com</strong>, <strong>.de</strong>).'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223892845070145369)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>19
,p_display_sequence=>600
,p_prompt=>unistr('\D83C\DFF7\FE0F TLD regex')
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'^[A-Za-z]+$'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(223908779381769434)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_attribute_group_id=>wwv_flow_imp.id(224004894479113300)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>TLD check: Enabled',
'TLD regex: ^[A-Za-z]+$</pre>',
'',
unistr('\274C <code>user@example.123</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Regular expression that the top-level domain must match when <strong>\D83D\DEAB TLD check</strong> is enabled. Enter the pattern only, without slashes.<br><br>'),
'',
unistr('The default pattern only allows letters \2014 no digits, dots or hyphens \2014 since a top-level domain is a single word like <strong>com</strong> or <strong>de</strong>.')))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223894930907142089)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>20
,p_display_sequence=>400
,p_prompt=>unistr('\D83C\DF10 Domain regex')
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'^[A-Za-z0-9.-]+$'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(223910002536768400)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_attribute_group_id=>wwv_flow_imp.id(224004894479113300)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Domain check: Enabled',
'Domain regex: ^[A-Za-z0-9.-]+$</pre>',
'',
unistr('\274C <code>user@example_com</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Regular expression that the part after the <strong>@</strong> must match when <strong>\D83D\DEAB Domain check</strong> is enabled. Enter the pattern only, without slashes.<br><br>'),
'',
unistr('The default pattern allows letters, digits, dots and hyphens \2014 the characters normally found in a domain name.')))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223895886265138033)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>21
,p_display_sequence=>200
,p_prompt=>unistr('\D83D\DC64 Local regex')
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'^[A-Za-z0-9!#$%&''*+/=?^_`{|}~.-]+$'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(223913713208746600)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_attribute_group_id=>wwv_flow_imp.id(224004894479113300)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Local check: Enabled',
'Local regex: ^[A-Za-z0-9!#$%&''*+/=?^_`{|}~.-]+$</pre>',
'',
unistr('\274C <code>user#name@example.com</code><br>'),
unistr('\2705 <code>user+tag@example.com</code>')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Regular expression that the part before the <strong>@</strong> must match when <strong>\D83D\DEAB Local check</strong> is enabled. Enter the pattern only, without slashes.<br><br>'),
'',
unistr('The default pattern is the standard set of characters allowed before the @ symbol, including <strong>+</strong> \2014 so plus-addressing (<code>user+tag@example.com</code>) is allowed. Remove the <strong>+</strong> from the pattern if you want to reject ')
||'it instead.'))
);
end;
/
begin
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223915587946697926)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>22
,p_display_sequence=>100
,p_prompt=>unistr('\2B07\FE0F Min. check')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(223821911192619981)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Min. check: Enabled',
'Min. length: 10</pre>',
'',
unistr('\2705 <code>user@example.com</code><br>'),
unistr('\274C <code>a@b.co</code><br><br>'),
'',
'The second email address contains fewer than 10 characters.'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Enables the minimum-length validation for the complete email address.<br><br>',
'',
unistr('The limit is defined under <strong>\D83D\DD22 Min. length</strong>. When disabled, the configured minimum length is ignored.')))
,p_attribute_comment=>'comments'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223916794477694774)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>23
,p_display_sequence=>300
,p_prompt=>unistr('\2B06\FE0F Max. check')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(223821911192619981)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Max. check: Enabled',
'Max. length: 50</pre>',
'',
unistr('\2705 <code>customer@example.com</code><br>'),
unistr('\274C Email addresses longer than 50 characters')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Enables the maximum-length validation for the complete email address.<br><br>',
'',
unistr('The limit is defined under <strong>\D83D\DD22 Max. length</strong>. When disabled, the configured maximum length is ignored.')))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223908779381769434)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>24
,p_display_sequence=>500
,p_prompt=>unistr('\D83C\DFF7\FE0F TLD check')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(224004894479113300)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>TLD check: Enabled',
'TLD regex: ^[A-Za-z]+$</pre>',
'',
unistr('\274C <code>user@example.123</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Validates the top-level domain (the part after the last dot, e.g. <strong>com</strong> in <strong>example.com</strong>) against the regular expression configured under <strong>\D83D\DCC4 TLD regex</strong>.<br><br>'),
'',
'When disabled, TLD regex is ignored.'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(223910002536768400)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>25
,p_display_sequence=>300
,p_prompt=>unistr('\D83C\DF10 Domain check')
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(224004894479113300)
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>Domain check: Enabled',
'Domain regex: ^[A-Za-z0-9.-]+$</pre>',
'',
unistr('\274C <code>user@exa_mple.com</code><br>'),
unistr('\2705 <code>user@example.com</code>')))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Validates the part after the <strong>@</strong> against the regular expression configured under <strong>\D83D\DCC4 Domain regex</strong>.<br><br>'),
'',
'When disabled, Domain regex is ignored.'))
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A20202053264820536F66747761726520536F6C7574696F6E73';
wwv_flow_imp.g_varchar2_table(2) := '0D0A202020456D61696C2056616C696461746F72202D204F7261636C652041504558204974656D20506C7567696E0D0A2020202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(3) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A202020436F6D706F6E656E74203A205374796C6573686565740D0A20202056657273696F6E2020203A20332E322E300D0A202020446174652020202020203A20323032362D30382D30310D0A20';
wwv_flow_imp.g_varchar2_table(4) := '2020417574686F72202020203A2053264820536F66747761726520536F6C7574696F6E730D0A2020204C6963656E73652020203A204D4954204C6963656E73652E205468697320636F6465206973206672656520616E64206F70656E20746F207573652C';
wwv_flow_imp.g_varchar2_table(5) := '206D6F646966792C0D0A202020202020202020202020202020616E64207265646973747269627574652C2077697468206F7220776974686F7574206174747269627574696F6E2C20666F720D0A202020202020202020202020202020706572736F6E616C';
wwv_flow_imp.g_varchar2_table(6) := '206F7220636F6D6D65726369616C2070726F6A656374732E0D0A2020202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D';
wwv_flow_imp.g_varchar2_table(7) := '0A202020416C6C2069636F6E732061726520707572652043535320286E6F2069636F6E2D666F6E7420646570656E64656E6379292E0D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(8) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A2E73682D656D6C2D77726170706572207B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A2020646973706C61793A20696E6C696E652D626C6F636B';
wwv_flow_imp.g_varchar2_table(9) := '3B0D0A7D0D0A0D0A2F2A20537472657463683A206D6972726F7220746865207374616E64617264204150455820225374726574636822206974656D207769647468206265686176696F72202A2F0D0A2E742D466F726D2D6669656C64436F6E7461696E65';
wwv_flow_imp.g_varchar2_table(10) := '722D2D73747265746368496E70757473202E73682D656D6C2D77726170706572207B0D0A2020646973706C61793A20626C6F636B3B0D0A202077696474683A20313030253B0D0A7D0D0A0D0A2E742D466F726D2D6669656C64436F6E7461696E65722D2D';
wwv_flow_imp.g_varchar2_table(11) := '73747265746368496E70757473202E73682D656D6C2D77726170706572202E73682D656D6C2D696E707574207B0D0A202077696474683A20313030253B0D0A7D0D0A0D0A2E73682D656D6C2D696E7075742E73682D656D6C2D696E76616C6964207B0D0A';
wwv_flow_imp.g_varchar2_table(12) := '2020626F726465722D636F6C6F723A20236334333633362021696D706F7274616E743B0D0A2020626F782D736861646F773A2030203020302031707820236334333633362021696D706F7274616E743B0D0A7D0D0A0D0A2F2A202D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(13) := '2D2D2D2D2D2D2D2D2D2D20506F706F7665722028626F64792D617474616368656420706F7274616C29202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0D0A2E73682D656D6C2D706F706F766572207B0D0A2020646973706C61793A206E6F6E65';
wwv_flow_imp.g_varchar2_table(14) := '3B0D0A2020706F736974696F6E3A2066697865643B0D0A20206261636B67726F756E643A20236666666666663B0D0A2020626F726465723A2031707820736F6C6964207267626128302C20302C20302C20302E3132293B0D0A2020626F726465722D7261';
wwv_flow_imp.g_varchar2_table(15) := '646975733A203870783B0D0A2020626F782D736861646F773A2030203870782032347078207267626128302C20302C20302C20302E3132292C20302032707820367078207267626128302C20302C20302C20302E3038293B0D0A202070616464696E673A';
wwv_flow_imp.g_varchar2_table(16) := '203132707820313470783B0D0A20207A2D696E6465783A2039393939393B0D0A7D0D0A0D0A2E73682D656D6C2D706F706F7665722E73682D656D6C2D706F706F7665722D6F70656E207B0D0A2020646973706C61793A20626C6F636B3B0D0A7D0D0A0D0A';
wwv_flow_imp.g_varchar2_table(17) := '2E73682D656D6C2D706F706F7665722D7469746C65207B0D0A2020646973706C61793A20626C6F636B3B0D0A2020666F6E742D73697A653A20313270783B0D0A2020636F6C6F723A20233838383738303B0D0A20206D617267696E2D626F74746F6D3A20';
wwv_flow_imp.g_varchar2_table(18) := '3870783B0D0A7D0D0A0D0A2E73682D656D6C2D72756C652D6C697374207B0D0A2020646973706C61793A20666C65783B0D0A2020666C65782D646972656374696F6E3A20636F6C756D6E3B0D0A20206761703A203670783B0D0A7D0D0A0D0A2F2A202D2D';
wwv_flow_imp.g_varchar2_table(19) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D204572726F7220726F7773202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0D0A2E73682D656D6C2D6572726F72207B0D0A2020646973706C6179';
wwv_flow_imp.g_varchar2_table(20) := '3A20666C65783B0D0A2020616C69676E2D6974656D733A2063656E7465723B0D0A20206761703A203870783B0D0A2020666F6E742D73697A653A20313370783B0D0A2020636F6C6F723A20236133326432643B0D0A7D0D0A0D0A2E73682D656D6C2D6572';
wwv_flow_imp.g_varchar2_table(21) := '726F722D69636F6E207B0D0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A202077696474683A20313670783B0D0A20206865696768743A20313670783B0D0A2020626F726465722D7261646975733A203530253B0D0A20206261636B';
wwv_flow_imp.g_varchar2_table(22) := '67726F756E643A20236334333633363B0D0A2020666C65782D736872696E6B3A20303B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A7D0D0A0D0A2E73682D656D6C2D6572726F722D69636F6E3A3A6265666F72652C0D0A2E73682D656D';
wwv_flow_imp.g_varchar2_table(23) := '6C2D6572726F722D69636F6E3A3A6166746572207B0D0A2020636F6E74656E743A2022223B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A20206C6566743A203770783B0D0A2020746F703A203470783B0D0A202077696474683A203270';
wwv_flow_imp.g_varchar2_table(24) := '783B0D0A20206865696768743A203870783B0D0A20206261636B67726F756E643A20236666666666663B0D0A2020626F726465722D7261646975733A203170783B0D0A7D0D0A0D0A2E73682D656D6C2D6572726F722D69636F6E3A3A6265666F7265207B';
wwv_flow_imp.g_varchar2_table(25) := '207472616E73666F726D3A20726F74617465283435646567293B207D0D0A2E73682D656D6C2D6572726F722D69636F6E3A3A616674657220207B207472616E73666F726D3A20726F74617465282D3435646567293B207D0D0A0D0A2F2A202D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(26) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D205375636365737320726F77202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0D0A2E73682D656D6C2D73756363657373207B0D0A2020646973706C61793A20';
wwv_flow_imp.g_varchar2_table(27) := '666C65783B0D0A2020616C69676E2D6974656D733A2063656E7465723B0D0A20206761703A203870783B0D0A2020666F6E742D73697A653A20313370783B0D0A2020636F6C6F723A20233362366431313B0D0A7D0D0A0D0A2E73682D656D6C2D73756363';
wwv_flow_imp.g_varchar2_table(28) := '6573732D69636F6E207B0D0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A202077696474683A20313670783B0D0A20206865696768743A20313670783B0D0A2020626F726465722D7261646975733A203530253B0D0A20206261636B';
wwv_flow_imp.g_varchar2_table(29) := '67726F756E643A20233633393932323B0D0A2020666C65782D736872696E6B3A20303B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A7D0D0A0D0A2E73682D656D6C2D737563636573732D69636F6E3A3A6166746572207B0D0A2020636F';
wwv_flow_imp.g_varchar2_table(30) := '6E74656E743A2022223B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A20206C6566743A203570783B0D0A2020746F703A203270783B0D0A202077696474683A203470783B0D0A20206865696768743A203870783B0D0A2020626F726465';
wwv_flow_imp.g_varchar2_table(31) := '723A20736F6C696420236666666666663B0D0A2020626F726465722D77696474683A2030203270782032707820303B0D0A20207472616E73666F726D3A20726F74617465283435646567293B0D0A7D0D0A0D0A2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(32) := '2D2D2D2D2D2D204E65757472616C20726F77202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0D0A2E73682D656D6C2D6E65757472616C207B0D0A2020646973706C61793A20666C65783B0D0A20';
wwv_flow_imp.g_varchar2_table(33) := '20616C69676E2D6974656D733A2063656E7465723B0D0A20206761703A203870783B0D0A2020666F6E742D73697A653A20313370783B0D0A2020636F6C6F723A20233838383738303B0D0A7D0D0A0D0A2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(34) := '2D2D2D20496E666F206E6F7469636573202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0D0A2E73682D656D6C2D6E6F746963652D6C697374207B0D0A2020646973706C61793A206E6F6E653B0D0A';
wwv_flow_imp.g_varchar2_table(35) := '2020666C65782D646972656374696F6E3A20636F6C756D6E3B0D0A20206761703A203670783B0D0A20206D617267696E2D746F703A203870783B0D0A202070616464696E672D746F703A203870783B0D0A2020626F726465722D746F703A203170782073';
wwv_flow_imp.g_varchar2_table(36) := '6F6C6964207267626128302C20302C20302C20302E3038293B0D0A7D0D0A0D0A2E73682D656D6C2D6E6F746963652D6C6973742E73682D656D6C2D6861732D6E6F7469636573207B0D0A2020646973706C61793A20666C65783B0D0A7D0D0A0D0A2E7368';
wwv_flow_imp.g_varchar2_table(37) := '2D656D6C2D6E6F74696365207B0D0A2020646973706C61793A20666C65783B0D0A2020616C69676E2D6974656D733A2063656E7465723B0D0A20206761703A203870783B0D0A2020666F6E742D73697A653A20313370783B0D0A2020636F6C6F723A2023';
wwv_flow_imp.g_varchar2_table(38) := '3063343437633B0D0A7D0D0A0D0A2E73682D656D6C2D6E6F746963652D69636F6E207B0D0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A202077696474683A20313670783B0D0A20206865696768743A20313670783B0D0A2020626F';
wwv_flow_imp.g_varchar2_table(39) := '726465722D7261646975733A203530253B0D0A20206261636B67726F756E643A20233138356661353B0D0A2020666C65782D736872696E6B3A20303B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A7D0D0A0D0A2E73682D656D6C2D6E6F';
wwv_flow_imp.g_varchar2_table(40) := '746963652D69636F6E3A3A6166746572207B0D0A2020636F6E74656E743A202269223B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A20206C6566743A20303B0D0A2020746F703A20303B0D0A202077696474683A20313030253B0D0A20';
wwv_flow_imp.g_varchar2_table(41) := '206865696768743A20313030253B0D0A2020646973706C61793A20666C65783B0D0A2020616C69676E2D6974656D733A2063656E7465723B0D0A20206A7573746966792D636F6E74656E743A2063656E7465723B0D0A2020636F6C6F723A202366666666';
wwv_flow_imp.g_varchar2_table(42) := '66663B0D0A2020666F6E742D73697A653A20313170783B0D0A2020666F6E742D7765696768743A203730303B0D0A2020666F6E742D7374796C653A206E6F726D616C3B0D0A2020666F6E742D66616D696C793A2047656F726769612C2073657269663B0D';
wwv_flow_imp.g_varchar2_table(43) := '0A7D0D0A0D0A2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D20426C6F636B656420627574746F6E202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0D0A2E73682D656D6C2D62746E2D626C6F';
wwv_flow_imp.g_varchar2_table(44) := '636B6564207B0D0A20206F7061636974793A20302E353B0D0A2020637572736F723A206E6F742D616C6C6F7765643B0D0A7D0D0A0D0A2F2A20526561736F6E20626F782073686F776E207768656E20686F766572696E672074686520626C6F636B656420';
wwv_flow_imp.g_varchar2_table(45) := '627574746F6E2E20506F736974696F6E65640D0A2020206162736F6C7574656C7920736F20697420666C6F6174732061626F76652074686520636F6E74656E742062656C6F7720696E7374656164206F662070757368696E670D0A202020697420646F77';
wwv_flow_imp.g_varchar2_table(46) := '6E202D206F7468657277697365207468652077686F6C6520666F726D20736869667473206F6E20657665727920686F7665722E202A2F0D0A2E73682D656D6C2D62746E2D68696E74207B0D0A2020646973706C61793A206E6F6E653B0D0A2020706F7369';
wwv_flow_imp.g_varchar2_table(47) := '74696F6E3A2066697865643B0D0A20207A2D696E6465783A2039393939393B0D0A2020616C69676E2D6974656D733A2063656E7465723B0D0A20206761703A203870783B0D0A202070616464696E673A2038707820313270783B0D0A2020626F782D7369';
wwv_flow_imp.g_varchar2_table(48) := '7A696E673A20626F726465722D626F783B0D0A2020666F6E742D73697A653A20313370783B0D0A2020666F6E742D7765696768743A203530303B0D0A20206C696E652D6865696768743A20312E343B0D0A2020636F6C6F723A20233863323032303B0D0A';
wwv_flow_imp.g_varchar2_table(49) := '20206261636B67726F756E643A20236664656165613B0D0A2020626F726465723A2031707820736F6C696420236632633463343B0D0A2020626F726465722D6C6566743A2033707820736F6C696420236334333633363B0D0A2020626F726465722D7261';
wwv_flow_imp.g_varchar2_table(50) := '646975733A203670783B0D0A2020626F782D736861646F773A2030203470782031327078207267626128302C20302C20302C20302E3135293B0D0A7D0D0A0D0A2E73682D656D6C2D62746E2D68696E742E73682D656D6C2D62746E2D68696E742D766973';
wwv_flow_imp.g_varchar2_table(51) := '69626C65207B0D0A2020646973706C61793A20666C65783B0D0A7D0D0A0D0A2E73682D656D6C2D62746E2D68696E742D69636F6E207B0D0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A202077696474683A20313470783B0D0A2020';
wwv_flow_imp.g_varchar2_table(52) := '6865696768743A20313470783B0D0A2020626F726465722D7261646975733A203530253B0D0A20206261636B67726F756E643A20236334333633363B0D0A2020666C65782D736872696E6B3A20303B0D0A2020706F736974696F6E3A2072656C61746976';
wwv_flow_imp.g_varchar2_table(53) := '653B0D0A7D0D0A0D0A2F2A204353532D647261776E2022212220696E73696465207468652072656420636972636C65202A2F0D0A2E73682D656D6C2D62746E2D68696E742D69636F6E3A3A6265666F7265207B0D0A2020636F6E74656E743A2022223B0D';
wwv_flow_imp.g_varchar2_table(54) := '0A2020706F736974696F6E3A206162736F6C7574653B0D0A20206C6566743A203670783B0D0A2020746F703A203370783B0D0A202077696474683A203270783B0D0A20206865696768743A203570783B0D0A20206261636B67726F756E643A2023666666';
wwv_flow_imp.g_varchar2_table(55) := '6666663B0D0A2020626F726465722D7261646975733A203170783B0D0A7D0D0A0D0A2E73682D656D6C2D62746E2D68696E742D69636F6E3A3A6166746572207B0D0A2020636F6E74656E743A2022223B0D0A2020706F736974696F6E3A206162736F6C75';
wwv_flow_imp.g_varchar2_table(56) := '74653B0D0A20206C6566743A203670783B0D0A2020746F703A20313070783B0D0A202077696474683A203270783B0D0A20206865696768743A203270783B0D0A20206261636B67726F756E643A20236666666666663B0D0A2020626F726465722D726164';
wwv_flow_imp.g_varchar2_table(57) := '6975733A203530253B0D0A7D0D0A0D0A0D0A2F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2049636F6E20706F736974696F6E696E67202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0D0A2F2A20';
wwv_flow_imp.g_varchar2_table(58) := '54686520556E6976657273616C205468656D6520706F736974696F6E73202E617065782D6974656D2D69636F6E2072656C617469766520746F0D0A2020202E742D466F726D2D6974656D577261707065722E204F7572206F776E20777261707065722073';
wwv_flow_imp.g_varchar2_table(59) := '69747320696E206265747765656E2C20736F207468652069636F6E0D0A202020776F756C64206F746865727769736520626520706C6163656420616761696E737420746865207772617070657227732066756C6C20686569676874202877686963680D0A';
wwv_flow_imp.g_varchar2_table(60) := '202020696E636C756465732074686520706F706F76657220656C656D656E74292E2021696D706F7274616E74206973206E65656465642062656361757365207468650D0A2020207468656D652773206F776E2072756C6520666F72207468697320636C61';
wwv_flow_imp.g_varchar2_table(61) := '7373206973206D6F72652073706563696669632E202A2F0D0A2E73682D656D6C2D77726170706572202E617065782D6974656D2D69636F6E207B0D0A2020706F736974696F6E3A206162736F6C7574652021696D706F7274616E743B0D0A20206C656674';
wwv_flow_imp.g_varchar2_table(62) := '3A203070782021696D706F7274616E743B0D0A2020746F703A203530252021696D706F7274616E743B0D0A2020626F74746F6D3A206175746F2021696D706F7274616E743B0D0A202072696768743A206175746F2021696D706F7274616E743B0D0A2020';
wwv_flow_imp.g_varchar2_table(63) := '7472616E73666F726D3A207472616E736C61746559282D353025292021696D706F7274616E743B0D0A20206D617267696E3A20302021696D706F7274616E743B0D0A2020706F696E7465722D6576656E74733A206E6F6E653B0D0A20207A2D696E646578';
wwv_flow_imp.g_varchar2_table(64) := '3A20323B0D0A20206C696E652D6865696768743A20313B0D0A7D0D0A0D0A2F2A205468652077726170706572206D757374206F6E6C792062652061732074616C6C2061732074686520696E70757420697473656C662C20736F2022746F703A2035302522';
wwv_flow_imp.g_varchar2_table(65) := '0D0A20202063656E74657273206F6E20746865206669656C64202D2074686520706F706F76657220697320706F736974696F6E3A666978656420616E64207468657265666F72650D0A202020646F65736E277420616464206865696768742C2062757420';
wwv_flow_imp.g_varchar2_table(66) := '74686973206D616B65732074686520696E74656E74206578706C696369742E202A2F0D0A2E73682D656D6C2D77726170706572207B0D0A20206C696E652D6865696768743A20303B0D0A7D0D0A0D0A2E73682D656D6C2D77726170706572202E73682D65';
wwv_flow_imp.g_varchar2_table(67) := '6D6C2D696E707574207B0D0A20206C696E652D6865696768743A206E6F726D616C3B0D0A7D0D0A0D0A0D0A2F2A2056657268696E646572742C2064617373206461732055542064656E2049636F6E2D436F6E7461696E6572206265696D20466F6B757373';
wwv_flow_imp.g_varchar2_table(68) := '696572656E0D0A20202064657320496E70757473207A7573C3A4747A6C69636820626C61752065696E66C3A4726274202D2049636F6E20626568C3A46C7420696D6D65720D0A2020207365696E65206E6F726D616C652F756E666F6B7573736965727465';
wwv_flow_imp.g_varchar2_table(69) := '204F7074696B2E202A2F0D0A2E742D466F726D2D696E707574436F6E7461696E65722E69732D666F6375736564202E617065782D6974656D2D69636F6E2C0D0A2E617065782D6974656D2D69636F6E2D636F6E7461696E65722E69732D666F6375736564';
wwv_flow_imp.g_varchar2_table(70) := '202E617065782D6974656D2D69636F6E207B0D0A20206261636B67726F756E642D636F6C6F723A20696E68657269742021696D706F7274616E743B0D0A2020636F6C6F723A20696E68657269742021696D706F7274616E743B0D0A202066696C7465723A';
wwv_flow_imp.g_varchar2_table(71) := '206E6F6E652021696D706F7274616E743B0D0A7D0D0A0D0A2E73682D656D6C2D77726170706572202E617065782D6974656D2D69636F6E207B0D0A20206865696768743A20313030252021696D706F7274616E743B0D0A7D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(223793411326834443)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_file_name=>'email_validator.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0D0A20202053264820536F66747761726520536F6C7574696F6E73';
wwv_flow_imp.g_varchar2_table(2) := '0D0A202020456D61696C2056616C696461746F72202D204F7261636C652041504558204974656D20506C7567696E0D0A2020202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(3) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A202020436F6D706F6E656E74203A20436C69656E742D73696465206265686176696F720D0A20202056657273696F6E2020203A20332E332E302028736861726564207469746C65207265676973';
wwv_flow_imp.g_varchar2_table(4) := '747279206163726F73732053264820706C7567696E732C2068696464656E0D0A202020202020202020202020202020696E70757473206E6F206C6F6E67657220626C6F636B20636F6E74726F6C6C656420627574746F6E732C2068696E7420626F78206E';
wwv_flow_imp.g_varchar2_table(5) := '6F0D0A2020202020202020202020202020206C6F6E67657220636F6C6C617073657320746F2074686520627574746F6E2773206F776E207769647468290D0A202020446174652020202020203A20323032362D30382D30360D0A202020417574686F7220';
wwv_flow_imp.g_varchar2_table(6) := '2020203A2053264820536F66747761726520536F6C7574696F6E730D0A2020204C6963656E73652020203A204D4954204C6963656E73652E205468697320636F6465206973206672656520616E64206F70656E20746F207573652C206D6F646966792C0D';
wwv_flow_imp.g_varchar2_table(7) := '0A202020202020202020202020202020616E64207265646973747269627574652C2077697468206F7220776974686F7574206174747269627574696F6E2C20666F720D0A202020202020202020202020202020706572736F6E616C206F7220636F6D6D65';
wwv_flow_imp.g_varchar2_table(8) := '726369616C2070726F6A656374732E0D0A2020202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A2020204E4F54453A';
wwv_flow_imp.g_varchar2_table(9) := '20436C69656E742D7369646520636865636B732061726520555820666565646261636B206F6E6C792E2054686520617574686F72697461746976650D0A20202076616C69646174696F6E206D7573742072756E207365727665722D7369646520696E2074';
wwv_flow_imp.g_varchar2_table(10) := '686520706C7567696E27732056616C69646174696F6E0D0A20202050726F6365647572652C2073696E6365204A6176615363726970742063616E2062652064697361626C6564206F722062797061737365642E205468652073616D650D0A202020617070';
wwv_flow_imp.g_varchar2_table(11) := '6C69657320746F2074686520626C6F636B656420627574746F6E2E0D0A2020203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_imp.g_varchar2_table(12) := '3D3D202A2F0D0A0D0A2F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A2F2F20536861726564206163726F737320616C6C';
wwv_flow_imp.g_varchar2_table(13) := '2053264820706C7567696E733A206C657473206D756C7469706C652076616C696461746F727320636F6E74726F6C6C696E670D0A2F2F207468652053414D4520627574746F6E20636F6D62696E65207468656972207469746C65207465787420696E7374';
wwv_flow_imp.g_varchar2_table(14) := '656164206F66206F76657277726974696E670D0A2F2F2065616368206F746865722E204775617264656420736F2069742773207361666520746F20696E636C75646520696E20657665727920706C7567696E2066696C650D0A2F2F2028656D61696C5F76';
wwv_flow_imp.g_varchar2_table(15) := '616C696461746F722E6A7320616E642070617373776F72645F76616C696461746F722E6A7320626F746820646566696E6520746869730D0A2F2F20626C6F636B206964656E746963616C6C79202D20746865206669727374206F6E6520746F206C6F6164';
wwv_flow_imp.g_varchar2_table(16) := '2077696E732C206861726D6C6573736C79292E0D0A2F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A696620282177696E';
wwv_flow_imp.g_varchar2_table(17) := '646F772E7368526567697374657242746E426C6F636B657229207B0D0A202077696E646F772E736842746E5265676973747279203D207B7D3B0D0A0D0A202077696E646F772E7368526567697374657242746E426C6F636B6572203D2066756E6374696F';
wwv_flow_imp.g_varchar2_table(18) := '6E202870427574746F6E49642C20704B65792C20704D65737361676529207B0D0A20202020696620282170427574746F6E496429207B2072657475726E3B207D0D0A2020202076617220726567203D2077696E646F772E736842746E5265676973747279';
wwv_flow_imp.g_varchar2_table(19) := '3B0D0A202020207265675B70427574746F6E49645D203D207265675B70427574746F6E49645D207C7C207B7D3B0D0A0D0A2020202069662028704D65737361676529207B0D0A2020202020207265675B70427574746F6E49645D5B704B65795D203D2070';
wwv_flow_imp.g_varchar2_table(20) := '4D6573736167653B0D0A202020207D20656C7365207B0D0A20202020202064656C657465207265675B70427574746F6E49645D5B704B65795D3B0D0A202020207D0D0A0D0A2020202076617220627574746F6E203D20646F63756D656E742E676574456C';
wwv_flow_imp.g_varchar2_table(21) := '656D656E74427949642870427574746F6E4964293B0D0A202020206966202821627574746F6E29207B2072657475726E3B207D0D0A0D0A20202020766172206D65737361676573203D204F626A6563742E6B657973287265675B70427574746F6E49645D';
wwv_flow_imp.g_varchar2_table(22) := '292E6D61702866756E6374696F6E20286B29207B0D0A20202020202072657475726E207265675B70427574746F6E49645D5B6B5D3B0D0A202020207D293B0D0A0D0A20202020696620286D657373616765732E6C656E677468203E203029207B0D0A2020';
wwv_flow_imp.g_varchar2_table(23) := '20202020627574746F6E2E73657441747472696275746528227469746C65222C206D657373616765732E6A6F696E282220C2B7202229293B0D0A202020207D20656C7365207B0D0A202020202020627574746F6E2E72656D6F7665417474726962757465';
wwv_flow_imp.g_varchar2_table(24) := '28227469746C6522293B0D0A202020207D0D0A20207D3B0D0A7D0D0A0D0A766172207368456D61696C56616C696461746F72203D207B0D0A0D0A2020696E69743A2066756E6374696F6E202870456C656D656E74496429207B0D0A202020207661722077';
wwv_flow_imp.g_varchar2_table(25) := '726170706572203D20646F63756D656E742E676574456C656D656E74427949642870456C656D656E744964202B20225F53485F454D41494C22293B0D0A2020202069662028217772617070657229207B0D0A202020202020636F6E736F6C652E7761726E';
wwv_flow_imp.g_varchar2_table(26) := '28227368456D61696C56616C696461746F723A2077726170706572206E6F7420666F756E6420666F722022202B2070456C656D656E744964293B0D0A20202020202072657475726E3B0D0A202020207D0D0A0D0A2020202076617220696E707574202020';
wwv_flow_imp.g_varchar2_table(27) := '3D20646F63756D656E742E676574456C656D656E74427949642870456C656D656E744964293B0D0A2020202076617220706F706F766572203D20777261707065722E717565727953656C6563746F7228222E73682D656D6C2D706F706F76657222293B0D';
wwv_flow_imp.g_varchar2_table(28) := '0A0D0A202020206966202821696E707574207C7C2021706F706F76657229207B0D0A202020202020636F6E736F6C652E7761726E28227368456D61696C56616C696461746F723A20696E636F6D706C657465206D61726B757020666F722022202B207045';
wwv_flow_imp.g_varchar2_table(29) := '6C656D656E744964293B0D0A20202020202072657475726E3B0D0A202020207D0D0A0D0A202020207661722072756C654C6973742020203D20706F706F7665722E717565727953656C6563746F7228222E73682D656D6C2D72756C652D6C69737422293B';
wwv_flow_imp.g_varchar2_table(30) := '0D0A20202020766172206E6F746963654C697374203D20706F706F7665722E717565727953656C6563746F7228222E73682D656D6C2D6E6F746963652D6C69737422293B0D0A20202020766172207469746C65456C202020203D20706F706F7665722E71';
wwv_flow_imp.g_varchar2_table(31) := '7565727953656C6563746F7228222E73682D656D6C2D706F706F7665722D7469746C6522293B0D0A0D0A202020202F2F20506F7274616C207061747465726E3A2061747461636820746F203C626F64793E20736F206E6F20616E636573746F72206F7665';
wwv_flow_imp.g_varchar2_table(32) := '72666C6F77206F720D0A202020202F2F20737461636B696E6720636F6E746578742063616E20636C6970206F7220636F7665722074686520706F706F7665722E0D0A20202020646F63756D656E742E626F64792E617070656E644368696C6428706F706F';
wwv_flow_imp.g_varchar2_table(33) := '766572293B0D0A0D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A202020202F2F204C616E67756167653A';
wwv_flow_imp.g_varchar2_table(34) := '2062726F77736572206C616E6775616765207374617274696E6720776974682022646522202D3E204765726D616E2C0D0A202020202F2F2065766572797468696E6720656C7365202D3E20456E676C6973682E0D0A202020202F2F202D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(35) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A202020207661722069734765726D616E203D20286E6176696761746F722E6C616E6775616765207C';
wwv_flow_imp.g_varchar2_table(36) := '7C202222292E746F4C6F7765724361736528292E696E6465784F66282264652229203D3D3D20303B0D0A2020202066756E6374696F6E20747874287044652C2070456E29207B2072657475726E2069734765726D616E203F20704465203A2070456E3B20';
wwv_flow_imp.g_varchar2_table(37) := '7D0D0A0D0A202020207469746C65456C2E74657874436F6E74656E74203D20747874282256616C6964696572756E67222C202256616C69646174696F6E22293B0D0A0D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(38) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A202020202F2F20436F6E66696775726174696F6E2066726F6D20646174612D2A20617474726962757465730D0A202020202F2F202D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(39) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A2020202066756E6374696F6E206174747228704E616D65292020207B2072657475726E2077';
wwv_flow_imp.g_varchar2_table(40) := '7261707065722E67657441747472696275746528704E616D6529207C7C2022223B207D0D0A2020202066756E6374696F6E2061747472594E28704E616D6529207B2072657475726E206174747228704E616D6529203D3D3D202259223B207D0D0A0D0A20';
wwv_flow_imp.g_varchar2_table(41) := '20202076617220636667203D207B0D0A202020202020726571756972653A20202020202020202061747472594E2822646174612D7265717569726522292C0D0A2020202020206175746F4C6F776572636173653A20202061747472594E2822646174612D';
wwv_flow_imp.g_varchar2_table(42) := '6175746F2D6C6F7765726361736522292C0D0A20202020202072656A6563745370616365733A2020202061747472594E2822646174612D72656A6563742D73706163657322292C0D0A20202020202073696E676C6541743A202020202020202061747472';
wwv_flow_imp.g_varchar2_table(43) := '594E2822646174612D73696E676C652D617422292C0D0A2020202020207265714C6F63616C3A202020202020202061747472594E2822646174612D7265712D6C6F63616C22292C0D0A202020202020726571446F6D61696E3A2020202020202061747472';
wwv_flow_imp.g_varchar2_table(44) := '594E2822646174612D7265712D646F6D61696E22292C0D0A2020202020206E6F446F75626C65446F74733A2020202061747472594E2822646174612D6E6F2D646F75626C652D646F747322292C0D0A2020202020206E6F4C6F63616C456467653A202020';
wwv_flow_imp.g_varchar2_table(45) := '202061747472594E2822646174612D6E6F2D6C6F63616C2D6564676522292C0D0A2020202020206E6F446F6D61696E456467653A2020202061747472594E2822646174612D6E6F2D646F6D61696E2D6564676522292C0D0A202020202020726571756972';
wwv_flow_imp.g_varchar2_table(46) := '65546C643A20202020202061747472594E2822646174612D726571756972652D746C6422292C0D0A202020202020746C64436865636B3A202020202020202061747472594E2822646174612D746C642D636865636B22292C0D0A202020202020646F6D61';
wwv_flow_imp.g_varchar2_table(47) := '696E436865636B3A202020202061747472594E2822646174612D646F6D61696E2D636865636B22292C0D0A2020202020206C6F63616C436865636B3A20202020202061747472594E2822646174612D6C6F63616C2D636865636B22292C0D0A2020202020';
wwv_flow_imp.g_varchar2_table(48) := '20746C645061747465726E3A202020202020617474722822646174612D746C642D7061747465726E22292C0D0A202020202020646F6D61696E5061747465726E3A202020617474722822646174612D646F6D61696E2D7061747465726E22292C0D0A2020';
wwv_flow_imp.g_varchar2_table(49) := '202020206C6F63616C5061747465726E3A20202020617474722822646174612D6C6F63616C2D7061747465726E22292C0D0A2020202020206D696E436865636B3A202020202020202061747472594E2822646174612D6D696E2D636865636B22292C0D0A';
wwv_flow_imp.g_varchar2_table(50) := '2020202020206D6178436865636B3A202020202020202061747472594E2822646174612D6D61782D636865636B22292C0D0A2020202020206D696E4C656E6774683A202020202020207061727365496E7428617474722822646174612D6D696E2D6C656E';
wwv_flow_imp.g_varchar2_table(51) := '67746822292C203130292C0D0A2020202020206D61784C656E6774683A202020202020207061727365496E7428617474722822646174612D6D61782D6C656E67746822292C203130292C0D0A2020202020207265737472696374576C6973743A20202061';
wwv_flow_imp.g_varchar2_table(52) := '747472594E2822646174612D72657374726963742D77686974656C69737422292C0D0A202020202020626C6F636B446973706F7361626C653A2061747472594E2822646174612D626C6F636B2D646973706F7361626C6522292C0D0A2020202020206275';
wwv_flow_imp.g_varchar2_table(53) := '74746F6E49643A2020202020202020617474722822646174612D627574746F6E2D696422290D0A202020207D3B0D0A0D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(54) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A202020202F2F205669736962696C6974792067756172643A2074727565206F6E6C79207768696C652074686520696E7075742069732061637475616C6C790D0A202020202F2F2072656E6465';
wwv_flow_imp.g_varchar2_table(55) := '72656420286E6F7420646973706C61793A6E6F6E652C206E6F7420696E7369646520612068696464656E20616E636573746F7220737563680D0A202020202F2F20617320616E20756E6F70656E656420696E6C696E65206469616C6F67292E2055736564';
wwv_flow_imp.g_varchar2_table(56) := '20736F20612068696464656E206669656C64206E657665720D0A202020202F2F20626C6F636B73206120636F6E74726F6C6C656420627574746F6E2074686520757365722063616E2774206576656E2073656520746865206669656C640D0A202020202F';
wwv_flow_imp.g_varchar2_table(57) := '2F20666F722E0D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A2020202066756E6374696F6E206973496E';
wwv_flow_imp.g_varchar2_table(58) := '70757456697369626C652829207B0D0A20202020202072657475726E20212128696E7075742E6F66667365745769647468207C7C20696E7075742E6F6666736574486569676874207C7C20696E7075742E676574436C69656E74526563747328292E6C65';
wwv_flow_imp.g_varchar2_table(59) := '6E677468293B0D0A202020207D0D0A0D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A202020202F2F204F';
wwv_flow_imp.g_varchar2_table(60) := '7074696F6E616C20636F6E74726F6C6C656420627574746F6E0D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(61) := '0D0A2020202076617220636F6E74726F6C6C6564427574746F6E203D206366672E627574746F6E4964203F20646F63756D656E742E676574456C656D656E7442794964286366672E627574746F6E496429203A206E756C6C3B0D0A202020207661722062';
wwv_flow_imp.g_varchar2_table(62) := '7574746F6E48696E74203D206E756C6C3B0D0A0D0A20202020696620286366672E627574746F6E49642026262021636F6E74726F6C6C6564427574746F6E29207B0D0A202020202020636F6E736F6C652E7761726E28227368456D61696C56616C696461';
wwv_flow_imp.g_varchar2_table(63) := '746F723A20627574746F6E207769746820737461746963204944202722202B206366672E627574746F6E4964202B202227206E6F7420666F756E6422293B0D0A202020207D0D0A0D0A2020202069662028636F6E74726F6C6C6564427574746F6E29207B';
wwv_flow_imp.g_varchar2_table(64) := '0D0A2020202020202F2F20496E7465726365707420636C69636B7320696E20746865206361707475726520706861736520736F2074686520626C6F636B2074616B6573206566666563740D0A2020202020202F2F206265666F7265207468652062757474';
wwv_flow_imp.g_varchar2_table(65) := '6F6E2773206F776E20696E6C696E65206F6E636C69636B2028617065782E7375626D6974292063616E20666972652E0D0A202020202020636F6E74726F6C6C6564427574746F6E2E6164644576656E744C697374656E65722822636C69636B222C206675';
wwv_flow_imp.g_varchar2_table(66) := '6E6374696F6E2028704576656E7429207B0D0A202020202020202069662028636F6E74726F6C6C6564427574746F6E2E636C6173734C6973742E636F6E7461696E73282273682D656D6C2D62746E2D626C6F636B6564222929207B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(67) := '202020704576656E742E70726576656E7444656661756C7428293B0D0A20202020202020202020704576656E742E73746F70496D6D65646961746550726F7061676174696F6E28293B0D0A20202020202020207D0D0A2020202020207D2C207472756529';
wwv_flow_imp.g_varchar2_table(68) := '3B0D0A0D0A2020202020202F2F2048696E7420656C656D656E7420617474616368656420746F203C626F64793E2028706F7274616C207061747465726E2C2073616D65206173207468650D0A2020202020202F2F20706F706F7665722920736F206E6F20';
wwv_flow_imp.g_varchar2_table(69) := '616E636573746F72206C61796F7574206F72206F766572666C6F772063616E206166666563742069742E0D0A202020202020627574746F6E48696E74203D20646F63756D656E742E637265617465456C656D656E74282264697622293B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(70) := '20627574746F6E48696E742E636C6173734E616D65203D202273682D656D6C2D62746E2D68696E742073682D7368617265642D62746E2D68696E74223B0D0A2020202020202F2F20536861726564206D61726B657220736F206F74686572205326482070';
wwv_flow_imp.g_varchar2_table(71) := '6C7567696E732028652E672E2050617373776F72642076616C696461746F72290D0A2020202020202F2F2063616E207265636F676E697A6520612068696E7420626F7820746861742074617267657473207468652073616D6520627574746F6E20616E64';
wwv_flow_imp.g_varchar2_table(72) := '0D0A2020202020202F2F20737461636B2062656C6F7720697420696E7374656164206F66206F7665726C617070696E672069742E204B6565702074686973206174747269627574650D0A2020202020202F2F206E616D65206964656E746963616C206163';
wwv_flow_imp.g_varchar2_table(73) := '726F737320706C7567696E733A20646174612D73682D68696E742D627574746F6E2E0D0A202020202020627574746F6E48696E742E7365744174747269627574652822646174612D73682D68696E742D627574746F6E222C206366672E627574746F6E49';
wwv_flow_imp.g_varchar2_table(74) := '64293B0D0A202020202020627574746F6E48696E742E696E6E657248544D4C203D20273C7370616E20636C6173733D2273682D656D6C2D62746E2D68696E742D69636F6E223E3C2F7370616E3E3C7370616E3E3C2F7370616E3E273B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(75) := '646F63756D656E742E626F64792E617070656E644368696C6428627574746F6E48696E74293B0D0A0D0A2020202020202F2F20506C7567696E2D61676E6F73746963207669736962696C69747920636865636B2028776F726B73207265676172646C6573';
wwv_flow_imp.g_varchar2_table(76) := '73206F662077686963680D0A2020202020202F2F2043535320636C61737320616E6F7468657220706C7567696E207573657320746F20746F67676C6520697473206F776E2068696E7420626F78292E0D0A20202020202066756E6374696F6E206973456C';
wwv_flow_imp.g_varchar2_table(77) := '656D656E7456697369626C652870456C29207B0D0A20202020202020206966202870456C203D3D3D20627574746F6E48696E7429207B2072657475726E2066616C73653B207D0D0A2020202020202020766172207374796C65203D2077696E646F772E67';
wwv_flow_imp.g_varchar2_table(78) := '6574436F6D70757465645374796C652870456C293B0D0A202020202020202072657475726E207374796C652E646973706C617920213D3D20226E6F6E6522202626207374796C652E7669736962696C69747920213D3D202268696464656E223B0D0A2020';
wwv_flow_imp.g_varchar2_table(79) := '202020207D0D0A0D0A2020202020202F2F20506F736974696F6E73207468652068696E74206469726563746C792062656E656174682074686520627574746F6E202D20737461636B732062656C6F770D0A2020202020202F2F20616E79206F7468657220';
wwv_flow_imp.g_varchar2_table(80) := '63757272656E746C792076697369626C652068696E7420626F78207468617420616C736F207461726765747320746869730D0A2020202020202F2F2073616D6520627574746F6E2028652E672E2066726F6D207468652050617373776F72642076616C69';
wwv_flow_imp.g_varchar2_table(81) := '6461746F7220706C7567696E292C20696E73746561640D0A2020202020202F2F206F66206F7665726C617070696E672069742E20576964746820697320666C6F6F72656420617420612073656E7369626C65206D696E696D756D20736F20610D0A202020';
wwv_flow_imp.g_varchar2_table(82) := '2020202F2F20736D616C6C2F636F6D7061637420627574746F6E2028652E672E206120746F702D72696768742069636F6E20627574746F6E2920646F65736E27740D0A2020202020202F2F20666F72636520746865206D65737361676520746578742074';
wwv_flow_imp.g_varchar2_table(83) := '6F207772617020696E746F20612074616C6C2C206D616E792D6C696E6520626F782E0D0A20202020202066756E6374696F6E20706F736974696F6E427574746F6E48696E742829207B0D0A20202020202020207661722072656374203D20636F6E74726F';
wwv_flow_imp.g_varchar2_table(84) := '6C6C6564427574746F6E2E676574426F756E64696E67436C69656E745265637428293B0D0A202020202020202076617220746F7020203D20726563742E626F74746F6D202B20363B0D0A0D0A2020202020202020766172206F7468657273203D20646F63';
wwv_flow_imp.g_varchar2_table(85) := '756D656E742E717565727953656C6563746F72416C6C280D0A20202020202020202020272E73682D7368617265642D62746E2D68696E745B646174612D73682D68696E742D627574746F6E3D2227202B206366672E627574746F6E4964202B2027225D27';
wwv_flow_imp.g_varchar2_table(86) := '0D0A2020202020202020293B0D0A20202020202020206F74686572732E666F72456163682866756E6374696F6E202870456C29207B0D0A20202020202020202020696620286973456C656D656E7456697369626C652870456C2929207B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(87) := '20202020202020766172206F7468657252656374203D2070456C2E676574426F756E64696E67436C69656E745265637428293B0D0A202020202020202020202020746F70203D204D6174682E6D617828746F702C206F74686572526563742E626F74746F';
wwv_flow_imp.g_varchar2_table(88) := '6D202B2036293B0D0A202020202020202020207D0D0A20202020202020207D293B0D0A0D0A20202020202020207661722068696E745769647468203D204D6174682E6D617828726563742E77696474682C20323430293B0D0A2020202020202020766172';
wwv_flow_imp.g_varchar2_table(89) := '2068696E744C65667420203D20726563742E6C6566743B0D0A20202020202020206966202868696E744C656674202B2068696E745769647468203E2077696E646F772E696E6E65725769647468202D203829207B0D0A2020202020202020202068696E74';
wwv_flow_imp.g_varchar2_table(90) := '4C656674203D204D6174682E6D617828382C2077696E646F772E696E6E65725769647468202D2068696E745769647468202D2038293B0D0A20202020202020207D0D0A0D0A2020202020202020627574746F6E48696E742E7374796C652E746F70202020';
wwv_flow_imp.g_varchar2_table(91) := '3D20746F70202B20227078223B0D0A2020202020202020627574746F6E48696E742E7374796C652E6C65667420203D2068696E744C656674202B20227078223B0D0A2020202020202020627574746F6E48696E742E7374796C652E7769647468203D2068';
wwv_flow_imp.g_varchar2_table(92) := '696E745769647468202B20227078223B0D0A2020202020207D0D0A0D0A202020202020636F6E74726F6C6C6564427574746F6E2E6164644576656E744C697374656E657228226D6F757365656E746572222C2066756E6374696F6E202829207B0D0A2020';
wwv_flow_imp.g_varchar2_table(93) := '20202020202069662028636F6E74726F6C6C6564427574746F6E2E636C6173734C6973742E636F6E7461696E73282273682D656D6C2D62746E2D626C6F636B6564222929207B0D0A20202020202020202020706F736974696F6E427574746F6E48696E74';
wwv_flow_imp.g_varchar2_table(94) := '28293B0D0A20202020202020202020627574746F6E48696E742E636C6173734C6973742E616464282273682D656D6C2D62746E2D68696E742D76697369626C6522293B0D0A20202020202020207D0D0A2020202020207D293B0D0A0D0A20202020202063';
wwv_flow_imp.g_varchar2_table(95) := '6F6E74726F6C6C6564427574746F6E2E6164644576656E744C697374656E657228226D6F7573656C65617665222C2066756E6374696F6E202829207B0D0A2020202020202020627574746F6E48696E742E636C6173734C6973742E72656D6F7665282273';
wwv_flow_imp.g_varchar2_table(96) := '682D656D6C2D62746E2D68696E742D76697369626C6522293B0D0A2020202020207D293B0D0A0D0A2020202020202F2F205468652068696E74206973206162736F6C7574656C7920706F736974696F6E65642C20736F20697473206F6666736574207061';
wwv_flow_imp.g_varchar2_table(97) := '72656E74206D7573740D0A2020202020202F2F2065737461626C697368206120706F736974696F6E696E6720636F6E74657874202D206F746865727769736520697420616E63686F727320746F207468650D0A2020202020202F2F207061676520696E73';
wwv_flow_imp.g_varchar2_table(98) := '74656164206F662073697474696E6720726967687420756E6465722074686520627574746F6E2E0D0A20202020202069662028676574436F6D70757465645374796C6528636F6E74726F6C6C6564427574746F6E2E706172656E744E6F6465292E706F73';
wwv_flow_imp.g_varchar2_table(99) := '6974696F6E203D3D3D20227374617469632229207B0D0A2020202020202020636F6E74726F6C6C6564427574746F6E2E706172656E744E6F64652E7374796C652E706F736974696F6E203D202272656C6174697665223B0D0A2020202020207D0D0A0D0A';
wwv_flow_imp.g_varchar2_table(100) := '2020202020202F2F204B656570207468652068696E7420676C75656420756E6465722074686520627574746F6E2028616E6420756E64657220616E79206F746865720D0A2020202020202F2F20737461636B65642068696E7429207768696C6520746865';
wwv_flow_imp.g_varchar2_table(101) := '2070616765207363726F6C6C73206F7220726573697A65732E0D0A20202020202077696E646F772E6164644576656E744C697374656E657228227363726F6C6C222C2066756E6374696F6E202829207B0D0A202020202020202069662028627574746F6E';
wwv_flow_imp.g_varchar2_table(102) := '48696E742E636C6173734C6973742E636F6E7461696E73282273682D656D6C2D62746E2D68696E742D76697369626C65222929207B0D0A20202020202020202020706F736974696F6E427574746F6E48696E7428293B0D0A20202020202020207D0D0A20';
wwv_flow_imp.g_varchar2_table(103) := '20202020207D2C2074727565293B0D0A0D0A20202020202077696E646F772E6164644576656E744C697374656E65722822726573697A65222C2066756E6374696F6E202829207B0D0A202020202020202069662028627574746F6E48696E742E636C6173';
wwv_flow_imp.g_varchar2_table(104) := '734C6973742E636F6E7461696E73282273682D656D6C2D62746E2D68696E742D76697369626C65222929207B0D0A20202020202020202020706F736974696F6E427574746F6E48696E7428293B0D0A20202020202020207D0D0A2020202020207D293B0D';
wwv_flow_imp.g_varchar2_table(105) := '0A202020207D0D0A0D0A2020202066756E6374696F6E207061727365446F6D61696E4C697374287052617729207B0D0A20202020202069662028217052617729207B2072657475726E205B5D3B207D0D0A20202020202072657475726E20705261772E73';
wwv_flow_imp.g_varchar2_table(106) := '706C697428222C22290D0A20202020202020202E6D61702866756E6374696F6E20286429207B2072657475726E20642E7472696D28292E746F4C6F7765724361736528293B207D290D0A20202020202020202E66696C7465722866756E6374696F6E2028';
wwv_flow_imp.g_varchar2_table(107) := '6429207B2072657475726E20642E6C656E677468203E20303B207D293B0D0A202020207D0D0A0D0A202020207661722077686974656C697374446F6D61696E7320203D207061727365446F6D61696E4C69737428617474722822646174612D646F6D6169';
wwv_flow_imp.g_varchar2_table(108) := '6E2D77686974656C6973742229293B0D0A2020202076617220646973706F7361626C65446F6D61696E73203D207061727365446F6D61696E4C69737428617474722822646174612D646973706F7361626C652D6C6973742229293B0D0A0D0A202020202F';
wwv_flow_imp.g_varchar2_table(109) := '2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A202020202F2F2048656C706572730D0A202020202F2F202D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(110) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A2020202066756E6374696F6E2073706C6974456D61696C287056616C756529207B0D0A20202020';
wwv_flow_imp.g_varchar2_table(111) := '2020766172206174203D207056616C75652E696E6465784F6628224022293B0D0A202020202020696620286174203D3D3D202D3129207B2072657475726E207B206C6F63616C3A207056616C75652C20646F6D61696E3A2022222C20746C643A20222220';
wwv_flow_imp.g_varchar2_table(112) := '7D3B207D0D0A202020202020766172206C6F63616C20203D207056616C75652E737562737472696E6728302C206174293B0D0A20202020202076617220646F6D61696E203D207056616C75652E737562737472696E67286174202B2031293B0D0A202020';
wwv_flow_imp.g_varchar2_table(113) := '202020766172206C617374446F74203D20646F6D61696E2E6C617374496E6465784F6628222E22293B0D0A20202020202076617220746C64203D206C617374446F74203D3D3D202D31203F202222203A20646F6D61696E2E737562737472696E67286C61';
wwv_flow_imp.g_varchar2_table(114) := '7374446F74202B2031293B0D0A20202020202072657475726E207B206C6F63616C3A206C6F63616C2C20646F6D61696E3A20646F6D61696E2C20746C643A20746C64207D3B0D0A202020207D0D0A0D0A2020202066756E6374696F6E2073616665526567';
wwv_flow_imp.g_varchar2_table(115) := '65785465737428705061747465726E2C207056616C756529207B0D0A202020202020747279207B0D0A202020202020202072657475726E206E65772052656745787028705061747465726E292E74657374287056616C7565293B0D0A2020202020207D20';
wwv_flow_imp.g_varchar2_table(116) := '636174636820286529207B0D0A2020202020202020636F6E736F6C652E7761726E28227368456D61696C56616C696461746F723A20696E76616C6964207061747465726E20636F6E666967757265643A2022202B20705061747465726E293B0D0A202020';
wwv_flow_imp.g_varchar2_table(117) := '202020202072657475726E2066616C73653B0D0A2020202020207D0D0A202020207D0D0A0D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(118) := '2D2D2D2D2D2D2D2D2D2D2D0D0A202020202F2F2052756C6520646566696E6974696F6E730D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(119) := '2D2D2D2D2D2D2D2D2D2D2D0D0A202020207661722072756C6573203D205B0D0A2020202020207B0D0A20202020202020206163746976653A206366672E726571756972652C0D0A20202020202020206D6573736167653A20747874282246656C64206461';
wwv_flow_imp.g_varchar2_table(120) := '7266206E69636874206C656572207365696E222C20224669656C64206D757374206E6F7420626520656D70747922292C0D0A2020202020202020746573743A2066756E6374696F6E20287629207B2072657475726E20762E7472696D28292E6C656E6774';
wwv_flow_imp.g_varchar2_table(121) := '68203E20303B207D0D0A2020202020207D2C0D0A2020202020207B0D0A20202020202020206163746976653A206366672E72656A6563745370616365732C0D0A20202020202020206D6573736167653A2074787428224B65696E65204C6565727A656963';
wwv_flow_imp.g_varchar2_table(122) := '68656E206F646572205374657565727A65696368656E2065726C61756274222C0D0A202020202020202020202020202020202020202020224E6F20737061636573206F7220636F6E74726F6C206368617261637465727320616C6C6F77656422292C0D0A';
wwv_flow_imp.g_varchar2_table(123) := '2020202020202020746573743A2066756E6374696F6E20287629207B2072657475726E20212F5B5C735C75303030302D5C75303031465C75303037465D2F2E746573742876293B207D0D0A2020202020207D2C0D0A2020202020207B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(124) := '20206163746976653A206366672E73696E676C6541742C0D0A20202020202020206D6573736167653A2074787428224D7573732067656E61752065696E20402D5A65696368656E20656E7468616C74656E222C0D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(125) := '202020202020224D75737420636F6E7461696E2065786163746C79206F6E6520402073796D626F6C22292C0D0A2020202020202020746573743A2066756E6374696F6E20287629207B0D0A2020202020202020202069662028762E7472696D28292E6C65';
wwv_flow_imp.g_varchar2_table(126) := '6E677468203D3D3D203029207B2072657475726E20747275653B207D0D0A2020202020202020202072657475726E2028762E6D61746368282F402F6729207C7C205B5D292E6C656E677468203D3D3D20313B0D0A20202020202020207D0D0A2020202020';
wwv_flow_imp.g_varchar2_table(127) := '207D2C0D0A2020202020207B0D0A20202020202020206163746976653A206366672E7265714C6F63616C2C0D0A20202020202020206D6573736167653A2074787428224E616D6520766F722064656D2040206665686C74222C20224E616D65206265666F';
wwv_flow_imp.g_varchar2_table(128) := '72652040206973206D697373696E6722292C0D0A2020202020202020746573743A2066756E6374696F6E20287629207B0D0A2020202020202020202069662028762E7472696D28292E6C656E677468203D3D3D2030207C7C20762E696E6465784F662822';
wwv_flow_imp.g_varchar2_table(129) := '402229203D3D3D202D3129207B2072657475726E20747275653B207D0D0A2020202020202020202072657475726E2073706C6974456D61696C2876292E6C6F63616C2E6C656E677468203E20303B0D0A20202020202020207D0D0A2020202020207D2C0D';
wwv_flow_imp.g_varchar2_table(130) := '0A2020202020207B0D0A20202020202020206163746976653A206366672E726571446F6D61696E2C0D0A20202020202020206D6573736167653A207478742822446F6D61696E206E6163682064656D2040206665686C74222C2022446F6D61696E206166';
wwv_flow_imp.g_varchar2_table(131) := '7465722040206973206D697373696E6722292C0D0A2020202020202020746573743A2066756E6374696F6E20287629207B0D0A2020202020202020202069662028762E7472696D28292E6C656E677468203D3D3D2030207C7C20762E696E6465784F6628';
wwv_flow_imp.g_varchar2_table(132) := '22402229203D3D3D202D3129207B2072657475726E20747275653B207D0D0A2020202020202020202072657475726E2073706C6974456D61696C2876292E646F6D61696E2E6C656E677468203E20303B0D0A20202020202020207D0D0A2020202020207D';
wwv_flow_imp.g_varchar2_table(133) := '2C0D0A2020202020207B0D0A20202020202020206163746976653A206366672E6E6F446F75626C65446F74732C0D0A20202020202020206D6573736167653A2074787428224B65696E6520646F7070656C74656E2050756E6B746520282E2E292065726C';
wwv_flow_imp.g_varchar2_table(134) := '61756274222C0D0A202020202020202020202020202020202020202020224E6F20636F6E736563757469766520646F747320282E2E2920616C6C6F77656422292C0D0A2020202020202020746573743A2066756E6374696F6E20287629207B2072657475';
wwv_flow_imp.g_varchar2_table(135) := '726E20762E696E6465784F6628222E2E2229203D3D3D202D313B207D0D0A2020202020207D2C0D0A2020202020207B0D0A20202020202020206163746976653A206366672E6E6F4C6F63616C456467652C0D0A20202020202020206D6573736167653A20';
wwv_flow_imp.g_varchar2_table(136) := '74787428225465696C20766F722064656D20402064617266206E69636874206D69742050756E6B7420626567696E6E656E206F64657220656E64656E222C0D0A2020202020202020202020202020202020202020202250617274206265666F7265204020';
wwv_flow_imp.g_varchar2_table(137) := '6D757374206E6F74207374617274206F7220656E642077697468206120646F7422292C0D0A2020202020202020746573743A2066756E6374696F6E20287629207B0D0A20202020202020202020766172206C6F63616C203D2073706C6974456D61696C28';
wwv_flow_imp.g_varchar2_table(138) := '76292E6C6F63616C3B0D0A20202020202020202020696620286C6F63616C2E6C656E677468203D3D3D203029207B2072657475726E20747275653B207D0D0A2020202020202020202072657475726E206C6F63616C2E63686172417428302920213D3D20';
wwv_flow_imp.g_varchar2_table(139) := '222E22202626206C6F63616C2E636861724174286C6F63616C2E6C656E677468202D20312920213D3D20222E223B0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020207B0D0A20202020202020206163746976653A206366672E6E6F';
wwv_flow_imp.g_varchar2_table(140) := '446F6D61696E456467652C0D0A20202020202020206D6573736167653A207478742822446F6D61696E2064617266206E69636874206D69742050756E6B74206F6465722042696E646573747269636820626567696E6E656E206F64657220656E64656E22';
wwv_flow_imp.g_varchar2_table(141) := '2C0D0A20202020202020202020202020202020202020202022446F6D61696E206D757374206E6F74207374617274206F7220656E642077697468206120646F74206F722068797068656E22292C0D0A2020202020202020746573743A2066756E6374696F';
wwv_flow_imp.g_varchar2_table(142) := '6E20287629207B0D0A2020202020202020202076617220646F6D61696E203D2073706C6974456D61696C2876292E646F6D61696E3B0D0A2020202020202020202069662028646F6D61696E2E6C656E677468203D3D3D203029207B2072657475726E2074';
wwv_flow_imp.g_varchar2_table(143) := '7275653B207D0D0A20202020202020202020766172206669727374203D20646F6D61696E2E6368617241742830293B0D0A20202020202020202020766172206C61737420203D20646F6D61696E2E63686172417428646F6D61696E2E6C656E677468202D';
wwv_flow_imp.g_varchar2_table(144) := '2031293B0D0A2020202020202020202072657475726E20666972737420213D3D20222E2220262620666972737420213D3D20222D22202626206C61737420213D3D20222E22202626206C61737420213D3D20222D223B0D0A20202020202020207D0D0A20';
wwv_flow_imp.g_varchar2_table(145) := '20202020207D2C0D0A2020202020207B0D0A20202020202020206163746976653A206366672E72657175697265546C642C0D0A20202020202020206D6573736167653A207478742822446F6D61696E20627261756368742065696E6520456E64756E6720';
wwv_flow_imp.g_varchar2_table(146) := '287A2E20422E202E64652C202E636F6D29222C0D0A20202020202020202020202020202020202020202022446F6D61696E206D75737420636F6E7461696E206120746F702D6C6576656C20646F6D61696E2028652E672E202E64652C202E636F6D292229';
wwv_flow_imp.g_varchar2_table(147) := '2C0D0A2020202020202020746573743A2066756E6374696F6E20287629207B0D0A2020202020202020202076617220646F6D61696E203D2073706C6974456D61696C2876292E646F6D61696E3B0D0A2020202020202020202069662028646F6D61696E2E';
wwv_flow_imp.g_varchar2_table(148) := '6C656E677468203D3D3D203029207B2072657475726E20747275653B207D0D0A2020202020202020202072657475726E20646F6D61696E2E696E6465784F6628222E222920213D3D202D313B0D0A20202020202020207D0D0A2020202020207D2C0D0A20';
wwv_flow_imp.g_varchar2_table(149) := '20202020207B0D0A20202020202020206163746976653A206366672E746C64436865636B202626206366672E746C645061747465726E2E6C656E677468203E20302C0D0A20202020202020206D6573736167653A207478742822446F6D61696E2D456E64';
wwv_flow_imp.g_varchar2_table(150) := '756E672069737420756E67C3BC6C746967222C2022546F702D6C6576656C20646F6D61696E20697320696E76616C696422292C0D0A2020202020202020746573743A2066756E6374696F6E20287629207B0D0A2020202020202020202076617220746C64';
wwv_flow_imp.g_varchar2_table(151) := '203D2073706C6974456D61696C2876292E746C643B0D0A2020202020202020202069662028746C642E6C656E677468203D3D3D203029207B2072657475726E20747275653B207D0D0A2020202020202020202072657475726E2073616665526567657854';
wwv_flow_imp.g_varchar2_table(152) := '657374286366672E746C645061747465726E2C20746C64293B0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020207B0D0A20202020202020206163746976653A206366672E6C6F63616C436865636B202626206366672E6C6F63616C';
wwv_flow_imp.g_varchar2_table(153) := '5061747465726E2E6C656E677468203E20302C0D0A20202020202020206D6573736167653A2074787428225465696C20766F722064656D204020656E7468C3A46C7420756E7A756CC3A47373696765205A65696368656E222C0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(154) := '2020202020202020202020202250617274206265666F7265204020636F6E7461696E7320696E76616C6964206368617261637465727322292C0D0A2020202020202020746573743A2066756E6374696F6E20287629207B0D0A2020202020202020202076';
wwv_flow_imp.g_varchar2_table(155) := '6172206C6F63616C203D2073706C6974456D61696C2876292E6C6F63616C3B0D0A20202020202020202020696620286C6F63616C2E6C656E677468203D3D3D203029207B2072657475726E20747275653B207D0D0A202020202020202020207265747572';
wwv_flow_imp.g_varchar2_table(156) := '6E2073616665526567657854657374286366672E6C6F63616C5061747465726E2C206C6F63616C293B0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020207B0D0A20202020202020206163746976653A206366672E646F6D61696E43';
wwv_flow_imp.g_varchar2_table(157) := '6865636B202626206366672E646F6D61696E5061747465726E2E6C656E677468203E20302C0D0A20202020202020206D6573736167653A207478742822446F6D61696E20656E7468C3A46C7420756E7A756CC3A47373696765205A65696368656E222C0D';
wwv_flow_imp.g_varchar2_table(158) := '0A20202020202020202020202020202020202020202022446F6D61696E20636F6E7461696E7320696E76616C6964206368617261637465727322292C0D0A2020202020202020746573743A2066756E6374696F6E20287629207B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(159) := '202076617220646F6D61696E203D2073706C6974456D61696C2876292E646F6D61696E3B0D0A2020202020202020202069662028646F6D61696E2E6C656E677468203D3D3D203029207B2072657475726E20747275653B207D0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(160) := '2072657475726E2073616665526567657854657374286366672E646F6D61696E5061747465726E2C20646F6D61696E293B0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020207B0D0A20202020202020206163746976653A20636667';
wwv_flow_imp.g_varchar2_table(161) := '2E6D696E436865636B202626202169734E614E286366672E6D696E4C656E677468292C0D0A20202020202020206D6573736167653A2074787428224D696E64657374656E732022202B206366672E6D696E4C656E677468202B2022205A65696368656E20';
wwv_flow_imp.g_varchar2_table(162) := '6572666F726465726C696368222C0D0A202020202020202020202020202020202020202020224174206C656173742022202B206366672E6D696E4C656E677468202B2022206368617261637465727320726571756972656422292C0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(163) := '20746573743A2066756E6374696F6E20287629207B0D0A2020202020202020202072657475726E20762E7472696D28292E6C656E677468203D3D3D2030207C7C20762E7472696D28292E6C656E677468203E3D206366672E6D696E4C656E6774683B0D0A';
wwv_flow_imp.g_varchar2_table(164) := '20202020202020207D0D0A2020202020207D2C0D0A2020202020207B0D0A20202020202020206163746976653A206366672E6D6178436865636B202626202169734E614E286366672E6D61784C656E677468292C0D0A20202020202020206D6573736167';
wwv_flow_imp.g_varchar2_table(165) := '653A20747874282248C3B663687374656E732022202B206366672E6D61784C656E677468202B2022205A65696368656E2065726C61756274222C0D0A202020202020202020202020202020202020202020224E6F206D6F7265207468616E2022202B2063';
wwv_flow_imp.g_varchar2_table(166) := '66672E6D61784C656E677468202B2022206368617261637465727320616C6C6F77656422292C0D0A2020202020202020746573743A2066756E6374696F6E20287629207B2072657475726E20762E7472696D28292E6C656E677468203C3D206366672E6D';
wwv_flow_imp.g_varchar2_table(167) := '61784C656E6774683B207D0D0A2020202020207D2C0D0A2020202020207B0D0A20202020202020206163746976653A206366672E7265737472696374576C6973742C0D0A20202020202020206D6573736167653A207478742822446F6D61696E20697374';
wwv_flow_imp.g_varchar2_table(168) := '206E6963687420617566206465722065726C61756274656E204C69737465222C0D0A20202020202020202020202020202020202020202022446F6D61696E206973206E6F74206F6E2074686520616C6C6F776564206C69737422292C0D0A202020202020';
wwv_flow_imp.g_varchar2_table(169) := '2020746573743A2066756E6374696F6E20287629207B0D0A2020202020202020202076617220646F6D61696E203D2073706C6974456D61696C2876292E646F6D61696E2E746F4C6F7765724361736528293B0D0A2020202020202020202069662028646F';
wwv_flow_imp.g_varchar2_table(170) := '6D61696E2E6C656E677468203D3D3D203029207B2072657475726E20747275653B207D0D0A2020202020202020202072657475726E2077686974656C697374446F6D61696E732E6C656E677468203D3D3D2030207C7C2077686974656C697374446F6D61';
wwv_flow_imp.g_varchar2_table(171) := '696E732E696E6465784F6628646F6D61696E2920213D3D202D313B0D0A20202020202020207D0D0A2020202020207D2C0D0A2020202020207B0D0A20202020202020206163746976653A206366672E626C6F636B446973706F7361626C652C0D0A202020';
wwv_flow_imp.g_varchar2_table(172) := '20202020206D6573736167653A207478742822576567776572662D452D4D61696C2D416E6269657465722073696E64206E696368742065726C61756274222C0D0A20202020202020202020202020202020202020202022446973706F7361626C6520656D';
wwv_flow_imp.g_varchar2_table(173) := '61696C2070726F76696465727320617265206E6F7420616C6C6F77656422292C0D0A2020202020202020746573743A2066756E6374696F6E20287629207B0D0A2020202020202020202076617220646F6D61696E203D2073706C6974456D61696C287629';
wwv_flow_imp.g_varchar2_table(174) := '2E646F6D61696E2E746F4C6F7765724361736528293B0D0A2020202020202020202069662028646F6D61696E2E6C656E677468203D3D3D203029207B2072657475726E20747275653B207D0D0A2020202020202020202072657475726E20646973706F73';
wwv_flow_imp.g_varchar2_table(175) := '61626C65446F6D61696E732E696E6465784F6628646F6D61696E29203D3D3D202D313B0D0A20202020202020207D0D0A2020202020207D0D0A202020205D3B0D0A0D0A202020207661722061637469766552756C6573203D2072756C65732E66696C7465';
wwv_flow_imp.g_varchar2_table(176) := '722866756E6374696F6E20287229207B2072657475726E20722E6163746976653B207D293B0D0A0D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(177) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A202020202F2F204E6F74696365732028626C756520696E666F20726F7773292C206275696C74206F6E63650D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(178) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A2020202066756E6374696F6E206275696C644E6F74696365732829207B0D0A202020202020766172206E6F7469636573203D205B5D3B0D0A0D0A202020202020';
wwv_flow_imp.g_varchar2_table(179) := '696620286366672E6175746F4C6F7765726361736529207B0D0A20202020202020206E6F74696365732E707573682874787428224175746F6D61746973636865204B6C65696E73636872656962756E672069737420616B746976222C0D0A202020202020';
wwv_flow_imp.g_varchar2_table(180) := '20202020202020202020202020202020202020224175746F6D61746963206C6F77657263617365206973206163746976652229293B0D0A2020202020207D0D0A0D0A202020202020696620286366672E6D6178436865636B202626202169734E614E2863';
wwv_flow_imp.g_varchar2_table(181) := '66672E6D61784C656E6774682929207B0D0A20202020202020206E6F74696365732E707573682874787428224D6178696D616C2022202B206366672E6D61784C656E677468202B2022205A65696368656E222C0D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(182) := '20202020202020202020224D6178696D756D2022202B206366672E6D61784C656E677468202B202220636861726163746572732229293B0D0A2020202020207D0D0A0D0A202020202020696620286366672E7265737472696374576C6973742026262077';
wwv_flow_imp.g_varchar2_table(183) := '686974656C697374446F6D61696E732E6C656E677468203E203029207B0D0A20202020202020207661722073686F776E203D2077686974656C697374446F6D61696E732E736C69636528302C2033292E6A6F696E28222C2022293B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(184) := '20766172207265737420203D2077686974656C697374446F6D61696E732E6C656E677468202D20333B0D0A2020202020202020766172206C69737454657874203D2072657374203E20300D0A202020202020202020203F2073686F776E202B2074787428';
wwv_flow_imp.g_varchar2_table(185) := '2220756E642022202B2072657374202B20222077656974657265222C202220616E642022202B2072657374202B2022206D6F726522290D0A202020202020202020203A2073686F776E3B0D0A20202020202020206E6F74696365732E7075736828747874';
wwv_flow_imp.g_varchar2_table(186) := '282245726C617562746520446F6D61696E733A20222C2022416C6C6F77656420646F6D61696E733A202229202B206C69737454657874293B0D0A2020202020207D0D0A0D0A2020202020206E6F746963654C6973742E696E6E657248544D4C203D202222';
wwv_flow_imp.g_varchar2_table(187) := '3B0D0A2020202020206E6F74696365732E666F72456163682866756E6374696F6E20286E29207B0D0A202020202020202076617220726F77203D20646F63756D656E742E637265617465456C656D656E7428227370616E22293B0D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(188) := '726F772E636C6173734E616D65203D202273682D656D6C2D6E6F74696365223B0D0A20202020202020207661722069636F6E203D20646F63756D656E742E637265617465456C656D656E7428226922293B0D0A202020202020202069636F6E2E636C6173';
wwv_flow_imp.g_varchar2_table(189) := '734E616D65203D202273682D656D6C2D6E6F746963652D69636F6E223B0D0A20202020202020207661722074657874203D20646F63756D656E742E637265617465456C656D656E7428227370616E22293B0D0A2020202020202020746578742E74657874';
wwv_flow_imp.g_varchar2_table(190) := '436F6E74656E74203D206E3B0D0A2020202020202020726F772E617070656E644368696C642869636F6E293B0D0A2020202020202020726F772E617070656E644368696C642874657874293B0D0A20202020202020206E6F746963654C6973742E617070';
wwv_flow_imp.g_varchar2_table(191) := '656E644368696C6428726F77293B0D0A2020202020207D293B0D0A0D0A2020202020206E6F746963654C6973742E636C6173734C6973742E746F67676C65282273682D656D6C2D6861732D6E6F7469636573222C206E6F74696365732E6C656E67746820';
wwv_flow_imp.g_varchar2_table(192) := '3E2030293B0D0A202020207D0D0A0D0A202020206275696C644E6F746963657328293B0D0A0D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(193) := '2D2D2D2D2D2D2D2D2D2D2D2D0D0A202020202F2F2052656E646572696E673A206661696C65642072756C6573206F6E6C793B20677265656E206C696E65207768656E20616C6C20706173730D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(194) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A2020202066756E6374696F6E2072656E6465724C697374287056616C756529207B0D0A20202020202076617220666169';
wwv_flow_imp.g_varchar2_table(195) := '6C6564203D2061637469766552756C65732E66696C7465722866756E6374696F6E20287229207B2072657475726E2021722E74657374287056616C7565293B207D293B0D0A0D0A20202020202072756C654C6973742E696E6E657248544D4C203D202222';
wwv_flow_imp.g_varchar2_table(196) := '3B0D0A0D0A202020202020696620287056616C75652E7472696D28292E6C656E677468203D3D3D203020262620216366672E7265717569726529207B0D0A2020202020202020766172206E65757472616C203D20646F63756D656E742E63726561746545';
wwv_flow_imp.g_varchar2_table(197) := '6C656D656E7428227370616E22293B0D0A20202020202020206E65757472616C2E636C6173734E616D65203D202273682D656D6C2D6E65757472616C223B0D0A20202020202020206E65757472616C2E74657874436F6E74656E74203D20747874282254';
wwv_flow_imp.g_varchar2_table(198) := '697070656E207A756D2056616C6964696572656E222C2022537461727420747970696E6720746F2076616C696461746522293B0D0A202020202020202072756C654C6973742E617070656E644368696C64286E65757472616C293B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(199) := '2072657475726E206661696C65643B0D0A2020202020207D0D0A0D0A202020202020696620286661696C65642E6C656E677468203D3D3D203029207B0D0A2020202020202020766172206F6B203D20646F63756D656E742E637265617465456C656D656E';
wwv_flow_imp.g_varchar2_table(200) := '7428227370616E22293B0D0A20202020202020206F6B2E636C6173734E616D65203D202273682D656D6C2D73756363657373223B0D0A20202020202020206F6B2E696E6E657248544D4C203D20273C6920636C6173733D2273682D656D6C2D7375636365';
wwv_flow_imp.g_varchar2_table(201) := '73732D69636F6E223E3C2F693E3C7370616E3E270D0A202020202020202020202B207478742822416C6C652056616C6964696572756E67656E2062657374616E64656E222C2022416C6C2076616C69646174696F6E732070617373656422290D0A202020';
wwv_flow_imp.g_varchar2_table(202) := '202020202020202B20273C2F7370616E3E273B0D0A202020202020202072756C654C6973742E617070656E644368696C64286F6B293B0D0A202020202020202072657475726E206661696C65643B0D0A2020202020207D0D0A0D0A202020202020666169';
wwv_flow_imp.g_varchar2_table(203) := '6C65642E666F72456163682866756E6374696F6E20287229207B0D0A202020202020202076617220726F77203D20646F63756D656E742E637265617465456C656D656E7428227370616E22293B0D0A2020202020202020726F772E636C6173734E616D65';
wwv_flow_imp.g_varchar2_table(204) := '203D202273682D656D6C2D6572726F72223B0D0A20202020202020207661722069636F6E203D20646F63756D656E742E637265617465456C656D656E7428226922293B0D0A202020202020202069636F6E2E636C6173734E616D65203D202273682D656D';
wwv_flow_imp.g_varchar2_table(205) := '6C2D6572726F722D69636F6E223B0D0A20202020202020207661722074657874203D20646F63756D656E742E637265617465456C656D656E7428227370616E22293B0D0A2020202020202020746578742E74657874436F6E74656E74203D20722E6D6573';
wwv_flow_imp.g_varchar2_table(206) := '736167653B0D0A2020202020202020726F772E617070656E644368696C642869636F6E293B0D0A2020202020202020726F772E617070656E644368696C642874657874293B0D0A202020202020202072756C654C6973742E617070656E644368696C6428';
wwv_flow_imp.g_varchar2_table(207) := '726F77293B0D0A2020202020207D293B0D0A0D0A20202020202072657475726E206661696C65643B0D0A202020207D0D0A0D0A2020202066756E6374696F6E20757064617465416C6C2829207B0D0A202020202020766172206661696C6564203D207265';
wwv_flow_imp.g_varchar2_table(208) := '6E6465724C69737428696E7075742E76616C7565293B0D0A20202020202076617220696E76616C6964203D206661696C65642E6C656E677468203E20300D0A20202020202020202626202128696E7075742E76616C75652E7472696D28292E6C656E6774';
wwv_flow_imp.g_varchar2_table(209) := '68203D3D3D203020262620216366672E72657175697265293B0D0A202020202020696E7075742E636C6173734C6973742E746F67676C65282273682D656D6C2D696E76616C6964222C20696E76616C6964293B0D0A0D0A20202020202069662028636F6E';
wwv_flow_imp.g_varchar2_table(210) := '74726F6C6C6564427574746F6E29207B0D0A20202020202020202F2F2041206669656C6420746861742069736E27742063757272656E746C792076697369626C652028652E672E2073697474696E6720696E736964650D0A20202020202020202F2F2061';
wwv_flow_imp.g_varchar2_table(211) := '6E20756E6F70656E656420696E6C696E65206469616C6F6729206D757374206E6576657220626C6F636B206120627574746F6E207468650D0A20202020202020202F2F20757365722063616E2774206576656E2073656520746865206669656C6420666F';
wwv_flow_imp.g_varchar2_table(212) := '722E0D0A2020202020202020766172206973426C6F636B6564203D206973496E70757456697369626C652829202626206661696C65642E6C656E677468203E20303B0D0A0D0A20202020202020202F2F204E6F74207573696E6720746865202264697361';
wwv_flow_imp.g_varchar2_table(213) := '626C6564222070726F70657274793A2062726F7773657273207375707072657373206D6F7573650D0A20202020202020202F2F206576656E74732028616E64207468657265666F726520746F6F6C7469707329206F6E2064697361626C656420656C656D';
wwv_flow_imp.g_varchar2_table(214) := '656E74732E0D0A2020202020202020636F6E74726F6C6C6564427574746F6E2E636C6173734C6973742E746F67676C65282273682D656D6C2D62746E2D626C6F636B6564222C206973426C6F636B6564293B0D0A2020202020202020636F6E74726F6C6C';
wwv_flow_imp.g_varchar2_table(215) := '6564427574746F6E2E7365744174747269627574652822617269612D64697361626C6564222C206973426C6F636B6564203F20227472756522203A202266616C736522293B0D0A0D0A20202020202020207661722068696E7454657874203D2074787428';
wwv_flow_imp.g_varchar2_table(216) := '224269747465207A75657273742065696E652067C3BC6C7469676520452D4D61696C2D416472657373652065696E676562656E222C0D0A20202020202020202020202020202020202020202020202020202022506C6561736520656E7465722061207661';
wwv_flow_imp.g_varchar2_table(217) := '6C696420656D61696C206164647265737320666972737422293B0D0A0D0A20202020202020202F2F205265676973746572732F756E726567697374657273207468697320696E7374616E63652773206D657373616765206F6E2074686520736861726564';
wwv_flow_imp.g_varchar2_table(218) := '0D0A20202020202020202F2F20627574746F6E207469746C6520726567697374727920696E7374656164206F66206F76657277726974696E672074686520627574746F6E27730D0A20202020202020202F2F207469746C65206174747269627574652064';
wwv_flow_imp.g_varchar2_table(219) := '69726563746C79202873656520746F70206F662066696C65292E0D0A202020202020202077696E646F772E7368526567697374657242746E426C6F636B6572286366672E627574746F6E49642C2070456C656D656E7449642C206973426C6F636B656420';
wwv_flow_imp.g_varchar2_table(220) := '3F2068696E7454657874203A206E756C6C293B0D0A0D0A202020202020202069662028627574746F6E48696E7429207B0D0A20202020202020202020627574746F6E48696E742E6C617374456C656D656E744368696C642E74657874436F6E74656E7420';
wwv_flow_imp.g_varchar2_table(221) := '3D2068696E74546578743B0D0A202020202020202020202F2F204869646520696D6D6564696174656C79207768656E2074686520627574746F6E206265636F6D657320757361626C652C206576656E2069660D0A202020202020202020202F2F20746865';
wwv_flow_imp.g_varchar2_table(222) := '20637572736F72206973207374696C6C20686F766572696E67206F7665722069742E0D0A2020202020202020202069662028216973426C6F636B656429207B0D0A202020202020202020202020627574746F6E48696E742E636C6173734C6973742E7265';
wwv_flow_imp.g_varchar2_table(223) := '6D6F7665282273682D656D6C2D62746E2D68696E742D76697369626C6522293B0D0A202020202020202020207D0D0A20202020202020207D0D0A2020202020207D0D0A202020207D0D0A0D0A2020202066756E6374696F6E20706F736974696F6E506F70';
wwv_flow_imp.g_varchar2_table(224) := '6F7665722829207B0D0A2020202020207661722072656374203D20696E7075742E676574426F756E64696E67436C69656E745265637428293B0D0A202020202020706F706F7665722E7374796C652E746F702020203D2028726563742E626F74746F6D20';
wwv_flow_imp.g_varchar2_table(225) := '2B203629202B20227078223B0D0A202020202020706F706F7665722E7374796C652E6C65667420203D20726563742E6C656674202B20227078223B0D0A202020202020706F706F7665722E7374796C652E7769647468203D20726563742E776964746820';
wwv_flow_imp.g_varchar2_table(226) := '2B20227078223B0D0A202020207D0D0A0D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A202020202F2F20';
wwv_flow_imp.g_varchar2_table(227) := '4175746F2D6C6F77657263617365207472616E73666F726D6174696F6E0D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(228) := '2D2D2D2D0D0A20202020696620286366672E6175746F4C6F7765726361736529207B0D0A202020202020696E7075742E6164644576656E744C697374656E65722822696E707574222C2066756E6374696F6E202829207B0D0A2020202020202020766172';
wwv_flow_imp.g_varchar2_table(229) := '207374617274203D20696E7075742E73656C656374696F6E53746172743B0D0A202020202020202076617220656E642020203D20696E7075742E73656C656374696F6E456E643B0D0A2020202020202020766172206C6F776572203D20696E7075742E76';
wwv_flow_imp.g_varchar2_table(230) := '616C75652E746F4C6F7765724361736528293B0D0A0D0A2020202020202020696620286C6F77657220213D3D20696E7075742E76616C756529207B0D0A20202020202020202020696E7075742E76616C7565203D206C6F7765723B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(231) := '202020747279207B0D0A202020202020202020202020696E7075742E73657453656C656374696F6E52616E67652873746172742C20656E64293B0D0A202020202020202020207D20636174636820286529207B0D0A2020202020202020202020202F2F20';
wwv_flow_imp.g_varchar2_table(232) := '736F6D652062726F777365727320646F6E277420737570706F72742074686973206F6E20747970653D22656D61696C22202D206E6F7420637269746963616C0D0A202020202020202020207D0D0A20202020202020207D0D0A2020202020207D293B0D0A';
wwv_flow_imp.g_varchar2_table(233) := '202020207D0D0A0D0A202020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A202020202F2F204576656E74730D0A20';
wwv_flow_imp.g_varchar2_table(234) := '2020202F2F202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202020696E7075742E6164644576656E744C697374656E6572';
wwv_flow_imp.g_varchar2_table(235) := '2822666F637573222C2066756E6374696F6E202829207B0D0A202020202020706F736974696F6E506F706F76657228293B0D0A202020202020706F706F7665722E636C6173734C6973742E616464282273682D656D6C2D706F706F7665722D6F70656E22';
wwv_flow_imp.g_varchar2_table(236) := '293B0D0A202020202020757064617465416C6C28293B0D0A202020207D293B0D0A0D0A20202020696E7075742E6164644576656E744C697374656E65722822696E707574222C2066756E6374696F6E202829207B0D0A202020202020757064617465416C';
wwv_flow_imp.g_varchar2_table(237) := '6C28293B0D0A20202020202069662028706F706F7665722E636C6173734C6973742E636F6E7461696E73282273682D656D6C2D706F706F7665722D6F70656E222929207B0D0A2020202020202020706F736974696F6E506F706F76657228293B0D0A2020';
wwv_flow_imp.g_varchar2_table(238) := '202020207D0D0A202020207D293B0D0A0D0A20202020696E7075742E6164644576656E744C697374656E65722822626C7572222C2066756E6374696F6E202829207B0D0A20202020202073657454696D656F75742866756E6374696F6E202829207B0D0A';
wwv_flow_imp.g_varchar2_table(239) := '2020202020202020706F706F7665722E636C6173734C6973742E72656D6F7665282273682D656D6C2D706F706F7665722D6F70656E22293B0D0A2020202020207D2C20313530293B0D0A202020202020757064617465416C6C28293B0D0A202020207D29';
wwv_flow_imp.g_varchar2_table(240) := '3B0D0A0D0A2020202077696E646F772E6164644576656E744C697374656E657228227363726F6C6C222C2066756E6374696F6E202829207B0D0A20202020202069662028706F706F7665722E636C6173734C6973742E636F6E7461696E73282273682D65';
wwv_flow_imp.g_varchar2_table(241) := '6D6C2D706F706F7665722D6F70656E222929207B0D0A2020202020202020706F736974696F6E506F706F76657228293B0D0A2020202020207D0D0A202020207D2C2074727565293B0D0A0D0A2020202077696E646F772E6164644576656E744C69737465';
wwv_flow_imp.g_varchar2_table(242) := '6E65722822726573697A65222C2066756E6374696F6E202829207B0D0A20202020202069662028706F706F7665722E636C6173734C6973742E636F6E7461696E73282273682D656D6C2D706F706F7665722D6F70656E222929207B0D0A20202020202020';
wwv_flow_imp.g_varchar2_table(243) := '20706F736974696F6E506F706F76657228293B0D0A2020202020207D0D0A202020207D293B0D0A0D0A202020202F2F2052652D72756E2076616C69646174696F6E20746865206D6F6D656E74207468697320696E707574206265636F6D65732076697369';
wwv_flow_imp.g_varchar2_table(244) := '626C652F68696464656E0D0A202020202F2F20616761696E2028652E672E20616E20696E6C696E65206469616C6F67206265696E67206F70656E6564206F7220636C6F736564292E20576974686F75740D0A202020202F2F20746869732C206120666965';
wwv_flow_imp.g_varchar2_table(245) := '6C6420746861742069732068696464656E20617420706167652D6C6F61642074696D6520776F756C64207374617920737475636B0D0A202020202F2F20696E20776861746576657220626C6F636B65642F756E626C6F636B656420737461746520697420';
wwv_flow_imp.g_varchar2_table(246) := '686164206F6E2066697273742072656E6465722C0D0A202020202F2F206576656E20616674657220746865206469616C6F67206C617465722072657665616C732069742E0D0A2020202069662028636F6E74726F6C6C6564427574746F6E202626207769';
wwv_flow_imp.g_varchar2_table(247) := '6E646F772E496E74657273656374696F6E4F6273657276657229207B0D0A202020202020766172207368456D6C5669734F62736572766572203D206E657720496E74657273656374696F6E4F627365727665722866756E6374696F6E202829207B0D0A20';
wwv_flow_imp.g_varchar2_table(248) := '20202020202020757064617465416C6C28293B0D0A2020202020207D293B0D0A2020202020207368456D6C5669734F627365727665722E6F62736572766528696E707574293B0D0A202020207D0D0A0D0A20202020757064617465416C6C28293B0D0A20';
wwv_flow_imp.g_varchar2_table(249) := '207D0D0A0D0A7D3B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(223796676993830858)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_file_name=>'email_validator.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E73682D656D6C2D777261707065727B706F736974696F6E3A72656C61746976653B646973706C61793A696E6C696E652D626C6F636B7D2E742D466F726D2D6669656C64436F6E7461696E65722D2D73747265746368496E70757473202E73682D656D6C';
wwv_flow_imp.g_varchar2_table(2) := '2D777261707065727B646973706C61793A626C6F636B3B77696474683A313030257D2E742D466F726D2D6669656C64436F6E7461696E65722D2D73747265746368496E70757473202E73682D656D6C2D77726170706572202E73682D656D6C2D696E7075';
wwv_flow_imp.g_varchar2_table(3) := '747B77696474683A313030257D2E73682D656D6C2D696E7075742E73682D656D6C2D696E76616C69647B626F726465722D636F6C6F723A2363343336333621696D706F7274616E743B626F782D736861646F773A30203020302031707820236334333633';
wwv_flow_imp.g_varchar2_table(4) := '3621696D706F7274616E747D2E73682D656D6C2D706F706F7665727B646973706C61793A6E6F6E653B706F736974696F6E3A66697865643B6261636B67726F756E643A236666663B626F726465723A31707820736F6C6964207267626128302C302C302C';
wwv_flow_imp.g_varchar2_table(5) := '2E3132293B626F726465722D7261646975733A3870783B626F782D736861646F773A30203870782032347078207267626128302C302C302C2E3132292C302032707820367078207267626128302C302C302C2E3038293B70616464696E673A3132707820';
wwv_flow_imp.g_varchar2_table(6) := '313470783B7A2D696E6465783A39393939397D2E73682D656D6C2D706F706F7665722E73682D656D6C2D706F706F7665722D6F70656E7B646973706C61793A626C6F636B7D2E73682D656D6C2D706F706F7665722D7469746C657B646973706C61793A62';
wwv_flow_imp.g_varchar2_table(7) := '6C6F636B3B666F6E742D73697A653A313270783B636F6C6F723A233838383738303B6D617267696E2D626F74746F6D3A3870787D2E73682D656D6C2D72756C652D6C6973747B646973706C61793A666C65783B666C65782D646972656374696F6E3A636F';
wwv_flow_imp.g_varchar2_table(8) := '6C756D6E3B6761703A3670787D2E73682D656D6C2D6572726F727B646973706C61793A666C65783B616C69676E2D6974656D733A63656E7465723B6761703A3870783B666F6E742D73697A653A313370783B636F6C6F723A236133326432647D2E73682D';
wwv_flow_imp.g_varchar2_table(9) := '656D6C2D6572726F722D69636F6E7B646973706C61793A696E6C696E652D626C6F636B3B77696474683A313670783B6865696768743A313670783B626F726465722D7261646975733A3530253B6261636B67726F756E643A236334333633363B666C6578';
wwv_flow_imp.g_varchar2_table(10) := '2D736872696E6B3A303B706F736974696F6E3A72656C61746976657D2E73682D656D6C2D6572726F722D69636F6E3A3A61667465722C2E73682D656D6C2D6572726F722D69636F6E3A3A6265666F72657B636F6E74656E743A22223B706F736974696F6E';
wwv_flow_imp.g_varchar2_table(11) := '3A6162736F6C7574653B6C6566743A3770783B746F703A3470783B77696474683A3270783B6865696768743A3870783B6261636B67726F756E643A236666663B626F726465722D7261646975733A3170787D2E73682D656D6C2D6572726F722D69636F6E';
wwv_flow_imp.g_varchar2_table(12) := '3A3A6265666F72657B7472616E73666F726D3A726F74617465283435646567297D2E73682D656D6C2D6572726F722D69636F6E3A3A61667465727B7472616E73666F726D3A726F74617465282D3435646567297D2E73682D656D6C2D737563636573737B';
wwv_flow_imp.g_varchar2_table(13) := '646973706C61793A666C65783B616C69676E2D6974656D733A63656E7465723B6761703A3870783B666F6E742D73697A653A313370783B636F6C6F723A233362366431317D2E73682D656D6C2D737563636573732D69636F6E7B646973706C61793A696E';
wwv_flow_imp.g_varchar2_table(14) := '6C696E652D626C6F636B3B77696474683A313670783B6865696768743A313670783B626F726465722D7261646975733A3530253B6261636B67726F756E643A233633393932323B666C65782D736872696E6B3A303B706F736974696F6E3A72656C617469';
wwv_flow_imp.g_varchar2_table(15) := '76657D2E73682D656D6C2D737563636573732D69636F6E3A3A61667465727B636F6E74656E743A22223B706F736974696F6E3A6162736F6C7574653B6C6566743A3570783B746F703A3270783B77696474683A3470783B6865696768743A3870783B626F';
wwv_flow_imp.g_varchar2_table(16) := '726465723A736F6C696420236666663B626F726465722D77696474683A30203270782032707820303B7472616E73666F726D3A726F74617465283435646567297D2E73682D656D6C2D6E65757472616C7B646973706C61793A666C65783B616C69676E2D';
wwv_flow_imp.g_varchar2_table(17) := '6974656D733A63656E7465723B6761703A3870783B666F6E742D73697A653A313370783B636F6C6F723A233838383738307D2E73682D656D6C2D6E6F746963652D6C6973747B646973706C61793A6E6F6E653B666C65782D646972656374696F6E3A636F';
wwv_flow_imp.g_varchar2_table(18) := '6C756D6E3B6761703A3670783B6D617267696E2D746F703A3870783B70616464696E672D746F703A3870783B626F726465722D746F703A31707820736F6C6964207267626128302C302C302C2E3038297D2E73682D656D6C2D62746E2D68696E742E7368';
wwv_flow_imp.g_varchar2_table(19) := '2D656D6C2D62746E2D68696E742D76697369626C652C2E73682D656D6C2D6E6F746963652D6C6973742E73682D656D6C2D6861732D6E6F74696365737B646973706C61793A666C65787D2E73682D656D6C2D6E6F746963657B646973706C61793A666C65';
wwv_flow_imp.g_varchar2_table(20) := '783B616C69676E2D6974656D733A63656E7465723B6761703A3870783B666F6E742D73697A653A313370783B636F6C6F723A233063343437637D2E73682D656D6C2D6E6F746963652D69636F6E7B646973706C61793A696E6C696E652D626C6F636B3B77';
wwv_flow_imp.g_varchar2_table(21) := '696474683A313670783B6865696768743A313670783B626F726465722D7261646975733A3530253B6261636B67726F756E643A233138356661353B666C65782D736872696E6B3A303B706F736974696F6E3A72656C61746976657D2E73682D656D6C2D6E';
wwv_flow_imp.g_varchar2_table(22) := '6F746963652D69636F6E3A3A61667465727B636F6E74656E743A2269223B706F736974696F6E3A6162736F6C7574653B6C6566743A303B746F703A303B77696474683A313030253B6865696768743A313030253B646973706C61793A666C65783B616C69';
wwv_flow_imp.g_varchar2_table(23) := '676E2D6974656D733A63656E7465723B6A7573746966792D636F6E74656E743A63656E7465723B636F6C6F723A236666663B666F6E742D73697A653A313170783B666F6E742D7765696768743A3730303B666F6E742D7374796C653A6E6F726D616C3B66';
wwv_flow_imp.g_varchar2_table(24) := '6F6E742D66616D696C793A47656F726769612C73657269667D2E73682D656D6C2D62746E2D626C6F636B65647B6F7061636974793A2E353B637572736F723A6E6F742D616C6C6F7765647D2E73682D656D6C2D62746E2D68696E747B646973706C61793A';
wwv_flow_imp.g_varchar2_table(25) := '6E6F6E653B706F736974696F6E3A66697865643B7A2D696E6465783A39393939393B616C69676E2D6974656D733A63656E7465723B6761703A3870783B70616464696E673A38707820313270783B626F782D73697A696E673A626F726465722D626F783B';
wwv_flow_imp.g_varchar2_table(26) := '666F6E742D73697A653A313370783B666F6E742D7765696768743A3530303B6C696E652D6865696768743A312E343B636F6C6F723A233863323032303B6261636B67726F756E643A236664656165613B626F726465723A31707820736F6C696420236632';
wwv_flow_imp.g_varchar2_table(27) := '633463343B626F726465722D6C6566743A33707820736F6C696420236334333633363B626F726465722D7261646975733A3670783B626F782D736861646F773A30203470782031327078207267626128302C302C302C2E3135297D2E73682D656D6C2D62';
wwv_flow_imp.g_varchar2_table(28) := '746E2D68696E742D69636F6E7B646973706C61793A696E6C696E652D626C6F636B3B77696474683A313470783B6865696768743A313470783B626F726465722D7261646975733A3530253B6261636B67726F756E643A236334333633363B666C65782D73';
wwv_flow_imp.g_varchar2_table(29) := '6872696E6B3A303B706F736974696F6E3A72656C61746976657D2E73682D656D6C2D62746E2D68696E742D69636F6E3A3A61667465722C2E73682D656D6C2D62746E2D68696E742D69636F6E3A3A6265666F72657B636F6E74656E743A22223B706F7369';
wwv_flow_imp.g_varchar2_table(30) := '74696F6E3A6162736F6C7574653B6C6566743A3670783B746F703A3370783B77696474683A3270783B6865696768743A3570783B6261636B67726F756E643A236666663B626F726465722D7261646975733A3170787D2E73682D656D6C2D62746E2D6869';
wwv_flow_imp.g_varchar2_table(31) := '6E742D69636F6E3A3A61667465727B746F703A313070783B6865696768743A3270783B626F726465722D7261646975733A3530257D2E73682D656D6C2D77726170706572202E617065782D6974656D2D69636F6E7B706F736974696F6E3A6162736F6C75';
wwv_flow_imp.g_varchar2_table(32) := '746521696D706F7274616E743B6C6566743A3021696D706F7274616E743B746F703A35302521696D706F7274616E743B626F74746F6D3A6175746F21696D706F7274616E743B72696768743A6175746F21696D706F7274616E743B7472616E73666F726D';
wwv_flow_imp.g_varchar2_table(33) := '3A7472616E736C61746559282D3530252921696D706F7274616E743B6D617267696E3A3021696D706F7274616E743B706F696E7465722D6576656E74733A6E6F6E653B7A2D696E6465783A323B6C696E652D6865696768743A317D2E73682D656D6C2D77';
wwv_flow_imp.g_varchar2_table(34) := '7261707065727B6C696E652D6865696768743A307D2E73682D656D6C2D77726170706572202E73682D656D6C2D696E7075747B6C696E652D6865696768743A6E6F726D616C7D2E617065782D6974656D2D69636F6E2D636F6E7461696E65722E69732D66';
wwv_flow_imp.g_varchar2_table(35) := '6F6375736564202E617065782D6974656D2D69636F6E2C2E742D466F726D2D696E707574436F6E7461696E65722E69732D666F6375736564202E617065782D6974656D2D69636F6E7B6261636B67726F756E642D636F6C6F723A696E686572697421696D';
wwv_flow_imp.g_varchar2_table(36) := '706F7274616E743B636F6C6F723A696E686572697421696D706F7274616E743B66696C7465723A6E6F6E6521696D706F7274616E747D2E73682D656D6C2D77726170706572202E617065782D6974656D2D69636F6E7B6865696768743A3130302521696D';
wwv_flow_imp.g_varchar2_table(37) := '706F7274616E747D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(224586012277325961)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_file_name=>'email_validator.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '77696E646F772E7368526567697374657242746E426C6F636B65727C7C2877696E646F772E736842746E52656769737472793D7B7D2C77696E646F772E7368526567697374657242746E426C6F636B65723D66756E6374696F6E28652C742C6E297B6966';
wwv_flow_imp.g_varchar2_table(2) := '2865297B76617220613D77696E646F772E736842746E52656769737472793B615B655D3D615B655D7C7C7B7D2C6E3F615B655D5B745D3D6E3A64656C65746520615B655D5B745D3B76617220693D646F63756D656E742E676574456C656D656E74427949';
wwv_flow_imp.g_varchar2_table(3) := '642865293B69662869297B76617220733D4F626A6563742E6B65797328615B655D292E6D6170282866756E6374696F6E2874297B72657475726E20615B655D5B745D7D29293B732E6C656E6774683E303F692E7365744174747269627574652822746974';
wwv_flow_imp.g_varchar2_table(4) := '6C65222C732E6A6F696E282220C2B7202229293A692E72656D6F766541747472696275746528227469746C6522297D7D7D293B766172207368456D61696C56616C696461746F723D7B696E69743A66756E6374696F6E2865297B76617220743D646F6375';
wwv_flow_imp.g_varchar2_table(5) := '6D656E742E676574456C656D656E744279496428652B225F53485F454D41494C22293B69662874297B766172206E3D646F63756D656E742E676574456C656D656E74427949642865292C613D742E717565727953656C6563746F7228222E73682D656D6C';
wwv_flow_imp.g_varchar2_table(6) := '2D706F706F76657222293B6966286E262661297B76617220693D612E717565727953656C6563746F7228222E73682D656D6C2D72756C652D6C69737422292C733D612E717565727953656C6563746F7228222E73682D656D6C2D6E6F746963652D6C6973';
wwv_flow_imp.g_varchar2_table(7) := '7422292C723D612E717565727953656C6563746F7228222E73682D656D6C2D706F706F7665722D7469746C6522293B646F63756D656E742E626F64792E617070656E644368696C642861293B766172206F3D303D3D3D286E6176696761746F722E6C616E';
wwv_flow_imp.g_varchar2_table(8) := '67756167657C7C2222292E746F4C6F7765724361736528292E696E6465784F662822646522293B722E74657874436F6E74656E743D76282256616C6964696572756E67222C2256616C69646174696F6E22293B766172206C3D7B726571756972653A7028';
wwv_flow_imp.g_varchar2_table(9) := '22646174612D7265717569726522292C6175746F4C6F776572636173653A702822646174612D6175746F2D6C6F7765726361736522292C72656A6563745370616365733A702822646174612D72656A6563742D73706163657322292C73696E676C654174';
wwv_flow_imp.g_varchar2_table(10) := '3A702822646174612D73696E676C652D617422292C7265714C6F63616C3A702822646174612D7265712D6C6F63616C22292C726571446F6D61696E3A702822646174612D7265712D646F6D61696E22292C6E6F446F75626C65446F74733A702822646174';
wwv_flow_imp.g_varchar2_table(11) := '612D6E6F2D646F75626C652D646F747322292C6E6F4C6F63616C456467653A702822646174612D6E6F2D6C6F63616C2D6564676522292C6E6F446F6D61696E456467653A702822646174612D6E6F2D646F6D61696E2D6564676522292C72657175697265';
wwv_flow_imp.g_varchar2_table(12) := '546C643A702822646174612D726571756972652D746C6422292C746C64436865636B3A702822646174612D746C642D636865636B22292C646F6D61696E436865636B3A702822646174612D646F6D61696E2D636865636B22292C6C6F63616C436865636B';
wwv_flow_imp.g_varchar2_table(13) := '3A702822646174612D6C6F63616C2D636865636B22292C746C645061747465726E3A662822646174612D746C642D7061747465726E22292C646F6D61696E5061747465726E3A662822646174612D646F6D61696E2D7061747465726E22292C6C6F63616C';
wwv_flow_imp.g_varchar2_table(14) := '5061747465726E3A662822646174612D6C6F63616C2D7061747465726E22292C6D696E436865636B3A702822646174612D6D696E2D636865636B22292C6D6178436865636B3A702822646174612D6D61782D636865636B22292C6D696E4C656E6774683A';
wwv_flow_imp.g_varchar2_table(15) := '7061727365496E7428662822646174612D6D696E2D6C656E67746822292C3130292C6D61784C656E6774683A7061727365496E7428662822646174612D6D61782D6C656E67746822292C3130292C7265737472696374576C6973743A702822646174612D';
wwv_flow_imp.g_varchar2_table(16) := '72657374726963742D77686974656C69737422292C626C6F636B446973706F7361626C653A702822646174612D626C6F636B2D646973706F7361626C6522292C627574746F6E49643A662822646174612D627574746F6E2D696422297D2C633D6C2E6275';
wwv_flow_imp.g_varchar2_table(17) := '74746F6E49643F646F63756D656E742E676574456C656D656E7442794964286C2E627574746F6E4964293A6E756C6C2C643D6E756C6C3B6966286C2E627574746F6E4964262621632626636F6E736F6C652E7761726E28227368456D61696C56616C6964';
wwv_flow_imp.g_varchar2_table(18) := '61746F723A20627574746F6E2077697468207374617469632049442027222B6C2E627574746F6E49642B2227206E6F7420666F756E6422292C63297B66756E6374696F6E207528297B76617220653D632E676574426F756E64696E67436C69656E745265';
wwv_flow_imp.g_varchar2_table(19) := '637428292C743D652E626F74746F6D2B363B646F63756D656E742E717565727953656C6563746F72416C6C28272E73682D7368617265642D62746E2D68696E745B646174612D73682D68696E742D627574746F6E3D22272B6C2E627574746F6E49642B27';
wwv_flow_imp.g_varchar2_table(20) := '225D27292E666F7245616368282866756E6374696F6E2865297B69662866756E6374696F6E2865297B696628653D3D3D642972657475726E21313B76617220743D77696E646F772E676574436F6D70757465645374796C652865293B72657475726E226E';
wwv_flow_imp.g_varchar2_table(21) := '6F6E6522213D3D742E646973706C617926262268696464656E22213D3D742E7669736962696C6974797D286529297B766172206E3D652E676574426F756E64696E67436C69656E745265637428293B743D4D6174682E6D617828742C6E2E626F74746F6D';
wwv_flow_imp.g_varchar2_table(22) := '2B36297D7D29293B766172206E3D4D6174682E6D617828652E77696474682C323430292C613D652E6C6566743B612B6E3E77696E646F772E696E6E657257696474682D38262628613D4D6174682E6D617828382C77696E646F772E696E6E657257696474';
wwv_flow_imp.g_varchar2_table(23) := '682D6E2D3829292C642E7374796C652E746F703D742B227078222C642E7374796C652E6C6566743D612B227078222C642E7374796C652E77696474683D6E2B227078227D632E6164644576656E744C697374656E65722822636C69636B222C2866756E63';
wwv_flow_imp.g_varchar2_table(24) := '74696F6E2865297B632E636C6173734C6973742E636F6E7461696E73282273682D656D6C2D62746E2D626C6F636B65642229262628652E70726576656E7444656661756C7428292C652E73746F70496D6D65646961746550726F7061676174696F6E2829';
wwv_flow_imp.g_varchar2_table(25) := '297D292C2130292C28643D646F63756D656E742E637265617465456C656D656E7428226469762229292E636C6173734E616D653D2273682D656D6C2D62746E2D68696E742073682D7368617265642D62746E2D68696E74222C642E736574417474726962';
wwv_flow_imp.g_varchar2_table(26) := '7574652822646174612D73682D68696E742D627574746F6E222C6C2E627574746F6E4964292C642E696E6E657248544D4C3D273C7370616E20636C6173733D2273682D656D6C2D62746E2D68696E742D69636F6E223E3C2F7370616E3E3C7370616E3E3C';
wwv_flow_imp.g_varchar2_table(27) := '2F7370616E3E272C646F63756D656E742E626F64792E617070656E644368696C642864292C632E6164644576656E744C697374656E657228226D6F757365656E746572222C2866756E6374696F6E28297B632E636C6173734C6973742E636F6E7461696E';
wwv_flow_imp.g_varchar2_table(28) := '73282273682D656D6C2D62746E2D626C6F636B656422292626287528292C642E636C6173734C6973742E616464282273682D656D6C2D62746E2D68696E742D76697369626C652229297D29292C632E6164644576656E744C697374656E657228226D6F75';
wwv_flow_imp.g_varchar2_table(29) := '73656C65617665222C2866756E6374696F6E28297B642E636C6173734C6973742E72656D6F7665282273682D656D6C2D62746E2D68696E742D76697369626C6522297D29292C22737461746963223D3D3D676574436F6D70757465645374796C6528632E';
wwv_flow_imp.g_varchar2_table(30) := '706172656E744E6F6465292E706F736974696F6E262628632E706172656E744E6F64652E7374796C652E706F736974696F6E3D2272656C617469766522292C77696E646F772E6164644576656E744C697374656E657228227363726F6C6C222C2866756E';
wwv_flow_imp.g_varchar2_table(31) := '6374696F6E28297B642E636C6173734C6973742E636F6E7461696E73282273682D656D6C2D62746E2D68696E742D76697369626C65222926267528297D292C2130292C77696E646F772E6164644576656E744C697374656E65722822726573697A65222C';
wwv_flow_imp.g_varchar2_table(32) := '2866756E6374696F6E28297B642E636C6173734C6973742E636F6E7461696E73282273682D656D6C2D62746E2D68696E742D76697369626C65222926267528297D29297D766172206D3D6228662822646174612D646F6D61696E2D77686974656C697374';
wwv_flow_imp.g_varchar2_table(33) := '2229292C683D6228662822646174612D646973706F7361626C652D6C6973742229292C673D5B7B6163746976653A6C2E726571756972652C6D6573736167653A76282246656C642064617266206E69636874206C656572207365696E222C224669656C64';
wwv_flow_imp.g_varchar2_table(34) := '206D757374206E6F7420626520656D70747922292C746573743A66756E6374696F6E2865297B72657475726E20652E7472696D28292E6C656E6774683E307D7D2C7B6163746976653A6C2E72656A6563745370616365732C6D6573736167653A7628224B';
wwv_flow_imp.g_varchar2_table(35) := '65696E65204C6565727A65696368656E206F646572205374657565727A65696368656E2065726C61756274222C224E6F20737061636573206F7220636F6E74726F6C206368617261637465727320616C6C6F77656422292C746573743A66756E6374696F';
wwv_flow_imp.g_varchar2_table(36) := '6E2865297B72657475726E212F5B5C735C75303030302D5C75303031465C75303037465D2F2E746573742865297D7D2C7B6163746976653A6C2E73696E676C6541742C6D6573736167653A7628224D7573732067656E61752065696E20402D5A65696368';
wwv_flow_imp.g_varchar2_table(37) := '656E20656E7468616C74656E222C224D75737420636F6E7461696E2065786163746C79206F6E6520402073796D626F6C22292C746573743A66756E6374696F6E2865297B72657475726E20303D3D3D652E7472696D28292E6C656E6774687C7C313D3D3D';
wwv_flow_imp.g_varchar2_table(38) := '28652E6D61746368282F402F67297C7C5B5D292E6C656E6774687D7D2C7B6163746976653A6C2E7265714C6F63616C2C6D6573736167653A7628224E616D6520766F722064656D2040206665686C74222C224E616D65206265666F72652040206973206D';
wwv_flow_imp.g_varchar2_table(39) := '697373696E6722292C746573743A66756E6374696F6E2865297B72657475726E20303D3D3D652E7472696D28292E6C656E6774687C7C2D313D3D3D652E696E6465784F6628224022297C7C772865292E6C6F63616C2E6C656E6774683E307D7D2C7B6163';
wwv_flow_imp.g_varchar2_table(40) := '746976653A6C2E726571446F6D61696E2C6D6573736167653A762822446F6D61696E206E6163682064656D2040206665686C74222C22446F6D61696E2061667465722040206973206D697373696E6722292C746573743A66756E6374696F6E2865297B72';
wwv_flow_imp.g_varchar2_table(41) := '657475726E20303D3D3D652E7472696D28292E6C656E6774687C7C2D313D3D3D652E696E6465784F6628224022297C7C772865292E646F6D61696E2E6C656E6774683E307D7D2C7B6163746976653A6C2E6E6F446F75626C65446F74732C6D6573736167';
wwv_flow_imp.g_varchar2_table(42) := '653A7628224B65696E6520646F7070656C74656E2050756E6B746520282E2E292065726C61756274222C224E6F20636F6E736563757469766520646F747320282E2E2920616C6C6F77656422292C746573743A66756E6374696F6E2865297B7265747572';
wwv_flow_imp.g_varchar2_table(43) := '6E2D313D3D3D652E696E6465784F6628222E2E22297D7D2C7B6163746976653A6C2E6E6F4C6F63616C456467652C6D6573736167653A7628225465696C20766F722064656D20402064617266206E69636874206D69742050756E6B7420626567696E6E65';
wwv_flow_imp.g_varchar2_table(44) := '6E206F64657220656E64656E222C2250617274206265666F72652040206D757374206E6F74207374617274206F7220656E642077697468206120646F7422292C746573743A66756E6374696F6E2865297B76617220743D772865292E6C6F63616C3B7265';
wwv_flow_imp.g_varchar2_table(45) := '7475726E20303D3D3D742E6C656E6774687C7C222E22213D3D742E6368617241742830292626222E22213D3D742E63686172417428742E6C656E6774682D31297D7D2C7B6163746976653A6C2E6E6F446F6D61696E456467652C6D6573736167653A7628';
wwv_flow_imp.g_varchar2_table(46) := '22446F6D61696E2064617266206E69636874206D69742050756E6B74206F6465722042696E646573747269636820626567696E6E656E206F64657220656E64656E222C22446F6D61696E206D757374206E6F74207374617274206F7220656E6420776974';
wwv_flow_imp.g_varchar2_table(47) := '68206120646F74206F722068797068656E22292C746573743A66756E6374696F6E2865297B76617220743D772865292E646F6D61696E3B696628303D3D3D742E6C656E6774682972657475726E21303B766172206E3D742E6368617241742830292C613D';
wwv_flow_imp.g_varchar2_table(48) := '742E63686172417428742E6C656E6774682D31293B72657475726E222E22213D3D6E2626222D22213D3D6E2626222E22213D3D612626222D22213D3D617D7D2C7B6163746976653A6C2E72657175697265546C642C6D6573736167653A762822446F6D61';
wwv_flow_imp.g_varchar2_table(49) := '696E20627261756368742065696E6520456E64756E6720287A2E20422E202E64652C202E636F6D29222C22446F6D61696E206D75737420636F6E7461696E206120746F702D6C6576656C20646F6D61696E2028652E672E202E64652C202E636F6D292229';
wwv_flow_imp.g_varchar2_table(50) := '2C746573743A66756E6374696F6E2865297B76617220743D772865292E646F6D61696E3B72657475726E20303D3D3D742E6C656E6774687C7C2D31213D3D742E696E6465784F6628222E22297D7D2C7B6163746976653A6C2E746C64436865636B26266C';
wwv_flow_imp.g_varchar2_table(51) := '2E746C645061747465726E2E6C656E6774683E302C6D6573736167653A762822446F6D61696E2D456E64756E672069737420756E67C3BC6C746967222C22546F702D6C6576656C20646F6D61696E20697320696E76616C696422292C746573743A66756E';
wwv_flow_imp.g_varchar2_table(52) := '6374696F6E2865297B76617220743D772865292E746C643B72657475726E20303D3D3D742E6C656E6774687C7C4C286C2E746C645061747465726E2C74297D7D2C7B6163746976653A6C2E6C6F63616C436865636B26266C2E6C6F63616C506174746572';
wwv_flow_imp.g_varchar2_table(53) := '6E2E6C656E6774683E302C6D6573736167653A7628225465696C20766F722064656D204020656E7468C3A46C7420756E7A756CC3A47373696765205A65696368656E222C2250617274206265666F7265204020636F6E7461696E7320696E76616C696420';
wwv_flow_imp.g_varchar2_table(54) := '6368617261637465727322292C746573743A66756E6374696F6E2865297B76617220743D772865292E6C6F63616C3B72657475726E20303D3D3D742E6C656E6774687C7C4C286C2E6C6F63616C5061747465726E2C74297D7D2C7B6163746976653A6C2E';
wwv_flow_imp.g_varchar2_table(55) := '646F6D61696E436865636B26266C2E646F6D61696E5061747465726E2E6C656E6774683E302C6D6573736167653A762822446F6D61696E20656E7468C3A46C7420756E7A756CC3A47373696765205A65696368656E222C22446F6D61696E20636F6E7461';
wwv_flow_imp.g_varchar2_table(56) := '696E7320696E76616C6964206368617261637465727322292C746573743A66756E6374696F6E2865297B76617220743D772865292E646F6D61696E3B72657475726E20303D3D3D742E6C656E6774687C7C4C286C2E646F6D61696E5061747465726E2C74';
wwv_flow_imp.g_varchar2_table(57) := '297D7D2C7B6163746976653A6C2E6D696E436865636B26262169734E614E286C2E6D696E4C656E677468292C6D6573736167653A7628224D696E64657374656E7320222B6C2E6D696E4C656E6774682B22205A65696368656E206572666F726465726C69';
wwv_flow_imp.g_varchar2_table(58) := '6368222C224174206C6561737420222B6C2E6D696E4C656E6774682B22206368617261637465727320726571756972656422292C746573743A66756E6374696F6E2865297B72657475726E20303D3D3D652E7472696D28292E6C656E6774687C7C652E74';
wwv_flow_imp.g_varchar2_table(59) := '72696D28292E6C656E6774683E3D6C2E6D696E4C656E6774687D7D2C7B6163746976653A6C2E6D6178436865636B26262169734E614E286C2E6D61784C656E677468292C6D6573736167653A76282248C3B663687374656E7320222B6C2E6D61784C656E';
wwv_flow_imp.g_varchar2_table(60) := '6774682B22205A65696368656E2065726C61756274222C224E6F206D6F7265207468616E20222B6C2E6D61784C656E6774682B22206368617261637465727320616C6C6F77656422292C746573743A66756E6374696F6E2865297B72657475726E20652E';
wwv_flow_imp.g_varchar2_table(61) := '7472696D28292E6C656E6774683C3D6C2E6D61784C656E6774687D7D2C7B6163746976653A6C2E7265737472696374576C6973742C6D6573736167653A762822446F6D61696E20697374206E6963687420617566206465722065726C61756274656E204C';
wwv_flow_imp.g_varchar2_table(62) := '69737465222C22446F6D61696E206973206E6F74206F6E2074686520616C6C6F776564206C69737422292C746573743A66756E6374696F6E2865297B76617220743D772865292E646F6D61696E2E746F4C6F7765724361736528293B72657475726E2030';
wwv_flow_imp.g_varchar2_table(63) := '3D3D3D742E6C656E6774687C7C28303D3D3D6D2E6C656E6774687C7C2D31213D3D6D2E696E6465784F66287429297D7D2C7B6163746976653A6C2E626C6F636B446973706F7361626C652C6D6573736167653A762822576567776572662D452D4D61696C';
wwv_flow_imp.g_varchar2_table(64) := '2D416E6269657465722073696E64206E696368742065726C61756274222C22446973706F7361626C6520656D61696C2070726F76696465727320617265206E6F7420616C6C6F77656422292C746573743A66756E6374696F6E2865297B76617220743D77';
wwv_flow_imp.g_varchar2_table(65) := '2865292E646F6D61696E2E746F4C6F7765724361736528293B72657475726E20303D3D3D742E6C656E6774687C7C2D313D3D3D682E696E6465784F662874297D7D5D2E66696C746572282866756E6374696F6E2865297B72657475726E20652E61637469';
wwv_flow_imp.g_varchar2_table(66) := '76657D29293B69662866756E6374696F6E28297B76617220653D5B5D3B6966286C2E6175746F4C6F776572636173652626652E70757368287628224175746F6D61746973636865204B6C65696E73636872656962756E672069737420616B746976222C22';
wwv_flow_imp.g_varchar2_table(67) := '4175746F6D61746963206C6F77657263617365206973206163746976652229292C6C2E6D6178436865636B26262169734E614E286C2E6D61784C656E677468292626652E70757368287628224D6178696D616C20222B6C2E6D61784C656E6774682B2220';
wwv_flow_imp.g_varchar2_table(68) := '5A65696368656E222C224D6178696D756D20222B6C2E6D61784C656E6774682B2220636861726163746572732229292C6C2E7265737472696374576C69737426266D2E6C656E6774683E30297B76617220743D6D2E736C69636528302C33292E6A6F696E';
wwv_flow_imp.g_varchar2_table(69) := '28222C2022292C6E3D6D2E6C656E6774682D332C613D6E3E303F742B76282220756E6420222B6E2B222077656974657265222C2220616E6420222B6E2B22206D6F726522293A743B652E707573682876282245726C617562746520446F6D61696E733A20';
wwv_flow_imp.g_varchar2_table(70) := '222C22416C6C6F77656420646F6D61696E733A2022292B61297D732E696E6E657248544D4C3D22222C652E666F7245616368282866756E6374696F6E2865297B76617220743D646F63756D656E742E637265617465456C656D656E7428227370616E2229';
wwv_flow_imp.g_varchar2_table(71) := '3B742E636C6173734E616D653D2273682D656D6C2D6E6F74696365223B766172206E3D646F63756D656E742E637265617465456C656D656E7428226922293B6E2E636C6173734E616D653D2273682D656D6C2D6E6F746963652D69636F6E223B76617220';
wwv_flow_imp.g_varchar2_table(72) := '613D646F63756D656E742E637265617465456C656D656E7428227370616E22293B612E74657874436F6E74656E743D652C742E617070656E644368696C64286E292C742E617070656E644368696C642861292C732E617070656E644368696C642874297D';
wwv_flow_imp.g_varchar2_table(73) := '29292C732E636C6173734C6973742E746F67676C65282273682D656D6C2D6861732D6E6F7469636573222C652E6C656E6774683E30297D28292C6C2E6175746F4C6F7765726361736526266E2E6164644576656E744C697374656E65722822696E707574';
wwv_flow_imp.g_varchar2_table(74) := '222C2866756E6374696F6E28297B76617220653D6E2E73656C656374696F6E53746172742C743D6E2E73656C656374696F6E456E642C613D6E2E76616C75652E746F4C6F7765724361736528293B69662861213D3D6E2E76616C7565297B6E2E76616C75';
wwv_flow_imp.g_varchar2_table(75) := '653D613B7472797B6E2E73657453656C656374696F6E52616E676528652C74297D63617463682865297B7D7D7D29292C6E2E6164644576656E744C697374656E65722822666F637573222C2866756E6374696F6E28297B7828292C612E636C6173734C69';
wwv_flow_imp.g_varchar2_table(76) := '73742E616464282273682D656D6C2D706F706F7665722D6F70656E22292C4528297D29292C6E2E6164644576656E744C697374656E65722822696E707574222C2866756E6374696F6E28297B4528292C612E636C6173734C6973742E636F6E7461696E73';
wwv_flow_imp.g_varchar2_table(77) := '282273682D656D6C2D706F706F7665722D6F70656E222926267828297D29292C6E2E6164644576656E744C697374656E65722822626C7572222C2866756E6374696F6E28297B73657454696D656F7574282866756E6374696F6E28297B612E636C617373';
wwv_flow_imp.g_varchar2_table(78) := '4C6973742E72656D6F7665282273682D656D6C2D706F706F7665722D6F70656E22297D292C313530292C4528297D29292C77696E646F772E6164644576656E744C697374656E657228227363726F6C6C222C2866756E6374696F6E28297B612E636C6173';
wwv_flow_imp.g_varchar2_table(79) := '734C6973742E636F6E7461696E73282273682D656D6C2D706F706F7665722D6F70656E222926267828297D292C2130292C77696E646F772E6164644576656E744C697374656E65722822726573697A65222C2866756E6374696F6E28297B612E636C6173';
wwv_flow_imp.g_varchar2_table(80) := '734C6973742E636F6E7461696E73282273682D656D6C2D706F706F7665722D6F70656E222926267828297D29292C63262677696E646F772E496E74657273656374696F6E4F62736572766572296E657720496E74657273656374696F6E4F627365727665';
wwv_flow_imp.g_varchar2_table(81) := '72282866756E6374696F6E28297B4528297D29292E6F627365727665286E293B4528297D656C736520636F6E736F6C652E7761726E28227368456D61696C56616C696461746F723A20696E636F6D706C657465206D61726B757020666F7220222B65297D';
wwv_flow_imp.g_varchar2_table(82) := '656C736520636F6E736F6C652E7761726E28227368456D61696C56616C696461746F723A2077726170706572206E6F7420666F756E6420666F7220222B65293B66756E6374696F6E207628652C74297B72657475726E206F3F653A747D66756E6374696F';
wwv_flow_imp.g_varchar2_table(83) := '6E20662865297B72657475726E20742E6765744174747269627574652865297C7C22227D66756E6374696F6E20702865297B72657475726E2259223D3D3D662865297D66756E6374696F6E20622865297B72657475726E20653F652E73706C697428222C';
wwv_flow_imp.g_varchar2_table(84) := '22292E6D6170282866756E6374696F6E2865297B72657475726E20652E7472696D28292E746F4C6F7765724361736528297D29292E66696C746572282866756E6374696F6E2865297B72657475726E20652E6C656E6774683E307D29293A5B5D7D66756E';
wwv_flow_imp.g_varchar2_table(85) := '6374696F6E20772865297B76617220743D652E696E6465784F6628224022293B6966282D313D3D3D742972657475726E7B6C6F63616C3A652C646F6D61696E3A22222C746C643A22227D3B766172206E3D652E737562737472696E6728302C74292C613D';
wwv_flow_imp.g_varchar2_table(86) := '652E737562737472696E6728742B31292C693D612E6C617374496E6465784F6628222E22292C733D2D313D3D3D693F22223A612E737562737472696E6728692B31293B72657475726E7B6C6F63616C3A6E2C646F6D61696E3A612C746C643A737D7D6675';
wwv_flow_imp.g_varchar2_table(87) := '6E6374696F6E204C28652C74297B7472797B72657475726E206E6577205265674578702865292E746573742874297D63617463682874297B72657475726E20636F6E736F6C652E7761726E28227368456D61696C56616C696461746F723A20696E76616C';
wwv_flow_imp.g_varchar2_table(88) := '6964207061747465726E20636F6E666967757265643A20222B65292C21317D7D66756E6374696F6E204528297B76617220743D66756E6374696F6E2865297B76617220743D672E66696C746572282866756E6374696F6E2874297B72657475726E21742E';
wwv_flow_imp.g_varchar2_table(89) := '746573742865297D29293B696628692E696E6E657248544D4C3D22222C303D3D3D652E7472696D28292E6C656E6774682626216C2E72657175697265297B766172206E3D646F63756D656E742E637265617465456C656D656E7428227370616E22293B72';
wwv_flow_imp.g_varchar2_table(90) := '657475726E206E2E636C6173734E616D653D2273682D656D6C2D6E65757472616C222C6E2E74657874436F6E74656E743D76282254697070656E207A756D2056616C6964696572656E222C22537461727420747970696E6720746F2076616C6964617465';
wwv_flow_imp.g_varchar2_table(91) := '22292C692E617070656E644368696C64286E292C747D696628303D3D3D742E6C656E677468297B76617220613D646F63756D656E742E637265617465456C656D656E7428227370616E22293B72657475726E20612E636C6173734E616D653D2273682D65';
wwv_flow_imp.g_varchar2_table(92) := '6D6C2D73756363657373222C612E696E6E657248544D4C3D273C6920636C6173733D2273682D656D6C2D737563636573732D69636F6E223E3C2F693E3C7370616E3E272B762822416C6C652056616C6964696572756E67656E2062657374616E64656E22';
wwv_flow_imp.g_varchar2_table(93) := '2C22416C6C2076616C69646174696F6E732070617373656422292B223C2F7370616E3E222C692E617070656E644368696C642861292C747D72657475726E20742E666F7245616368282866756E6374696F6E2865297B76617220743D646F63756D656E74';
wwv_flow_imp.g_varchar2_table(94) := '2E637265617465456C656D656E7428227370616E22293B742E636C6173734E616D653D2273682D656D6C2D6572726F72223B766172206E3D646F63756D656E742E637265617465456C656D656E7428226922293B6E2E636C6173734E616D653D2273682D';
wwv_flow_imp.g_varchar2_table(95) := '656D6C2D6572726F722D69636F6E223B76617220613D646F63756D656E742E637265617465456C656D656E7428227370616E22293B612E74657874436F6E74656E743D652E6D6573736167652C742E617070656E644368696C64286E292C742E61707065';
wwv_flow_imp.g_varchar2_table(96) := '6E644368696C642861292C692E617070656E644368696C642874297D29292C747D286E2E76616C7565292C613D742E6C656E6774683E3026262128303D3D3D6E2E76616C75652E7472696D28292E6C656E6774682626216C2E72657175697265293B6966';
wwv_flow_imp.g_varchar2_table(97) := '286E2E636C6173734C6973742E746F67676C65282273682D656D6C2D696E76616C6964222C61292C63297B76617220733D2121286E2E6F666673657457696474687C7C6E2E6F66667365744865696768747C7C6E2E676574436C69656E74526563747328';
wwv_flow_imp.g_varchar2_table(98) := '292E6C656E677468292626742E6C656E6774683E303B632E636C6173734C6973742E746F67676C65282273682D656D6C2D62746E2D626C6F636B6564222C73292C632E7365744174747269627574652822617269612D64697361626C6564222C733F2274';
wwv_flow_imp.g_varchar2_table(99) := '727565223A2266616C736522293B76617220723D7628224269747465207A75657273742065696E652067C3BC6C7469676520452D4D61696C2D416472657373652065696E676562656E222C22506C6561736520656E74657220612076616C696420656D61';
wwv_flow_imp.g_varchar2_table(100) := '696C206164647265737320666972737422293B77696E646F772E7368526567697374657242746E426C6F636B6572286C2E627574746F6E49642C652C733F723A6E756C6C292C64262628642E6C617374456C656D656E744368696C642E74657874436F6E';
wwv_flow_imp.g_varchar2_table(101) := '74656E743D722C737C7C642E636C6173734C6973742E72656D6F7665282273682D656D6C2D62746E2D68696E742D76697369626C652229297D7D66756E6374696F6E207828297B76617220653D6E2E676574426F756E64696E67436C69656E7452656374';
wwv_flow_imp.g_varchar2_table(102) := '28293B612E7374796C652E746F703D652E626F74746F6D2B362B227078222C612E7374796C652E6C6566743D652E6C6566742B227078222C612E7374796C652E77696474683D652E77696474682B227078227D7D7D3B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(224899522738449690)
,p_plugin_id=>wwv_flow_imp.id(223779260480124598)
,p_file_name=>'email_validator.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
