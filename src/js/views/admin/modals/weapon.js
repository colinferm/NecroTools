Necro.Views.Admin.Modal.EditWeapon = Necro.Views.BaseModal.extend({
	templateName: 'modal-weapon',

	events: {
		'click .add_ammo': 'addAmmoType'
	},

	render: function() {
		console.log(this.model.toJSON());
		this.$el.html(this.template({
			model: this.model.toJSON(), 
			categories: Necro.Apps.Data.WeaponCategories
		}));
		let characteristics = this.model.get('characteristics');
		this.table = new Necro.Views.Admin.Modal.WeaponCharacteristicList({
			el: $('table.weapon-stats', this.$el), 
			collection: characteristics, 
			weaponId: this.model.id
		});
		
		return this;
	},

	addedTag: function(event) {
		var tag = event.detail.data;
		console.log(tag);
	},

	save: function(callback) {
        /* var m = this.model;
        m.set("trait_name", $('.trait_name', this.$el).val());
        m.set("trait_value", $('.trait_value', this.$el).val());
        m.set("notes", $('.notes', this.$el).val());

        m.save({
            success: callback(true, m),
            error: callback(false)
        }); */
	}

});

Necro.Views.Admin.Modal.WeaponCharacteristicList = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'modal-weapon-characteristic-list',
	newCharacteristicModel: null,

	events: {
		'click .add_ammo': 'addNewRow'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.collection.on('add', this.addAmmoType);
		this.render();
	},

	render: function() {
		this.$el.html(this.template);
		this.addAmmoTypes();
		return this;
	},

	addAmmoTypes: function() {
		_.each(this.collection.models, function(ammo) {
			this.addAmmoType(ammo);
		}, this);
	},

	addAmmoType: function(ammo) {
		var characteristic = new Necro.Views.Admin.Modal.WeaponCharacteristicListItem({model: ammo});
		$('.add_ammo_row', this.el).before(characteristic.render().$el);
	},

	addNewRow: function() {
		if (this.newCharacteristicModel) {
			this.newCharacteristicModel.save();
		}
		let char = new Necro.Models.WeaponCharacteristic({weapon_id: this.weaponId});
		this.collection.add(char);
		this.newCharacteristicModel = char;
	}
});

Necro.Views.Admin.Modal.WeaponCharacteristicListItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'modal-weapon-characteristic-list-item',
	tagsOptions: {
		id: 0,
		editTags: false,
		createInvalidTags: false,
		backspace: false,
		tagTextProp: 'trait_name',
		dropdown: {
			mapValueTo: 'trait_name',
			searchKeys: ['trait_name']
		},
		autoComplete: {
			tabKey: true
		}
	},

	events: {

	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		/* this.model.on("change", this.render, this);
		this.model.on("destroy", this.remove, this); */
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		this.$el.addClass("characteristic-id-" + this.model.id);
		this.$el.data('id', this.model.id);

		var options = this.tagsOptions;
		options.id = 'char-' + this.model.id;
		options.whitelist = Necro.Apps.Data.WeaponTraits;

		var input = this.$el.get(0).querySelector('[name="traits"]');
		var tagify = new Tagify(input, options);
		tagify.on('add', this.addedTag);

		return this;
	},

	addedTag: function(event) {
		var tag = event.detail.data;
		console.log(tag);
	}

});