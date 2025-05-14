Necro.Views.Admin.WeaponModal = Necro.Views.BaseModal.extend({
	templateName: 'modal-weapon',

	events: {
	},

	render: function() {
		this.$el.html(this.template({model: this.model.toJSON(), categories: Necro.Apps.Data.WeaponCategories, }));
		return this;
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