Necro.Views.Admin.WeaponList = Backbone.View.extend({
	tagName: 'div',
	templateName: 'weapon-list',
	pageTitle: 'Weapons',

	events: {
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
		var row = new Necro.Views.Admin.WargearItem({model: item});
		$('tbody', this.$el).append(row.render().$el);
	},

});

Necro.Views.Admin.WargearItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'weapon-list-item',

	events: {
		'click .action_edit': 'editWeapon'
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
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.WeaponModal",
			title: "Edit Weapon",
			modalSize: 'modal-lg',
			model: this.model
		});
	},

	deleteWeapon: function() {
		this.model.destroy();
	}

});