Necro.Views.Admin.SiteUserList = Backbone.View.extend({
	tagName: 'div',
	className: '',
	templateName: 'user-list',
	pageTitle: 'Site Users',

	events: {
		'click .addUser': 'addUser'
	},

	initialize: function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		this.collection = new Necro.Collections.Users();
		this.collection.on('add', this.addItem, this);
		this.collection.fetch();
	},

	render: function() {
		var table = null;

		this.$el.html(this.template());
		this.addItems();

		return this;
	},

	addItems: function() {
		_.each(this.collection.models, function(user) {
			user.urlRoot = '/api/site-users';
			this.addItem(user);
		}, this);
	},

	addItem: function(user) {
		var item = new Necro.Views.Admin.SiteUserListItem({model: user});
		$('tbody', this.$el).append(item.render().$el);
	},

	addUser: function() {
		var perm = Necro.Apps.Data.UserPermissions.get(4);
		var user = new Necro.Models.User({permissions: [perm]});
		user.urlRoot = '/api/site-users';

		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.AddSiteUserModal",
			title: "Add User",
			buttonText: "Save User",
			model: user,
			callback: _.bind(function() {
				if (user) this.collection.add(user);
			}, this)
		});
	}
});

Necro.Views.Admin.SiteUserListItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'user-list-item',

	events: {
		'click .user_name': 'editUser',
		'click .email_address': 'editUser',
		'click .action_edit': 'editUser',
		'click .action_remove': 'deleteUser'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.on("sync", this.render, this);
		this.model.on("destroy", this.remove, this);
		//this.model.on("destroy", this.remove, this);
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	},

	editUser: function() {
		var user = this.model;
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.AddSiteUserModal",
			title: "Edit User",
			buttonText: "Save User",
			model: user,
			callback: _.bind(function() {
				this.render();
			}, this)
		});
	},

	deleteUser: function() {
		this.model.urlRoot = '/api/site-users';
		this.model.destroy();
	}

});