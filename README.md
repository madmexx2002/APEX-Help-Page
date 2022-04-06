# APEX-Help-Page
Is a dynamic action plugin to show the page help and could replace the apex way of page help. It's also possible to render a help button in the title bar of a modal dialog. 

Just set the `pageHelp--dialog` class in the CSS Classes field in the Dialog Section of the related page. 

The help page can be shown on a user defined page (For example, the wizard created help page) or in a popup window.

The help page can be triggered from a button or navigation bar entry, too. Just set the class `pageHelp`. 

https://github.com/madmexx2002/APEX-Help-Page/blob/5620bb9ad693c1be65d5a944cdd2aa13ed214b2f/demo.mp4


## Setup

Load plugin in on global page (0) on Page Load. If you have a custom help page go to the plugin settings and select page id and item (plugin will store the page id in this item). For a example of a custom help page create a new page with feature wizard "About Page".  
