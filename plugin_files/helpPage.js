/*
 * Plugin:   APEX Help Page
 * Version:  1.0
 *
 * License:  MIT License Copyright 2022 Mark Lenzer.
 * Github:   https://github.com/madmexx2002/APEX-Help-Page
 * Mail:     ich@madmexx.com
 * Issues:   https://github.com/madmexx2002/APEX-Help-Page/issues
 *
 * Author:   Mark Lenzer
 */
function modalHelp(ajaxIdentifier) {
    /* Create a Help Button in a Modal Dialog Titlebar */
    $(document).on("dialogopen", function (event) {
        var vParent = $(event.target).parent();

        // Dont activate for iframes that aren't modal dialgos or when the ui-dialog--help class isn't set in the dialog settings
        if (
            !$(vParent).hasClass("ui-dialog--apex") ||
            !$(vParent).hasClass("helpPage--dialog")
        ) {
            return;
        }

        //  Add refresh button
        var vEventTarget = $(event.target),
            rBtnTitle = "Help",
            rBtn =
            '<button type="button" title="%0" aria-label="Help" ' +
            '    style="right:%1px;border-radius: 100%; width: 24px; height: 24px; padding:0;position: absolute;" ' +
            '    class="helpPage t-Button t-Button--noLabel t-Button--icon t-Button--small">' +
            '<span aria-hidden="true" class="ModalDialogHelp t-Icon fa fa-question"></span></button>',
            vTitle = $(vParent).find(".ui-dialog-title"),
            vDialogCloseBtn = $(vParent).find(".ui-dialog-titlebar-close"),
            vMargin = 0,
            vDialog = $(vEventTarget).closest("div.ui-dialog--apex"),
            viFrame = $(vDialog).find("iframe");

        // Position the help button left side of Close Button
        if (
            $(vDialogCloseBtn).length > 0 &&
            $(vDialogCloseBtn).css("margin-left").replace("px", "") == "0"
        ) {
            vMargin = 44;
        } else {
            vMargin = 12;
        }

        // Set Button title/tooltip and add Button
        rBtn = apex.lang.format(rBtn, rBtnTitle, vMargin);
        $(vTitle).after(rBtn);
    });

    /* Show Help for Modal Dialog */
    $("body").on("click", ".helpPage", function (event) {
        // Create jQuery Function classList
        $.fn.classList = function () {
            return this[0].className.split(/\s+/);
        };

        var vEventTarget = $(event.target),
            vDialog = $(vEventTarget).closest("div.ui-dialog--apex");
        var vPage;

        // Search for PAGE_ID
        if (vDialog.length == 1) {
            // iframe (Modal Dialog)
            vPage = $(vDialog)
                .find("iframe")
                .contents()
                .find("html")
                .classList()[0]
                .replace("page-", "");
        } else {
            // not a iframe (Normal Page)
            vPage = pFlowStepId.value;
        }

        // Call application process MODAL_PAGE_HELP and show result
        apex.server.plugin(
            ajaxIdentifier, {
                x01: vPage,
            }, {
                success: function (pData) {
                    switch (pData.window) {
                        case "page":
                            // Normal page
                            apex.navigation.redirect(pData.window_url);
                            break;
                        case "modalPage":
                            // Modal page
                            eval(pData.window_url);
                            break;
                        default:
                            // Show in theme popup
                            apex.theme.popupFieldHelp({
                                title: pData.helpTitle,
                                helpText: pData.helpText,
                            });
                    }
                },
            }
        );
    });
}
