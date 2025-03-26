Necro.Views.InjuryModal = Backbone.View.extend({
    templateName: 'modal-injury',

    events: {
        'change .injury_selector': 'populateDescription'
    },

    initialize : function(options) {
        this.opts = options;
        this.model = options.model;
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

    render: function() {
		//this.$el.html(this.template(this.model.toJSON()));
        this.$el.html(this.template({injuries: Necro.Apps.Data.Injuries, model: this.model.toJSON()}));
        return this.$el;
    },

    populateDescription: function() {
        var val = $('.injury_selector', this.$el).val();
        var inj = Necro.Apps.Data.Injuries[val];
        $('.injury_result', this.$el).html("Result: <b>"+inj.description+"</b>");
    }

});