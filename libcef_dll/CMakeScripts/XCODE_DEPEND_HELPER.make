# DO NOT EDIT
# This makefile makes sure all linkable targets are
# up-to-date with anything they link to
default:
	echo "Do not invoke directly"

# Rules to remove targets that are older than anything to which they
# link.  This forces Xcode to relink the targets from scratch.  It
# does not seem to check these dependencies itself.
PostBuild.libcef_dll_wrapper.Debug:
/Users/admin/cef/libcef_dll/Debug/libcef_dll_wrapper.a:
	/bin/rm -f /Users/admin/cef/libcef_dll/Debug/libcef_dll_wrapper.a


PostBuild.libcef_dll_wrapper.Release:
/Users/admin/cef/libcef_dll/Release/libcef_dll_wrapper.a:
	/bin/rm -f /Users/admin/cef/libcef_dll/Release/libcef_dll_wrapper.a


PostBuild.libcef_dll_wrapper.MinSizeRel:
/Users/admin/cef/libcef_dll/MinSizeRel/libcef_dll_wrapper.a:
	/bin/rm -f /Users/admin/cef/libcef_dll/MinSizeRel/libcef_dll_wrapper.a


PostBuild.libcef_dll_wrapper.RelWithDebInfo:
/Users/admin/cef/libcef_dll/RelWithDebInfo/libcef_dll_wrapper.a:
	/bin/rm -f /Users/admin/cef/libcef_dll/RelWithDebInfo/libcef_dll_wrapper.a




# For each target create a dummy ruleso the target does not have to exist
