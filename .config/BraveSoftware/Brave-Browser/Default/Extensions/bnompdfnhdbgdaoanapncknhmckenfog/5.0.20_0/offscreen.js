chrome.runtime.onMessage.addListener((e,a,l)=>{if("localstorage"===e.type)return localStorage?l(localStorage):l(null),!0;l()});
