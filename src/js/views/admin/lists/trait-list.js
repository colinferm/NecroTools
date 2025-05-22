Necro.Views.TraitList = Necro.Views.BaseListView.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'trait-list',
	pageTitle: 'Weapon Traits',
	searchKey: 'trait_name',

	events: _.extend({
		'click .addTrait': 'addTrait',
	}, Necro.Views.BaseListView.prototype.events),

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		this.collection = new Necro.Collections.Traits({});
		this.collection.on("add", this.addItem, this);
		this.collection.fetch();
	},

	addItems: function(items) {
		if (!items) items = this.collection.models;
		$('tbody', this.$el).empty()
		_.each(items, function(model) {
			this.addItem(model);
		}, this);
	},

	addItem: function(item) {
		var row = new Necro.Views.TraitItem({model: item});
		$('tbody', this.$el).append(row.render().$el);
	},

	addTrait: function() {
		var m = new Necro.Models.Trait();
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.TraitModal",
			title: "Add Trait",
			model: m,
			callback: _.bind(function() {
				if (m) this.collection.add(m);
			}, this)
		});
	}

});

Necro.Views.TraitItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'trait-list-item',

	events: {
		'click .trait_name': 'editTrait',
		'click .action_edit': 'editTrait',
		'click .action_remove': 'deleteTrait'
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
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.TraitModal",
			title: "Edit Trait",
			model: this.model
		});
	},

	deleteTrait: function() {
		this.model.destroy();
	}

});