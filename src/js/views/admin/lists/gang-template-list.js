Necro.Views.Admin.GangList = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'gang-template-list',
	pageTitle: 'Admin Gang Lists',
	model: null,

	events: {
		'click .add_gang': 'addGang'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

        this.collection = new Necro.Collections.GangTypes({});
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
		var row = new Necro.Views.Admin.GangItem({model: item});
		$('tbody', this.$el).append(row.render().$el);
	},

	addGang: function() {
		var m = new Necro.Models.Gang();
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.GangEditModal",
			title: "Add Gang",
			model: m,
			callback: _.bind(function() {
				if (m) this.collection.add(m);
			}, this)
		});
	}

});

Necro.Views.Admin.GangItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'gang-template-list-item',

	events: {
		'click .type_name': 'editGang',
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

	editGang: function() {
		necro.passMode = this.model;
		necro.navigate("adminGangs/" + this.model.get("id"), true);
	},

	deleteGang: function() {
		this.model.destroy();
	}

});