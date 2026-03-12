# Ceres Solver - A fast non-linear least squares minimizer
# Copyright 2024 Google Inc. All rights reserved.
# http://ceres-solver.org/
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# * Neither the name of Google Inc. nor the names of its contributors may be
#   used to endorse or promote products derived from this software without
#   specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# FindCUDSS.cmake - Helper to find NVIDIA cuDSS when using find_package(cudss CONFIG).
#                   On Debian/Ubuntu, libcudss installs to non-standard paths that
#                   CONFIG mode does not search; this module hints cudss_DIR and
#                   cudss_INCLUDE_DIR so find_package(cudss CONFIG) can succeed.
#
# After inclusion, cudss_FOUND and related variables are set by find_package(cudss CONFIG).

if(NOT cudss_DIR)
  file(GLOB _cudss_cfg "/usr/lib/*/libcudss/*/cmake/cudss/cudss-config.cmake"
       "/usr/lib/*/libcudss/*/cmake/cudss/cudssConfig.cmake")
  list(GET _cudss_cfg 0 _cudss_first)
  if(_cudss_first)
    get_filename_component(cudss_DIR "${_cudss_first}" DIRECTORY)
    set(cudss_DIR "${cudss_DIR}" CACHE PATH "cuDSS CMake config directory")
  endif()
  unset(_cudss_cfg)
  unset(_cudss_first)
endif()

# Debian/Ubuntu put headers in /usr/include/libcudss/<ver>/; cudss-config.cmake
# looks only relative to the lib path, so hint the include dir when not set.
if(NOT cudss_INCLUDE_DIR)
  file(GLOB _cudss_inc_dirs "/usr/include/libcudss/*")
  foreach(_cudss_inc IN LISTS _cudss_inc_dirs)
    if(EXISTS "${_cudss_inc}/cudss.h")
      set(cudss_INCLUDE_DIR "${_cudss_inc}" CACHE PATH "cuDSS include directory")
      break()
    endif()
  endforeach()
  unset(_cudss_inc_dirs)
  unset(_cudss_inc)
endif()

find_package(cudss CONFIG)
