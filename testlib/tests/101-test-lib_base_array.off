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
# - lib_base_array.sh
#
__tlogls lib_base_array.sh

####
#
# - __array_exists
#
unset $(set | grep -E '^(__TEST_|__T_).*' | awk -F "=" '{print $1}')
__tlogfs '__array_exists'

__tlogts "Error 101"
__tlogtsig 101 __array_exists

__tlogts "Error 1 (Variable, empty)"
unset __TEST_VAR
declare __TEST_VAR=""
__tlogtsig 1 __array_exists __TEST_VAR
unset __TEST_VAR

__tlogts "Error 1 (Variable, string)"
declare __TEST_VAR="SOMETHING"
__tlogtsig 1 __array_exists __TEST_VAR
unset __TEST_VAR

__tlogts "Error 0 (Variable, array, empty)"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -a __TEST_ARRAY=()
__tlogtsig 0 __array_exists __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Error 0 (Variable, array, not empty)"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -a __TEST_ARRAY=(1 2 3 4)
__tlogtsig 0 __array_exists __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Error 1 (Variable, associative array, empty)"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -A __TEST_ARRAY=()
__tlogtsig 1 __array_exists __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Error 1 (Variable, associative array, filled)"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -A __TEST_ARRAY=([a]=0 [b]=1 [c]=2 [d]=3)
__tlogtsig 1 __array_exists __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Error 1 (Nameref, empty)"
unset __TEST_ARRAY __TEST_NAMEREF
unset -n __TEST_ARRAY __TEST_NAMEREF
declare -A __TEST_ARRAY=()
declare -n __TEST_NAMEREF="__TEST_ARRAY"
__tlogtsig 1 __array_exists __TEST_NAMEREF
unset -n __TEST_NAMEREF __TEST_ARRAY
unset __TEST_NAMEREF __TEST_ARRAY

__tlogts "Error 1 (Nameref, filled)"
unset __TEST_ARRAY __TEST_NAMEREF
unset -n __TEST_ARRAY __TEST_NAMEREF
declare -A __TEST_ARRAY=([a]=1 [b]=2 [c]=3)
declare -n __TEST_NAMEREF="__TEST_ARRAY"
__tlogtsig 1 __array_exists __TEST_NAMEREF
unset __TEST_ARRAY __TEST_NAMEREF
unset -n __TEST_ARRAY __TEST_NAMEREF

#####
#
# - __array_empty
#
unset $(set | grep -E '^(__TEST_|__T_).*' | awk -F "=" '{print $1}')
__tlogfs __array_empty

__tlogts "Error 101"
__tlogtsig 101 __array_empty

__tlogts "Error 102"
__tlogtsig 102 __array_empty __MISSING_ARRAY

__tlogts "Error 1"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -a __TEST_ARRAY=(1 2 3)
__tlogtsig 1 __array_empty __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Error 0"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -a __TEST_ARRAY=()
__tlogtsig 0 __array_empty __TEST_ARRAY
unset __TEST_ARRAY


#####
#
# - __array_contains
#
unset $(set | grep -E '^(__TEST_|__T_).*' | awk -F "=" '{print $1}')
__tlogfs __array_contains

__tlogts "Error 101"
__tlogtsig 101 __array_contains

__tlogts "Error 102"
__tlogtsig 102 __array_contains __MISSING_ARRAY

__tlogts "Error 111"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -a __TEST_ARRAY=()
__tlogtsig 111 __array_contains __TEST_ARRAY __SOME_NEEDLE
unset __TEST_ARRAY
unset -n __TEST_ARRAY

__tlogts "Error 1"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -a __TEST_ARRAY=(1 2 3 4)
__tlogtsig 1 __array_contains __TEST_ARRAY 5
unset __TEST_ARRAY

__tlogts "Error 0"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -a __TEST_ARRAY=(1 2 3 4 5)
__tlogtsig 0 __array_contains __TEST_ARRAY 5
unset __TEST_ARRAY

#####
#
# - __array_add
#
unset $(set | grep -E '^(__TEST_|__T_).*' | awk -F "=" '{print $1}')
__tlogfs __array_add

