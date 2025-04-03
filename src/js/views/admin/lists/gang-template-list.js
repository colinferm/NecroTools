Necro.Views.AdminGangList = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'gang-list',
	pageTitle: 'Gangs',

	events: {
		'click .add_gang': 'addGang'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

        this.collection = new Necro.Collections.Gangs({});
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
		var row = new Necro.Views.AdminGangItem({model: item});
		$('tbody', this.$el).append(row.render().$el);
	},

	addGang: function() {
		var m = new Necro.Models.Gang();
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.AdminGangEditModal",
			title: "Add Gang",
			model: m,
			callback: _.bind(function() {
				if (m) this.collection.add(m);
			}, this)
		});
	}

});

Necro.Views.AdminGangItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'gang-list-item',

	events: {
		'click .action_edit': 'editGang',
		'click .action_remove': 'deleteGang',
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.on("change", this.render, this);
		this.model.on("destroy", this.remove, this);
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		var menu = new Foundation.DropdownMenu($('ul.dropdown.menu', this.$el));
		return this;
	},

	editTrait: function() {
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.AdminGangEditModal",
			title: "Edit Trait",
			model: this.model
		});
	},

	deleteTrait: function() {
		this.model.destroy();
	}

});