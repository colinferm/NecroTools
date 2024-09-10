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
		
		if (!this.session.isLoggedIn()) {
			window.location.href = '#login';
		}
	},

	updateRight: function(elem, title) {
		this.rightContent.pageTitle = title;
		Necro.Events.trigger('right:title:change');
		$('.right-content-container', this.rightContent.$el).html(elem);
	},

	home: function() {

	},

	login: function() {
		var loginView = new Necro.Views.Login({model: this.session});
		this.updateRight(loginView.render(), "Log In");
	}, 

	logout: function() {

	},

	register: function() {

	},

	listGangs: function() {

	},

	addGang: function() {

	}
});