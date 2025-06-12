Necro.Views.BaseListView = Backbone.View.extend({
	templateName: '',
	tagName: 'div',
	className: 'large-12',
	searchKey: 'id',
	appendSelector: 'tbody',
	actionButtonText: 'Action Button',
	itemClassName: 'Necro.Views.BaseListItemView',
	
	events: {
		'keyup': 'search',
		'.action_button': 'handleActionButton'
	},
	
	initialize : function(options) {
		var templateOpts = {
			actionButtonText: this.actionButtonText
		};
		if (this.onInitalize) this.onInitalize(templateOpts);
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html(templateOpts));
	},

	search: function(e) {
		if (e.keyCode !== 16) {
			if ($('.search_input', this.$el).is(":focus")) {
				let search = $('.search_input', this.$el).val();
				let key = this.searchKey;
				let items = this.collection.filter(function(item) {
					var searchCol = item.attributes[key].toLowerCase();
					if (searchCol.includes(search.toLowerCase())) return 1;
					return 0;
				})
				this.addItems(items);
			}
		}
	},

	addItems: function(items) {
		if (!items) items = this.collection.models;
		$(this.appendSelector, this.$el).empty()
		_.each(items, function(item) {
			this.addItem(item);
		}, this);
	},
	
	addItem: function(item) {
		if (this.beforeAddItem) this.beforeAddItem(item)
		var view = Necro.Utils.Resolver.getNewInstance(this.itemClassName, {model: item});
		$(this.appendSelector, this.$el).append(view.render().$el);
	},

	render: function() {
		this.$el.html(this.template);
		
		if (this.onRender) this.onRender();
		return this;
	},
	
	handleActionButton: function(e) {
		if (this.handleAction) this.handleAction();
	}

});

Necro.Views.BaseListItemView = Backbone.View.extend({
	templateName: '',
	tagName: 'tr',
	
	events: {},
	
	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		if (this.model) {
			this.model.on("change", this.render, this);
			this.model.on("destroy", this.remove, this);
		}
	},
	
	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	}
});