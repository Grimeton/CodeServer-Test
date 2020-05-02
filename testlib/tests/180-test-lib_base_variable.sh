#!/usr/bin/env bash
#
#
# Copyright (c) 2020, <grimeton@gmx.net>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the software/distribution.
#
# 3. If we meet some day, and you think this stuff is worth it,
#    you can buy me a beer in return, Grimeton.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
if ! (return 0 2>/dev/null); then
    echo "THIS IS A CONFIGURATION FILE AND SHOULD NOT BE CALLED DIRECTLY. '($(realpath "${0}")'"
    exit 254
fi

set -o nounset

#####
#
# - lib_base_variable.sh
#

__tlogls lib_base_variable.sh

###
#
# - __variable_exists
#
__tlogfs __variable_exists

__tlogts "Error 101"
__tlogtsig 101 $(__variable_exists)

__tlogts "Error 1"
__tlogtsig 1 $(__variable_exists __MISSING_VARIABLE)

__tlogts "Error 0"
__tlogtsig 0 $(
    declare __EXISTING_VARIABLE="1"
    __variable_exists __EXISTING_VARIABLE
)

###
#
# - __variable_type_aarray
#
__tlogfs __variable_type_aarray

__tlogts "Error 101 - Empty argument."
__tlogtsig 101 $(__variable_type_aarray)

__tlogts "Error 101 - Non empty argument, missing variable."
__tlogtsig 101 $(__variable_type_aarray __MISSING_VARIABLE)

