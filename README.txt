Janison Replay for Mac OS
-------------------------
Based on Chromium Version: 66.0.3359.117


CONTENTS
--------

cmake       Contains CMake configuration files shared by all targets.

Debug       Contains the "Chromium Embedded Framework.framework" and other
            components required to run the debug version of CEF-based
            applications.

include     Contains all required CEF header files.

libcef_dll  Contains the source code for the libcef_dll_wrapper static library
            that all applications using the CEF C++ API must link against.

Release     Contains the "Chromium Embedded Framework.framework" and other
            components required to run the release version of CEF-based
            applications.

tests/      Directory of tests that demonstrate CEF usage.

  cefclient Contains the Janison Replay.

  shared    Contains shared source code.


USAGE
-----

1. Clone repository from https://github.com/AlexanderKozlov19/cef.git.
2. Download CMake from https://cmake.org/download/
3. Launch CMake.
4. Select «Where is the source code» to subfolder /cef/libcef_dll, and «Where to build the binaries» to subfolder /cef/libcef_dll_wrapper. Then press «Configure» (leave default settings - XCode and «Use default native compiler») and «Generate». 5. Select «Where is the source code» to subfolder /cef, and «Where to build the binaries» to subfolder /cef. Then press «Configure» (leave default settings - XCode and «Use default native compiler» and «Generate».
6. Launch /cef/MakeCef.command with double click or open terminal in folder /cef and type ./MakeCef.command. If there are no permissions to launch this script, open terminal in folder /cef and type command "chmod u+x MakeCef.command" and press Enter. After MakeCef.command will finish in folder /cef/release/Chromium Embedded Framework.framework and /cef/debug/Chromium Embedded Framework.framework file "Chromium Embedded Framework" will be present.
7. In Xcode open file cef.xcodeproj, select Target "Janison Replay", build and run Jansion Replay application.
