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
		return this.get('is_admin');
	}
});