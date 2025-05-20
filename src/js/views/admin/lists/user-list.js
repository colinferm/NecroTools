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
		this.collection.fetch({ success: _.bind(this.addItems, this) });
		//this.collection.on('add', this.addItem, this);
	},

	render: function() {
		var table = null;

		this.$el.html(this.template());
		this.addItems();

		return this;
	},

	addItems: function() {
		_.each(this.collection.models, function(user) {
			this.addItem(user);
		}, this);
	},

	addItem: function(user) {
		var item = new Necro.Views.Admin.SiteUserListItem({model: user});
		$('tbody', this.$el).append(item.render().$el);
	},

	addUser: function() {
		var user = new Necro.Models.User({});
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.AddSiteUserModal",
			title: "Add User",
			buttonText: "Save User",
			model: user,
			callback: _.bind(function() {
				if (m) this.collection.add(m);
			}, this)
		});
	}
});

Necro.Views.Admin.SiteUserListItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'user-list-item',

	events: {
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.on("sync", this.render, this);
		//this.model.on("destroy", this.remove, this);
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	},

	editUser: function() {
	},

	deleteUser: function() {
		this.model.destroy();
	}

});