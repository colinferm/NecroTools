Necro.Views.GangList = Backbone.View.extend({
	tagName: 'table',
	className: 'hover',
	templateName: 'gang-list',
	pageTitle: 'Log In',

	events: {
		
	},

	initialize : function(options) {
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
	}

});