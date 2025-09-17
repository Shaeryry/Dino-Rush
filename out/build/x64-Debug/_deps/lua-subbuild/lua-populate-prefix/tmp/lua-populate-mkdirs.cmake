# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION ${CMAKE_VERSION}) # this file comes with cmake

# If CMAKE_DISABLE_SOURCE_CHANGES is set to true and the source directory is an
# existing directory in our source tree, calling file(MAKE_DIRECTORY) on it
# would cause a fatal error, even though it would be a no-op.
if(NOT EXISTS "C:/HOWEST/SoftwareEngineering/SE_Exam_2DAE11_Kipula_Rity/Project/out/build/x64-Debug/_deps/lua-src")
  file(MAKE_DIRECTORY "C:/HOWEST/SoftwareEngineering/SE_Exam_2DAE11_Kipula_Rity/Project/out/build/x64-Debug/_deps/lua-src")
endif()
file(MAKE_DIRECTORY
  "C:/HOWEST/SoftwareEngineering/SE_Exam_2DAE11_Kipula_Rity/Project/out/build/x64-Debug/_deps/lua-build"
  "C:/HOWEST/SoftwareEngineering/SE_Exam_2DAE11_Kipula_Rity/Project/out/build/x64-Debug/_deps/lua-subbuild/lua-populate-prefix"
  "C:/HOWEST/SoftwareEngineering/SE_Exam_2DAE11_Kipula_Rity/Project/out/build/x64-Debug/_deps/lua-subbuild/lua-populate-prefix/tmp"
  "C:/HOWEST/SoftwareEngineering/SE_Exam_2DAE11_Kipula_Rity/Project/out/build/x64-Debug/_deps/lua-subbuild/lua-populate-prefix/src/lua-populate-stamp"
  "C:/HOWEST/SoftwareEngineering/SE_Exam_2DAE11_Kipula_Rity/Project/out/build/x64-Debug/_deps/lua-subbuild/lua-populate-prefix/src"
  "C:/HOWEST/SoftwareEngineering/SE_Exam_2DAE11_Kipula_Rity/Project/out/build/x64-Debug/_deps/lua-subbuild/lua-populate-prefix/src/lua-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "C:/HOWEST/SoftwareEngineering/SE_Exam_2DAE11_Kipula_Rity/Project/out/build/x64-Debug/_deps/lua-subbuild/lua-populate-prefix/src/lua-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "C:/HOWEST/SoftwareEngineering/SE_Exam_2DAE11_Kipula_Rity/Project/out/build/x64-Debug/_deps/lua-subbuild/lua-populate-prefix/src/lua-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
