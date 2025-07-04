Detector_config(function(config){
	var form=document.getElementById('detector_options_form');
	Xtion_foreach(config,function(v,k){var e=form.elements[k];if(e){e.value=typeof v==='object'?JSON.stringify(v):v}})
	document.getElementById('detector_options_form_pro_link').href=LOCATION_MAIN+'pro?source=detector_options&utm_source=detector_options';
	User_is_pro(function(pro){
		if(pro){
			var c=document.getElementById('detector_options_form_pro');c.style.cssText='';c.innerHTML='<label>Email Tracker Blocker Status <select name="block"><option value="0">Disabled</option><option value="1">Enabled</option></select></label><label>Email Tracker Blocker Type <select name="block_type"><option value="2">Aggressive (Block anything that looks like an email tracker)</option><option value="1">Light (Block popular email trackers)</option><option value="0">Custom (Block only your custom email tracker rules)</option></select></label><p>Custom Email Tracker Block/Allow Rules (Blacklist / Whitelist)</p><div id="detector_rules_container"></div><a id="detector_add_rule_button" href="#" style="margin-top:4px;">+Add Rule</a><br/><br/>';
			window.detector_rules=config.rules||[];Detector_rules_refresh();
			document.getElementById('detector_add_rule_button').addEventListener('click',function(){
				var popup=Xtion_popup(Xtion_json_to_form({type:'0',name:'',search_type:'0',search_value:''},function(r){
					var empty_inputs=0;Xtion_foreach(r,function(v,k){if(v===''){empty_inputs=1}});if(empty_inputs){alert('Required fields missing');return}
					window.detector_rules.push(r);
					Detector_rules_refresh();
					popup.close();
				},{input:{type:{0:'Block',1:'Allow'},search_type:{0:'URL Contains Value',1:'URL Matches Regular Expression (RegExp)'}},prepend:'<h2>Add Custom Email Tracker Rule</h2><p>Block or allow additional custom email trackers by checking whether email image URL\'s contain certain values.</p>'}))
			})
			Xtion_foreach(config,function(v,k){var e=form.elements[k];if(e){e.value=typeof v==='object'?JSON.stringify(v):v}})
		}
	})
	form.addEventListener('submit',function(event){event.preventDefault();
		config.detector=form.elements.detector.value;
		User_is_pro(function(pro){
			if(pro){
				form.elements.forEach(function(e){config[e.name]=e.value})
				config.rules=window.detector_rules;
			}
			Detector_config_update(config,function(){
				chrome.runtime.sendMessage({a:'detector_config_update'});
				document.getElementById('detector_options_form_output').innerHTML='Saved';
				setTimeout(function(){window.close()},250)
			});
		},false,true);
	})
})



function Detector_rules_refresh(){
	var c='';
	if(window.detector_rules.length){
		c='<table style="width:100%;table-layout:fixed;"><thead><tr><th>Type</th><th>Name</th><th>Search Type</th><th>Search Value</th><th>Actions</th></tr></thead><tbody><tr>';
		window.detector_rules.forEach(function(v,k){
			c+='<tr><td>'+{0:'Block',1:'Allow'}[v.type]+'</td><td>'+Xtion_html_special_chars(v.name)+'</td><td>'+{0:'URL Contains Value',1:'URL Matches Regular Expression (RegExp)'}[v.search_type]+'</td><td>'+Xtion_html_special_chars(v.search_value)+'</td><td><a data-delete-rule="'+k+'" href="#">-Delete Rule</a></td></tr>';
		})
		c+='</tr></tbody></table>';
	}
	document.getElementById('detector_rules_container').innerHTML=c;
	document.querySelectorAll('[data-delete-rule]').forEach(function(e){e.addEventListener('click',function(){
		window.detector_rules.splice(this.getAttribute('data-delete-rule'),1);Detector_rules_refresh();
	})})
}