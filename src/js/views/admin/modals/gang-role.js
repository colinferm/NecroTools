Necro.Views.Admin.Modal.GangRoleEdit = Necro.Views.BaseModal.extend({
	templateName: 'modal-gang-role',

	render: function() {
		var template = this.model.get("template");
		if (!template) {
			template = new Necro.Models.FighterTemplate({gang_type_id: this.model.get('gang_type_id'), fighter_role: this.model.id});
			this.model.set("template", template);
		}
		this.$el.html(this.template({model: this.model.toJSON(), template: template.toJSON(), roles: Necro.Apps.Data.RoleClasses}));
		return this;
	},

	checkValidation: function(field) {
		if (field.hasClass('role_name') && field.val() < 3) {
			field.addClass('is-invalid');
			return;
		}

		let numbers = /^[0-9]+$/;
		if (field.hasClass('base_value') && (field.val().length == 0 || !field.val().match(numbers))) {
			field.addClass('is-invalid');
			return;
		}

		if (field.hasClass('num_start_skills') && (field.val().length == 0 || !field.val().match(numbers))) {
			field.addClass('is-invalid');
			return;
		}

		field.removeClass('is-invalid').addClass('is-valid');
	},

	save: function(callback) {
		let roleName = $('.role_name', this.$el).val();
		let baseValue = $('.base_value', this.$el).val();
		let hierarchy = $('[name="hierarchy_role"]', this.$el).val();

		let numStartSkills = $('.num_start_skills', this.$el).val();
		if (!numStartSkills) numStartSkills = 0;

		var isVehicle = ($('.isVehicle', this.$el).is(':checked')) ? 1 : 0;
		var isDramatis = ($('.isDramatis', this.$el).is(':checked')) ? 1 : 0;

		var m = this.model;
		m.set("role_name", roleName);
		m.set("hierarchy_role", hierarchy);

		var t = this.model.get("template");
		t.set("base_value", baseValue);
		t.set("num_start_skills", numStartSkills);
		t.set("is_vehicle", isVehicle);
		t.set("is_dramatis", isDramatis);

		m.save(null, {
			success: function(mo, r, o) {
				t.set("fighter_role", m.id);
				t.save(null, {
					success: callback(true, m),
					error: callback(false)
				})
			},
			error: function(mo, r, o) {
				console.log(r);
				callback(false);
			}
		});
	}

});