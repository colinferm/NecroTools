Necro.Views.Admin.Modal.EditArchetype = Necro.Views.BaseModal.extend({
	templateName: 'modal-archetype',

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	},

	checkValidation: function(field) {
		if (field.hasClass('archetype_name') && field.val().length < 5) {
			field.addClass('is-invalid');
			return;
		}
		
		field.removeClass('is-invalid').addClass('is-valid');
	},

	save: function(callback) {
        var m = this.model;
        m.set("archetype_name", $('.archetype_name', this.$el).val());
        m.set("archetype_description", $('.archetype_description', this.$el).val());

		let isWyrd = ($(".is_wyrd", this.$el).is(':checked')) ? 1 : 0;
		m.set("is_wyrd", isWyrd);

		console.log("New? " + m.isNew());

        m.save({
            success: callback(true, m),
            error: callback(false)
        });
	}

});