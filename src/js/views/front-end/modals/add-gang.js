Necro.Views.User.Modal.AddGang = Necro.Views.BaseModal.extend({
	templateName: 'modal-add-gang',

	render: function() {
		this.$el.html(this.template({
			model: this.model.toJSON()
		}));
		return this;
	},

	checkValidation: function(field) {
		if (field.is('[name="gang_type"]')) {
			if (field.val() == 0) {
				field.addClass('is-invalid');
				return;
			}
		}
		let numbers = /^[0-9]+$/;
		if (field.hasClass('credits') && (field.val().length == 0 || !field.val().match(numbers))) {
			field.addClass('is-invalid');
			return;
		}

		if (field.hasClass('gang_name') && field.val().length <= 5) {
			field.addClass('is-invalid');
			return;
		}
		
		field.addClass('is-valid').removeClass('is-invalid');
	},

	save: function(callback) {
		let m = this.model;

		let gangTypeId = $('[name="gang_type"]', this.$el).val();
		let gangName = $('.gang_name', this.$el).val();
		let credits = $('.credits', this.$el).val();
		var outlaw = ($('.isOutlaw', this.$el).is(":checked")) ? 1 : 0;

		var gang = {
			gang_name: gangName,
			gang_type_id: gangTypeId,
			outlaw: outlaw,
			credits: credits
		};

		for (var i = 0; i < Necro.Apps.Data.GangTypes.length; i++) {
			var g = Necro.Apps.Data.GangTypes[i];
			if (g.id == gangTypeId) {
				gang.type_name = g.type_name;
				break;
			}
		}

		m.set(gang);
		m.save(null, {
			success: callback(true, m),
			error: callback(false)
		});
	}
});