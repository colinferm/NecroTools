Necro.Views.GangListItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'gang-list-item',

	events: {
		'click .action_edit': 'editGang'
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

	editGang: function() {
		//necro.rosterForm(this.model.get("id"), this.model);
		necro.navigate("roster/"+this.model.get("id"));
	}

});