Necro.Views.Admin.WeaponModal = Necro.Views.BaseModal.extend({
	templateName: 'modal-weapon',
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
		'click .add_ammo': 'addAmmoType'
	},

	render: function() {
		console.log(this.model.toJSON());
		this.$el.html(this.template({
			model: this.model.toJSON(), 
			categories: Necro.Apps.Data.WeaponCategories
		}));

		var chars = this.model.get("characteristics");

		for(var i = 0; i < chars.models.length; i++) {
			var characteristics = chars.models[i];
			var traits = characteristics.get("traits");

			var options = this.tagsOptions;
			options.id = 'char-' + characteristics.id;
			options.whitelist = Necro.Apps.Data.WeaponTraits;

			console.log(traits);
			var className = '.characteristic-id-' + characteristics.id;
			console.log(className);
			var row = $('.characteristic-id-' + characteristics.id, this.el).get(0);
			console.log(row);
			var input = row.querySelector('[name="traits"]');

			var tagify = new Tagify(input, options);
			tagify.addTags(traits);
			tagify.on('add', _.bind(this.addedTag, this));
		}

		return this;
	},

	addAmmoType: function() {
		$('.add_ammo').attr('disabled', '');
		var row = $('.ammo_type_row.sample-row', this.el).first().clone();
		row.removeClass('sample-row');
		$('.add_ammo_row', this.el).before(row);

		var options = this.tagsOptions;
		options.whitelist = Necro.Apps.Data.WeaponTraits;

		var input = row.get(0).querySelector('[name="traits"]');
		var tagify = new Tagify(input, options);
		tagify.on('add', this.addedTag);
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