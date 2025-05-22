Necro.Views.Admin.Modal.EditTrait = Necro.Views.BaseModal.extend({
	templateName: 'modal-trait',

	events: {
	},

	render: function() {
		//this.$el.html(this.template(this.model.toJSON()));
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	},

	save: function(callback) {
        var m = this.model;
        m.set("trait_name", $('.trait_name', this.$el).val());
        m.set("trait_value", $('.trait_value', this.$el).val());
        m.set("notes", $('.notes', this.$el).val());

        m.save({
            success: callback(true, m),
            error: callback(false)
        });
	}

});