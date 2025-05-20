Necro.Views.Admin.GangRoleList = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'gang-role-list',
	model: null,

	events: {
		'click .addRole': 'addRole'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
        this.gangRoles = new Necro.Collections.GangRoles();
		this.gangRoles.gangId = this.model.get('id');
		//this.collection.empty();
		this.gangRoles.fetch({ success: _.bind(this.addItems, this) });
	},

	render: function() {
		this.$el.html(this.template);
		//if (this.collection && this.collection.length > 0) this.addItems();
		return this;
	},

	addItems: function() {
		$('tbody', this.$el).empty()
		_.each(this.gangRoles.models, function(model) {
			this.addItem(model);
		}, this);
	},

	addItem: function(item) {
		var row = new Necro.Views.Admin.GangRoleListItem({model: item});
		$('tbody', this.$el).append(row.render().$el);
	},

	addRole: function() {
		var roles = this.gangRoles;
		//roles.on('add', _.bind(this.addItem, this));
		var m = new Necro.Models.GangRole({gang_type_id: this.model.get('id')});
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.GangRoleEditModal",
			title: "Add Gang Role",
			model: m,
			callback: function(model) {
				roles.add(model);
			}
		});
	}

});

Necro.Views.Admin.GangRoleListItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'gang-role-list-item',

	events: {
		'click .action_edit': 'popRoleModal',
		'click .action_primary': 'addPrimarySkills',
		'click .action_secondary': 'addSecondarySkills',
		'click .action_remove': 'deleteRole',
		'click .stat-line': 'editStatline',
		'click .action_stats': 'editStatline'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.on("change", this.render, this);
		this.model.on("destroy", this.remove, this);
		this.model.attributes.primary_skills.on("update", this.render, this);
		this.model.attributes.secondary_skills.on("update", this.render, this);
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	},

	addPrimarySkills: function() {
		this.popSkillSetModal(true);
	},

	addSecondarySkills: function() {
		this.popSkillSetModal(false);
	},

	popSkillSetModal: function(primary) {
		var title = "Assign Primary Skills";
		if (!primary) {
			title = "Assign Secondary Skills";
		}
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.AssignSkillSet",
			title: title,
			model: this.model,
			primarySkill: primary
		});
	},

	popRoleModal: function(primary) {
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.GangRoleEditModal",
			title: "Add Gang Role",
			model: this.model,
		});
	},

	editStatline: function() {
		var m = this.model;
		var template = m.get("template");
		var title = "Edit " + m.get("role_name") + " Statline";
		if (!template) template = new Necro.Models.FighterTemplate({gang_type_id: this.model.attributes.gang_type_id, fighter_role: this.model.id});
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.StatLineModal",
			title: title,
			model: template,
			modalSize: 'modal-lg',
			callback: _.bind(function(t) {
				if (t) {
					m.set('template', t);
				}
			}, this)
		});
	},

	deleteRole: function() {
		this.model.destroy();
	}

});