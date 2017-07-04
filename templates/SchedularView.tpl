{* {include file="modules/Schedular/SchedularComponents.tpl"} *}
{* <link rel="stylesheet" type="text/css" href="modules/Schedular/lib/css/slds-button.css">
<link rel="stylesheet" type="text/css" href="modules/Schedular/lib/css/slds-icon.css">
<link rel="stylesheet" type="text/css" href="modules/Schedular/lib/css/slds-combobox.css"> *}
<link rel="stylesheet" type="text/css" href="modules/Schedular/lib/css/salesforce-lightning-design-system.min.css">
<div id="schedular"></div>
<!-- Data DIV's -->
<div style="display: none;">
	{foreach from=$resource_users item=user key=key}
	<div class="resource resource__user">
		<div class="resource__id">{$user.id}</div>
		<div class="resource__name">{$user.first_name} {$user.last_name}</div>
	</div>
	{/foreach}
</div>
<!-- // Data DIV's -->
<!-- Add / Edit Event UI -->
<div id="schedular-event-ui">
	<div id="schedular-event-ui__draghandle">{$MOD.clicktodrag}</div>
	<div class="slds-form slds-form_horizontal">
		<fieldset class="slds-form-element">
			<table width="100%" style="color: #54698d;">
				<tbody>
					<tr style="font-weight: bold;">
						<td width="25%">{$MOD.startdate}</td>
						<td width="25%">{$MOD.starttime}</td>
						<td width="25%">{$MOD.enddate}</td>
						<td width="25%">{$MOD.endtime}</td>
					</tr>
					<tr>
						<td width="25%" id="schedular-event-ui__startdate"></td>
						<td width="25%" id="schedular-event-ui__starttime"></td>
						<td width="25%" id="schedular-event-ui__enddate"></td>
						<td width="25%" id="schedular-event-ui__endtime"></td>
					</tr>
					<tr style="font-weight: bold;">
						<td width="25%">{$MOD.resource}</td>
						<td width="25%"></td>
						<td width="25%"></td>
						<td width="25%"></td>
					</tr>
					<tr>
						<td width="25%" id="schedular-event-ui__resourcename"></td>
						<td width="25%"></td>
						<td width="25%"></td>
						<td width="25%"></td>
					</tr>										
				</tbody>
			</table>
		</fieldset>
		<div class="slds-form-element">
			<label class="slds-form-element__label" for="schedular_name">{$MOD.title}</label>
			<div class="slds-form-element__control">
				<input id="schedular_name" name="schedular_name" class="slds-input" data-required="true" placeholder="Placeholder Text" type="text">
			</div>
		</div>
		<div class="slds-form-element">
			<label class="slds-form-element__label" for="schedular_description">{$MOD.description}</label>
			<div class="slds-form-element__control">
				<textarea id="schedular_description" class="slds-textarea" placeholder="Description"></textarea>
			</div>
		</div>		
		<fieldset class="slds-form-element">
			<label class="slds-form-element__label" for="select-01">{$MOD.schedular_eventtype}</label>
			<div class="slds-form-element__control">
				<div class="slds-select_container">
					<select class="slds-select" id="event-types">
						{foreach from=$event_types item=event_type key=key}
						<option value="{$event_type.schedular_eventtype}">{$event_type.schedular_eventtype|@getTranslatedString:'Schedular'}</option>
						{/foreach}
					</select>
				</div>
			</div>
		</fieldset>
		{foreach from=$relations item=relation key=key name=name}
			{* Call removed to support Smarty 2 *}
			{* {call name=relationautocomplete relation=$relation} *}
			<fieldset class="slds-form-element">
				<label class="slds-form-element__label" for="combobox-unique-id">{$MOD.searchin} {$relation.schedular_relmodule_name|@getTranslatedString:$relation.schedular_relmodule_name}</label>
				<div class="slds-form-element__control">
					<div class="slds-combobox_container">
						<div class="slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open" aria-expanded="true" aria-haspopup="listbox" role="combobox">
							<div class="slds-combobox__form-element slds-input-has-icon slds-input-has-icon_right">
								{* <input type="hidden" class="relation-autocomplete__hidden" name="" value=""> *}
								<input class="slds-input slds-combobox__input relation-autocomplete-input" data-filterrel-id="{$relation.schedular_filterrel_id}" data-module="{$relation.schedular_relmodule_name}" id="search-{$relation.schedular_relmodule_name|strtolower}" aria-activedescendant="schedular-relation-{$relation.schedular_relid}" aria-autocomplete="list" aria-controls="schedular-relation-{$relation.schedular_relid}" autocomplete="off" role="textbox" placeholder="{$MOD.searchin} {$relation.schedular_relmodule_name|@getTranslatedString:$relation.schedular_relmodule_name}" type="text" data-ac='{$relation.json}' data-relid="{$relation.schedular_relid}">
								<span class="slds-icon_container slds-icon-utility-search slds-input__icon slds-input__icon_right" title="Description of icon when needed">
									<svg class="slds-icon slds-icon slds-icon_x-small slds-icon-text-default" aria-hidden="true">
										<use xlink:href="include/LD/assets/icons/utility-sprite/svg/symbols.svg#search"></use>
									</svg>
									<span class="slds-assistive-text">Description of icon</span>
								</span>
							</div>
							<div id="listbox-unique-id" role="listbox" class="">
								<ul class="slds-listbox slds-listbox_vertical slds-dropdown slds-dropdown_fluid relation-autocomplete__target" style="opacity : 0;" role="presentation">
								</ul>
							</div>
						</div>
					</div>
				</div>
			</fieldset>
			<fieldset class="slds-form-element">
				<label class="slds-form-element__label" for="input-unique-id">{$MOD.currentlylinked} {$relation.schedular_relmodule_name|@getTranslatedString:$relation.schedular_relmodule_name}</label>
				<div class="slds-form-element__control existing-relations existing-relations__{$relation.schedular_relmodule_name}" data-relid="{$relation.schedular_relid}"></div>
			</fieldset>
		{/foreach}
{* 		<fieldset class="slds-form-element">
			<label class="slds-form-element__label" for="schedular_description">Description</label>
			<div class="slds-form-element__control">
				<textarea id="schedular_description" class="slds-textarea" placeholder="Description"><pre>{$relations|print_r}</pre></textarea>
			</div>
		</fieldset>	 *}		
		<fieldset class="slds-form-element">
			<div class="slds-button-group" role="group">
				<button class="slds-button slds-button_success" id="sch-save-event-ui">{$MOD.save}</button>
				<button class="slds-button slds-button_destructive" id="sch-cancel-event-ui">{$MOD.cancel}</button>
				<a id="sch-visit-event-link" target="_blank"><button class="slds-button slds-button_neutral" id="sch-visit-event-ui">{$MOD.visit_event}</button></a>
			</div>
		</fieldset>
	</div>
	<!-- Hidden DIV that hold some values to be picked up by the JS init script -->
	<div id="schedular-general-settings">
		<input type="hidden" name="business-hours-start" id="business-hours-start" value="{$general_settings.business_hours_start}" />
		<input type="hidden" name="business-hours-end" id="business-hours-end" value="{$general_settings.business_hours_end}" />
		<input type="hidden" name="current-user-id" id="current-user-id" value="{$current_user_id}" />
		<input type="hidden" name="preferred-view" id="preferred-view" value="{$preferred_view}" />
	</div>
	<!-- Hidden DIV that hold some language strings -->
	<div id="schedular-lang-strings">
		<input type="hidden" name="resource-label" id="resource-label" value="{$MOD.resources}" />
		<input type="hidden" name="legend-label" id="legend-label" value="{$MOD.legend}" />
	</div>
	<!-- Hidden div that holds all the data to save -->
	<div id="schedular-savedata">
		<input type="hidden" id="sch-startdate" data-columnfield="schedular_startdate" value="" />
		<input type="hidden" id="sch-starttime" data-columnfield="schedular_starttime" value="" />
		<input type="hidden" id="sch-enddate" data-columnfield="schedular_enddate" value="" />
		<input type="hidden" id="sch-endtime" data-columnfield="schedular_endtime" value="" />
		<input type="hidden" id="sch-assignedto" data-columnfield="assigned_user_id" value="" />
		<input type="hidden" id="sch-description" data-columnfield="description" value="" />
		<input type="hidden" id="sch-eventtype" data-columnfield="schedular_eventtype" value="" />
		<input type="hidden" id="sch-id" data-columnfield="schedularid" value="" />
		<input type="hidden" id="sch-name" data-columnfield="schedular_name" value="" />
	</div>
	<!-- // Hidden div that holds all the data to save -->
</div>
<!-- Eventtype color legend div -->
<div id="schedular-eventtypes-legends">
	<div id="schedular-eventtypes-legends__header">
		<span class="slds-icon_container slds-icon-utility-announcement" title="Description of icon when needed">
			<svg class="slds-icon slds-icon_x-small slds-icon-text-light" aria-hidden="true">
			<use xlink:href="include/LD/assets/icons/utility-sprite/svg/symbols.svg#move"></use>
			</svg>
			<span class="slds-assistive-text">Description of icon</span>
		</span>
		<div id="close-schedular-eventtypes-legend">X</div>
	</div>
	<div id="schedular-eventtypes-legends__content">
	{foreach from=$event_types item=event_type key=key}
	<div class="eventtype-legend">
		<div class="eventtype-legend__colorbox" style="background-color: {$event_type.eventtype_bgcolor}"></div>
		<div class="eventtype-legend__name">{$event_type.schedular_eventtype|@getTranslatedString:'Schedular'}</div>
	</div>
	{/foreach}
	</div>
</div>
<!-- // Eventtype color legend div -->
<!-- // Add / Edit Event UI -->
<script type="text/javascript" src="modules/Schedular/Schedular.js"></script>