__tlogts "Error 0 - Existing variable, 'Associative Array'."
__tlogtsig 0 $(
    declare -A __TEST_VARIABLE=([a]=1 [b]=2 [c]=3)
    __variable_type_aarray __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Array'."
__tlogtsig 1 $(
    declare -a __TEST_VARIABLE=(1 2 3)
    __variable_type_aarray __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Function'."
__tlogtsig 1 $(
    function __TEST_VARIABLE() { return 0; }
    __variable_type_aarray __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Integer'."
__tlogtsig 1 $(
    declare -i __TEST_VARIABLE=1
    __variable_type_aarray __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Nameref'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE_DUMMY="ABC"
    declare -n __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_type_aarray __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'String'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE="test"
    __variable_type_aarray __TEST_VARIABLE
)

__tlogfe

###
#
# - __variable_type_array
#
__tlogfs __variable_type_array

__tlogts "Error 101 - Empty argument."
__tlogtsig 101 $(__variable_type_array)

__tlogts "Error 101 - Non empty argument, missing variable."
__tlogtsig 101 $(__variable_type_array __MISSING_VARIABLE)

__tlogts "Error 1 - Existing variable, 'Associative Array'."
__tlogtsig 1 $(
    declare -A __TEST_VARIABLE=([a]=1 [b]=2 [c]=3)
    __variable_type_array __TEST_VARIABLE
)

__tlogts "Error 0 - Existing variable, 'Array'."
__tlogtsig 0 $(
    declare -a __TEST_VARIABLE=(1 2 3)
    __variable_type_array __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Function'."
__tlogtsig 1 $(
    function __TEST_VARIABLE() { return 0; }
    __variable_type_array __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Integer'."
__tlogtsig 1 $(
    declare -i __TEST_VARIABLE=1
    __variable_type_array __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Nameref'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE_DUMMY="ABC"
    declare -n __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_type_array __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'String'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE="test"
    __variable_type_array __TEST_VARIABLE
)

__tlogfe
###
#
# - __variable_type_function
#
__tlogfs __variable_type_function

__tlogts "Error 101 - Empty argument."
__tlogtsig 101 $(__variable_type_function)

__tlogts "Error 101 - Non empty argument, missing variable."
__tlogtsig 101 $(__variable_type_function __MISSING_VARIABLE)

__tlogts "Error 1 - Existing variable, 'Associative Array'."
__tlogtsig 1 $(
    declare -A __TEST_VARIABLE=([a]=1 [b]=2 [c]=3)
    __variable_type_function __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Array'."
__tlogtsig 1 $(
    declare -a __TEST_VARIABLE=(1 2 3)
    __variable_type_function __TEST_VARIABLE
)

__tlogts "Error 0 - Existing variable, 'Function'."
__tlogtsig 0 $(
    function __TEST_VARIABLE() { return 0; }
    __variable_type_function __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Integer'."
__tlogtsig 1 $(
    declare -i __TEST_VARIABLE=1
    __variable_type_function __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Nameref'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE_DUMMY="ABC"
    declare -n __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_type_function __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'String'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE="test"
    __variable_type_function __TEST_VARIABLE
)

__tlogfe
###
#
# - __variable_type_integer
#
__tlogfs __variable_type_integer

__tlogts "Error 101 - Empty argument."
__tlogtsig 101 $(__variable_type_integer)

__tlogts "Error 101 - Non empty argument, missing variable."
__tlogtsig 101 $(__variable_type_integer __MISSING_VARIABLE)

__tlogts "Error 1 - Existing variable, 'Associative Array'."
__tlogtsig 1 $(
    declare -A __TEST_VARIABLE=([a]=1 [b]=2 [c]=3)
    __variable_type_integer __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Array'."
__tlogtsig 1 $(
    declare -a __TEST_VARIABLE=(1 2 3)
    __variable_type_integer __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Function'."
__tlogtsig 1 $(
    function __TEST_VARIABLE() { return 0; }
    __variable_type_integer __TEST_VARIABLE
)

__tlogts "Error 0 - Existing variable, 'Integer'."
__tlogtsig 0 $(
    declare -i __TEST_VARIABLE=1
    __variable_type_integer __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Nameref'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE_DUMMY="ABC"
    declare -n __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_type_integer __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'String'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE="test"
    __variable_type_integer __TEST_VARIABLE
)

__tlogfe
###
#
# - __variable_type_nameref
#
__tlogfs __variable_type_nameref

__tlogts "Error 101 - Empty argument."
__tlogtsig 101 $(__variable_type_nameref)

__tlogts "Error 101 - Non empty argument, missing variable."
__tlogtsig 101 $(__variable_type_nameref __MISSING_VARIABLE)

__tlogts "Error 1 - Existing variable, 'Associative Array'."
__tlogtsig 1 $(
    declare -A __TEST_VARIABLE=([a]=1 [b]=2 [c]=3)
    __variable_type_nameref __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Array'."
__tlogtsig 1 $(
    declare -a __TEST_VARIABLE=(1 2 3)
    __variable_type_nameref __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Function'."
__tlogtsig 1 $(
    function __TEST_VARIABLE() { return 0; }
    __variable_type_nameref __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Integer'."
__tlogtsig 1 $(
    declare -i __TEST_VARIABLE=1
    __variable_type_nameref __TEST_VARIABLE
)

__tlogts "Error 0 - Existing variable, 'Nameref'."
__tlogtsig 0 $(
    declare __TEST_VARIABLE_DUMMY="ABC"
    declare -n __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_type_nameref __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'String'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE="test"
    __variable_type_nameref __TEST_VARIABLE
)

__tlogfe
###
#
# - __variable_type_string
#
__tlogfs __variable_type_string

__tlogts "Error 101 - Empty argument."
__tlogtsig 101 $(__variable_type_string)

__tlogts "Error 101 - Non empty argument, missing variable."
__tlogtsig 101 $(__variable_type_string __MISSING_VARIABLE)

__tlogts "Error 1 - Existing variable, 'Associative Array'."
__tlogtsig 1 $(
    declare -A __TEST_VARIABLE=([a]=1 [b]=2 [c]=3)
    __variable_type_string __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Array'."
__tlogtsig 1 $(
    declare -a __TEST_VARIABLE=(1 2 3)
    __variable_type_string __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Function'."
__tlogtsig 1 $(
    function __TEST_VARIABLE() { return 0; }
    __variable_type_string __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Integer'."
__tlogtsig 1 $(
    declare -i __TEST_VARIABLE=1
    __variable_type_string __TEST_VARIABLE
)

__tlogts "Error 1 - Existing variable, 'Nameref'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE_DUMMY="ABC"
    declare -n __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_type_string __TEST_VARIABLE
)

__tlogts "Error 0 - Existing variable, 'String'."
__tlogtsig 0 $(
    declare __TEST_VARIABLE="test"
    __variable_type_string __TEST_VARIABLE
)

__tlogfe

###
#
# - __variable_mode_export
#
__tlogfs __variable_mode_export

__tlogts "Error 101 - Empty argument."
__tlogtsig 101 $(__variable_mode_export)

__tlogts "Error 101 - Missing variable."
__tlogtsig 101 $(__variable_mode_export __MISSING_VARIABLE)

__tlogts "Error 1 - Associative Array."
__tlogtsig 1 $(
    declare -A __TEST_VARIABLE=()
    __variable_mode_export __TEST_VARIABLE
)

__tlogts "Error 0 - Associative Array."
__tlogtsig 0 $(
    declare -Ax __TEST_VARIABLE=()
    __variable_mode_export __TEST_VARIABLE
)

__tlogts "Error 1 - Array."
__tlogtsig 1 $(
    declare -a __TEST_VARIABLE=()
    __variable_mode_export __TEST_VARIABLE
)

__tlogts "Error 0 - Array."
__tlogtsig 0 $(
    declare -ax __TEST_VARIABLE=()
    __variable_mode_export __TEST_VARIABLE
)

__tlogts "Error 1 - Function."
__tlogtsig 1 $(
    function __TEST_VARIABLE() { return 0; }
    __variable_mode_export __TEST_VARIABLE
)

__tlogts "Error 1 - Integer."
__tlogtsig 1 $(
    declare -i __TEST_VARIABLE=1
    __variable_mode_export __TEST_VARIABLE
)

__tlogts "Error 0 - Integer."
__tlogtsig 0 $(
    declare -ix __TEST_VARIABLE=1
    __tlogtsig 0 __variable_mode_export __TEST_VARIABLE
)

__tlogts "Error 1 - Nameref."
__tlogtsig 1 $(
    declare __TEST_VARIABLE_DUMMY=""
    declare -n __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_mode_export __TEST_VARIABLE
)

__tlogts "Error 0 - Nameref."
__tlogtsig 0 $(
    declare __TEST_VARIABLE_DUMMY=""
    declare -nx __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_mode_export __TEST_VARIABLE
)

__tlogts "Error 1 - String."
__tlogtsig 1 $(
    declare __TEST_VARIABLE=""
    __variable_mode_export __TEST_VARIABLE
)

__tlogts "Error 0 - String."
__tlogtsig 0 $(
    declare -x __TEST_VARIABLE=1
    __tlogtsig 0 __variable_mode_export __TEST_VARIABLE
)

__tlogfe

###
#
# - __variable_mode_lowercase
#
__tlogfs __variable_mode_lowercase

__tlogts "Error 101 - Empty argument."
__tlogtsig 101 $(__variable_mode_lowercase)

__tlogts "Error 101 - Missing variable."
__tlogtsig 101 $(__variable_mode_lowercase __MISSING_VARIABLE)

__tlogts "Error 1 - Associative Array."
__tlogtsig 1 $(
    declare -A __TEST_VARIABLE=()
    __variable_mode_lowercase __TEST_VARIABLE
)

__tlogts "Error 0 - Associative Array."
__tlogtsig 0 $(
    declare -Al __TEST_VARIABLE=()
    __variable_mode_lowercase __TEST_VARIABLE
)

__tlogts "Error 1 - Array."
__tlogtsig 1 $(
    declare -a __TEST_VARIABLE=()
    __variable_mode_lowercase __TEST_VARIABLE
)

__tlogts "Error 0 - Array."
__tlogtsig 0 $(
    declare -al __TEST_VARIABLE=()
    __variable_mode_lowercase __TEST_VARIABLE
)

__tlogts "Error 1 - Function."
__tlogtsig 1 $(
    function __TEST_VARIABLE() { return 0; }
    __variable_mode_lowercase __TEST_VARIABLE
)

__tlogts "Error 1 - Integer."
__tlogtsig 1 $(
    declare -i __TEST_VARIABLE=1
    __variable_mode_lowercase __TEST_VARIABLE
)

__tlogts "Error 0 - Integer."
__tlogtsig 0 $(
    declare -il __TEST_VARIABLE=1
    __tlogtsig 0 __variable_mode_lowercase __TEST_VARIABLE
)

__tlogts "Error 1 - Nameref."
__tlogtsig 1 $(
    declare __TEST_VARIABLE_DUMMY=""
    declare -n __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_mode_lowercase __TEST_VARIABLE
)

__tlogts "Error 0 - Nameref."
__tlogtsig 0 $(
    declare __TEST_VARIABLE_DUMMY=""
    declare -nl __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_mode_lowercase __TEST_VARIABLE
)

__tlogts "Error 1 - String."
__tlogtsig 1 $(
    declare __TEST_VARIABLE=""
    __variable_mode_lowercase __TEST_VARIABLE
)

__tlogts "Error 0 - String."
__tlogtsig 0 $(
    declare -l __TEST_VARIABLE=1
    __tlogtsig 0 __variable_mode_lowercase __TEST_VARIABLE
)

__tlogfe
###
#
# - __variable_mode_readonly
#
__tlogfs __variable_mode_readonly

__tlogts "Error 101 - Empty argument."
__tlogtsig 101 $(__variable_mode_readonly)

__tlogts "Error 101 - Missing variable."
__tlogtsig 101 $(__variable_mode_readonly __MISSING_VARIABLE)

__tlogts "Error 1 - Associative Array."
__tlogtsig 1 $(
    declare -A __TEST_VARIABLE=()
    __variable_mode_readonly __TEST_VARIABLE
)

__tlogts "Error 0 - Associative Array."
__tlogtsig 0 $(
    declare -Ar __TEST_VARIABLE=()
    __variable_mode_readonly __TEST_VARIABLE
)

__tlogts "Error 1 - Array."
__tlogtsig 1 $(
    declare -a __TEST_VARIABLE=()
    __variable_mode_readonly __TEST_VARIABLE
)

__tlogts "Error 0 - Array."
__tlogtsig 0 $(
    declare -ar __TEST_VARIABLE=()
    __variable_mode_readonly __TEST_VARIABLE
)

__tlogts "Error 1 - Function."
__tlogtsig 1 $(
    function __TEST_VARIABLE() { return 0; }
    __variable_mode_readonly __TEST_VARIABLE
)

__tlogts "Error 1 - Integer."
__tlogtsig 1 $(
    declare -i __TEST_VARIABLE=1
    __variable_mode_readonly __TEST_VARIABLE
)

__tlogts "Error 0 - Integer."
__tlogtsig 0 $(
    declare -ir __TEST_VARIABLE=1
    __tlogtsig 0 __variable_mode_readonly __TEST_VARIABLE
)

__tlogts "Error 1 - Nameref."
__tlogtsig 1 $(
    declare __TEST_VARIABLE_DUMMY=""
    declare -n __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_mode_readonly __TEST_VARIABLE
)

__tlogts "Error 0 - Nameref."
__tlogtsig 0 $(
    declare __TEST_VARIABLE_DUMMY=""
    declare -nr __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_mode_readonly __TEST_VARIABLE
)

__tlogts "Error 1 - String."
__tlogtsig 1 $(
    declare __TEST_VARIABLE=""
    __variable_mode_readonly __TEST_VARIABLE
)

__tlogts "Error 0 - String."
__tlogtsig 0 $(
    declare -r __TEST_VARIABLE=1
    __tlogtsig 0 __variable_mode_readonly __TEST_VARIABLE
)

__tlogfe
###
#
# - __variable_mode_trace
#
__tlogfs __variable_mode_trace

__tlogts "Error 101 - Empty argument."
__tlogtsig 101 $(__variable_mode_trace)

__tlogts "Error 101 - Missing variable."
__tlogtsig 101 $(__variable_mode_trace __MISSING_VARIABLE)

__tlogts "Error 1 - Associative Array."
__tlogtsig 1 $(
    declare -A __TEST_VARIABLE=()
    __variable_mode_trace __TEST_VARIABLE
)

__tlogts "Error 0 - Associative Array."
__tlogtsig 0 $(
    declare -At __TEST_VARIABLE=()
    __variable_mode_trace __TEST_VARIABLE
)

__tlogts "Error 1 - Array."
__tlogtsig 1 $(
    declare -a __TEST_VARIABLE=()
    __variable_mode_trace __TEST_VARIABLE
)

__tlogts "Error 0 - Array."
__tlogtsig 0 $(
    declare -at __TEST_VARIABLE=()
    __variable_mode_trace __TEST_VARIABLE
)

__tlogts "Error 1 - Function."
__tlogtsig 1 $(
    function __TEST_VARIABLE() { return 0; }
    __variable_mode_trace __TEST_VARIABLE
)

__tlogts "Error 1 - Integer."
__tlogtsig 1 $(
    declare -i __TEST_VARIABLE=1
    __variable_mode_trace __TEST_VARIABLE
)

__tlogts "Error 0 - Integer."
__tlogtsig 0 $(
    declare -it __TEST_VARIABLE=1
    __tlogtsig 0 __variable_mode_trace __TEST_VARIABLE
)

__tlogts "Error 1 - Nameref."
__tlogtsig 1 $(
    declare __TEST_VARIABLE_DUMMY=""
    declare -n __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_mode_trace __TEST_VARIABLE
)

__tlogts "Error 0 - Nameref."
__tlogtsig 0 $(
    declare __TEST_VARIABLE_DUMMY=""
    declare -nt __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_mode_trace __TEST_VARIABLE
)

__tlogts "Error 1 - String."
__tlogtsig 1 $(
    declare __TEST_VARIABLE=""
    __variable_mode_trace __TEST_VARIABLE
)

__tlogts "Error 0 - String."
__tlogtsig 0 $(
    declare -t __TEST_VARIABLE=1
    __tlogtsig 0 __variable_mode_trace __TEST_VARIABLE
)

__tlogfe
###
#
# - __variable_mode_uppercase
#
__tlogfs __variable_mode_uppercase

__tlogts "Error 101 - Empty argument."
__tlogtsig 101 $(__variable_mode_uppercase)

__tlogts "Error 101 - Missing variable."
__tlogtsig 101 $(__variable_mode_uppercase __MISSING_VARIABLE)

__tlogts "Error 1 - Associative Array."
__tlogtsig 1 $(
    declare -A __TEST_VARIABLE=()
    __variable_mode_uppercase __TEST_VARIABLE
)

__tlogts "Error 0 - Associative Array."
__tlogtsig 0 $(
    declare -Au __TEST_VARIABLE=()
    __variable_mode_uppercase __TEST_VARIABLE
)

__tlogts "Error 1 - Array."
__tlogtsig 1 $(
    declare -a __TEST_VARIABLE=()
    __variable_mode_uppercase __TEST_VARIABLE
)

__tlogts "Error 0 - Array."
__tlogtsig 0 $(
    declare -au __TEST_VARIABLE=()
    __variable_mode_uppercase __TEST_VARIABLE
)

__tlogts "Error 1 - Function."
__tlogtsig 1 $(
    function __TEST_VARIABLE() { return 0; }
    __variable_mode_uppercase __TEST_VARIABLE
)

__tlogts "Error 1 - Integer."
__tlogtsig 1 $(
    declare -i __TEST_VARIABLE=1
    __variable_mode_uppercase __TEST_VARIABLE
)

__tlogts "Error 0 - Integer."
__tlogtsig 0 $(
    declare -iu __TEST_VARIABLE=1
    __tlogtsig 0 __variable_mode_uppercase __TEST_VARIABLE
)

__tlogts "Error 1 - Nameref."
__tlogtsig 1 $(
    declare __TEST_VARIABLE_DUMMY=""
    declare -n __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_mode_uppercase __TEST_VARIABLE
)

__tlogts "Error 0 - Nameref."
__tlogtsig 0 $(
    declare __TEST_VARIABLE_DUMMY=""
    declare -nu __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_mode_uppercase __TEST_VARIABLE
)

__tlogts "Error 1 - String."
__tlogtsig 1 $(
    declare __TEST_VARIABLE=""
    __variable_mode_uppercase __TEST_VARIABLE
)

__tlogts "Error 0 - String."
__tlogtsig 0 $(
    declare -u __TEST_VARIABLE=1
    __tlogtsig 0 __variable_mode_uppercase __TEST_VARIABLE
)

__tlogfe

#####
#
# - __variable_type
#
__tlogfs __variable_type

__tlogts "Error 101 - Empty argument."
__tlogtsig 101 $(__variable_type)

__tlogts "Error 101 - Missing variable."
__tlogtsig 101 $(__variable_type __MISSING_VARIABLE)

__tlogts "Error 0 - Existing Associative Array."
__tlogtsig 0 $(
    declare -A __TEST_VARIABLE=()
    declare __T_RES=""
    if __variable_type __TEST_VARIABLE __T_RES; then
        if [[ "${__T_RES}" == "A" ]]; then
            return 0
        fi
    fi

    return 1

)

__tlogts "Error 0 - Existing Array."
__tlogtsig 0 $(
    declare -a __TEST_VARIABLE=()
    declare __T_RES=""
    if __variable_type __TEST_VARIABLE __T_RES; then
        if [[ "${__T_RES}" == "a" ]]; then
            return 0
        fi
    fi

    return 1

)

__tlogts "Error 0 - Existing Function."
__tlogtsig 0 $(
    function __TEST_VARIABLE() { return 0; }
    declare __T_RES=""
    if __variable_type __TEST_VARIABLE __T_RES; then
        if [[ "${__T_RES}" == "f" ]]; then
            return 0
        fi
    fi

    return 1

)

__tlogts "Error 0 - Existing Integer."
__tlogtsig 0 $(
    declare -i __TEST_VARIABLE=1
    declare __T_RES=""
    if __variable_type __TEST_VARIABLE __T_RES; then
        if [[ "${__T_RES}" == "i" ]]; then
            return 0
        fi
    fi

    return 1

)

__tlogts "Error 0 - Existing Nameref."
__tlogtsig 0 $(
    declare __TEST_VARIABLE_DUMMY=""
    declare -n __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    declare __T_RES=""
    if __variable_type __TEST_VARIABLE __T_RES; then
        if [[ "${__T_RES}" == "n" ]]; then
            return 0
        fi
    fi

    return 1

)

__tlogts "Error 0 - Existing String."
__tlogtsig 0 $(
    declare __TEST_VARIABLE=""
    declare __T_RES=""
    if __variable_type __TEST_VARIABLE __T_RES; then
        if [[ "${__T_RES}" == "s" ]]; then
            return 0
        fi
    fi

    return 1

)

__tlogfe

#####
#
# - __variable_text
__tlogfs __variable_text

__tlogts "Error 101 - Missing argument."
__tlogtsig 101 $(__variable_text)

__tlogts "Error 101 - Argument non existant variable."
__tlogtsig 101 $(__variable_text MISSING_VARIABLE)

__tlogts "Error 101 - Existing, non string variable."
__tlogtsig 101 $(
    declare -a __TEST_VARIABLE=(1 2 3)
    __variable_text __TEST_VARIABLE
)

__tlogts "Error 0 - Text: 'true', Test: 'true'."
__tlogtsig 0 $(
    declare __TEST_VARIABLE="true"
    __variable_text __TEST_VARIABLE "true"
)

__tlogts "Error 1 - Text 'false', Test: 'true'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE="false"
    __variable_text __TEST_VARIABLE "true"
)

__tlogts "Error 0 - Text 'false', Test: 'false'."
__tlogtsig 0 $(
    declare __TEST_VARIABLE="false"
    __variable_text __TEST_VARIABLE "false"
)

__tlogts "Error 1 - Text 'true', Test: 'false'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE="true"
    __variable_text __TEST_VARIABLE "false"
)

__tlogts "Error 1 - Text '', Test: 'true'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE=""
    __variable_text __TEST_VARIABLE "true"
)

__tlogts "Error 1 - Text '', Test: 'false'."
__tlogtsig 1 $(
    declare __TEST_VARIABLE=""
    __variable_text __TEST_VARIABLE "false"
)

__tlogfe

#####
#
# - __variable_empty
#

__tlogfs __variable_empty

__tlogts "Error 101 - Missing argument."
__tlogtsig 101 $(
    __variable_empty
)

__tlogts "Error 101 - Missing variable."
__tlogtsig 101 $(
    __variable_empty MISSING_VARIABLE
)

__tlogts "Error 0 - Array."
__tlogtsig 0 $(
    declare -a __TEST_VARIABLE=()
    __variable_empty __TEST_VARIABLE
)

__tlogts "Error 1 - Array."
__tlogtsig 1 $(
    declare -a __TEST_VARIABLE=(1 2 3)
    __variable_empty __TEST_VARIABLE
)

__tlogts "Error 0 - Associative Array."
__tlogtsig 0 $(
    declare -A __TEST_VARIABLE=()
    __variable_empty __TEST_VARIABLE
)

__tlogts "Error 1 - Associative Array."
__tlogtsig 1 $(
    declare -A __TEST_VARIABLE=([a]=1 [b]=2 [c]=3)
    __variable_empty __TEST_VARIABLE
)

__tlogts "Error 1 - Function."
__tlogtsig 1 $(
    function __TEST_VARIABLE() { return 0; }
    __variable_empty __TEST_VARIABLE
)

__tlogts "Error 1 - Integer."
__tlogtsig 1 $(
    declare -i __TEST_VARIABLE=10
    __variable_empty __TEST_VARIABLE
)

__tlogts "Error 1 - Nameref."
__tlogtsig 1 $(
    declare __TEST_VARIABLE_DUMMY=""
    declare -n __TEST_VARIABLE="__TEST_VARIABLE_DUMMY"
    __variable_empty __TEST_VARIABLE
)

__tlogts "Error 0 - String."
__tlogtsig 0 $(
    declare __TEST_VARIABLE=""
    __variable_empty __TEST_VARIABLE
)

__tlogts "Error 1 - String."
__tlogtsig 1 $(
    declare __TEST_VARIABLE="ABC"
    __variable_empty __TEST_VARIABLE
)
__tlogfe
__tlogle
