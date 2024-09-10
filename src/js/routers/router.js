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
		"addGang": "addGang",
		/*
		"entities/list":"entityListSearch",
		"entities/new":"entityForm",
		"entities/:id":"entityForm",
		*/
	},

	initialize: function () {
		_.bindAll(this, 'home');
		_.bindAll(this, 'login');
		_.bindAll(this, 'logout');
		_.bindAll(this, 'register');
		_.bindAll(this, 'listGangs');
		_.bindAll(this, 'addGang');

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
			this.session.save({
				oauth_key: auth
			}, {
				success: function() {
					necro.navigate("gangs", {trigger: true});
				},
				error: function() {
					necro.navigate("login", {trigger: true});
				}
			});
		} else {
			necro.navigate("login", {trigger: true});
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

	addGang: function() {

	}
});