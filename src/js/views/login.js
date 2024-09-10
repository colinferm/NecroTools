Necro.Views.Login = Backbone.View.extend({
	tagName: 'div',
	className: 'large-6',
	templateName: 'login',
	pageTitle: 'Blah',

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

	render: function() {
		this.$el.html(this.template());
		return this.$el;
	}

});