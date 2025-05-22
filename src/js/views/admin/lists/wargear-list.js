Necro.Views.Admin.WargearList = Necro.Views.BaseListView.extend({
	tagName: 'div',
	templateName: 'wargear-list',
	pageTitle: 'Wargear',
	searchKey: 'weapon_name',

	events: _.extend({
		'click .addWargear': 'addWargear'
	}, Necro.Views.BaseListView.prototype.events),

	initialize : function(options) {
		let html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		this.collection = new Necro.Collections.Wargear({});
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
		var row = new Necro.Views.Admin.WargearItem({model: item});
		$('tbody', this.$el).append(row.render().$el);
	},

	addWargear: function() {
		var wargear = new Necro.Models.Wargear({});
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.Modal.Wargear",
			title: "Add Wargear",
			modalSize: 'modal-md',
			model: wargear,
			callback: _.bind(function() {
				if (wargear) this.collection.add(wargear);
			}, this)
		});
	}

});

Necro.Views.Admin.WargearItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'wargear-list-item',

	events: {
		'click .weapon_name': 'editGear',
		'click .action_edit': 'editGear',
		'click .action_remove': 'deleteGear',
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

	editGear: function() {
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.Modal.Wargear",
			title: "Edit Wargear",
			modalSize: 'modal-md',
			model: this.model
		});
	},

	deleteGear: function() {
		this.model.destroy();
	}

});