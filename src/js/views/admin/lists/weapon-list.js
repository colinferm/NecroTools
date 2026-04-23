Necro.Views.Admin.WeaponList = Necro.Views.BaseListView.extend({
	tagName: 'div',
	templateName: 'weapon-list',
	pageTitle: 'Weapons',
	searchKey: 'weapon_name',
	filterProp: 'category_id',
	filterName: 'category_name',
	filterSelector: "#filterByCategory",

	events: _.extend({
		'click .addWeapon': 'addWeapon',
	}, Necro.Views.BaseListView.prototype.events),

	onInitialize : function(options) {
		this.filterCollection = Necro.Apps.Data.WeaponCategories;
		this.collection = new Necro.Collections.Weapons();
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
		var row = new Necro.Views.Admin.WeaponItem({model: item});
		$('tbody', this.$el).append(row.render().$el);
	},

	addWeapon: function() {
		var weaponModel = new Necro.Models.Weapon({});
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.Modal.EditWeapon",
			title: "Add Weapon",
			modalSize: 'modal-xl',
			model: weaponModel
		});
	}

});

Necro.Views.Admin.WeaponItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'weapon-list-item',

	events: {
		'click .action_edit': 'editWeapon',
		'click .weapon_name': 'editWeapon'
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

	editWeapon: function() {
		this.model.fetch({
			success: _.bind(function() {
				var modal = new Necro.Views.Modal({
					class: "Necro.Views.Admin.Modal.EditWeapon",
					title: "Edit Weapon",
					modalSize: 'modal-xl',
					model: this.model
				});
			}, this)
		});
	},

	deleteWeapon: function() {
		this.model.destroy();
	}

});