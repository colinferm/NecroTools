Necro.Views.GangList = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'gang-list',
	pageTitle: 'Your Gangs',

	events: {
		'click .addGang': 'addGang'
	},

	initialize : function(options) {
		_.bindAll(this, 'addGang');

		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		this.collection = new Necro.Collections.Gangs({});
		this.collection.on('remove', this.notifyGangs, this);
		this.collection.on('add', this.addItem, this);
		this.collection.fetch();
	},

	render: function() {
		this.$el.html(this.template());
		return this;
	},

	notifyGangs: function() {
		Necro.Events.trigger("gangs_updated", this.collection);
	},

	addItems: function() {
		$('.gang-list', this.el).empty()
		_.each(this.collection.models, function(model) {
			this.addItem(model);
		});
		Necro.Events.trigger("gangs_updated", this.collection);
	},

	addItem: function(item) {
		var item = new Necro.Views.GangListItem({model: item});
		$('.gang-list', this.el).append(item.render().$el);
	},

	addGang: function() {
		var m = new Necro.Models.Gang({user_id: necro.session.id});
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.User.Modal.AddGang",
			title: "Add Gang",
			buttonText: "Save Gang",
			model: m,
			callback: _.bind(function() {
				if (m) {
					this.collection.add(m);
					Necro.Events.trigger("gangs_updated", this.collection);
				}
			}, this)
		});
	}

});


Necro.Views.GangListItem = Backbone.View.extend({
	tagName: 'div',
	className: 'gang-info-card-container w-50 m-2 p-2',
	templateName: 'gang-list-item',

	events: {
		'click h2': 'editGang',
		'click h3': 'editGang',
		'click .action_remove': 'removeGang'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.on("destroy", this.remove, this);
		this.model.on("change", this.render, this);
		//this.model.fetch();
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	},

	editGang: function() {
		necro.navigate("roster/" + this.model.get("id"), {trigger: true});
	},

	removeGang: function() {
		this.model.destroy();
	}

});