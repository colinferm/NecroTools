Necro.Views.BaseModal = Backbone.View.extend({
	templateName: 'modal-injury',

	initialize : function(options) {
		this.opts = options;
		this.model = options.model;
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

	save: function(cb) {
		cb(true);
	}

});