//
//  appbridge_handler.c
//  Janison_Replay_Helper
//
//  Created by Alexander Kozlov on 10.05.2018.
//

#include "tests/cefclient/renderer/client_renderer.h"

#include <sstream>
#include <string>

#include "include/cef_crash_util.h"
#include "include/cef_dom.h"
#include "include/wrapper/cef_helpers.h"
#include "include/wrapper/cef_message_router.h"
#include "include/cef_parser.h"


#include "appbridge_handler.h"

namespace client {
    namespace  {
        
    const char kAskAdminPassword[] = "AppBridge.AskAmdinPassword";
    const char kGetVersionInfo[] = "AppBridge.getAppVersionInfo";
    const char kRetrieveBatteryInfo[] = "battery.getStatus";
    const char kRetrieveKeyboardLayouts[] = "keyboardLayout.getLayouts";
    const char kSetCurrentLayoutID[] = "keyboardLayout.trySetCurrentLayoutId";
    const char kGetCurrentLayoutID[] = "keyboardLayout.getCurrentLayoutId";
    const char kSubscribeToEvents[] =  "subscribeToEvents";
    const char kMachineName[] = "hostApp.getMachineName";
   
        
    bool MyV8Handler::Execute(const CefString& name,
                                 CefRefPtr<CefV8Value> object,
                                 const CefV8ValueList& arguments,
                                 CefRefPtr<CefV8Value>& retval,
                                 CefString& exception) {
                
                
                
    if (name == "handleBrowserRequest") {
        
        CefString funcName = arguments[0]->GetStringValue();
        
        if ( funcName == "battery.getStatus" ) {
            
            std::string name = funcName;
            CefRefPtr<CefV8Context> context = CefV8Context::GetCurrentContext();
            int browser_id = context->GetBrowser()->GetIdentifier();
            client_app_->SetMessageCallback(name, browser_id, context,
                                            arguments[2]);
            
            CefRefPtr<CefProcessMessage> message =
            CefProcessMessage::Create(kRetrieveBatteryInfo);
            
            CefRefPtr<CefBrowser> browser = CefV8Context::GetCurrentContext()->GetBrowser();
            browser->SendProcessMessage(PID_BROWSER, message);
            
           /* CefRefPtr<CefDictionaryValue> result_dict = CefDictionaryValue::Create();
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
            */
            
            return true;
        }
        else
            if ( funcName == "hostApp.requestTermination" ) {
 
                CefRefPtr<CefProcessMessage> message =
                CefProcessMessage::Create(kAskAdminPassword);
                
                CefRefPtr<CefBrowser> browser = CefV8Context::GetCurrentContext()->GetBrowser();
                browser->SendProcessMessage(PID_BROWSER, message);
              
                return true;
            }
        else
            if ( funcName == "hostApp.getDeviceRecord") {
                CefRefPtr<CefV8Value> cef8String = CefV8Value::CreateString("Not implemented yet!");
                
                CefV8ValueList argsForCallback;
                argsForCallback.push_back(cef8String);
                
                arguments[3]->ExecuteFunction(nullptr, argsForCallback);
            }
        else
            if ( funcName == "hostApp.getAppVersionInfo" ) {
            
                std::string name = funcName;
                CefRefPtr<CefV8Context> context = CefV8Context::GetCurrentContext();
                int browser_id = context->GetBrowser()->GetIdentifier();
                client_app_->SetMessageCallback(name, browser_id, context,
                                                arguments[2]);
                
                CefRefPtr<CefProcessMessage> message =
                CefProcessMessage::Create(kGetVersionInfo);
               
                
                CefRefPtr<CefBrowser> browser = CefV8Context::GetCurrentContext()->GetBrowser();
                browser->SendProcessMessage(PID_BROWSER, message);
                
                return true;
            }
        else 
            if ( ( funcName == kRetrieveKeyboardLayouts ) || ( funcName == kGetCurrentLayoutID ) ) {
                std::string name = funcName;
                CefRefPtr<CefV8Context> context = CefV8Context::GetCurrentContext();
                int browser_id = context->GetBrowser()->GetIdentifier();
                client_app_->SetMessageCallback(name, browser_id, context,
                                                arguments[2]);
                
                CefRefPtr<CefProcessMessage> message =
                CefProcessMessage::Create(funcName);
                
                CefRefPtr<CefBrowser> browser = CefV8Context::GetCurrentContext()->GetBrowser();
                browser->SendProcessMessage(PID_BROWSER, message);
                
                return true;
            }
        else
            if ( funcName == kSetCurrentLayoutID ) {
                
                std::string name = funcName;
                CefRefPtr<CefV8Context> context = CefV8Context::GetCurrentContext();
                int browser_id = context->GetBrowser()->GetIdentifier();
                client_app_->SetMessageCallback(name, browser_id, context,
                                                arguments[2]);
                
                CefString code = arguments[1]->GetStringValue();
                
                CefRefPtr<CefProcessMessage> message =
                CefProcessMessage::Create(kSetCurrentLayoutID);
                message->GetArgumentList()->SetString(0, code);
                
                CefRefPtr<CefBrowser> browser = CefV8Context::GetCurrentContext()->GetBrowser();
                browser->SendProcessMessage(PID_BROWSER, message);
                
                 return true;
                }
        else
            if ( funcName == kMachineName ) {
                
                std::string name = funcName;
                CefRefPtr<CefV8Context> context = CefV8Context::GetCurrentContext();
                int browser_id = context->GetBrowser()->GetIdentifier();
                client_app_->SetMessageCallback(name, browser_id, context,
                                                arguments[2]);
                
                CefRefPtr<CefProcessMessage> message =
                CefProcessMessage::Create(kMachineName);
                
                
                CefRefPtr<CefBrowser> browser = CefV8Context::GetCurrentContext()->GetBrowser();
                browser->SendProcessMessage(PID_BROWSER, message);
                
                return true;
                }
        else
            {
            exception = "no";
            return true;

            }

        }
    else {
        if ( name ==  kSubscribeToEvents) {
            
            CefRefPtr<CefV8Context> context = CefV8Context::GetCurrentContext();
            int browser_id = context->GetBrowser()->GetIdentifier();
            client_app_->SetMessageCallback(name, browser_id, context,
                                            arguments[0]);
            
            return true;
        }
       
    }

    
    // Function does not exist.
    return false;
}
        
    // void SendAppInfo( std::string appVersion ) {
        
  //  }
            
            // Provide the reference counting implementation for this class.

        
    }  // namespace renderer
}

