Necro.Views.BaseModal = Backbone.View.extend({
	class: "row",

	initialize : function(options) {
		this.opts = options;
		this.model = options.model;
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

	save: function(callback) {
		callback(true);
	}

});