__tlogts "Error 101"
__tlogtsig 101 __array_add

__tlogts "Error 102"
__tlogtsig 102 __array_add __MISSING_ARRAY

__tlogts "Error 111"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -a __TEST_ARRAY=("TESTITEM")
__tlogtsig 111 __array_add __TEST_ARRAY TESTITEM

__tlogts "Error 0, Existing array, no item."
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -a __TEST_ARRAY=()
if __array_add __TEST_ARRAY "TESTITEM"; then
    if [[ ${#__TEST_ARRAY[@]} -gt 0 ]]; then
        for __T_ITEM in "${__TEST_ARRAY[@]}"; do
            if [[ "${__T_ITEM}" != "TESTITEM" ]]; then
                __tlogte "Item not added to array ($?)."
            else
                __tlogtp "Found."
            fi
        done
    else
        __tlogte "Item not added, array empty ($?)."
    fi
else
    __tlogte "Could not add item to array ($?)."
fi
unset __TEST_ARRAY

####
#
# - __array_add_always
#
unset $(set | grep -E '^(__TEST_|__T_).*' | awk -F "=" '{print $1}')
__tlogfs __array_add_always

__tlogts "Error 101"
__tlogtsig 101 __array_add_always

__tlogts "Error 102"
__tlogtsig 102 __array_add_always __MISSING_ARRAY

__tlogts "Adding existing value to existing array. Expected to work."
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare __TEST_ARRAY=(1 2 3 4 5)
if __array_add_always __TEST_ARRAY 1; then
    declare -i __T_CTR=0
    unset __T_LOOP_ERROR
    for __T_VALUE in "1" "2" "3" "4" "5" "1"; do
        if [[ "${__TEST_ARRAY[${__T_CTR}]}" != "${__T_VALUE}" ]]; then
            declare __T_LOOP_ERROR=1
        fi
        ((__T_CTR++)) || true
    done
    if [[ -z ${__T_LOOP_ERROR+x} ]]; then
        __tlogtp
    else
        __tlogte "__T_VALUE is wrong ($?)."
    fi
else
    __tlogte "Problems running '__array_add_always' ($?)."
fi
unset __T_TEST_ARRAY __T_LOOP_ERROR
unset -n __T_TEST_ARRAY __T_LOOP_ERROR

#####
#
# - __array_remove
#
unset $(set | grep -E '^(__TEST_|__T_).*' | awk -F "=" '{print $1}')
__tlogfs __array_remove

__tlogts "Error 101"
__tlogtsig 101 __array_remove

__tlogts "Error 102"
__tlogtsig 102 __array_remove __MISSING_ARRAY

__tlogts "Error 111"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -a __TEST_ARRAY=()
__tlogtsig 111 __array_remove __TEST_ARRAY __MISSING_KEY
unset __TEST_ARRAY

__tlogts "Error 1 - Existing Array and items, wrong item to delete..."
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -a __TEST_ARRAY=(1 2 3 4 5)
__tlogtsig 1 __array_remove __TEST_ARRAY 9
unset __TEST_ARRAY

__tlogts "Error 0 - Existing Array and items, right item to delete..."
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -a __TEST_ARRAY=(0 1 2 3 4 5)
if __array_remove __TEST_ARRAY 5; then
    if [[ ${#__TEST_ARRAY[@]} -ne 5 ]]; then
        declare -p __TEST_ARRAY
        __tlogte "'__TEST_ARRAY' not '5' ($?)."
    else
        unset __T_LOOP_ERROR
        for i in 0 1 2 3 4; do
            if [[ "${__TEST_ARRAY[${i}]}" != "${i}" ]]; then
                declare -i __T_LOOP_ERROR=1
            fi
        done

        if [[ -z ${__T_LOOP_ERROR+x} ]]; then
            __tlogtp
        else
            __tlogte "'__TEST_ARRAY': Items wrong: '${__TEST_ARRAY[${i}]}' <> '${i}' ($?)."
        fi
    fi
else
    __tlogte "Problems running '__array_remove' ($?)."
fi



#
# - END: lib_base_array.sh
#
#####
