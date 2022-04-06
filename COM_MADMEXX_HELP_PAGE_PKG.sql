CREATE OR REPLACE package COM_MADMEXX_HELP_PAGE_PKG authid DEFINER as 

   /*
    * Plugin:   APEX Help Page
    * Version:  1.0
    *
    * License:  MIT License Copyright 2022 Mark Lenzer.
    * Github:   https://github.com/madmexx2002/APEX-Help-Page
    * Issues:   https://github.com/madmexx2002/APEX-Help-Page/issues
    *
    * Author:   Mark Lenzer
    */

   function APEX_PLUGIN_RENDER(
      P_DYNAMIC_ACTION in APEX_PLUGIN.T_DYNAMIC_ACTION
    , P_PLUGIN         in APEX_PLUGIN.T_PLUGIN)
      return APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT;

   function APEX_PLUGIN_AJAX(
      P_DYNAMIC_ACTION in APEX_PLUGIN.T_DYNAMIC_ACTION
    , P_PLUGIN         in APEX_PLUGIN.T_PLUGIN)
      return APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT;

end COM_MADMEXX_HELP_PAGE_PKG;
/


CREATE OR REPLACE package body COM_MADMEXX_HELP_PAGE_PKG as

   function APEX_PLUGIN_RENDER(
      P_DYNAMIC_ACTION in APEX_PLUGIN.T_DYNAMIC_ACTION
    , P_PLUGIN         in APEX_PLUGIN.T_PLUGIN)
      return APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT is
      L_RESULT APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT;
   begin
      L_RESULT.AJAX_IDENTIFIER     := APEX_PLUGIN.GET_AJAX_IDENTIFIER;

      if APEX_APPLICATION.G_DEBUG then
         APEX_PLUGIN_UTIL.DEBUG_DYNAMIC_ACTION(
            P_PLUGIN         => P_PLUGIN
          , P_DYNAMIC_ACTION => P_DYNAMIC_ACTION);
      end if;

      L_RESULT.JAVASCRIPT_FUNCTION := 'modalHelp('
                                      || APEX_JAVASCRIPT.ADD_VALUE(APEX_PLUGIN.GET_AJAX_IDENTIFIER, FALSE)
                                      || ')';

      return L_RESULT;
   end APEX_PLUGIN_RENDER;

   /* ====================================================================================================================================================================================  */

   function APEX_PLUGIN_AJAX(
      P_DYNAMIC_ACTION in APEX_PLUGIN.T_DYNAMIC_ACTION
    , P_PLUGIN         in APEX_PLUGIN.T_PLUGIN)
      return APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT is
      EX_NO_PAGE   exception;
      L_RESULT     APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT;
      L_PAGE       pls_integer           := APEX_APPLICATION.G_X01;
      L_PAGE_TITLE APEX_APPLICATION_PAGES.PAGE_TITLE%type;
      L_HELP_TEXT  APEX_APPLICATION_PAGES.HELP_TEXT%type;
      K_HELP_TEXT  constant varchar2(64) := P_DYNAMIC_ACTION.ATTRIBUTE_06;
      L_WINDOW     varchar2(16);
      L_WINDOW_URL varchar2(4000)        := 'Empty';
   begin
      
      -- Check PAGE_ID
      if L_PAGE is null then
         raise EX_NO_PAGE;
      end if;
      
      -- IF 'Y' use custom help page
      if P_DYNAMIC_ACTION.ATTRIBUTE_03 = 'Y' then
         L_WINDOW_URL := APEX_PAGE.GET_URL(
                            P_PAGE   => P_DYNAMIC_ACTION.ATTRIBUTE_04
                          , P_ITEMS  => P_DYNAMIC_ACTION.ATTRIBUTE_05
                          , P_VALUES => L_PAGE
                         );
         -- Standard page or modal dialog                
         if INSTR(L_WINDOW_URL, 'javascript') > 0 then
            L_WINDOW     := 'modalPage';
            L_WINDOW_URL := REPLACE(L_WINDOW_URL, 'javascript:', '');
         else
            L_WINDOW := 'page';
         end if;
      
      -- Load build-in page help from Application Builder
      else
         -- Show with popup
         L_WINDOW := 'popup';
         
         -- Load help
         select HELP_TEXT into L_HELP_TEXT
           from APEX_APPLICATION_PAGES
          where APPLICATION_ID = APEX_APPLICATION.G_FLOW_ID
            and PAGE_ID = L_PAGE;

      end if;

      -- Return JSON with page, helptext und window title
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('page', L_PAGE);
      APEX_JSON.WRITE('helpTitle', APEX_LANG.MESSAGE('APEX.DIALOG.HELP'));
      APEX_JSON.WRITE('helpText', COALESCE(L_HELP_TEXT, K_HELP_TEXT));
      APEX_JSON.WRITE('window', L_WINDOW);
      APEX_JSON.WRITE('window_url', L_WINDOW_URL);
      APEX_JSON.CLOSE_ALL;

      return L_RESULT;

   exception
      when others then
         APEX_JSON.OPEN_OBJECT;
         APEX_JSON.WRITE('error', 'Error. Page help could not be loaded.');
         APEX_JSON.CLOSE_ALL;
         return L_RESULT;
   end APEX_PLUGIN_AJAX;

end COM_MADMEXX_HELP_PAGE_PKG;
/
