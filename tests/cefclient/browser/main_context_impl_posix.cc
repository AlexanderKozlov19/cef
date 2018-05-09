// Copyright (c) 2015 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

#include "tests/cefclient/browser/main_context_impl.h"

#include <unistd.h>
#include <mach-o/dyld.h>



namespace client {

std::string MainContextImpl::GetDownloadPath(const std::string& file_name) {
  return std::string();
}

std::string MainContextImpl::GetAppWorkingDirectory() {

    char exePath[PATH_MAX];
    uint32_t len = sizeof(exePath);
    if (_NSGetExecutablePath(exePath, &len) != 0) {
        exePath[0] = '\0'; // buffer too small (!)
    } else {
        // resolve symlinks, ., .. if possible
        char *canonicalPath = realpath(exePath, NULL);
        if (canonicalPath != NULL) {
            strncpy(exePath,canonicalPath,len);
            free(canonicalPath);
        }
    }
    
    std::string str = std::string(exePath);
    int index = str.rfind("MacOS");
    str.erase(index);
   // str = str + "Resources/";
    
    /*
    std::string str = std::string(exePath);
    int index = str.find("Debug/Janison Replay.app");
    //    str.erase(index);
    str = str.substr(0, index);
    str = str + "Resources/";
     */


    return str;
  /*
  char szWorkingDir[512];
  if (getcwd(szWorkingDir, sizeof(szWorkingDir) - 1) == NULL) {
    szWorkingDir[0] = 0;
  } else {
    // Add trailing path separator.
    size_t len = strlen(szWorkingDir);
    szWorkingDir[len] = '/';
    szWorkingDir[len + 1] = 0;
    
      
   
  }
  return szWorkingDir;
   */
}

}  // namespace client
