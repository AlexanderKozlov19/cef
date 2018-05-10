//
//  appbridge_handler.h
//  Janison_Replay_Helper
//
//  Created by Alexander Kozlov on 10.05.2018.
//

#ifndef appbridge_handler_h
#define appbridge_handler_h

#include "include/cef_base.h"
#include "tests/shared/renderer/client_app_renderer.h"
//#include "tests/cefclient/renderer/client_renderer.h"

namespace client {
    namespace  {
        
        class MyV8Handler : public CefV8Handler {
        private:
            CefRefPtr<ClientAppRenderer> client_app_;
            
        public:
           // MyV8Handler() {}
            explicit MyV8Handler(CefRefPtr<ClientAppRenderer> client_app)
            : client_app_(client_app) { }
            
            virtual bool Execute(const CefString& name,
                                 CefRefPtr<CefV8Value> object,
                                 const CefV8ValueList& arguments,
                                 CefRefPtr<CefV8Value>& retval,
                                 CefString& exception) OVERRIDE;
            
            IMPLEMENT_REFCOUNTING(MyV8Handler);
        
        };
        
    }  // namespace renderer
} 

#endif /* appbridge_handler_h */
