Necro.Views.GangListItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'gang-list-item',

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
		var data = {
			gang_name: this.model.get("gang_name"),
			gang_house: this.model.get("type_name"),
			gang_value: 0,
			gang_fighters: 0
		};
		this.$el.html(this.template(data));
		Necro.Events.trigger('stylize');
		return this.$el;
	},

});