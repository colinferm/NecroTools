Necro.Views.Admin.AdminView = Backbone.View.extend({
	tagName: 'div',
	className: 'container admin-home',
	templateName: 'admin-view',
	pageTitle: 'Welcome to Hell',

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

	render: function() {
		this.$el.html(this.template);
		return this;
	}

});