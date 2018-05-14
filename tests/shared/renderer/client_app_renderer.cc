// Copyright (c) 2013 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

#include "tests/shared/renderer/client_app_renderer.h"

#include "include/base/cef_logging.h"
#include "tests/cefclient/renderer/appbridge_handler.cc"
#include "include/cef_parser.h"

namespace client {
    
const char kSetVersionInfo[] = "hostApp.getAppVersionInfo";

ClientAppRenderer::ClientAppRenderer() {
  CreateDelegates(delegates_);
}

void ClientAppRenderer::OnRenderThreadCreated(
    CefRefPtr<CefListValue> extra_info) {
  DelegateSet::iterator it = delegates_.begin();
  for (; it != delegates_.end(); ++it)
    (*it)->OnRenderThreadCreated(this, extra_info);
}

void ClientAppRenderer::OnWebKitInitialized() {
    MyV8Handler *appBridgeHandler = new MyV8Handler( this );
    
    std::string extensionCode =
    
    "var __macOsAppHostObject;"
    "if (!__macOsAppHostObject)"
    "  __macOsAppHostObject = {};"
    "(function() {"
    "  __macOsAppHostObject.handleBrowserRequest = function(namem, args,resolve, reject ) {"
    "    native function handleBrowserRequest();"
    "    return handleBrowserRequest(namem, args, resolve, reject);"
    "  };"
    "})();"
    "(function() {"
    "  __macOsAppHostObject.subscribeToEvents = function( args,resolve, reject ) {"
    "    native function subscribeToEvents();"
    "    return subscribeToEvents(args, resolve, reject);"
    "  };"
    "})();";
    
    // Register the extension.
    CefRegisterExtension("__macOsAppHostObject", extensionCode, appBridgeHandler);
    
    
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
    
    
void ClientAppRenderer::SetMessageCallback(const std::string& message_name,
                                       int browser_id,
                                       CefRefPtr<CefV8Context> context,
                                       CefRefPtr<CefV8Value> function) {
    
    CefString message_name_CEF = message_name;
    CallbackMap::const_iterator it = callback_map_.begin();
    
    while ( it != callback_map_.end()) {
        std::string testString = it->first.first;
        if ( testString == message_name ) {
            callback_map_.erase(it);
            it = callback_map_.begin();
        }
        else it++;
    }
    
    callback_map_.insert( std::make_pair(std::make_pair(message_name, browser_id), std::make_pair(context, function)));
}

bool ClientAppRenderer::OnProcessMessageReceived(
    CefRefPtr<CefBrowser> browser,
    CefProcessId source_process,
    CefRefPtr<CefProcessMessage> message) {
  DCHECK_EQ(source_process, PID_BROWSER);
    
    std::string message_name_test = message->GetName();
    
    if ( message_name_test == kSetVersionInfo ) {
        CefString verApp = message->GetArgumentList()->GetString(0);
        
        CefString message_name = message->GetName();
        CallbackMap::const_iterator it = callback_map_.find( std::make_pair(message_name.ToString(), browser->GetIdentifier()));
        
        if (it != callback_map_.end()) {
            // Enter the context.
            it->second.first->Enter();
            
            CefRefPtr<CefDictionaryValue> result_dict = CefDictionaryValue::Create();
            result_dict->SetNull("number");
            result_dict->SetString( "name", verApp);
            
            CefRefPtr<CefValue> value = CefValue::Create();
            
            value->SetDictionary(result_dict);
            
            std::string json = CefWriteJSON(value, JSON_WRITER_DEFAULT);
            
            CefRefPtr<CefV8Value> cef8String = CefV8Value::CreateString(json);
            
            CefV8ValueList argsForCallback;
            argsForCallback.push_back(cef8String);

            
            // Execute the callback.
            CefRefPtr<CefV8Value> retval =
            it->second.second->ExecuteFunction(NULL, argsForCallback);
            
            // Exit the context.
            it->second.first->Exit();
            
            callback_map_.erase( it );
        }
        
        return true;
    }
    
    if ( message_name_test == kRetrieveBatteryInfo ) {
        bool isPresent = message->GetArgumentList()->GetBool(0);
    
        CefString message_name = message->GetName();
        CallbackMap::const_iterator it = callback_map_.find( std::make_pair(message_name.ToString(), browser->GetIdentifier()));
        
        if (it != callback_map_.end()) {
            // Enter the context.
            it->second.first->Enter();
            
            CefRefPtr<CefDictionaryValue> result_dict = CefDictionaryValue::Create();
            if ( isPresent ) {
                bool isCharging = message->GetArgumentList()->GetBool(1);
                result_dict->SetBool("isCharging", isCharging);
                double percentage = message->GetArgumentList()->GetDouble(2);
                result_dict->SetDouble("level", percentage);
                unsigned int seconds = message->GetArgumentList()->GetInt(3);
                result_dict->SetInt("timeLeft", seconds);
            }
            else {
                result_dict->SetBool("isCharging", true);
                result_dict->SetNull("level");
                result_dict->SetNull("timeLeft");
            }
           
            
            CefRefPtr<CefValue> value = CefValue::Create();
            
            value->SetDictionary(result_dict);
            
            std::string json = CefWriteJSON(value, JSON_WRITER_DEFAULT);
            
            CefRefPtr<CefV8Value> cef8String = CefV8Value::CreateString(json);
            
            CefV8ValueList argsForCallback;
            argsForCallback.push_back(cef8String);
            
            
            // Execute the callback.
            CefRefPtr<CefV8Value> retval =
            it->second.second->ExecuteFunction(NULL, argsForCallback);
            
            // Exit the context.
            it->second.first->Exit();
            
            callback_map_.erase( it );
        }
        
       
    }
    
    if ( ( message_name_test == kRetrieveKeyboardLayouts ) || ( message_name_test == kGetCurrentLayoutID ) ) {
        
        CefString message_name = message->GetName();
        CallbackMap::const_iterator it = callback_map_.find( std::make_pair(message_name.ToString(), browser->GetIdentifier()));
        
        if (it != callback_map_.end()) {
            // Enter the context.
            it->second.first->Enter();
            
            CefString stringJSON = message->GetArgumentList()->GetString(0);
            
            CefRefPtr<CefV8Value> cef8String = CefV8Value::CreateString(stringJSON);
            
            CefV8ValueList argsForCallback;
            argsForCallback.push_back(cef8String);
            
            // Execute the callback.
            CefRefPtr<CefV8Value> retval =
            it->second.second->ExecuteFunction(NULL, argsForCallback);
            
            // Exit the context.
            it->second.first->Exit();
            
            callback_map_.erase( it );
        }
        
        
        return true;
    }
    
    if ( message_name_test == kSetCurrentLayoutID ) {
        
        CefString message_name = message->GetName();
        CallbackMap::const_iterator it = callback_map_.find( std::make_pair(message_name.ToString(), browser->GetIdentifier()));
        
        if (it != callback_map_.end()) {
            // Enter the context.
            it->second.first->Enter();

            
            bool result = message->GetArgumentList()->GetBool(0);
            
            CefRefPtr<CefV8Value> cef8String = CefV8Value::CreateBool( result );
            
            CefV8ValueList argsForCallback;
            argsForCallback.push_back(cef8String);
            
            // Execute the callback.
            CefRefPtr<CefV8Value> retval =
            it->second.second->ExecuteFunction(NULL, argsForCallback);
            
            // Exit the context.
            it->second.first->Exit();
            
            callback_map_.erase( it );
        }
        
        
        return true;
    }
    
    if ( message_name_test == kSubscribeToEvents ) {
        CefString message_name = message->GetName();
        CallbackMap::const_iterator it = callback_map_.find( std::make_pair(message_name.ToString(), browser->GetIdentifier()));
        
        if (it != callback_map_.end()) {
            // Enter the context.
            it->second.first->Enter();
            
            CefString apiName = message->GetArgumentList()->GetString(0);
            CefString eventName = message->GetArgumentList()->GetString(1);
            CefString argsJSON = message->GetArgumentList()->GetString(2);
            
            CefV8ValueList argsForCallback;
            
            CefRefPtr<CefV8Value> cefApiName = CefV8Value::CreateString( apiName );
            argsForCallback.push_back(cefApiName);
            
            CefRefPtr<CefV8Value> cefEventName = CefV8Value::CreateString( eventName );
            argsForCallback.push_back(cefEventName);
            
            CefRefPtr<CefV8Value> cefArgsJSON = CefV8Value::CreateString( argsJSON );
            argsForCallback.push_back(cefArgsJSON);
            
            // Execute the callback.
            CefRefPtr<CefV8Value> retval =
            it->second.second->ExecuteFunction(NULL, argsForCallback);
            
            // Exit the context.
            it->second.first->Exit();
            
        }
        
        
        return true;
        
    }

  bool handled = false;

  DelegateSet::iterator it = delegates_.begin();
  for (; it != delegates_.end() && !handled; ++it) {
    handled =
        (*it)->OnProcessMessageReceived(this, browser, source_process, message);
  }

  return handled;
}

}  // namespace client
