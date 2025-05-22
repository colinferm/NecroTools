var Necro = {
	Apps: {
		Data: {}
	},
	Utils: {
		UI: {},
		Functions: {}
	},
	Routers: {},
	Collections: {},
	Models: {},
	Views: {
		Admin: {
			Modal: {}
		},
		User: {
			Modal: {}
		}
	},
	Events: {}
};

_.extend(Necro.Events, Backbone.Events);

Necro.Apps.Data.FighterTypes = ['leader','champion','fighter','prospect','juve','brute','hanger-on','pet'];

Necro.Utils.UI.TPL = {
	templates: {},

	//pre-loads all templates into a hash
	loadAllTemplates: function (callback) {
		var that = this;
		//that.templates[name] = data;
		var templateCount = 0;
		if (Object.keys(that.templates).length == 0) {
			$("script").each(function (index) {
				var tmpid = $(this).attr('id');
				if (tmpid) {
					//console.log("Loading template " + index + ":" + tmpid);
					that.templates[tmpid] = $(this).html();
				}
				templateCount++;
			});
			console.log("Loaded templates");
		}
		callback(templateCount);
	},

	// Get template by name from hash of preloaded templates
	get: function (name) {
		return this.templates[name];
	}
};

Necro.Utils.UI.Helpers = {
	TemplateSelectBox: function(options) {
		/* 
		{{select-box 
			field-name="hierarchy_role" 
			collection-property="roles" 
			item-id="type" 
			item-name="name" 
			value-property="model.hierarchy_role"
		}}
		*/
		var model = options.data.root.model;

		var fieldName = options.hash['field-name'];
		var itemId = options.hash['item-id'];
		var itemName = options.hash['item-name'];
		var collectionName = options.hash['collection-property']; 
		var modelProperty = options.hash['model-property'];
		var withBlank = (options.hash['with-blank']) ? true : false;

		var html = '<select name="' + fieldName + '" class="form-control">';
		if (withBlank) {
			html += '<option value="0">--</option>';
		}
		var collection = this[collectionName];
		for (var i = 0; i < collection.length; i++) {
			var elem = collection[i];
			var selected = '';
			if (elem[itemId] == model[modelProperty]) selected = 'selected';
			html += '<option value="' + elem[itemId] + '" ' + selected + '>' + elem[itemName] + '</option>';
		}
		html += '</select>'
		return html;
	},

	TemplateOptions: function(options) {
		var item = this;
		var model = options.data.root.model;
		var selectKey = options.hash['selected-id'];
		var nameParam = options.hash['name-param'];
		var selected = "";
		if (this.id == model[selectKey]) selected = "selected";
		return '<option value="' + this.id + '" ' + selected + '>' + this[nameParam] + '</option>';
	},

	GangSelectBox: function(options) {
		var item = this;
		var model = options.data.root.model;
		var selectedId = options.hash['selected-id'];
		var fieldName = options.hash['field-name'];
		let gangs = Necro.Apps.Data.GangTypes;
		var html = '<select name="' + fieldName + '">';
		_.each(gangs, function(gang, i) {
			var selected = "";
			if (gang.id == selectedId) selected = "selected";
			html += '<option value="' + gang.id + '" ' + selected + '>' + gang.type_name + '</option>';
		});
		html += "</select>";
		return html;
	},

	TemplateCheckbox: function(options, context) {
		//var model = options.data.root.model;

		var className = options.hash['class-name'];
		var nameParam = options.hash['name-param'];
		var idParam = (options.hash['id-param']) ? options.hash['id-param'] : '';
		var text = (options.hash['text']) ? options.hash['text'] : '';
		var objName = (options.hash['obj-name']) ? options.hash['obj-name'] : 'model';

		var model = options.data.root[objName];

		var checked = "";
		var formId = "";
		if (idParam) formId = 'id="'+idParam+'"';
		if (model[nameParam] == 1) checked = "checked";
		return '<input type="checkbox" class="' + className + ' form-check-input" value="' + this.model.id + '" ' + formId + ' ' + checked + '>' + text;
	},

	TemplateCheckboxSkill: function(options) {
		var model = options.data.root.model;

		var className = options.hash['class-name'];
		var nameParam = options.hash['name-param'];

		var checked = "";
		model.skills.models.forEach(function(item) {
			if (item.id == this.id) {
				checked = "checked";
				return;
			}
		});
		return '<input type="checkbox" class="' + className + ' form-check-input" value="' + this.id + '" ' + checked + '>&nbsp;' + this[nameParam];
	},

	TemplateCheckboxSkillSet: function(options) {
		var model = options.data.root.model;
		var checkId = this.id;

		var className = options.hash['class-name'];
		var nameParam = options.hash['name-param'];

		var checked = "";
		var skills = [];
		if (options.data.root.primary && model.primary_skills) {
			skills = model.primary_skills.models;
		} else if (model.secondary_skills) {
			skills = model.secondary_skills.models;
		}
		for (var i = 0; i < skills.length; i++) {
			let s = skills[i];
			if (s.id == checkId) {
				checked = "checked";
				break
			}
		}
		return '<input type="checkbox" class="' + className + ' form-check-input" value="' + checkId + '" ' + checked + '>&nbsp;' + this.attributes[nameParam];
	},

	TemplateCheckboxPermissions: function(options) {
		var model = options.data.root.model;
		var checkId = this.id;

		var className = options.hash['class-name'];
		var nameParam = options.hash['name-param'];

		var checked = "";
		if (model.permissions) {
			var perms = model.permissions;
			
			for (var i = 0; i < perms.length; i++) {
				let p = perms[i];
				if (p.id == checkId) {
					checked = "checked";
					break
				}
			}
		}
		return '<input type="checkbox" class="' + className + ' form-check-input" value="' + checkId + '" ' + checked + '>&nbsp;' + this[nameParam];
	},

	TemplateDateFormat: function(options) {
		var modelProperty = options.hash['model-property'];
		var formatString = (options.hash['format']) ? options.hash['format'] : 'MM/DD/YYYY';
		var dateProp = this[modelProperty];

		if (dateProp) {
			var dateParse = moment(dateProp);

			return dateParse.format(formatString);
		}
	}
}
Handlebars.registerHelper("select-box", Necro.Utils.UI.Helpers.TemplateSelectBox);
Handlebars.registerHelper("form-option", Necro.Utils.UI.Helpers.TemplateOptions);
Handlebars.registerHelper("gang-select", Necro.Utils.UI.Helpers.GangSelectBox);
Handlebars.registerHelper("checkbox-skill", Necro.Utils.UI.Helpers.TemplateCheckboxSkill);
Handlebars.registerHelper("checkbox-skillset", Necro.Utils.UI.Helpers.TemplateCheckboxSkillSet);
Handlebars.registerHelper("checkbox-permission", Necro.Utils.UI.Helpers.TemplateCheckboxPermissions);
Handlebars.registerHelper("checkbox", Necro.Utils.UI.Helpers.TemplateCheckbox);
Handlebars.registerHelper("date-format", Necro.Utils.UI.Helpers.TemplateDateFormat);

Necro.Utils.Functions = {
	getGangById: function(id) {
		for(var i = 0; i < Necro.Apps.Data.GangTypes.length; i++) {
			let gang = Necro.Apps.Data.GangTypes[i];
			if (gang.id == id) {
				var model = new Necro.Models.GangType(gang);
				return model;
			}
		}
	}
}

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
		var MyClass = Necro.Utils.Resolver.stringToObject(classNameWithNamespace,'function');
		return new MyClass(params);
	}
};

Necro.Apps.handleAjaxOauth = function (xhr) {
	var token = (app && app.session && app.session.authenticated()) ? app.session.getAuthToken() : null;
	if (token) {
		xhr.setRequestHeader("Authorization", "OAuth oauth_token=" + token);
	}
};

Date.prototype.dateToYMD = function() {
    var d = this.getDate();
    var m = this.getMonth() + 1; //Month from 0 to 11
    var y = this.getFullYear();
    return '' + (m<=9 ? '0' + m : m) + '/' + (d <= 9 ? '0' + d : d) + '/' + y;
}

Date.prototype.toString = function() {
	return this.dateToYMD();
}