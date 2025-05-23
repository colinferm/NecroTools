Necro.Views.Admin.Modal.EditTrait = Necro.Views.BaseModal.extend({
	templateName: 'modal-trait',

	render: function() {
		//this.$el.html(this.template(this.model.toJSON()));
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	},

	checkValidation: function(field) {
		if (field.hasClass('trait_name') && field.val().length < 5) {
			field.addClass('is-invalid');
			return;
		}

		let numbers = /^[0-9]+$/;
		if (field.hasClass('trait_value') && (field.val().length == 0 || !field.val().match(numbers))) {
			field.addClass('is-invalid');
			return;
		}
		
		field.removeClass('is-invalid').addClass('is-valid');
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