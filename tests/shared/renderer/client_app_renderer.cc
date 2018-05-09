// Copyright (c) 2013 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

#include "tests/shared/renderer/client_app_renderer.h"

#include "include/base/cef_logging.h"

namespace client {

ClientAppRenderer::ClientAppRenderer() {
  CreateDelegates(delegates_);
}

void ClientAppRenderer::OnRenderThreadCreated(
    CefRefPtr<CefListValue> extra_info) {
  DelegateSet::iterator it = delegates_.begin();
  for (; it != delegates_.end(); ++it)
    (*it)->OnRenderThreadCreated(this, extra_info);
}
    
    class MyV8Handler : public CefV8Handler {
    public:
        MyV8Handler() {}
        
        virtual bool Execute(const CefString& name,
                             CefRefPtr<CefV8Value> object,
                             const CefV8ValueList& arguments,
                             CefRefPtr<CefV8Value>& retval,
                             CefString& exception) OVERRIDE {
            
           
            
            if (name == "handleBrowserRequest") {
                
               /* if ( arguments.size() == 0 )
                    exception = "0";
                if ( arguments.size() == 1 )
                    exception = "1";
                
                if ( arguments.size() == 2 )
                    exception = "2";
                
                if ( arguments.size() == 3 )
                    exception = "3";
                
                if ( arguments.size() == 4 )
                    exception = "4";
                
                return true;
                */
                CefString funcName = arguments[0]->GetStringValue();
                
                /*if ( arguments[1]->IsFunction() ) {
                    retval = CefV8Value::CreateObject( NULL, NULL );
                    retval->SetValue("isCharging", CefV8Value::CreateBool(true), V8_PROPERTY_ATTRIBUTE_READONLY);
                    retval->SetValue("level", CefV8Value::CreateUInt(0), V8_PROPERTY_ATTRIBUTE_READONLY);
                    retval->SetValue("timeLeft",  CefV8Value::CreateUInt(1), V8_PROPERTY_ATTRIBUTE_READONLY );
                    arguments[1]->ExecuteFunction(retval, arguments);
                    return  true;
                }*/
                if ( funcName == "battery.getStatus" ) {
                    
                    
                    CefRefPtr<CefV8Value> obj = CefV8Value::CreateObject( NULL, NULL );
                    retval = CefV8Value::CreateObject( NULL, NULL );
                    obj->SetValue("isCharging", CefV8Value::CreateBool(true), V8_PROPERTY_ATTRIBUTE_READONLY);
                    obj->SetValue("level", CefV8Value::CreateUInt(0), V8_PROPERTY_ATTRIBUTE_READONLY);
                    obj->SetValue("timeLeft",  CefV8Value::CreateUInt(1), V8_PROPERTY_ATTRIBUTE_READONLY );
                    retval ->SetValue("BatteryStatus", obj, V8_PROPERTY_ATTRIBUTE_NONE );
                    
                    arguments[2]->ExecuteFunction(obj, arguments);
                   
                    return true;
                }
                else {
                    exception = "123";
                    return true;
                }
               
                // Return my string value.
               // exception = "1";
                if ( arguments.size() == 0 )
                    exception = "0";
                if ( arguments.size() == 1 )
                    exception = "1";
                
                if ( arguments.size() == 2 )
                    exception = "2";
                
                if ( arguments.size() == 3 )
                    exception = "3";
                
                if ( arguments.size() == 4 )
                    exception = "4";
                
                exception = funcName;
                return true;
                
               
                
                return true;
            }
            
            exception = "no";
            
            // Function does not exist.
            return false;
        }
        
