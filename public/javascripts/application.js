function changing_input_onfocus(element, label) {
  if (!element.alreadyChanged) {
    element.value = label;
  }
}

function changing_input_onchange(element) {
  element.alreadyChanged = true;
}

function changing_input_onblur(element, label) {
  if (!element.alreadyChanged) {
    element.value = label;
  }
}

function number_workcamps() {
  tds = $('cart_workcamps_tbody').select('td.numbering');
  for (i = 0; i<tds.size(); i++) {
    tds[i].update((i+1) + ".");
  }
}
