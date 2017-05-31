
function SchedularSettings() {
	this.saveAvUsersButton = document.getElementById("save-available-users");
	this.saveEvTypeSettingsButton = document.getElementById("save-event-settings");
	this.createRelButton = document.getElementById("create-relation");

	this.saveAvUsersButton.addEventListener("click", function(){
		settings.saveAvUsers();
	});
	this.saveEvTypeSettingsButton.addEventListener("click", function(){
		settings.saveEventTypeSettings();
	});
	this.createRelButton.addEventListener("click", function(){
		settings.createRelation();
	});
}

SchedularSettings.prototype.save = function(data) {
	var functionToCall = data.action;
	var endPoint = "index.php?module=Schedular&action=SchedularAjax&file=ajax";
	var dataToSave = encodeURIComponent(JSON.stringify(data.toSave));
	var callback = data.callback;

	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {
			callback(xhttp.response);
	    }
	};
	xhttp.open("GET", endPoint + "&function=" + functionToCall + "&data=" + dataToSave, true);
	xhttp.send(); 
}

SchedularSettings.prototype.saveAvUsers = function() {
	var checkboxes = document.getElementsByClassName("available-users__checkbox");
	var selectedUsers = "";

	for (var i = 0; i < checkboxes.length; i++) {
		if (checkboxes[i].checked == true) {
			var userId = checkboxes[i].id.slice(-1);
			selectedUsers += userId + ",";
		}
	}

	selectedUsers = selectedUsers.substr(0, selectedUsers.length - 1);
	this.save({
		"action" 	: "saveAvailableUsers",
		"toSave"	: {
			"users"		: selectedUsers
		},
		"callback"	: function(response) {
			if (response == "true") {
				window.settings.toast("toast-message__users-saved");
			}
		}
	});
}

SchedularSettings.prototype.saveEventTypeSettings = function() {
	var eventBgColorInputs = document.getElementsByClassName("event-type__background-color");
	var eventTypes = {};
	for (var i = 0; i < eventBgColorInputs.length; i++) {
		var eventId = eventBgColorInputs[i].id.slice(-1);
		// console.log(eventId);
		eventTypes[eventId] = {
			"colors" : {
				"bg" : eventBgColorInputs[i].value
			}
		}
	}
	this.save({
		"action" 	: "saveEventTypeSettings",
		"toSave"	: {
			"eventTypes"	: eventTypes
		},
		"callback"	: function(response) {
			if (response == "true") {
				window.settings.toast("toast-message__event-types-saved");
			}
		}
	});
}

SchedularSettings.prototype.createRelation = function() {
	var avModules = document.getElementById("select-module-to-relate").getElementsByTagName("option");
	var selModule = "";
	for (var i = 0; i < avModules.length; i++) {
		if (avModules[i].selected == true) {
			selModule = avModules[i].value;
			break;
		}
	}
	this.save({
		"action" 	: "createRelation",
		"toSave"	: {
			"moduleName"	: selModule
		},
		"callback"	: function(response) {
			response = JSON.parse(response);
			if (response.result == "success") {
				window.settings.createRelationUI(response);
			}
		}
	});
}

SchedularSettings.prototype.createRelationUI = function(newRelation) {
	var template = document.getElementById("relation-template");
	var newNode = template.cloneNode(true);
	var container = document.getElementById("schedular-relations");

	newNode.id = "relation-" + newRelation.schedular_relid;
	newNode.removeAttribute("style");
	newNode.getElementsByClassName("schedular-relation__id")[0].innerText = newRelation.schedular_relid;
	newNode.getElementsByClassName("schedular-relation__module-name")[0].innerText = newRelation.schedular_relmodule_name;
	newNode.getElementsByClassName("schedular-relation__remove")[0].addEventListener("click", window.settings.removeRelation);

	container.appendChild(newNode);
}

SchedularSettings.prototype.removeRelation = function() {
	var el = this;
	while (el = el.parentElement) {
		if (el.classList.contains("schedular-relation")) {
			window.settings.save({
				"action" 	: "deleteRelation",
				"toSave"	: {
					"relationId"	: el.id.split("-")[1]
				},
				"callback"	: function(response) {
					if (response == 'true') {
						document.getElementById("schedular-relations").removeChild(el);
					}
				}
			});
			break;
		}
	}
}

SchedularSettings.prototype.toast = function(message, type) {
	var toastDiv = document.getElementById("toast");
	var toastText = document.getElementById("toasttext");
	var closeToast = document.getElementById("close-toast");

	toastDiv.style.display = "block";
	toastText.innerText = document.getElementById(message).innerText;
	closeToast.addEventListener("click", function(){
		toastDiv.style.display = "none";
	});
}

window.addEventListener("load", function(){
	window.settings = new SchedularSettings();

	var removeRelationButtons = document.getElementsByClassName("schedular-relation__remove");
	for (var i = 0; i < removeRelationButtons.length; i++) {
		removeRelationButtons[i].addEventListener("click", window.settings.removeRelation);
	}
});