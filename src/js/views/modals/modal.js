Necro.Views.Modal = Backbone.View.extend({
	tagName: 'div',
	className: 'reveal',
    id: "fighterModal",
	templateName: 'modal-wrapper',

	events: {
		
	},

	initialize : function(options) {
        this.opts = options;
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
        this.render();
	},

	render: function() {
		//this.$el.html(this.template(this.model.toJSON()));
        $("#"+this.id).remove();
        this.$el.html(this.template({modal_title: this.opts.title}));
        this.$el.attr('data-reveal', '');
        this.$el.attr('data-overlay', 'true');

        var content = Necro.Utils.Resolver.getNewInstance(this.opts.class, {model: this.model});
        $('.modal-container', this.$el).html(content.render());

        $('body').append(this.$el);

        var popup = new Foundation.Reveal(this.$el);
        this.$el.on('closed.zf.reveal', this.close);
        popup.open();
		return this.$el;
	},

    close: function() {
        $(".reveal-overlay").remove();
        $("#"+this.id).remove();
    }


});