Necro.Views.Admin.WargearList = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'wargear-list',
	pageTitle: 'Wargear',

	events: {
		'click .addWargear': 'addWargear'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

	render: function() {
		this.$el.html(this.template);
		return this;
	},

	addItems: function() {
		$('tbody', this.$el).empty()
		_.each(this.collection.models, function(model) {
			this.addItem(model);
		}, this);
	},

	addItem: function(item) {
		var row = new Necro.Views.Admin.WargearItem({model: item});
		$('tbody', this.$el).append(row.render().$el);
	},

	addWargear: function() {
		
	}

});

Necro.Views.Admin.WargearItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'wargear-list-item',

	events: {
		'click .action_edit': 'editTrait',
		'click .action_remove': 'deleteTrait',
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.on("change", this.render, this);
		this.model.on("destroy", this.remove, this);
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		//var menu = new Foundation.DropdownMenu($('ul.dropdown.menu', this.$el));
		return this;
	},

	editTrait: function() {

	},

	deleteTrait: function() {
		this.model.destroy();
	}

});