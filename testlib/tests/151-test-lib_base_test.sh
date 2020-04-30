#!/usr/bin/env bash
#
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <grimeton@gmx.net> wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return, Grimeton.
#
# The license text was written by <phk@FreeBSD.ORG> - Poul-Henning Kamp
# ----------------------------------------------------------------------------
#
if ! (return 0 2>/dev/null); then
    echo "THIS IS A LIBRARY FILE AND SHOULD NOT BE CALLED DIRECTLY. '($(realpath "${0}"))'"
    exit 254
fi

#####
#
# - lib_base_test.sh
#
__tlogls lib_base_test

####
#
# - __test_variable_exists
__tlogfs __test_variable_exists

__tlogts "Testing existing variable..."
declare __T_TESTVAR="abc"
if __test_variable_exists __T_TESTVAR; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Testing existing, empty variable..."
unset __T_TESTVAR
declare __T_TESTVAR=""
if __test_variable_exists __T_TESTVAR; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Testing non existing variable..."
unset __T_TESTVAR
if __test_variable_exists __T_TESTVAR; then
    __tlogte
else
    __tlogtp
fi

####
#
# - __test_variable_empty
__tlogfs __test_variable_empty

__tlogts "Testing existing, empty variable..."
declare __T_TESTVAR=""
if __test_variable_empty __T_TESTVAR; then
    __tlogtp
else
    __tlogte $?
fi

__tlogts "Testing existing variable..."
unset __T_TESTVAR
declare __T_TESTVAR="not empty"
if __test_variable_empty __T_TESTVAR; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Testing non existing variable..."
unset __T_TESTVAR
if __test_variable_empty __T_TESTVAR; then
    __tlogte
else
    __tlogtp
fi

####
#
# - __test_variable_text
__tlogfs __test_variable_text

__tlogts "Testing: VARNAME: exists, VARCONTENT: 'True', TEST_FOR: true, RESULT: ''..."

declare __T_TESTVAR="True"
if __test_variable_text __T_TESTVAR 1 ""; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Testing: VARNAME: exists, VARCONTENT 'False', TEST_FOR: false, RESULT: ''..."
unset __T_TESTVAR
declare __T_TESTVAR="False"

if __test_variable_text __T_TESTVAR 0 ""; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Testing: VARNAME: non-existent, TEST_FOR: false, RESULT: ''..."
unset __T_TESTVAR

if __test_variable_text __T_TESTVAR 0 ""; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Testing: VARNAME: exists, VARCONTENT: 'True', TEST_FOR: true, RESULT: 'VARCONTENT'..."
unset __T_TESTVAR
declare __T_TESTVAR="True"
if __T_TEST_RESULT="$(__test_variable_text __T_TESTVAR 1 "${__T_TESTVAR}")"; then
    if [[ "${__T_TEST_RESULT}" == "True" ]]; then
        __tlogtp
    else
        __tlogte
    fi
else
    __tlogte
fi
unset __T_TEST_RESULT

__tlogfe

####
#
# - __test_variable_text_true
#

__tlogfs __test_variable_text_true

__tlogts "Testing VARNAME: exists, VARCONTENT: 'True'..."
declare __T_TESTVAR="True"
if __test_variable_text_true __T_TESTVAR; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Testing VARNAME: exists, VARCONTENT: 'True', variable content..."
declare __T_TESTVAR="True"
if __test_variable_text_true "${__T_TESTVAR}"; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Testing VARNAME: exists, VARCONTENT: 'False', variable content..."
declare __T_TESTVAR="False"
if __test_variable_text_true "${__T_TESTVAR}"; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Testing VARNAME: exists, VARCONTENT: 'blubb'..."
declare __T_TESTVAR="blubb"
if __test_variable_text_true __T_TESTVAR; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Testing VARNAME: exists, VARCONTENT: '0'..."
declare __T_TESTVAR="0"
if __test_variable_text_true; then
    __tlogte
else
    __tlogtp
fi

unset __T_TESTVAR

__tlogfe

####
#
# - __test_variable_text_false
#

__tlogfs __test_variable_text_false

__tlogts "Testing VARNAME: exists, VARCONTENT: 'True'..."
declare __T_TESTVAR="True"
if __test_variable_text_false __T_TESTVAR; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Testing VARNAME: exists, VARCONTENT: 'True', variable content..."
declare __T_TESTVAR="True"
if __test_variable_text_false "${__T_TESTVAR}"; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Testing VARNAME: exists, VARCONTENT: 'False', variable content..."
declare __T_TESTVAR="False"
if __test_variable_text_false "${__T_TESTVAR}"; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Testing VARNAME: exists, VARCONTENT: 'blubb'..."
declare __T_TESTVAR="blubb"
if __test_variable_text_false __T_TESTVAR; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Testing VARNAME: exists, VARCONTENT: '0'..."
declare __T_TESTVAR="0"
if __test_variable_text_false __T_TESTVAR; then
    __tlogtp
else
    __tlogte
fi

