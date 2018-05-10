// Copyright (c) 2012 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

#ifndef CEF_TESTS_CEFCLIENT_RENDERER_CLIENT_RENDERER_H_
#define CEF_TESTS_CEFCLIENT_RENDERER_CLIENT_RENDERER_H_
#pragma once



#include "include/cef_base.h"
#include "tests/shared/renderer/client_app_renderer.h"
/*
#if defined(OS_MACOSX)
// Forward declaration of ObjC types used by cefclient and not provided by
// include/internal/cef_types_mac.h.
#ifdef __cplusplus
#ifdef __OBJC__
@class QuitDialog;
#else
class QuitDialog;
#endif
#endif
#endif  // defined OS_MACOSX
*/
namespace client {
namespace renderer {

// Create the renderer delegate. Called from client_app_delegates_renderer.cc.
void CreateDelegates(ClientAppRenderer::DelegateSet& delegates);

}  // namespace renderer
}  // namespace client

#endif  // CEF_TESTS_CEFCLIENT_RENDERER_CLIENT_RENDERER_H_
