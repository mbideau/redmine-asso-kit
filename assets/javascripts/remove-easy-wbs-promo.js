$(function() {
  function removeYsyPromo() {
    if($('#wbs_legend').length != 0) {
      $('#wbs_legend').unbind('click');
      $('#wbs_legend #hotkey_link').insertAfter('#wbs_menu .menu-item.legend-toggler').addClass('menu-item').addClass('hotkeys').find('a').first().html('Raccourcis Clavier');
    }
  };
  var ysyHackTimeoutId = window.setTimeout(function() {
    window.clearTimeout(ysyHackTimeoutId);
    removeYsyPromo();
    if($('#wbs_legend').length == 0) {
      ysyHackTimeoutId = window.setTimeout(function() {
        window.clearTimeout(ysyHackTimeoutId);
        removeYsyPromo();
      }, 2000);
    }
  }, 500);
});
