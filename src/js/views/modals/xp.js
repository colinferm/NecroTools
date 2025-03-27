Necro.Views.XPModal = Backbone.View.extend({
    templateName: 'modal-xp',

    events: {
        'change .xp_field': 'grabXP'
    },

    initialize : function(options) {
        this.opts = options;
        this.model = options.model;
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

    render: function() {
		//this.$el.html(this.template(this.model.toJSON()));
        this.$el.html(this.template({model: this.model.toJSON()}));
        return this.$el;
    },

    grabXP: function() {
        this.xp = $('.xp_field', this.$el).val();
    },

    save: function(cb) {
        if (this.xp) {
            console.log("Saving XP: " + this.xp);
            var currXP = this.model.get("experience");
            var newXP = currXP + parseInt(this.xp);
            this.model.set("experience", newXP);
            this.model.set("audit", "Added " + this.xp + "xp");
            this.model.save({
                success: cb(true),
                errpr: cb(false)
            });
        }
    }

});