Necro.Views.RightContent = Backbone.View.extend({
	tagName: 'div',
	className: 'col-10 mb-5 right-content',
	templateName: 'right-content',
	pageTitle: 'Blah',

	initialize : function(options) {
		Necro.Events.on('right:title:change', _.bind(this.render, this));
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

	render: function() {
		this.$el.html(this.template({title: this.pageTitle}));
		return this;
	}

});