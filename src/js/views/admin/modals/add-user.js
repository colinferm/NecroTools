Necro.Views.Admin.AddSiteUserModal = Necro.Views.BaseModal.extend({
	templateName: 'modal-add-user',

	events: {
		'click .registerButton': 'save',
		'click [name="generatePassword"]': 'showHidePasswords',
		'focusout .emailInput': 'checkFieldValid',
		'focusout .usernameInput': 'checkFieldValid',
		'click [type="checkbox"]': 'addPermissions'
	},

	render: function() {
		this.$el.html(this.template({model: this.model, permissions: Necro.Apps.Data.UserPermissions}));
		return this;
	},

	save: function(callback) {
		let roleNameField = $('.role_name', this.$el);
		let hierarchy = $('[name="hierarchy_role"]', this.$el).val();
		let roleName = roleNameField.val();

		if (!roleName || roleName.length < 3) {
			roleNameField.addClass('error');
			return;
		} else {
			roleNameField.removeClass('error');
		}
		var m = this.model;
        m.set("role_name", roleName);
        m.set("hierarchy_role", hierarchy);

		console.log(m.toJSON());

        m.save({
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
		if (target.val().length > 5) {
			var fieldName = "";

			if (target.hasClass('emailInput')) {
				fieldName = "email_address";
			} else if (target.hasClass('usernameInput')) {
				fieldName = "username";
			}

			this.validateInfo({field: fieldName, value: target.val()}, function(success){
				if (success) {
					target.removeClass('invalidField').addClass('validField');
				} else {
					target.removeClass('validField').addClass('invalidField');
				}
				this.validateForm();
			});
		} else {
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

	addPermissions: function(e) {
		console.log(e);

	},

	registerUser: function() {
		var userName = $('.usernameInput', this.$el).val();
		var emailAddr = $('.emailInput', this.$el).val();
		var password = $('.passwordInput', this.$el).val();
		var generatePassword = $('[name="generatePassword"]:checked').val();

		/* this.model.set({
			username: userName,
			userpassword: password,
			email: emailAddr,
			permissions: []
		}) */
	}

});