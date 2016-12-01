function toggleAccountMenuDropdown() {
  var dropdown = $('#tasks + ul.menu-children');
  if(dropdown.hasClass('visible')){
    dropdown.removeClass('visible');
  }else{
    dropdown.addClass('visible');
  }
}
