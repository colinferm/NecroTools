Necro.Views.Roster = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'roster-list',
	pageTitle: 'Gang',

	events: {
		
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		if (this.model.get("id")) {
			this.model.fetch({
				success: _.bind(this.addItems, this)
			});
		}
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		return this.$el;
	},

	addItems: function() {
		$('tbody', this.el).empty()
		_.each(this.model.get("fighters").models, function(model) {
			var item = new Necro.Views.RosterItem({model: model});
			$('tbody', this.el).append(item.render());
		});
		Necro.Events.trigger('stylize');
	}

});