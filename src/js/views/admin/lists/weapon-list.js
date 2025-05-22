Necro.Views.Admin.WeaponList = Backbone.View.extend({
	tagName: 'div',
	templateName: 'weapon-list',
	pageTitle: 'Weapons',

	events: {
		'click .addWeapon': 'addWeapon'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.collection = new Necro.Collections.Weapons();
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
		var row = new Necro.Views.Admin.WeaponItem({model: item});
		$('tbody', this.$el).append(row.render().$el);
	},

	addWeapon: function() {
		var weaponModel = new Necro.Models.Weapon({});
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.WeaponModal",
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
					class: "Necro.Views.Admin.WeaponModal",
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