Necro.Views.Admin.Modal.SkillEdit = Necro.Views.BaseModal.extend({
	templateName: 'modal-edit-skill',

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	},

	checkValidation: function(field) {
		if (field.hasClass('skill_name') && field.val().length < 5) {
			field.addClass('is-invalid');
			return;
		}
		field.removeClass('is-invalid').addClass('is-valid');
	},

	save: function(callback) {
        var m = this.model;
        m.set("skill_name", $('.skill_name', this.$el).val());
        m.set("skill_description", $('.skill_description', this.$el).val());

        m.save({
            success: callback(true, m),
            error: callback(false)
        });
	}

});