unset __T_TESTVAR

__tlogfe

####
#
# - test_array_exists

__tlogfs __test_array_exists
__tlogts "Existing array..."

unset __TEST_ARRAY
declare -a __TEST_ARRAY=(1 2 3)

if __test_array_exists __TEST_ARRAY; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Existing empty array..."
unset __TEST_ARRAY
declare -a __TEST_ARRAY=()

if __test_array_exists __TEST_ARRAY; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Existing associative array..."
unset __TEST_ARRAY
declare -A __TEST_ARRAY=([a]=1 [b]=2 [c]=3)
if __test_array_exists __TEST_ARRAY; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Existing empty associative array..."
unset __TEST_ARRAY
declare -A __TEST_ARRAY=()

if __test_array_exists __TEST_ARRAY; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Existing variable..."
unset __TEST_ARRAY
declare __TEST_ARRAY="somestingsomething"

if __test_array_exists __TEST_ARRAY; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Empty variable..."
unset __TEST_ARRAY
declare __TEST_ARRAY=""

if __test_array_exists __TEST_ARRAY; then
    __tlogte
else
    __tlogtp
fi

__tlogfe

####
#
# - test_array_associative
__tlogfs __test_array_associative
__tlogts "Existing associative array..."

unset __TEST_ARRAY
declare -A __TEST_ARRAY=([a]=1 [b]=2 [c]=3)

if __test_array_associative __TEST_ARRAY; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Existing associative empty array..."
unset __TEST_ARRAY
declare -A __TEST_ARRAY=()

if __test_array_associative __TEST_ARRAY; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Existing array..."
unset __TEST_ARRAY
declare -a __TEST_ARRAY=(1 2 3)

if __test_array_associative __TEST_ARRAY; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Existing empty array..."
unset __TEST_ARRAY
declare -a __TEST_ARRAY=()

if __test_array_associative __TEST_ARRAY; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Existing variable..."
unset __TEST_ARRAY
declare __TEST_ARRAY="somestingsomething"

if __test_array_associative __TEST_ARRAY; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Empty variable..."
unset __TEST_ARRAY
declare __TEST_ARRAY=""

if __test_array_associative __TEST_ARRAY; then
    __tlogte
else
    __tlogtp
fi

#####
#
# - __test_array_contains
#

__tlogfs __test_array_contains

__tlogts "Haystack: Exists, Needle: Exists, in Haystack"
declare -a __T_HAYSTACK=(1 2 3 4 5)
declare __T_NEEDLE=1

if __test_array_contains "${__T_NEEDLE}" "${__T_HAYSTACK[@]}"; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Haystack: Nameref, exists - Needle: Exists, in haystack."
declare -a __T_HAYSTACK=(1 2 3 4 5)
declare __T_NEEDLE=1

if __test_array_contains "${__T_NEEDLE}" __T_HAYSTACK; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Haystack: exists, Needle: exists, not in hs"
unset __T_HAYSTACK
unset __T_NEEDLE
declare -a __T_HAYSTACK=(1 2 3 4 5)
declare __T_NEEDLE=10

if __test_array_contains "${__T_NEEDLE}" "${__T_HAYSTACK[@]}"; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Haystack: exists, as nameref - Needle: Exists"
unset __T_HAYSTACK
unset __T_NEEDLE
declare -a __T_HAYSTACK=(1 2 3 4 5)
declare __T_NEEDLE=10

if __test_array_contains "${__T_NEEDLE}" "__T_HAYSTACK"; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Haystack exists- Needle: exists, but empty"
unset __T_HAYSTACK
unset __T_NEEDLE
declare -a __T_HAYSTACK=(1 2 3 4 5)
declare __T_NEEDLE=""

if __test_array_contains "${__T_NEEDLE}" __T_HAYSTACK; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Haystack: exists,empty - Needle: exists, not empty"
unset __T_HAYSTACK
unset __T_NEEDLE
declare -a __T_HAYSTACK=()
declare __T_NEEDLE=5

if __test_array_contains "${__T_NEEDLE}" "${__T_HAYSTACK[@]}"; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Haystack: exists, not array, Needle: exists, not empty"
unset __T_HAYSTACK
unset __T_NEEDLE
declare __T_HAYSTACK="1 2 3 4 5"
declare __T_NEEDLE=1
if __test_array_contains "${__T_NEEDLE}" "${__T_HAYSTACK}"; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Haystack not an array, nameref - Needle: exists, not empty"
unset __T_HAYSTACK
unset __T_NEEDLE
declare __T_HAYSTACK="1 2 3 4 5"
declare __T_NEEDLE=1
if __test_array_contains "${__T_NEEDLE}" __T_HAYSTACK; then
    __tlogte
else
    __tlogtp
fi

#####
#
# - __test_nameref_exists
#

__tlogfs __test_nameref_exists
__tlogts "Testing existing nameref..."

unset __T_TEST
unset __T_TEST_NAMEREF
unset -n __T_TEST_NAMEREF
declare __T_TEST="foobar"
declare -n __T_TEST_NAMEREF="__T_TEST"