        // Provide the reference counting implementation for this class.
        IMPLEMENT_REFCOUNTING(MyV8Handler);
    };

void ClientAppRenderer::OnWebKitInitialized() {
    CefRefPtr<MyV8Handler> handlerExt = new MyV8Handler();
    
    std::string extensionCode =

    "var __macOsAppHostObject;"
    "if (!__macOsAppHostObject)"
    "  __macOsAppHostObject = {};"
    "(function() {"
    "  __macOsAppHostObject.handleBrowserRequest = function(namem, args,resolve, reject ) {"
    "    native function handleBrowserRequest();"
    "    return handleBrowserRequest(namem, args, resolve, reject);"
  //  "    return new Promise(function(resolve, reject) {"
  //  "    handleBrowserRequest(namem, args, resolve, reject);"
   // "    })"
    "  };"
    "})();";
  
    // Register the extension.
    CefRegisterExtension("__macOsAppHostObject", extensionCode, handlerExt);

    
  DelegateSet::iterator it = delegates_.begin();
  for (; it != delegates_.end(); ++it)
    (*it)->OnWebKitInitialized(this);
}

void ClientAppRenderer::OnBrowserCreated(CefRefPtr<CefBrowser> browser) {
  DelegateSet::iterator it = delegates_.begin();
  for (; it != delegates_.end(); ++it)
    (*it)->OnBrowserCreated(this, browser);
}

void ClientAppRenderer::OnBrowserDestroyed(CefRefPtr<CefBrowser> browser) {
  DelegateSet::iterator it = delegates_.begin();
  for (; it != delegates_.end(); ++it)
    (*it)->OnBrowserDestroyed(this, browser);
}

CefRefPtr<CefLoadHandler> ClientAppRenderer::GetLoadHandler() {
  CefRefPtr<CefLoadHandler> load_handler;
  DelegateSet::iterator it = delegates_.begin();
  for (; it != delegates_.end() && !load_handler.get(); ++it)
    load_handler = (*it)->GetLoadHandler(this);

  return load_handler;
}

void ClientAppRenderer::OnContextCreated(CefRefPtr<CefBrowser> browser,
                                         CefRefPtr<CefFrame> frame,
                                         CefRefPtr<CefV8Context> context) {
  DelegateSet::iterator it = delegates_.begin();
  for (; it != delegates_.end(); ++it)
    (*it)->OnContextCreated(this, browser, frame, context);
}

void ClientAppRenderer::OnContextReleased(CefRefPtr<CefBrowser> browser,
                                          CefRefPtr<CefFrame> frame,
                                          CefRefPtr<CefV8Context> context) {
  DelegateSet::iterator it = delegates_.begin();
  for (; it != delegates_.end(); ++it)
    (*it)->OnContextReleased(this, browser, frame, context);
}

void ClientAppRenderer::OnUncaughtException(
    CefRefPtr<CefBrowser> browser,
    CefRefPtr<CefFrame> frame,
    CefRefPtr<CefV8Context> context,
    CefRefPtr<CefV8Exception> exception,
    CefRefPtr<CefV8StackTrace> stackTrace) {
  DelegateSet::iterator it = delegates_.begin();
  for (; it != delegates_.end(); ++it) {
    (*it)->OnUncaughtException(this, browser, frame, context, exception,
                               stackTrace);
  }
}

void ClientAppRenderer::OnFocusedNodeChanged(CefRefPtr<CefBrowser> browser,
                                             CefRefPtr<CefFrame> frame,
                                             CefRefPtr<CefDOMNode> node) {
  DelegateSet::iterator it = delegates_.begin();
  for (; it != delegates_.end(); ++it)
    (*it)->OnFocusedNodeChanged(this, browser, frame, node);
}

bool ClientAppRenderer::OnProcessMessageReceived(
    CefRefPtr<CefBrowser> browser,
    CefProcessId source_process,
    CefRefPtr<CefProcessMessage> message) {
  DCHECK_EQ(source_process, PID_BROWSER);

  bool handled = false;

  DelegateSet::iterator it = delegates_.begin();
  for (; it != delegates_.end() && !handled; ++it) {
    handled =
        (*it)->OnProcessMessageReceived(this, browser, source_process, message);
  }

  return handled;
}

}  // namespace client
