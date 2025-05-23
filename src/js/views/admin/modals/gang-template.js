Necro.Views.Admin.Modal.GangTemplate = Necro.Views.BaseModal.extend({
	templateName: 'modal-gang-template',

	render: function() {
		this.$el.html(this.template({model: this.model.toJSON()}));
		return this;
	},

	checkValidation: function(field) {
		if (field.hasClass('gangName') && field.val().length <= 5) {
			field.addClass('is-invalid');
			return;
		}
		field.removeClass('is-invalid').addClass('is-valid');
	},

	save: function(callback) {
		var gangName = $('.gangName', this.$el).val();
		var description = $('.gangDescription', this.$el).html();
		var houseGang = ($('.isHouseGang', this.$el).is(':checked')) ? 1 : 0;
		var outlaw = ($('.isOutlaw', this.$el).is(':checked')) ? 1 : 0;

		var m = this.model;
		m.set("type_name", gangName);
		m.set("gang_description", description);
		m.set("house_gang", houseGang);
		m.set("outlaw", outlaw);

		m.save({
			success: callback(true, m),
			error: callback(false)
		});
	}

});