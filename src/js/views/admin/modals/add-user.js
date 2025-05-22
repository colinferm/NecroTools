Necro.Views.Admin.Modal.AddSiteUser = Necro.Views.BaseModal.extend({
	templateName: 'modal-add-user',

	events: {
		'click [name="generatePassword"]': 'showHidePasswords',
		'click [type="checkbox"].permission_box': 'handlePermissions',
		'focusout .emailInput': 'checkFieldValid',
		'focusout .usernameInput': 'checkFieldValid'
	},

	render: function() {
		this.$el.html(this.template({model: this.model.toJSON(), isNew: this.model.isNew(), permissions: Necro.Apps.Data.UserPermissions.toJSON()}));
		return this;
	},

	save: function(callback) {
		let roleNameField = $('.role_name', this.$el);

		var userName = $('.usernameInput', this.$el).val();
		var emailAddr = $('.emailInput', this.$el).val();
		var password = $('.passwordInput', this.$el).val();
		var firstName = $('.firstNameInput', this.$el).val();
		var lastName = $('.lastNameInput', this.$el).val();
		var isConfirmed = ($('.confirmed', this.$el).is(':checked')) ? 1 : 0;
		var generatePassword = $('[name="generatePassword"]:checked').val();

		//console.log("Generate Password: " + generatePassword);

		let user = {
			username: userName,
			userpassword: password,
			generate_password: generatePassword,
			email_address: emailAddr,
			confirmed: isConfirmed,
			first_name: firstName,
			last_name: lastName
		};

		let m = this.model;
		m.urlRoot = "/api/site-users";
		//m.set(user);
		m.save(user, {
			success: callback(true, m),
			error: callback(false)
		});
	},

	showHidePasswords: function(e) {
		var target = $(e.currentTarget);

		if (target.val() == 'create-password') {
			$('.passwordInput', this.el).parent().removeClass("d-none");
		} else {
			$('.passwordInput', this.el).parent().addClass("d-none");
		}
	},

	checkFieldValid: function(e) {
		var target = $(e.currentTarget);

		var fieldName = "";

		if (target.hasClass('emailInput')) {
			fieldName = "email_address";
		} else if (target.hasClass('usernameInput')) {
			fieldName = "username";
		}

		let origVal = this.model.get(fieldName);

		if (target.val().length > 5 && target.val() != origVal) {
			this.validateInfo({field: fieldName, value: target.val()}, function(success){
				if (success) {
					target.removeClass('invalidField').addClass('validField');
				} else {
					target.removeClass('validField').addClass('invalidField');
				}
			});
		} else if (target.val() != origVal) {
			target.removeClass('validField').addClass('invalidField');
		}
	},

	validateInfo: function(item, cb) {
		console.log(item);

		$.ajax({
			url: '/api/registerValidation',
			data: item,
			dataType: 'json',
			method: 'POST',
			success: _.bind(function(data) {
				cb(true);
			}, this),
			error: _.bind(function(data) {
				cb((data.status == 200));
			}, this),
		});
	},

	handlePermissions: function(e) {
		var permVal = $(e.currentTarget).val();
		var perms = this.model.get("permissions");
		if ($(e.currentTarget).is(':checked')) {
			var perm = Necro.Apps.Data.UserPermissions.get(permVal);
			perms.push(perm);

		} else {
			var temp = [];
			_.each(perms, function(item) {
				if (item.id != permVal) temp.push(item);
			});
			this.model.set("permissions", temp);
		}
	}

});