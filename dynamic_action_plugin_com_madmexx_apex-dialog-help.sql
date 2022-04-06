prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_200100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1800226374041842
,p_default_application_id=>101
,p_default_id_offset=>3700527344609345
,p_default_owner=>'DEVELOPER_APP'
);
end;
/
 
prompt APPLICATION 101 - Application Template
--
-- Application Export:
--   Application:     101
--   Name:            Application Template
--   Date and Time:   17:49 Wednesday April 6, 2022
--   Exported By:     DEVELOPER_APP
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 4520941116105406
--   Manifest End
--   Version:         20.1.0.00.13
--   Instance ID:     300172863090659
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_madmexx_apex_page_help
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(4520941116105406)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.MADMEXX.APEX-HELP-PAGE'
,p_display_name=>'Help Page'
,p_category=>'INIT'
,p_supported_ui_types=>'DESKTOP'
,p_javascript_file_urls=>'#PLUGIN_FILES#helpPage#MIN#.js'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function APEX_PLUGIN_RENDER(',
'  P_DYNAMIC_ACTION in APEX_PLUGIN.T_DYNAMIC_ACTION',
', P_PLUGIN         in APEX_PLUGIN.T_PLUGIN)',
'  return APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT is',
'  L_RESULT APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT;',
'begin',
'  L_RESULT.AJAX_IDENTIFIER     := APEX_PLUGIN.GET_AJAX_IDENTIFIER;',
'',
'  if APEX_APPLICATION.G_DEBUG then',
'     APEX_PLUGIN_UTIL.DEBUG_DYNAMIC_ACTION(',
'        P_PLUGIN         => P_PLUGIN',
'      , P_DYNAMIC_ACTION => P_DYNAMIC_ACTION);',
'  end if;',
'',
'  L_RESULT.JAVASCRIPT_FUNCTION := ''modalHelp(''',
'                                  || APEX_JAVASCRIPT.ADD_VALUE(APEX_PLUGIN.GET_AJAX_IDENTIFIER, FALSE)',
'                                  || '')'';',
'',
'  return L_RESULT;',
'end APEX_PLUGIN_RENDER;',
'',
'/* ====================================================================================================================================================================================  */',
'',
'function APEX_PLUGIN_AJAX(',
'  P_DYNAMIC_ACTION in APEX_PLUGIN.T_DYNAMIC_ACTION',
', P_PLUGIN         in APEX_PLUGIN.T_PLUGIN)',
'  return APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT is',
'  EX_NO_PAGE   exception;',
'  L_RESULT     APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT;',
'  L_PAGE       pls_integer           := APEX_APPLICATION.G_X01;',
'  L_PAGE_TITLE APEX_APPLICATION_PAGES.PAGE_TITLE%type;',
'  L_HELP_TEXT  APEX_APPLICATION_PAGES.HELP_TEXT%type;',
'  K_HELP_TEXT  constant varchar2(64) := P_DYNAMIC_ACTION.ATTRIBUTE_06;',
'  L_WINDOW     varchar2(16);',
'  L_WINDOW_URL varchar2(4000)        := ''Empty'';',
'begin',
'',
'  -- Check PAGE_ID',
'  if L_PAGE is null then',
'     raise EX_NO_PAGE;',
'  end if;',
'',
'  -- IF ''Y'' use custom help page',
'  if P_DYNAMIC_ACTION.ATTRIBUTE_03 = ''Y'' then',
'     L_WINDOW_URL := APEX_PAGE.GET_URL(',
'                        P_PAGE   => P_DYNAMIC_ACTION.ATTRIBUTE_04',
'                      , P_ITEMS  => P_DYNAMIC_ACTION.ATTRIBUTE_05',
'                      , P_VALUES => L_PAGE',
'                     );',
'     -- Standard page or modal dialog                ',
'     if INSTR(L_WINDOW_URL, ''javascript'') > 0 then',
'        L_WINDOW     := ''modalPage'';',
'        L_WINDOW_URL := REPLACE(L_WINDOW_URL, ''javascript:'', '''');',
'     else',
'        L_WINDOW := ''page'';',
'     end if;',
'',
'     -- Build in page help from Application Builder',
'  else',
'     -- Show with popup',
'     L_WINDOW := ''popup'';',
'',
'     -- Load help',
'     select HELP_TEXT into L_HELP_TEXT',
'       from APEX_APPLICATION_PAGES',
'      where APPLICATION_ID = APEX_APPLICATION.G_FLOW_ID',
'        and PAGE_ID = L_PAGE;',
'',
'  end if;',
'',
'  -- Return JSON with page, helptext und window title',
'  APEX_JSON.OPEN_OBJECT;',
'  APEX_JSON.WRITE(''page'', L_PAGE);',
'  APEX_JSON.WRITE(''helpTitle'', APEX_LANG.MESSAGE(''APEX.DIALOG.HELP''));',
'  APEX_JSON.WRITE(''helpText'', COALESCE(L_HELP_TEXT, K_HELP_TEXT));',
'  APEX_JSON.WRITE(''window'', L_WINDOW);',
'  APEX_JSON.WRITE(''window_url'', L_WINDOW_URL);',
'  APEX_JSON.CLOSE_ALL;',
'',
'  return L_RESULT;',
'',
'exception',
'  when others then',
'     APEX_JSON.OPEN_OBJECT;',
'     APEX_JSON.WRITE(''error'', ''Error. Page help could not be loaded.'');',
'     APEX_JSON.CLOSE_ALL;',
'     return L_RESULT;',
'end APEX_PLUGIN_AJAX;'))
,p_api_version=>2
,p_render_function=>'COM_MADMEXX_HELP_PAGE_PKG.apex_plugin_render'
,p_ajax_function=>'COM_MADMEXX_HELP_PAGE_PKG.apex_plugin_ajax'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Is a dynamic action plugin to show the page help and could replace the apex way of page help. It is also possible to render a help button in the title bar of a modal dialog. </p>',
'<p>Just set the <code><strong>pageHelp--dialog</strong></code> class in the CSS Classes field in the Dialog Section of the related page. <br>',
'The help page can be shown on a user defined page (For example, the wizard created help page) or in a popup window<br>',
'The help page can be triggered from a button or navigation bar entry, too. Just set the class <code><strong>pageHelp</strong></code>. </p>'))
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/madmexx2002/APEX-Help-Page'
,p_files_version=>11
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4733571188182500)
,p_plugin_id=>wwv_flow_api.id(4520941116105406)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Use Help Page'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'Set to ''Yes'' if you would use a custom help page. Could be the wizard generated build in help page.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4734253380189899)
,p_plugin_id=>wwv_flow_api.id(4520941116105406)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Page Number'
,p_attribute_type=>'PAGE NUMBER'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(4733571188182500)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Select custom help page.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4734969323195014)
,p_plugin_id=>wwv_flow_api.id(4520941116105406)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Page Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(4733571188182500)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Select Page Item to hold page number for help.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(4928522236683132)
,p_plugin_id=>wwv_flow_api.id(4520941116105406)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>5
,p_prompt=>'No Help Message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'No help available for this page.'
,p_display_length=>256
,p_max_length=>256
,p_is_translatable=>true
,p_help_text=>'Define your own "No help available for this page" message.'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0D0A202A20506C7567696E3A202020415045582048656C7020506167650D0A202A2056657273696F6E3A2020312E300D0A202A0D0A202A204C6963656E73653A20204D4954204C6963656E736520436F707972696768742032303232204D61726B20';
wwv_flow_api.g_varchar2_table(2) := '4C656E7A65722E0D0A202A204769746875623A20202068747470733A2F2F6769746875622E636F6D2F6D61646D657878323030322F415045582D48656C702D506167650D0A202A204D61696C3A2020202020617065782D706C7567696E73407072657469';
wwv_flow_api.g_varchar2_table(3) := '75732E636F6D0D0A202A204973737565733A20202068747470733A2F2F6769746875622E636F6D2F6D61646D657878323030322F415045582D48656C702D506167652F6973737565730D0A202A0D0A202A20417574686F723A2020204D61726B204C656E';
wwv_flow_api.g_varchar2_table(4) := '7A65720D0A202A2F0D0A66756E6374696F6E206D6F64616C48656C7028616A61784964656E74696669657229207B0D0A202020202F2A2043726561746520612048656C7020427574746F6E20696E2061204D6F64616C204469616C6F67205469746C6562';
wwv_flow_api.g_varchar2_table(5) := '6172202A2F0D0A202020202428646F63756D656E74292E6F6E28226469616C6F676F70656E222C2066756E6374696F6E20286576656E7429207B0D0A20202020202020207661722076506172656E74203D2024286576656E742E746172676574292E7061';
wwv_flow_api.g_varchar2_table(6) := '72656E7428293B0D0A0D0A20202020202020202F2F20446F6E7420616374697661746520666F7220696672616D65732074686174206172656E2774206D6F64616C206469616C676F73206F72207768656E207468652075692D6469616C6F672D2D68656C';
wwv_flow_api.g_varchar2_table(7) := '7020636C6173732069736E27742073657420696E20746865206469616C6F672073657474696E67730D0A2020202020202020696620280D0A20202020202020202020202021242876506172656E74292E686173436C617373282275692D6469616C6F672D';
wwv_flow_api.g_varchar2_table(8) := '2D617065782229207C7C0D0A20202020202020202020202021242876506172656E74292E686173436C617373282268656C70506167652D2D6469616C6F6722290D0A202020202020202029207B0D0A20202020202020202020202072657475726E3B0D0A';
wwv_flow_api.g_varchar2_table(9) := '20202020202020207D0D0A0D0A20202020202020202F2F2020416464207265667265736820627574746F6E0D0A202020202020202076617220764576656E74546172676574203D2024286576656E742E746172676574292C0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(10) := '20207242746E5469746C65203D202248656C70222C0D0A2020202020202020202020207242746E203D0D0A202020202020202020202020273C627574746F6E20747970653D22627574746F6E22207469746C653D2225302220617269612D6C6162656C3D';
wwv_flow_api.g_varchar2_table(11) := '2248656C70222027202B0D0A20202020202020202020202027202020207374796C653D2272696768743A253170783B626F726465722D7261646975733A20313030253B2077696474683A20323470783B206865696768743A20323470783B207061646469';
wwv_flow_api.g_varchar2_table(12) := '6E673A303B706F736974696F6E3A206162736F6C7574653B222027202B0D0A2020202020202020202020202720202020636C6173733D2268656C705061676520742D427574746F6E20742D427574746F6E2D2D6E6F4C6162656C20742D427574746F6E2D';
wwv_flow_api.g_varchar2_table(13) := '2D69636F6E20742D427574746F6E2D2D736D616C6C223E27202B0D0A202020202020202020202020273C7370616E20617269612D68696464656E3D22747275652220636C6173733D224D6F64616C4469616C6F6748656C7020742D49636F6E2066612066';
wwv_flow_api.g_varchar2_table(14) := '612D7175657374696F6E223E3C2F7370616E3E3C2F627574746F6E3E272C0D0A202020202020202020202020765469746C65203D20242876506172656E74292E66696E6428222E75692D6469616C6F672D7469746C6522292C0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(15) := '202020764469616C6F67436C6F736542746E203D20242876506172656E74292E66696E6428222E75692D6469616C6F672D7469746C656261722D636C6F736522292C0D0A202020202020202020202020764D617267696E203D20302C0D0A202020202020';
wwv_flow_api.g_varchar2_table(16) := '202020202020764469616C6F67203D202428764576656E74546172676574292E636C6F7365737428226469762E75692D6469616C6F672D2D6170657822292C0D0A20202020202020202020202076694672616D65203D202428764469616C6F67292E6669';
wwv_flow_api.g_varchar2_table(17) := '6E642822696672616D6522293B0D0A0D0A20202020202020202F2F20506F736974696F6E207468652068656C7020627574746F6E206C6566742073696465206F6620436C6F736520427574746F6E0D0A2020202020202020696620280D0A202020202020';
wwv_flow_api.g_varchar2_table(18) := '2020202020202428764469616C6F67436C6F736542746E292E6C656E677468203E20302026260D0A2020202020202020202020202428764469616C6F67436C6F736542746E292E63737328226D617267696E2D6C65667422292E7265706C616365282270';
wwv_flow_api.g_varchar2_table(19) := '78222C20222229203D3D202230220D0A202020202020202029207B0D0A202020202020202020202020764D617267696E203D2034343B0D0A20202020202020207D20656C7365207B0D0A202020202020202020202020764D617267696E203D2031323B0D';
wwv_flow_api.g_varchar2_table(20) := '0A20202020202020207D0D0A0D0A20202020202020202F2F2053657420427574746F6E207469746C652F746F6F6C74697020616E642061646420427574746F6E0D0A20202020202020207242746E203D20617065782E6C616E672E666F726D6174287242';
wwv_flow_api.g_varchar2_table(21) := '746E2C207242746E5469746C652C20764D617267696E293B0D0A20202020202020202428765469746C65292E6166746572287242746E293B0D0A202020207D293B0D0A0D0A202020202F2A2053686F772048656C7020666F72204D6F64616C204469616C';
wwv_flow_api.g_varchar2_table(22) := '6F67202A2F0D0A20202020242822626F647922292E6F6E2822636C69636B222C20222E68656C7050616765222C2066756E6374696F6E20286576656E7429207B0D0A20202020202020202F2F20437265617465206A51756572792046756E6374696F6E20';
wwv_flow_api.g_varchar2_table(23) := '636C6173734C6973740D0A2020202020202020242E666E2E636C6173734C697374203D2066756E6374696F6E202829207B0D0A20202020202020202020202072657475726E20746869735B305D2E636C6173734E616D652E73706C6974282F5C732B2F29';
wwv_flow_api.g_varchar2_table(24) := '3B0D0A20202020202020207D3B0D0A0D0A202020202020202076617220764576656E74546172676574203D2024286576656E742E746172676574292C0D0A202020202020202020202020764469616C6F67203D202428764576656E74546172676574292E';
wwv_flow_api.g_varchar2_table(25) := '636C6F7365737428226469762E75692D6469616C6F672D2D6170657822293B0D0A20202020202020207661722076506167653B0D0A0D0A20202020202020202F2F2053656172636820666F7220504147455F49440D0A2020202020202020696620287644';
wwv_flow_api.g_varchar2_table(26) := '69616C6F672E6C656E677468203D3D203129207B0D0A2020202020202020202020202F2F20696672616D6520284D6F64616C204469616C6F67290D0A2020202020202020202020207661722076694672616D65203D202428764469616C6F67292E66696E';
wwv_flow_api.g_varchar2_table(27) := '642822696672616D6522293B0D0A2020202020202020202020207650616765203D202428764469616C6F67290D0A202020202020202020202020202020202E66696E642822696672616D6522290D0A202020202020202020202020202020202E636F6E74';
wwv_flow_api.g_varchar2_table(28) := '656E747328290D0A202020202020202020202020202020202E66696E64282268746D6C22290D0A202020202020202020202020202020202E636C6173734C69737428295B305D0D0A202020202020202020202020202020202E7265706C61636528227061';
wwv_flow_api.g_varchar2_table(29) := '67652D222C202222293B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020202F2F206E6F74206120696672616D6520284E6F726D616C2050616765290D0A2020202020202020202020207650616765203D2070466C6F775374';
wwv_flow_api.g_varchar2_table(30) := '657049642E76616C75653B0D0A20202020202020207D0D0A0D0A20202020202020202F2F2043616C6C206170706C69636174696F6E2070726F63657373204D4F44414C5F504147455F48454C5020616E642073686F7720726573756C740D0A2020202020';
wwv_flow_api.g_varchar2_table(31) := '202020617065782E7365727665722E706C7567696E280D0A202020202020202020202020616A61784964656E7469666965722C207B0D0A202020202020202020202020202020207830313A2076506167652C0D0A2020202020202020202020207D2C207B';
wwv_flow_api.g_varchar2_table(32) := '0D0A20202020202020202020202020202020737563636573733A2066756E6374696F6E2028704461746129207B0D0A2020202020202020202020202020202020202020737769746368202870446174612E77696E646F7729207B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(33) := '2020202020202020202020202020202063617365202270616765223A0D0A202020202020202020202020202020202020202020202020202020202F2F204E6F726D616C20706167650D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(34) := '2020617065782E6E617669676174696F6E2E72656469726563742870446174612E77696E646F775F75726C293B0D0A20202020202020202020202020202020202020202020202020202020627265616B3B0D0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(35) := '202020202020206361736520226D6F64616C50616765223A0D0A202020202020202020202020202020202020202020202020202020202F2F204D6F64616C20706167650D0A20202020202020202020202020202020202020202020202020202020657661';
wwv_flow_api.g_varchar2_table(36) := '6C2870446174612E77696E646F775F75726C293B0D0A20202020202020202020202020202020202020202020202020202020627265616B3B0D0A20202020202020202020202020202020202020202020202064656661756C743A0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(37) := '20202020202020202020202020202020202020202F2F2053686F7720696E207468656D6520706F7075700D0A20202020202020202020202020202020202020202020202020202020617065782E7468656D652E706F7075704669656C6448656C70287B0D';
wwv_flow_api.g_varchar2_table(38) := '0A20202020202020202020202020202020202020202020202020202020202020207469746C653A2070446174612E68656C705469746C652C0D0A202020202020202020202020202020202020202020202020202020202020202068656C70546578743A20';
wwv_flow_api.g_varchar2_table(39) := '70446174612E68656C70546578742C0D0A202020202020202020202020202020202020202020202020202020207D293B0D0A20202020202020202020202020202020202020207D0D0A202020202020202020202020202020207D2C0D0A20202020202020';
wwv_flow_api.g_varchar2_table(40) := '20202020207D0D0A2020202020202020293B0D0A202020207D293B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(4521584918105421)
,p_plugin_id=>wwv_flow_api.id(4520941116105406)
,p_file_name=>'helpPage.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E206D6F64616C48656C7028616A61784964656E746966696572297B2428646F63756D656E74292E6F6E28226469616C6F676F70656E222C2866756E6374696F6E2861297B76617220653D2428612E746172676574292E706172656E74';
wwv_flow_api.g_varchar2_table(2) := '28293B696628242865292E686173436C617373282275692D6469616C6F672D2D6170657822292626242865292E686173436C617373282268656C70506167652D2D6469616C6F672229297B76617220743D2428612E746172676574292C693D273C627574';
wwv_flow_api.g_varchar2_table(3) := '746F6E20747970653D22627574746F6E22207469746C653D2225302220617269612D6C6162656C3D2248656C702220202020207374796C653D2272696768743A253170783B626F726465722D7261646975733A20313030253B2077696474683A20323470';
wwv_flow_api.g_varchar2_table(4) := '783B206865696768743A20323470783B2070616464696E673A303B706F736974696F6E3A206162736F6C7574653B222020202020636C6173733D2268656C705061676520742D427574746F6E20742D427574746F6E2D2D6E6F4C6162656C20742D427574';
wwv_flow_api.g_varchar2_table(5) := '746F6E2D2D69636F6E20742D427574746F6E2D2D736D616C6C223E3C7370616E20617269612D68696464656E3D22747275652220636C6173733D224D6F64616C4469616C6F6748656C7020742D49636F6E2066612066612D7175657374696F6E223E3C2F';
wwv_flow_api.g_varchar2_table(6) := '7370616E3E3C2F627574746F6E3E272C6C3D242865292E66696E6428222E75692D6469616C6F672D7469746C6522292C6E3D242865292E66696E6428222E75692D6469616C6F672D7469746C656261722D636C6F736522292C6F3D302C703D242874292E';
wwv_flow_api.g_varchar2_table(7) := '636C6F7365737428226469762E75692D6469616C6F672D2D6170657822293B242870292E66696E642822696672616D6522293B6F3D24286E292E6C656E6774683E3026262230223D3D24286E292E63737328226D617267696E2D6C65667422292E726570';
wwv_flow_api.g_varchar2_table(8) := '6C61636528227078222C2222293F34343A31322C693D617065782E6C616E672E666F726D617428692C2248656C70222C6F292C24286C292E61667465722869297D7D29292C242822626F647922292E6F6E2822636C69636B222C222E68656C7050616765';
wwv_flow_api.g_varchar2_table(9) := '222C2866756E6374696F6E286576656E74297B242E666E2E636C6173734C6973743D66756E6374696F6E28297B72657475726E20746869735B305D2E636C6173734E616D652E73706C6974282F5C732B2F297D3B76617220764576656E74546172676574';
wwv_flow_api.g_varchar2_table(10) := '3D24286576656E742E746172676574292C764469616C6F673D2428764576656E74546172676574292E636C6F7365737428226469762E75692D6469616C6F672D2D6170657822292C76506167653B696628313D3D764469616C6F672E6C656E677468297B';
wwv_flow_api.g_varchar2_table(11) := '7661722076694672616D653D2428764469616C6F67292E66696E642822696672616D6522293B76506167653D2428764469616C6F67292E66696E642822696672616D6522292E636F6E74656E747328292E66696E64282268746D6C22292E636C6173734C';
wwv_flow_api.g_varchar2_table(12) := '69737428295B305D2E7265706C6163652822706167652D222C2222297D656C73652076506167653D70466C6F775374657049642E76616C75653B617065782E7365727665722E706C7567696E28616A61784964656E7469666965722C7B7830313A765061';
wwv_flow_api.g_varchar2_table(13) := '67657D2C7B737563636573733A66756E6374696F6E287044617461297B7377697463682870446174612E77696E646F77297B636173652270616765223A617065782E6E617669676174696F6E2E72656469726563742870446174612E77696E646F775F75';
wwv_flow_api.g_varchar2_table(14) := '726C293B627265616B3B63617365226D6F64616C50616765223A6576616C2870446174612E77696E646F775F75726C293B627265616B3B64656661756C743A617065782E7468656D652E706F7075704669656C6448656C70287B7469746C653A70446174';
wwv_flow_api.g_varchar2_table(15) := '612E68656C705469746C652C68656C70546578743A70446174612E68656C70546578747D297D7D7D297D29297D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(4830034210582945)
,p_plugin_id=>wwv_flow_api.id(4520941116105406)
,p_file_name=>'helpPage.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done