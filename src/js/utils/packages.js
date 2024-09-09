var Necro = {
	Apps: {},
	Utils: {},
	Routers: {},
	Models: {},
	Views: {},
	UI: {}
};

Necro.Apps.FighterTypes = ['leader','champion','fighter','prospect','juve','brute','hanger-on','pet'];

Necro.Utils.UI.TPL = {
	templates: {},

	//pre-loads all templates into a hash
	loadAllTemplates: function (callback) {
		var that = this;
		//that.templates[name] = data;
		if (Object.keys(that.templates).length == 0) {
			$("script").each(function (index) {
				var tmpid = $(this).attr('id');
				if (tmpid) {
					//console.log("Loading template " + index + ":" + tmpid);
					that.templates[tmpid] = $(this).html();
				}
			});
			console.log("Loaded templates");
		}
		callback();
	},

	// Get template by name from hash of preloaded templates
	get: function (name) {
		return this.templates[name];
	}
};

//helper class for working with packages
Necro.Utils.Resolver = {	
	//return a nested property from an object.  
	//getValue(object,'level1.level2.level3') would be equivolent to object['level1']['level2']['level3']
	getValue : function(object, prop) {
		if (!object || !prop) return null;
		var arr = prop.split('.');
		var fn = object;
		for (var i = 0, len = arr.length; i < len; i++) {
			if (fn == null)
				return fn;
			else if (Backbone.Model.prototype.isPrototypeOf(fn) && fn.has(arr[i]))
				fn = fn.get(arr[i]);
			else if (_.isFunction(fn[arr[i]]))
				fn = fn[arr[i]](); 
			else
				fn = fn[arr[i]];
		}
		return fn;
	},
		
	stringToObject : function(str, type) {
		type = type || 'object';  // can pass "function"
		var arr = str.split('.');

		var fn = (window || this);
		for (var i = 0, len = arr.length; i < len; i++)
			fn = fn[arr[i]];
		//console.log('type of str=' + (typeof fn)); 
		if (typeof fn !== type)
			throw new Error(type +' not found: ' + str);

		return  fn;
	},
		
	//creates objects from classes that are namespaced.  ie:   new package.package.Object();
	getNewInstance : function(classNameWithNamespace, params) {
		params = params || {};
		var MyClass = Utils.Resolver.stringToObject(classNameWithNamespace,'function');
		return new MyClass(params);
	}
};

Necro.Apps.handleAjaxOauth = function (xhr) {
	var token = (app && app.session && app.session.authenticated()) ? app.session.getAuthToken() : null;
	if (token) {
		xhr.setRequestHeader("Authorization", "OAuth oauth_token=" + token);
	}
};