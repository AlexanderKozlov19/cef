// Copyright (c) 2012 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.



#include "tests/cefclient/renderer/client_renderer.h"

//#import "tests/cefclient/QuitDialog/QuitDialogWrapper.h"

#include <sstream>
#include <string>


#include "include/cef_crash_util.h"
#include "include/cef_dom.h"
#include "include/wrapper/cef_helpers.h"
#include "include/wrapper/cef_message_router.h"
#include "include/cef_parser.h"

namespace client {
namespace renderer {

namespace {

// Must match the value in client_handler.cc.
const char kFocusedNodeChangedMessage[] = "ClientRenderer.FocusedNodeChanged";
const char kTerminateProcess[] = "ClientRenderer.TerminateProcess";

class ClientRenderDelegate : public ClientAppRenderer::Delegate {
 public:
  ClientRenderDelegate() : last_node_is_editable_(false) {}

  void OnRenderThreadCreated(CefRefPtr<ClientAppRenderer> app,
                             CefRefPtr<CefListValue> extra_info) OVERRIDE {
    if (CefCrashReportingEnabled()) {
      // Set some crash keys for testing purposes. Keys must be defined in the
      // "crash_reporter.cfg" file. See cef_crash_util.h for details.
      CefSetCrashKeyValue("testkey_small1", "value1_small_renderer");
      CefSetCrashKeyValue("testkey_small2", "value2_small_renderer");
      CefSetCrashKeyValue("testkey_medium1", "value1_medium_renderer");
      CefSetCrashKeyValue("testkey_medium2", "value2_medium_renderer");
      CefSetCrashKeyValue("testkey_large1", "value1_large_renderer");
      CefSetCrashKeyValue("testkey_large2", "value2_large_renderer");
    }
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
                
                CefString funcName = arguments[0]->GetStringValue();
                
                if ( funcName == "battery.getStatus" ) {
                    
                    CefRefPtr<CefDictionaryValue> result_dict = CefDictionaryValue::Create();
                    result_dict->SetBool("isCharging", true);
                    result_dict->SetDouble( "level", 1);
                    result_dict->SetDouble("timeLeft", 1);
                    
                    //CefRefPtr<CefDictionaryValue> objectJSON = CefDictionaryValue::Create();
                    //objectJSON->SetDictionary("BatteryStatus", result_dict);
                    
                    CefRefPtr<CefValue> value = CefValue::Create();
                    
                    value->SetDictionary(result_dict);
                    
                    std::string json = CefWriteJSON(value, JSON_WRITER_DEFAULT);
                    
                    CefRefPtr<CefV8Value> cef8String = CefV8Value::CreateString(json);
                    
                    CefV8ValueList argsForCallback;
                    argsForCallback.push_back(cef8String);
                    
                    arguments[2]->ExecuteFunction(nullptr, argsForCallback);
                    
                    return true;
                }
                else
                    if ( funcName == "hostApp.requestTermination" ) {
                        
                        CefRefPtr<CefProcessMessage> message =
                        CefProcessMessage::Create(kTerminateProcess);
                        //message->GetArgumentList()->SetBool(0, is_editable);
                        CefRefPtr<CefBrowser> browser = CefV8Context::GetCurrentContext()->GetBrowser();
                        browser->SendProcessMessage(PID_BROWSER, message);
                        
                        //exception = "Got";
                       // QuitDialogWrapper *quitDialogWrapper = new QuitDialogWrapper;
                       // quitDialogWrapper->create();
                        
                        
                        
                       // QuitDialog *quitDialog = [[QuitDialog alloc] initWithWindowNibName:@"QuitDialog"];
                       // quitDialog = NULL;
                        
                    
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

  void OnWebKitInitialized(CefRefPtr<ClientAppRenderer> app) OVERRIDE {
    // Create the renderer-side router for query handling.
    CefMessageRouterConfig config;
    message_router_ = CefMessageRouterRendererSide::Create(config);
      
      CefRefPtr<MyV8Handler> handlerExt = new MyV8Handler();
      
      std::string extensionCode =
      
      "var __macOsAppHostObject;"
      "if (!__macOsAppHostObject)"
      "  __macOsAppHostObject = {};"
      "(function() {"
      "  __macOsAppHostObject.handleBrowserRequest = function(namem, args,resolve, reject ) {"
      "    native function handleBrowserRequest();"
      "    return handleBrowserRequest(namem, args, resolve, reject);"
      "  };"
      "})();";
      
      // Register the extension.
      CefRegisterExtension("__macOsAppHostObject", extensionCode, handlerExt);
  }

  void OnContextCreated(CefRefPtr<ClientAppRenderer> app,
                        CefRefPtr<CefBrowser> browser,
                        CefRefPtr<CefFrame> frame,
                        CefRefPtr<CefV8Context> context) OVERRIDE {
    message_router_->OnContextCreated(browser, frame, context);
  }

  void OnContextReleased(CefRefPtr<ClientAppRenderer> app,
                         CefRefPtr<CefBrowser> browser,
                         CefRefPtr<CefFrame> frame,
                         CefRefPtr<CefV8Context> context) OVERRIDE {
    message_router_->OnContextReleased(browser, frame, context);
  }

  void OnFocusedNodeChanged(CefRefPtr<ClientAppRenderer> app,
                            CefRefPtr<CefBrowser> browser,
                            CefRefPtr<CefFrame> frame,
                            CefRefPtr<CefDOMNode> node) OVERRIDE {
    bool is_editable = (node.get() && node->IsEditable());
    if (is_editable != last_node_is_editable_) {
      // Notify the browser of the change in focused element type.
      last_node_is_editable_ = is_editable;
      CefRefPtr<CefProcessMessage> message =
          CefProcessMessage::Create(kFocusedNodeChangedMessage);
      message->GetArgumentList()->SetBool(0, is_editable);
      browser->SendProcessMessage(PID_BROWSER, message);
    }
  }

  bool OnProcessMessageReceived(CefRefPtr<ClientAppRenderer> app,
                                CefRefPtr<CefBrowser> browser,
                                CefProcessId source_process,
                                CefRefPtr<CefProcessMessage> message) OVERRIDE {
    return message_router_->OnProcessMessageReceived(browser, source_process,
                                                     message);
  }

 private:
  bool last_node_is_editable_;

  // Handles the renderer side of query routing.
  CefRefPtr<CefMessageRouterRendererSide> message_router_;

  DISALLOW_COPY_AND_ASSIGN(ClientRenderDelegate);
  IMPLEMENT_REFCOUNTING(ClientRenderDelegate);
};

}  // namespace

void CreateDelegates(ClientAppRenderer::DelegateSet& delegates) {
  delegates.insert(new ClientRenderDelegate);
}

}  // namespace renderer
}  // namespace client
