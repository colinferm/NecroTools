Necro.Views.LeftContent = Backbone.View.extend({
	tagName: 'div',
	className: 'cell large-3 left-content',
	templateName: 'left-content',
	loggedIn: false,

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		this.gangCollection = new Necro.Collections.Gangs({});
		//this.listenTo(this.collecton, 'update', this.addItems)
		this.gangCollection.fetch({
			success: _.bind(this.userGangs, this)
		});

		Necro.Events.on("user:verified", function(){
			this.loggedIn = true;
			this.render();
			this.userGangs();
		}, this);
		Necro.Events.on('user:loggedout', function() {
			this.loggedIn = false;
			this.render();
		}, this);
		Necro.Events.on("gangs_updated", _.bind(this.gangsUpdated, this));
		Necro.Events.on("roster_updated", this.gangFighters);
	},

	render: function() {
		this.$el.html(this.template({loggedIn: this.loggedIn}));
		$('.gang_fighter_title', this.$el).css('display', 'none');
		$('.gang_fighters', this.$el).css('display', 'none');
		return this;
	},

	gangsUpdated: function(gangs) {
		this.gangCollection = gangs;
		this.userGangs();
	},

	userGangs: function() {
		$('.gang_fighter_title', this.$el).css('display', 'none');
		$('.gang_fighters', this.$el).css('display', 'none');
		var list = $('.gang_list', this.$el);
		list.empty();

		_.each(this.gangCollection.models, function(item) {
			list.append('<li><a href="#roster/'+item.get("id")+'">'+item.get("gang_name")+'</a></li>');
		}, this);
	},

	gangFighters: function(gang) {
		/*
		$('.gang_fighter_title', this.$el).css('display', 'none');
		var fighters = $('.gang_fighters', this.$el);

		_.each(gang.models, function(item) {
			list.append('<li><a href="#roster/'+item.get("id")+'">'+item.get("gang_name")+'</a></li>');
		}, this);
		*/
	}

});