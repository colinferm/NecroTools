Apps.RedRouter = Backbone.Router.extend({
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
		/*
		//user session
		this.session = new Security.Session();

		//generate the top nav
		this.topNav = new TopNavView({ el: $('#topNavWrapper') });
		this.menu = new MenuView({ el: $('.breadLine'), collection: this.session.taskList });

		// On route change event handler.
		$(window).on('hashchange', function (event) {
			window.tabindex = 0;
		});
		*/
	},

	home: function() {

	},

	login: function() {

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