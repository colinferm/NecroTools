Necro.Models.User = Backbone.Model.extend({
	urlRoot:     "/api/user",
	idAttribute: "id",
	defaults:    {
		'oauth_key': null,
		'is_admin': false
	},

	isLoggedIn: function() {
		if (this.get('oauth_key')) return true;
		return false;
	},

	isAdmin: function() {
		let admin = this.get('is_admin');
		return admin;
	},

	logout: function() {
		this.id = 0;
		this.oauth_key = null,
		this.is_admin = false;
	}
});

Necro.Collections.Users = Backbone.Collection.extend({
	model: Necro.Models.User,
	url:   '/api/site-users',
	
	initialize: function() {
		this.comparator = "username";
	},

	parse: function(resp) {
		this.add(resp);
		return resp;
	}
});

Necro.Collections.UserPermissions = Backbone.Collection.extend({
	model: Necro.Models.User,
	url:   '/api/site-users',
	
	initialize: function() {
		this.comparator = "id";
	},

	parse: function(resp) {
		this.add(resp);
		return resp;
	}
});