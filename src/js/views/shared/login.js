Necro.Views.Login = Backbone.View.extend({
	tagName: 'div',
	className: 'p-5',
	templateName: 'login',
	pageTitle: 'Log In',

	events: {
		'click .loginButton': 'login',
		'keypress': 'keyAction'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		_.bind(this.login, this);
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	},

	keyAction: function(e) {
		if (e.keyCode === 13) {
			if ($('.passwordInput', this.el).is(":focus")) {
				this.login();
			}
		}
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
					Necro.Events.trigger('user:loggedin user:verified');
				} else {
					console.log("Failed login");
				}
			}, this)
		});

		console.log("Try to log in");
	}

});