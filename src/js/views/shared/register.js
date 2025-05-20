Necro.Views.Register = Backbone.View.extend({
	tagName: 'div',
	className: 'registerForm',
	templateName: 'register',
	pageTitle: 'Register',
	isValid: false,

	events: {
		'click .registerButton': 'register',
		'change .passwordInput': 'validatePassword',
		'change .confirmPasswordInput': 'validatePassword',
		'focusout .emailInput': 'checkFieldValid',
		'focusout .usernameInput': 'checkFieldValid',
		'keypress': 'keyAction'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	},

	keyAction: function(e) {
		if (e.keyCode === 13) {
			if ($('.confirmPasswordInput', this.el).is(":focus")) {
				this.login();
			}
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

	validatePassword: function() {
		var password = $('.passwordInput', this.$el).val();
		var confPassword = $('.confirmPasswordInput', this.$el).val();

		if (password && password.length > 5) {
			$('.passwordInput', this.$el).removeClass('invalidField').addClass('validField');
			
			if (confPassword && confPassword.length > 5 && password == confPassword) {
				$('.confirmPasswordInput', this.$el).removeClass('invalidField').addClass('validField');
			} else {
				$('.confirmPasswordInput', this.$el).removeClass('validField').addClass('invalidField');
			}
			this.validateForm();
		}
	},

	validateForm: function() {
		var valid = true;
		$('input', this.$el).each(function() {
			if (!$(this).hasClass('validField')) valid = false;
		});

		this.isValid = valid;
		if (valid) {
			$(".registerButton", this.$el).removeClass('disabled');
		} else {
			$(".registerButton", this.$el).addClass('disabled');
		}
	},

	register: function() {
		var userName = $('.usernameInput', this.$el).val();
		var emailAddr = $('.emailInput', this.$el).val();
		var password = $('.passwordInput', this.$el).val();
		var confPassword = $('.confirmPasswordInput', this.$el).val();

		this.model.set({
			username: userName,
			userpassword: password,
			email: emailAddr,

		})
	}
});