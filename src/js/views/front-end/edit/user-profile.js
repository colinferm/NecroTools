Necro.Views.UserProfile = Necro.Views.ValidationView.extend({
	tagName: 'div',
	className: 'container',
	templateName: 'user-profile',
	pageTitle: 'Your Profile',

	events: _.extend({
		'click .saveButton': 'doSave'
	}, Necro.Views.ValidationView.prototype.events),

	initialize : function(options) {
		let html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		Necro.Events.on('user:verified', this.render, this);
	},

	render: function() {
		let profile = necro.session;
		this.$el.html(this.template({profile: profile.toJSON()}));
		$(".country_selector", this.$el).countrySelect({
			responsiveDropdown: true,
			preferredCountries: ['us', 'gb',  'de', 'fr', 'dk', 'no', 'se', 'ca']
		});
		return this;
	},

	checkValidation: function(field) {
		if (field.hasClass('email_address') || field.hasClass('username')) {
			var fieldName = "username";
			if (field.hasClass('email_address')) {
				fieldName = "email_address";
			}
			let origVal = necro.session.get(fieldName);

			if (field.val().length > 5 && field.val() != origVal) {
				this.validateInfo({field: fieldName, value: field.val()}, function(success){
					if (success) {
						field.removeClass('is-invalid').addClass('is-valid');
					} else {
						field.removeClass('is-valid').addClass('is-invalid');
						return;
					}
				});

			} else if (field.val() != origVal) {
				field.removeClass('is-valid').addClass('is-invalid');
				return;
			}
		}

		if (field.hasClass('password') && (field.val().length > 0 && field.val().length < 10)) {
			field.removeClass('is-valid').addClass('is-invalid');
			return;
		}

		if (field.hasClass('confirm_password') && field.val().length > 0 && field.val() != $('.password', this.$el).val()) {
			field.removeClass('is-valid').addClass('is-invalid');
			return;
		}

		field.removeClass('is-invalid').addClass('is-valid');
	},

	save: function() {
		let username = $('.username', this.$el).val();
		let email_address = $('.email_address', this.$el).val();
		let firstName = $('.first_name', this.$el).val();
		let lastName = $('.last_name', this.$el).val();
		let password = $('.password', this.$el).val();

		let countryData = $(".country_selector", this.$el).countrySelect("getSelectedCountryData");
		console.log(countryData);

		var user = {
			username: username,
			email_address: email_address,
			first_name: firstName,
			last_name: lastName
		}

		if (countryData) {
			user.country = countryData.iso2;
		}
		console.log(user);

		if (password.length > 0) {
			let confirmPassword = $('.confirm_password', this.$el).val();
			if (password != confirmPassword) return;
			user.userpassword = password
		}
		necro.session.url = function() {
			return this.urlRoot + this.id;
		};
		necro.session.urlRoot = "/api/user-profile/";
		necro.session.save(user);

	}

});