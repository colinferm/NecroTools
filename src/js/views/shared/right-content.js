Necro.Views.RightContent = Backbone.View.extend({
	tagName: 'div',
	className: 'cell large-9 grid-x right-content',
	templateName: 'right-content',
	pageTitle: 'Blah',

	initialize : function(options) {
		Necro.Events.on('right:title:change', _.bind(this.render, this));
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

	render: function() {
		this.$el.html(this.template({title: this.pageTitle}));
		return this.$el;
	}

});