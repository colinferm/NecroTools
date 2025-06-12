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

Necro.Models.User.FollowFriend = Necro.Models.User.extend({
	urlRoot: function() {
		return "/api/user/" + this.id + "/" + this.listType;
	},
	listType: 'follows',
	idAttribute: "id",
	defaults: _.extend({
		created: null,
		receiving_approved: false
	}, Necro.Models.User.prototype.defaults)
});

Necro.Collections.User.Follows = Backbone.Collection.extend({
	model: Necro.Models.User.FollowFriend,
	url: function() {
		return "/api/user/" + this.user_id + "/follows";
	},
	
	initialize: function() {
		this.comparator = "created";
	},

	parse: function(resp) {
		if (response.created) response.created = new Date(response.created);
		
		this.add(resp);
		return resp;
	}
});

Necro.Collections.User.Friends = Backbone.Collection.extend({
	model: Necro.Models.User.FollowFriend,
	url: function() {
		return "/api/user/" + this.user_id + "/friends";
	},
	
	initialize: function() {
		this.comparator = "username";
	},

	parse: function(resp) {
		if (response.created) response.created = new Date(response.created);
		if (response.receiving_approved) response.receiving_approved = true; 
		
		this.add(resp);
		return resp;
	}
});