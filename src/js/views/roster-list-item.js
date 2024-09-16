Necro.Views.RosterItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'roster-list-item',

	events: {
		
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.fetch({
			success: _.bind(this.render, this)
		});
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		Necro.Events.trigger('stylize');
		return this.$el;
	},

});