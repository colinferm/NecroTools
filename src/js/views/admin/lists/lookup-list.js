Necro.Views.Admin.LookupList = Necro.Views.BaseListView.extend({
	tagName: 'div',
	templateName: 'lookup-list',
	pageTitle: 'Lookups',
	searchKey: 'lookup_value',

	events: _.extend({
		'click .addLookup': 'addLookup',
	}, Necro.Views.BaseListView.prototype.events),

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.collection = new Necro.Collections.Lookups();
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
		var row = new Necro.Views.Admin.LookupItem({model: item});
		$('tbody', this.$el).append(row.render().$el);
	},

	addLookup: function() {
		var m = new Necro.Models.Lookup();
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.Modal.EditLookup",
			title: "Add Lookup",
			model: m,
			callback: _.bind(function() {
				if (m) this.collection.add(m);
			}, this)
		});
	}

});

Necro.Views.Admin.LookupItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'lookup-list-item',

	events: {
		'click .action_edit': 'editLookup',
		'click .lookup_value': 'editLookup',
		'click .action_remove': 'deleteLookup'
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

	editLookup: function() {
		let m = this.model;
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.Modal.EditLookup",
			title: "Add Lookup",
			model: m,
		});
	},

	deleteLookup: function() {
		this.model.destroy();
	}

});