//
// Functions used only to show image list within TinyMCE/AdvImage plugin.
//
//

function select_image_in_browser(thumb_id, path) {
  document.getElementById('src').value = path;
  new Effect.Shake(thumb_id);
}

function mouse_on_image(thumb_id) {
  $(thumb_id).setStyle("border: 1px solid black;");
}

function mouse_out_image(thumb_id) {
  $(thumb_id).setStyle("border: 1px solid white;");
}

