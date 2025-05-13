Necro.Views.Admin.WargearList = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'wargear-list',
	pageTitle: 'Traits',

	events: {
		'click .addTrait': 'addWargear'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		this.collection = new Necro.Collections.Traits({});
		this.collection.fetch({
			success: _.bind(this.addItems, this)
		});
		this.collection.on("add", this.addItems, this);
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

	addWargear
    : function() {
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