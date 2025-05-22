Necro.Views.Admin.Modal.Wargear = Necro.Views.BaseModal.extend({
	templateName: 'modal-edit-wargear',

	events: {
	},

	render: function() {
		this.$el.html(this.template({model: this.model.toJSON(), categories: Necro.Apps.Data.WargearCategories}));
		return this;
	},

	save: function(callback) {
		var m = this.model;
		let name = $('.wargear_name', this.$el).val();
		let catId = $('[name="category_name"]', this.$el).val();
		let value = $('.weapon_value', this.$el).val();
		let rarity = $('.rarity', this.$el).val();
		let notes = $('.notes', this.$el).val();

		let wargear = {
			weapon_name: name,
			weapon_category_id: catId,
			weapon_value: value,
			rarity: rarity,
			notes: notes,
			is_wargear: 1
		};
		console.log(wargear);

		m.save(wargear, {
			sucess: callback(true, m),
			failure: callback(false)
		});
	}

});