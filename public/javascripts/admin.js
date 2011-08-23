///////////////////////////////////////////////////////////////////////////////////////////
// TINY_MCE INTEGRATION
//
// Used receipt at
//
// http://walksalong.wordpress.com/2008/02/14/getting-tinymce-to-work-with-activescaffold/
//
// Other changes are marked by 'HACK_TINYMCE' comment in the vendor files.
//
function rails_init_tinyMCE(){
    if (!tinyMCE) {
                alert('Warning - TinyMCE plugin not present!')
                return;
        }

    tinyMCE.isLoaded = false;

        tinyMCE.init({
	         content_css : '/stylesheets/article.css',
                 mode: 'specific_textareas',
                 editor_deselector : /(no_rich_text|no_widgets)/,
                 // editor_selector : /rich_text/,
                 entity_encoding: 'raw',
                 theme:'advanced',
                 theme_advanced_toolbar_location : "top",
                 theme_advanced_buttons1 : "undo,redo,separator,cut,copy,paste,separator,bold,italic,underline,separator,bullist,numlist,separator,outdent,indent,separator,justifyleft,justifyright,justifycenter,justifyfull",
                 theme_advanced_buttons2 : "tablecontrols,separator,formatselect,separator,link, unlink, image,anchor,code",
                 theme_advanced_buttons3 : "",
	         theme_advanced_blockformats : "h1,h2,h3,h4,h5,h6",
                 plugins : 'advimage, advlink, table'
                });

    tinyMCE.onLoad();
		true;
}

function rails_update_from_tinyMCE(form){
    if (!tinyMCE || !form) {
                alert('Warning - TinyMCE plugin not present!')
                return;
        }

    tinyMCE.triggerSave();
}

rails_init_tinyMCE();
