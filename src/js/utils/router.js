Necro.Routers.NecroRouter = Backbone.Router.extend({
	savedSearches: {},
	history: [],
	passModel: null,

	routes:{
		"":"home",
		"error":"error",
		"login":"login",
		"logout":"logout",
		"register": "register",
		"gangs":"listGangs",
		"roster": "rosterForm",
		"roster/:id": "rosterForm",
		"fighter/:id": "fighterForm",
		"profile": "userProfile",

		"admin": "adminView",
		"adminGangs": "adminGangList",
		"adminGangs/:id": "adminGangForm",
		"adminSkills": "adminSkillsList",
		"adminSkills/:id": "adminSkillForm",
		"adminFighters": "adminFighterList",
		"adminFighters/:id": "adminFighterForm",
		"adminWeaponTraits": "adminWeaponTraitList",
		"adminWeaponTraits/:id": "adminEditTrait",
		"adminWeapons": "adminWeapons",
		"adminWargear": "adminWargearlist",
		"adminUserList": "adminUserList",
		"adminArchetypes": "adminArchetypes",
		"adminLookups": "adminLookupList"
	},

	initialize: function () {
		_.bindAll(this, 
			'home', 'login', 'logout', 'register', 'listGangs', 'rosterForm',
			'updateRight', 'updateLeft', 'showRoster', 'userProfile', "fighterForm", "showFighter",
			/** Admin */
			'adminGangList', 'adminGangForm', 'adminSkillsList', 'adminSkillForm',
			'adminFighterList', 'adminFighterForm', 'adminWeaponTraitList', 'adminEditTrait',
			'adminWeapons', 'adminView', 'adminLookupList'
		);

		//Necro.Events.on('stylize', this.updateFoundation);

		//user session
		this.session = new Necro.Models.User();

		//generate the top nav
		this.header = new Necro.Views.Header({ el: $('nav') });
		this.footer = new Necro.Views.Footer({ el: $('.footer-content') });
		this.leftContent = new Necro.Views.LeftContent({});
		this.rightContent = new Necro.Views.RightContent({});
		this.rightContent.pageTitle = 'Home';
		this.contentWell = $('.main-content');
		//this.menu = new MenuView({ el: $('.breadLine'), collection: this.session.taskList });

		// On route change event handler.
		$(window).on('hashchange', function (event) {
			window.tabindex = 0;
		});

		Necro.Events.on("user:loggedin", function() {
			if (this.session.isAdmin()) {
				this.navigate("admin", {trigger: true});
			} else {
				this.navigate("gangs", {trigger: true});
			}
		}, this);

		Necro.Events.on("user:loggedout", function() {
			this.navigate("login", {trigger: true});
		}, this);
	},

	load: function (callback) {
		this.header.render();
		this.footer.render();
		this.contentWell.append(this.leftContent.render().$el);
		this.contentWell.append(this.rightContent.render().$el);
		Backbone.history.start();

		var auth = $.cookie('auth');
		if (auth) {
			//this.session.set("oauth_key", auth);
			this.session.url = "/api/verify";

			var location = this.whereAmI();

			this.session.save({
				oauth_key: auth
			}, {
				success: _.bind(function() {
					this.navigate(location, {trigger: true});
					Necro.Events.trigger('user:verified');
				}, this),
				error: _.bind(function() {
					this.navigate("login", {trigger: true});
				}, this)
			});
		} else {
			var location = this.whereAmI();
			if (location == "#register") return;
			this.navigate("login", {trigger: true});
		}
	},

	whereAmI: function() {
		var location = window.location.href;
		var i = location.indexOf('#');
		var loc = "/";
		if (i == -1) {
			loc = "#gangs";
		} else {
			loc = location.substring(i, location.length);
		}
		return loc;
	},

	updateRight: function(elem, title) {
		this.rightContent.pageTitle = title;
		Necro.Events.trigger('right:title:change');
		$('.right-content-container', this.rightContent.$el).html(elem);
	},

	updateLeft: function(elem, title) {
	
	},
	home: function() {

	},

	login: function() {
		var loginView = new Necro.Views.Login({
			model: this.session
		});
		this.updateRight(loginView.render().$el, "Log In");
	}, 

	logout: function() {
		$.cookie('auth', '');
		this.session.logout();
		Necro.Events.trigger('user:loggedout');
		this.navigate("login", {trigger: true});
	},

	register: function() {
		var registerView = new Necro.Views.Register({
			model: this.session
		});
		this.updateRight(registerView.render().$el, "Register");
	},

	listGangs: function() {
		var gangListView = new Necro.Views.GangList({});
		this.updateRight(gangListView.render().$el, gangListView.pageTitle);
	},

	rosterForm: function(id) {
		if (id) {
			var gang = new Necro.Models.Gang({id: id});
			gang.fetch({
				success: this.showRoster
			});
		} else {
			var gang = new Necro.Models.Gang();
			this.showRoster(gang);
		}
	},

	showRoster: function(gang) {
		var title = "Create Roster";
		if (gang.get("id")) title = gang.get("gang_name");
		var rosterListView = new Necro.Views.Roster({model: gang});
		this.updateRight(rosterListView.render().$el, title);
	},

	fighterForm: function(id) {
		if (id) {
			var fighter = new Necro.Models.Fighter({id: id});
			fighter.fetch({
				success: this.showFighter
			});
		}
	},

	showFighter: function(fighter) {
		var title = "Create Fighter";
		if (fighter.get("id")) title = fighter.get("gang_name");
		var fighterView = new Necro.Views.User.EditFighter({model: fighter});
		this.updateRight(fighterView.render().$el, title);
	},

	userProfile: function() {
		let userProfile = new Necro.Views.UserProfile();
		this.updateRight(userProfile.render().$el, userProfile.pageTitle);
	},


	/**
	 * Admin
	 */
	adminView: function() {
		let adminView = new Necro.Views.Admin.AdminView();
		this.updateRight(adminView.render().$el, adminView.pageTitle);
	},

	adminUserList: function() {
		var userList = new Necro.Views.Admin.SiteUserList();
		this.updateRight(userList.render().$el, userList.pageTitle);
	},

	adminGangList: function() {
		var gangList = new Necro.Views.Admin.GangList();
		//var title = "Gang Lists";
		this.updateRight(gangList.render().$el, gangList.pageTitle);

	},

	adminGangForm: function(id) {
		var gang = null;
		if (this.passModel) {
			gang = this.passModel;
			this.passModel = null;
		} else {
			gang = Necro.Utils.Functions.getGangById(id);
		}

		var gangEdit = new Necro.Views.Admin.GangEdit({model: gang});
		this.updateRight(gangEdit.render().$el, gangEdit.pageTitle);
	},

	adminSkillsList: function() {
		var skillList = new Necro.Views.Admin.SkillList({});
		this.updateRight(skillList.render().$el, skillList.pageTitle);
	},

	adminSkillForm: function(id) {

	},

	adminFighterList: function() {

	},

	adminFighterForm: function(id) {

	},

	adminWeaponTraitList: function() {
		var traitList = new Necro.Views.TraitList({});
		this.updateRight(traitList.render().$el, traitList.pageTitle);
	},

	adminEditTrait: function(traitId) {

	},

	adminWargearlist: function() {
		var wargearList = new Necro.Views.Admin.WargearList({});
		this.updateRight(wargearList.render().$el, wargearList.pageTitle);
	},

	adminWeapons: function() {
		var traitList = new Necro.Views.Admin.WeaponList({});
		var title = traitList.pageTitle;
		this.updateRight(traitList.render().$el, title);
	},

	adminArchetypes: function() {
		var archetypesList = new Necro.Views.Admin.ArchetypeList({});
		this.updateRight(archetypesList.render().$el, archetypesList.pageTitle);
	},

	adminLookupList: function() {
		var lookupList = new Necro.Views.Admin.LookupList({});
		this.updateRight(lookupList.render().$el, lookupList.pageTitle);
	}
});