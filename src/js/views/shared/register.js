Necro.Views.Register = Backbone.View.extend({
	tagName: 'div',
	className: 'large-6 grid-x',
	templateName: 'register',
	pageTitle: 'Register',

	events: {
		'click .registerButton': 'register',
		'change .confirmPasswordInput': 'validatePassword'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		new Foundation.Abide($('form', this.$el));
		$('form', this.$el).on('forminvalid.zf.abide', _.bind(this.formInValid, this));
		$('form', this.$el).on('formvalid.zf.abide', _.bind(this.formValid, this));
		return this;
	},

	formInValid: function(ev, frm) {
		$(".registerButton", this.$el).addClass('disabled');
	},

	formValid: function(ev, frm) {
		$(".registerButton", this.$el).removeClass('disabled');
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