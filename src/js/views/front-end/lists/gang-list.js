Necro.Views.GangList = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'gang-list',
	pageTitle: 'Gangs',

	events: {
		'click .addGang': 'addGang'
	},

	initialize : function(options) {
		_.bindAll(this, 'addGang');

		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		this.collection = new Necro.Collections.Gangs({});
		//this.listenTo(this.collecton, 'update', this.addItems)
		this.collection.fetch({
			success: _.bind(this.addItems, this)
		});
	},

	render: function() {
		this.$el.html(this.template());
		return this;
	},

	addItems: function() {
		$('tbody', this.el).empty()
		_.each(this.collection.models, function(model) {
			var item = new Necro.Views.GangListItem({model: model});
			$('tbody', this.el).append(item.render().$el);
		});
		Necro.Events.trigger("gangs_updated", this.collection);
	},

	addGang: function() {
		var m = new Necro.Models.GangType({user_id: necro.session.id});
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.User.Modal.AddGang",
			title: "Add Gang",
			buttonText: "Save Gang",
			model: m,
			callback: _.bind(function() {
				if (m) {
					this.collection.add(m);
				}
			}, this)
		});
	}

});


Necro.Views.GangListItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'gang-list-item',

	events: {
		'click .action_edit': 'editGang',
		'click .gang_name': 'editGang'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.fetch({
			success: _.bind(this.render, this)
		});
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		//var menu = new Foundation.DropdownMenu($('ul.dropdown.menu', this.$el));
		return this;
	},

	editGang: function() {
		necro.navigate("roster/"+this.model.get("id"), {trigger: true});
	}

});