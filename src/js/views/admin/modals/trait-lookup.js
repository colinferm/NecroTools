Necro.Views.Admin.Modal.EditTrait = Necro.Views.BaseModal.extend({
	templateName: 'modal-trait',

	render: function() {
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

Necro.Views.Admin.Modal.EditLookup = Necro.Views.Admin.Modal.EditTrait.extend({
	templateName: 'modal-lookup',

	render: function() {
		this.$el.html(this.template({gangTypes: Necro.Apps.Data.GangTypes, model: this.model.toJSON()}));
		return this;
	},

	checkValidation: function(field) {
		if (field.hasClass('lookup_value') && field.val().length < 5) {
			field.addClass('is-invalid');
			return;
		}

		if (field.hasClass('lookup_key') && field.val().length < 5) {
			field.addClass('is-invalid');
			return;
		}

		let numbers = /^[0-9]+$/;
		if (field.hasClass('misc_value') && (field.val().length == 0 || !field.val().match(numbers))) {
			field.addClass('is-invalid');
			return;
		}

		var specialAttr = $('.is_special_attribute', this.$el).is(":checked");
		if (field.hasClass('is_special_attribute')) {
			if (specialAttr) {
				$('[name="gang_type"]', this.$el).prop('disabled', false);
				$('.is_gang_related', this.$el).prop('disabled', false);
				$('.is_fighter_related', this.$el).attr('disabled', false);
			} else {
				$('[name="gang_type"]', this.$el).prop('disabled', true);
				$('.is_gang_related', this.$el).prop('disabled', true);
				$('.is_fighter_related', this.$el).attr('disabled', true);
			}
		}

		let gangSelection = $('[name="gang_type"]', this.$el);
		if (specialAttr && gangSelection.val() == 0)  {
			gangSelection.addClass('is-invalid');
			return;
		}

		var selectedVal = field.val();
		if (field == gangSelection && specialAttr && field.val() == "0") {
			field.addClass('is-invalid');
			return;
		}

		
		field.removeClass('is-invalid').addClass('is-valid');
	},

	save: function(callback) {
        var m = this.model;
        m.set("lookup_key", $('.lookup_key', this.$el).val());
		m.set("lookup_value", $('.lookup_value', this.$el).val());
        m.set("misc_value", $('.misc_value', this.$el).val());
        m.set("notes", $('.notes', this.$el).val());

		let isSpecial = $('.is_special_attribute', this.$el).is(":checked") ? 1 : 0;
		m.set("is_special_attribute", isSpecial);

		if (isSpecial == 1) {
			let isGangRelated = $('.is_gang_related', this.$el).is(":checked") ? 1 : 0;
			m.set("is_gang_related", isGangRelated);

			let isFighterRelated = $('.is_fighter_related', this.$el).is(":checked") ? 1 : 0;
			m.set("is_fighter_related", isFighterRelated);

			var gangTypeId = $('[name="gang_type"]', this.$el).val();
			if (gangTypeId == 0) gangTypeId = null;
			m.set("gang_type_id", gangTypeId);

		} else {
			m.set("is_gang_related", 0);
			m.set("is_fighter_related", 0);
			m.set("gang_type_id", null);
		}

        m.save({
            success: callback(true, m),
            error: callback(false)
        });
	}

});