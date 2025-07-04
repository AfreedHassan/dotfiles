if('serviceWorker' in navigator){navigator.serviceWorker.register=function(){return Promise.reject("Service workers disabled.");};}
navigator.serviceWorker.getRegistrations().then(regs=>{regs.forEach(reg=>reg.unregister());});
