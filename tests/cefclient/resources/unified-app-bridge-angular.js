!function(t){var e={};function r(n){if(e[n])return e[n].exports;var o=e[n]={i:n,l:!1,exports:{}};return t[n].call(o.exports,o,o.exports,r),o.l=!0,o.exports}r.m=t,r.c=e,r.d=function(t,e,n){r.o(t,e)||Object.defineProperty(t,e,{configurable:!1,enumerable:!0,get:n})},r.r=function(t){Object.defineProperty(t,"__esModule",{value:!0})},r.n=function(t){var e=t&&t.__esModule?function(){return t.default}:function(){return t};return r.d(e,"a",e),e},r.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},r.p="",r(r.s=27)}([function(t,e,r){"use strict";Object.defineProperty(e,"__esModule",{value:!0}),function(t){t.Android="Android",t.IOS="iOS",t.MacOS="macOS",t.Windows="Windows"}(e.PlatformName||(e.PlatformName={}))},function(t,e,r){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n=function(){function t(){this.eventHandlers={}}return t.prototype.dispatch=function(t,e){var r=this.eventHandlers[t];if(null!=r)for(var n=0,o=r;n<o.length;n++){(0,o[n])(e)}},t.prototype.subscribe=function(t,e){var r=this,n=this.eventHandlers[t]||(this.eventHandlers[t]=[]);return-1===n.indexOf(e)&&n.push(e),function(){return r.unsubscribe(t,e)}},t.prototype.unsubscribe=function(t,e){var r=this.eventHandlers[t];if(null!=r){var n=r.indexOf(e);-1!==n&&r.splice(n,1)}},t}();e.ApiHandler=n},function(t,e,r){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n=function(){return function(){}}();e.ApiHandlerBootstrapper=n},function(t,e,r){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n=r(5),o=function(){function t(){}return t.prototype.execute=function(t,e){var r=this;return n.initApiHandler().then(function(n){return n.execute(r.apiName,t,e)}).catch(function(e){return Promise.reject("Unable to execute "+r.apiName+"."+t+": "+e)})},t.prototype.subscribe=function(t,e){var r=this;return n.initApiHandler().then(function(n){return n.subscribe(r.apiName+"."+t,e)}).catch(function(e){return Promise.reject("Unable to subscribe to "+r.apiName+"."+t+": "+e)})},t}();e.Api=o},function(t,e,r){"use strict";function n(t){for(var r in t)e.hasOwnProperty(r)||(e[r]=t[r])}Object.defineProperty(e,"__esModule",{value:!0}),n(r(16)),n(r(15))},function(t,e,r){"use strict";var n=this&&this.__assign||Object.assign||function(t){for(var e,r=1,n=arguments.length;r<n;r++)for(var o in e=arguments[r])Object.prototype.hasOwnProperty.call(e,o)&&(t[o]=e[o]);return t};Object.defineProperty(e,"__esModule",{value:!0});var o=r(19),i=null;e.initApiHandler=function(){return i||(t=Object.keys(o).reduce(function(t,e){try{return n({},t,((r={})[e]=new o[e],r))}catch(r){return console.error("Unable to construct "+e+": "+r),t}var r},{}),e=Object.keys(t).map(function(e){return t[e].checkPlatform().then(function(t){return t?e:null},function(t){return console.error("Platform check failed by "+e+": "+t),null})}),i=Promise.all(e).then(function(t){return t.filter(function(t){return null!=t})}).then(function(e){return 1===e.length?t[e[0]].bootstrap().catch(function(t){return Promise.reject(e[0]+" is failed to bootstrap: "+t)}):Promise.reject(e.length?"Either "+(r=e).reduce(function(t,e,n){return t+(0==n?"":n<r.length-1?", ":" and ")+e},"")+" are able to bootstrap on current platform.":"No appropriate bootstrapper found for current platform.");var r}).catch(function(t){return Promise.reject("Unable to bootstrap JR APIs: "+t)}));var t,e}},function(t,e,r){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n=function(){function t(t,e){this.$rootScope=t,this.$q=e}return t.prototype.promise=function(t){var e=this.$q.defer();return t.then(e.resolve,e.reject),e.promise},t.prototype.event=function(t){var e=this;return function(r){return t(function(t){try{r(t)}finally{e.$rootScope.$apply()}})}},t}();e.Wrapper=n},function(t,e,r){"use strict";var n,o=this&&this.__extends||(n=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var r in e)e.hasOwnProperty(r)&&(t[r]=e[r])},function(t,e){function r(){this.constructor=t}n(t,e),t.prototype=null===e?Object.create(e):(r.prototype=e.prototype,new r)});Object.defineProperty(e,"__esModule",{value:!0});var i=function(t){function e(){return null!==t&&t.apply(this,arguments)||this}return o(e,t),Object.defineProperty(e.prototype,"apiName",{get:function(){return"keyboardLayout"},enumerable:!0,configurable:!0}),e.prototype.onLayoutChanged=function(t){return this.subscribe("layoutChanged",t)},e.prototype.getLayouts=function(){return this.execute("getLayouts")},e.prototype.getLayout=function(t){return this.execute("getLayout",t)},e.prototype.getCurrentLayoutId=function(){return this.execute("getCurrentLayoutId")},e.prototype.trySetCurrentLayoutId=function(t){return this.execute("trySetCurrentLayoutId",t)},e}(r(3).Api);e.KeyboardLayoutApi=i},function(t,e,r){"use strict";var n,o=this&&this.__extends||(n=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var r in e)e.hasOwnProperty(r)&&(t[r]=e[r])},function(t,e){function r(){this.constructor=t}n(t,e),t.prototype=null===e?Object.create(e):(r.prototype=e.prototype,new r)});Object.defineProperty(e,"__esModule",{value:!0});var i=function(t){function e(){return null!==t&&t.apply(this,arguments)||this}return o(e,t),Object.defineProperty(e.prototype,"apiName",{get:function(){return"battery"},enumerable:!0,configurable:!0}),e.prototype.onStatusChanged=function(t){return this.subscribe("statusChanged",t)},e.prototype.getStatus=function(){return this.execute("getStatus")},e}(r(3).Api);e.BatteryApi=i},function(t,e,r){"use strict";var n,o=this&&this.__extends||(n=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var r in e)e.hasOwnProperty(r)&&(t[r]=e[r])},function(t,e){function r(){this.constructor=t}n(t,e),t.prototype=null===e?Object.create(e):(r.prototype=e.prototype,new r)});Object.defineProperty(e,"__esModule",{value:!0});var i=r(1),u=r(0),c=function(t){function e(e){var r=t.call(this)||this;if(r.hostObj=e,null==e)throw new Error("Given host object is null.");return r}return o(e,t),Object.defineProperty(e.prototype,"name",{get:function(){return u.PlatformName.Windows},enumerable:!0,configurable:!0}),e.prototype.execute=function(t,r,n){var o=this;return new Promise(function(i,u){o.hostObj.handleBrowserRequest(t+"."+r,e.serializeMethodArgs(t,r,n),i,u)}).then(function(n){return e.deserializeMethodResult(t,r,n)})},e.prototype.handleEvent=function(t,r,n){try{this.dispatch(t+"."+r,e.deserializeEventArgs(t,r,n))}catch(e){throw"Unable to handle event "+t+"."+r+": "+e}},e.serializeMethodArgs=function(t,e,r){try{return JSON.stringify(r)}catch(t){throw"Unable to serialize method args '"+r+"': "+t}},e.deserializeMethodResult=function(t,e,r){try{return JSON.parse(r)}catch(t){throw"Unable to parse result '"+r+"': "+t}},e.deserializeEventArgs=function(t,e,r){try{return JSON.parse(r)}catch(t){throw"Unable to deserialize event args '"+r+"': "+t}},e}(i.ApiHandler);e.WindowsApiHandler=c},function(t,e,r){"use strict";var n,o=this&&this.__extends||(n=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var r in e)e.hasOwnProperty(r)&&(t[r]=e[r])},function(t,e){function r(){this.constructor=t}n(t,e),t.prototype=null===e?Object.create(e):(r.prototype=e.prototype,new r)});Object.defineProperty(e,"__esModule",{value:!0});var i=r(2),u=r(9),c=function(t){function e(){return null!==t&&t.apply(this,arguments)||this}return o(e,t),e.prototype.checkPlatform=function(){return Promise.resolve(null!=e.getHostObject())},e.prototype.bootstrap=function(){return new Promise(function(t,r){var n=e.getHostObject(),o=new u.WindowsApiHandler(n);n.subscribeToEvents(function(t,e,r){return o.handleEvent(t,e,r)}).then(function(){return t(o)},function(t){return r("Unable to subscribe for host events: "+t)})})},e.getHostObject=function(){return window.__windowsAppHostObject},e}(i.ApiHandlerBootstrapper);e.WindowsApiHandlerBootstrapper=c},function(t,e,r){"use strict";var n,o=this&&this.__extends||(n=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var r in e)e.hasOwnProperty(r)&&(t[r]=e[r])},function(t,e){function r(){this.constructor=t}n(t,e),t.prototype=null===e?Object.create(e):(r.prototype=e.prototype,new r)});Object.defineProperty(e,"__esModule",{value:!0});var i=r(1),u=r(0),c=function(t){function e(e){var r=t.call(this)||this;if(r.hostObj=e,null==e)throw new Error("Given host object is null.");return r}return o(e,t),Object.defineProperty(e.prototype,"name",{get:function(){return u.PlatformName.MacOS},enumerable:!0,configurable:!0}),e.prototype.execute=function(t,r,n){var o=this;return new Promise(function(i,u){o.hostObj.handleBrowserRequest(t+"."+r,e.serializeMethodArgs(t,r,n),i,u)}).then(function(n){return e.deserializeMethodResult(t,r,n)})},e.prototype.handleEvent=function(t,r,n){try{this.dispatch(t+"."+r,e.deserializeEventArgs(t,r,n))}catch(e){throw"Unable to handle event "+t+"."+r+": "+e}},e.serializeMethodArgs=function(t,e,r){try{return JSON.stringify(r)}catch(t){throw"Unable to serialize method args '"+r+"': "+t}},e.deserializeMethodResult=function(t,e,r){try{return JSON.parse(r)}catch(t){throw"Unable to parse result '"+r+"': "+t}},e.deserializeEventArgs=function(t,e,r){try{return JSON.parse(r)}catch(t){throw"Unable to deserialize event args '"+r+"': "+t}},e}(i.ApiHandler);e.MacosApiHandler=c},function(t,e,r){"use strict";var n,o=this&&this.__extends||(n=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var r in e)e.hasOwnProperty(r)&&(t[r]=e[r])},function(t,e){function r(){this.constructor=t}n(t,e),t.prototype=null===e?Object.create(e):(r.prototype=e.prototype,new r)});Object.defineProperty(e,"__esModule",{value:!0});var i=r(2),u=r(11),c=function(t){function e(){return null!==t&&t.apply(this,arguments)||this}return o(e,t),e.prototype.checkPlatform=function(){return Promise.resolve(null!=e.getHostObject())},e.prototype.bootstrap=function(){return new Promise(function(t){var r=e.getHostObject(),n=new u.MacosApiHandler(r);r.subscribeToEvents(function(t,e,r){return n.handleEvent(t,e,r)}),t(n)})},e.getHostObject=function(){return window.__macOsAppHostObject},e}(i.ApiHandlerBootstrapper);e.MacosApiHandlerBootstrapper=c},function(t,e,r){"use strict";var n,o=this&&this.__extends||(n=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var r in e)e.hasOwnProperty(r)&&(t[r]=e[r])},function(t,e){function r(){this.constructor=t}n(t,e),t.prototype=null===e?Object.create(e):(r.prototype=e.prototype,new r)});Object.defineProperty(e,"__esModule",{value:!0});var i=r(1),u=r(4),c=r(0),s=function(t){function e(e){var r=t.call(this)||this;if(r.hostObj=e,null==e)throw new Error("Given host object is null.");return r}return o(e,t),Object.defineProperty(e.prototype,"name",{get:function(){return c.PlatformName.IOS},enumerable:!0,configurable:!0}),e.prototype.execute=function(t,e,r){var n=this;switch(t+"."+e){case"hostApp.getAppVersionInfo":return new Promise(function(t,e){return n.hostObj.callHandler("getAppVersion",function(r){""==r?e("Unable to get app version."):t(new u.AppVersionInfo(null,r))})});case"hostApp.requestTermination":return new Promise(function(t){n.hostObj.callHandler("quitPages",{}),t()});default:return Promise.reject("Method isn't supported for current platform.")}},e}(i.ApiHandler);e.IosApiHandler=s},function(t,e,r){"use strict";var n,o=this&&this.__extends||(n=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var r in e)e.hasOwnProperty(r)&&(t[r]=e[r])},function(t,e){function r(){this.constructor=t}n(t,e),t.prototype=null===e?Object.create(e):(r.prototype=e.prototype,new r)});Object.defineProperty(e,"__esModule",{value:!0});var i=r(2),u=r(13),c=function(t){function e(){return null!==t&&t.apply(this,arguments)||this}return o(e,t),e.prototype.checkPlatform=function(){return new Promise(function(t){var e=window.navigator.standalone,r=window.navigator.userAgent.toLowerCase(),n=/safari/.test(r);t(/iphone|ipod|ipad/.test(r)&&!e&&!n)})},e.prototype.bootstrap=function(){return new Promise(function(t){var e=function(e){return t(new u.IosApiHandler(e))},r=window.WebViewJavascriptBridge;if(r)e(r);else{var n=window.WVJBCallbacks;if(n)n.push(e);else{window.WVJBCallbacks=[e];var o=document.createElement("iframe");o.style.display="none",o.src="https://__bridge_loaded__",document.documentElement.appendChild(o),setTimeout(function(){return document.documentElement.removeChild(o)},0)}}})},e}(i.ApiHandlerBootstrapper);e.IosApiHandlerBootstrapper=c},function(t,e,r){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n=function(){return function(t,e){}}();e.DeviceRecord=n},function(t,e,r){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n=function(){return function(t,e){this.number=t,this.name=e}}();e.AppVersionInfo=n},function(t,e,r){"use strict";var n,o=this&&this.__extends||(n=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var r in e)e.hasOwnProperty(r)&&(t[r]=e[r])},function(t,e){function r(){this.constructor=t}n(t,e),t.prototype=null===e?Object.create(e):(r.prototype=e.prototype,new r)});Object.defineProperty(e,"__esModule",{value:!0});var i=r(1),u=r(4),c=r(0),s=function(t){function e(e){var r=t.call(this)||this;if(r.hostObj=e,null==e)throw new Error("Given host object is null.");return r}return o(e,t),Object.defineProperty(e.prototype,"name",{get:function(){return c.PlatformName.Android},enumerable:!0,configurable:!0}),e.prototype.execute=function(t,e,r){var n=this;switch(t+"."+e){case"hostApp.getAppVersionInfo":return new Promise(function(t){return t(new u.AppVersionInfo(n.hostObj.getAppVersionNumber(),n.hostObj.getAppVersionName()))});case"hostApp.requestTermination":return new Promise(function(t){n.hostObj.ExitApp(),t()});default:return Promise.reject("Method isn't supported for current platform.")}},e}(i.ApiHandler);e.AndroidApiHandler=s},function(t,e,r){"use strict";var n,o=this&&this.__extends||(n=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var r in e)e.hasOwnProperty(r)&&(t[r]=e[r])},function(t,e){function r(){this.constructor=t}n(t,e),t.prototype=null===e?Object.create(e):(r.prototype=e.prototype,new r)});Object.defineProperty(e,"__esModule",{value:!0});var i=r(2),u=r(17),c=function(t){function e(){return null!==t&&t.apply(this,arguments)||this}return o(e,t),e.prototype.checkPlatform=function(){return Promise.resolve(null!=e.getDroidJsObj())},e.prototype.bootstrap=function(){return Promise.resolve(new u.AndroidApiHandler(e.getDroidJsObj()))},e.getDroidJsObj=function(){return window.DroidJS},e}(i.ApiHandlerBootstrapper);e.AndroidApiHandlerBootstrapper=c},function(t,e,r){"use strict";function n(t){for(var r in t)e.hasOwnProperty(r)||(e[r]=t[r])}Object.defineProperty(e,"__esModule",{value:!0}),n(r(18)),n(r(14)),n(r(12)),n(r(10))},function(t,e,r){"use strict";var n,o=this&&this.__extends||(n=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var r in e)e.hasOwnProperty(r)&&(t[r]=e[r])},function(t,e){function r(){this.constructor=t}n(t,e),t.prototype=null===e?Object.create(e):(r.prototype=e.prototype,new r)});Object.defineProperty(e,"__esModule",{value:!0});var i=r(3),u=r(5),c=function(t){function e(){return null!==t&&t.apply(this,arguments)||this}return o(e,t),Object.defineProperty(e.prototype,"apiName",{get:function(){return"hostApp"},enumerable:!0,configurable:!0}),e.prototype.getPlatformName=function(){return u.initApiHandler().then(function(t){return t.name},function(t){return Promise.reject("Unable to initialize: "+t)})},e.prototype.notifyInitialized=function(){return this.execute("notifyInitialized")},e.prototype.getAppVersionInfo=function(){return this.execute("getAppVersionInfo")},e.prototype.getDeviceRecord=function(){return this.execute("getDeviceRecord")},e.prototype.requestTermination=function(){return this.execute("requestTermination")},e}(i.Api);e.HostAppApi=c},function(t,e,r){"use strict";function n(t){for(var r in t)e.hasOwnProperty(r)||(e[r]=t[r])}Object.defineProperty(e,"__esModule",{value:!0}),n(r(20)),n(r(8)),n(r(7))},function(t,e,r){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n=r(21);e.extendWindow=function(){var t=new n.HostAppApi;window.initAppBridge=function(){return Promise.resolve(t)},window.jrHostApp=t,window.jrBattery=new n.BatteryApi,window.jrKeyboardLayout=new n.KeyboardLayoutApi}},function(t,e,r){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n=r(6);e.jrKeyboardLayoutService=function(t,e){var r=window.jrKeyboardLayout,o=new n.Wrapper(t,e);return{onLayoutChanged:o.event(function(t){return r.onLayoutChanged(t)}),getLayouts:function(){return o.promise(r.getLayouts())},getLayout:function(t){return o.promise(r.getLayout(t))},getCurrentLayoutId:function(){return o.promise(r.getCurrentLayoutId())},trySetCurrentLayoutId:function(t){return o.promise(r.trySetCurrentLayoutId(t))}}}},function(t,e,r){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n=r(6);e.jrHostAppService=function(t,e){var r=window.jrHostApp,o=new n.Wrapper(t,e);return{getPlatformName:function(){return o.promise(r.getPlatformName())},getAppVersionInfo:function(){return o.promise(r.getAppVersionInfo())},getDeviceRecord:function(){return o.promise(r.getDeviceRecord())},notifyInitialized:function(){return o.promise(r.notifyInitialized())},requestTermination:function(){return o.promise(r.requestTermination())}}}},function(t,e,r){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n=r(6);e.jrBatteryService=function(t,e){var r=window.jrBattery,o=new n.Wrapper(t,e);return{onStatusChanged:o.event(function(t){return r.onStatusChanged(t)}),getStatus:function(){return o.promise(r.getStatus())}}}},function(t,e,r){"use strict";function n(t){for(var r in t)e.hasOwnProperty(r)||(e[r]=t[r])}Object.defineProperty(e,"__esModule",{value:!0}),n(r(25)),n(r(24)),n(r(23))},function(t,e,r){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n=r(22),o=r(26);n.extendWindow();var i=window.angular;if(null==i)throw new Error("Unable to find angular, make sure that this script is included AFTER angular script.");i.module("jr-browser-api-extensions",[]).service("jrHostApp",["$rootScope","$q",o.jrHostAppService]).service("jrBattery",["$rootScope","$q",o.jrBatteryService]).service("jrKeyboardLayout",["$rootScope","$q",o.jrKeyboardLayoutService]),i.module("unified-app-bridge",[]).service("appBridge",["$rootScope","$q",o.jrHostAppService])}]);