if __test_nameref_exists __T_TEST_NAMEREF; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Testing existing nameref to array..."

unset __T_TEST
unset __T_TEST_NAMEREF
unset -n __T_TEST_NAMEREF
declare -a __T_TEST=(1 2 3)
declare -n __T_TEST_NAMEREF="__T_TEST"

if __test_nameref_exists __T_TEST_NAMEREF; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Testing non existing nameref..."
unset __T_TEST
unset __T_TEST_NAMEREF
unset -n __T_TEST_NAMEREF
declare __T_TEST_NAMEREF="_T_TEST"

if __test_nameref_exists __T_TEST_NAMEREF; then
    __tlogte
else
    __tlogtp
fi

#####
#
# - __test_arrayref_exists
#

__tlogfs __test_arrayref_exists

__tlogts "Testing existing array and arrayref..."

unset __T_ARRAY
unset __T_ARRAY_REF
unset -n __T_ARRAY_REF

declare -a __T_ARRAY=(1 2 3)
declare -n __T_ARRAY_REF="__T_ARRAY"

if __test_arrayref_exists __T_ARRAY_REF; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Testing existing array and wrong arrayref..."
unset __T_ARRAY
unset -n __T_ARRAY_REF
declare -a __T_ARRAY=(1 2 3)
declare -n __T_ARRAY_REF="__T_ARRAY_WRONG"

if __test_arrayref_exists __T_ARRAY_REF; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Testing nameref to a none array..."
unset __T_ARRAY
unset __T_ARRAY_REF
unset -n __T_ARRAY_REF

declare __T_ARRAY="1 2 3"
declare -n __T_ARRAY_REF="__T_ARRAY"

if __test_arrayref_exists __T_ARRAY_REF; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Testing none nameref...."
unset __T_ARRAY
unset __T_ARRAY_REF
unset -n __T_ARRAY_REF
declare __T_ARRAY_REF=(1 2 3)

if __test_arrayref_exists __T_ARRAY_REF; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Testing nameref to an associative array..."
unset __T_ARRAY
unset __T_ARRAY_REF
unset -n __T_ARRAY_REF

declare -A __T_ARRAY=([a]=1 [b]=2 [c]=3)
declare -n __T_ARRAY_REF="__T_ARRAY"

if __test_arrayref_exists __T_ARRAY_REF; then
    __tlogte
else
    __tlogtp
fi

#####
#
# - __test_arrayref_associative
#
__tlogfs __test_arrayref_associative

__tlogts "Testing existing array and arrayref..."
unset __T_ARRAY
unset __T_ARRAY_REF
unset -n __T_ARRAY_REF

declare -A __T_ARRAY=([a]=1 [b]=2 [c]=3)
declare -n __T_ARRAY_REF="__T_ARRAY"

if __test_arrayref_associative __T_ARRAY_REF; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Testing existing array and wrong arrayref..."
unset __T_ARRAY
unset __T_ARRAY_REF
unset -n __T_ARRAY_REF
declare -A __T_ARRAY=([a]=1 [b]=2 [c]=3)
declare -n __T_ARRAY_REF="__T_ARRAY_WRONG"

if __test_arrayref_associative __T_ARRAY_REF; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Testing nameref to a none array..."
unset __T_ARRAY
unset __T_ARRAY_REF
unset -n __T_ARRAY_REF

declare __T_ARRAY="1 2 3"
declare -n __T_ARRAY_REF="__T_ARRAY"

if __test_arrayref_associative __T_ARRAY_REF; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Testing none nameref...."
unset __T_ARRAY
unset __T_ARRAY_REF
unset -n __T_ARRAY_REF
declare -A __T_ARRA_REF=([a]=1 [b]=2 [c]=3)

if __test_arrayref_associative __T_ARRAY_REF; then
    __tlogte
else
    __tlogtp
fi

__tlogts "Testing nameref to a 'normal' array..."
unset __T_ARRAY
unset __T_ARRAY_REF
unset -n __T_ARRAY_REF

declare -a __T_ARRAY=(1 2 3)
declare -n __T_ARRAY_REF="__T_ARRAY"

if __test_arrayref_associative __T_ARRAY_REF; then
    __tlogte
else
    __tlogtp
fi

#####
#
# - __test_function_exists
#

__tlogfs __test_function_exists
__tlogts "Testing existing function..."
unset -f __test_function
function __test_function() {
    return 0
}

if __test_function_exists __test_function; then
    __tlogtp
else
    __tlogte
fi

__tlogts "Testing non existing function..."
unset -f __test_function
if __test_function_exists __test_function; then
    __tlogte
else
    __tlogtp
fi
__tlogfe
__tlogfs __test_file_access_read_by_user
__tlogts "=== The test for can only be run as root and has not been implemented yet... ==="
__tlogtw " SKIPPED."
__tlogfe
__tlogle

#
# - END: lib_base_test.sh
#
#####