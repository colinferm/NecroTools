Necro.Routers.NecroRouter = Backbone.Router.extend({
	savedSearches: {},
	history: [],

	routes:{
		"":"home",
		"error":"error",
		"login":"login",
		"logout":"logout",
		"register": "register",
		"gangs":"listGangs",
		"roster": "rosterForm",
		"roster/:id": "rosterForm"
		/*
		"entities/list":"entityListSearch",
		"entities/new":"entityForm",
		"entities/:id":"entityForm",
		*/
	},

	initialize: function () {
		_.bindAll(this, 
			'home', 'login', 'logout', 'register', 'listGangs', 'rosterForm',
			'updateRight', 'updateLeft', 'updateFoundation', 'showRoster'
		);

		Necro.Events.on('stylize', this.updateFoundation);

		//user session
		this.session = new Necro.Models.User();

		//generate the top nav
		this.header = new Necro.Views.Header({ el: $('.nav-content') });
		this.footer = new Necro.Views.Footer({ el: $('.footer-content') });
		this.leftContent = new Necro.Views.LeftContent({});
		this.rightContent = new Necro.Views.RightContent({});
		this.rightContent.pageTitle = 'Home';
		this.contentWell = $('.main-content');
		//this.menu = new MenuView({ el: $('.breadLine'), collection: this.session.taskList });

		var auth = $.cookie('auth');
		if (auth) {
			//this.session.set("oauth_key", auth);
			this.session.url = "/api/verify";
			var location = window.location.href;
			location = location.substring(location.indexOf('#'), location.length)
			this.session.save({
				oauth_key: auth
			}, {
				success: _.bind(function() {
					this.navigate(location, {trigger: true});
				}, this),
				error: _.bind(function() {
					this.navigate(location, {trigger: true});
				}, this)
			});
		} else {
			this.navigate("login", {trigger: true});
		}
		this.updateFoundation();

		// On route change event handler.
		$(window).on('hashchange', function (event) {
			window.tabindex = 0;
		});
	},

	load: function (callback) {
		this.header.render();
		this.footer.render();
		this.contentWell.append(this.leftContent.render());
		this.contentWell.append(this.rightContent.render());
		Backbone.history.start();
	},

	updateRight: function(elem, title) {
		this.rightContent.pageTitle = title;
		Necro.Events.trigger('right:title:change');
		$('.right-content-container', this.rightContent.$el).html(elem);
	},

	updateLeft: function(elem, title) {
	
	},

	updateFoundation: function() {
		$(document).foundation();
	},

	home: function() {

	},

	login: function() {
		var loginView = new Necro.Views.Login({
			model: this.session
		});
		this.updateRight(loginView.render(), "Log In");
	}, 

	logout: function() {

	},

	register: function() {

	},

	listGangs: function() {
		var gangListView = new Necro.Views.GangList({});
		this.updateRight(gangListView.render(), "Gangs");
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
		this.updateRight(rosterListView.render(), title);
	}
});