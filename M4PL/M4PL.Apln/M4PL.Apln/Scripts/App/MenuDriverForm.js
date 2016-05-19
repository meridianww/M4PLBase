
function MenuRibbonIndexChanged() {
    if (rdblstMenuRibbon.GetValue())
        $('#dvRibbon').css("display", "");
    else
        $('#dvRibbon').css("display", "none");
}

