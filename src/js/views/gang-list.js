Necro.Views.GangList = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'gang-list',
	pageTitle: 'Gangs',

	events: {
		'click .addGang': 'addGang'
	},

	initialize : function(options) {
		_.bindAll(this, 'addGang');

		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		this.collection = new Necro.Models.GangCollection({});
		//this.listenTo(this.collecton, 'update', this.addItems)
		this.collection.fetch({
			success: _.bind(this.addItems, this)
		});
	},

	render: function() {
		this.$el.html(this.template());
		return this.$el;
	},

	addItems: function() {
		$('tbody', this.el).empty()
		_.each(this.collection.models, function(model) {
			var item = new Necro.Views.GangListItem({model: model});
			$('tbody', this.el).append(item.render());
		});
	},

	addGang: function() {
		necro.navigate("roster", {trigger: true});
	}

});