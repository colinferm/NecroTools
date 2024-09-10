Necro.Views.Login = Backbone.View.extend({
	tagName: 'div',
	className: 'large-6',
	templateName: 'login',
	pageTitle: 'Log In',

	events: {
		'click .loginButton': 'login'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		_.bind(this.login, this);
	},

	render: function() {
		this.$el.html(this.template());
		return this.$el;
	},

	login: function() {
		var email =  $('.emailInput', this.el).val();
		var password =  $('.passwordInput', this.el).val();
		$.ajax({
			url: '/api/login',
			data: {
				email_address: email,
				userpassword: password
			},
			dataType: 'json',
			method: 'POST',
			success: _.bind(function(data) {
				console.log(data);
				this.model.set(data);
				if (this.model.isLoggedIn()) {
					console.log("Logged in!")
					window.necro.navigate("gangs", {trigger: true});
				} else {
					console.log("Failed login");
				}
			}, this)
		});

		console.log("Try to log in");
	}

});