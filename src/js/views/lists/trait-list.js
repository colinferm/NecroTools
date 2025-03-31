Necro.Views.TraitList = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'trait-list',
	pageTitle: 'Traits',

	events: {
		'click .addTrait': 'addTrait'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		this.collection = new Necro.Models.TraitCollection({});
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
		var row = new Necro.Views.TraitItem({model: item});
		$('tbody', this.$el).append(row.render().$el);
		Necro.Events.trigger('stylize');
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