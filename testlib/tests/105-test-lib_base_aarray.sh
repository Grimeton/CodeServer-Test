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
# - lib_base_aarray.sh
#
__tlogls lib_base_aarray

#####
#
# - __aarray_exists
#
__tlogfs __aarray_exists

__tlogts "Error 101"
__tlogtsig 101 __aarray_exists

__tlogts "None existing array."
__tlogtsig 1 __aarray_exists __FOO_ARRAY_NAME

__tlogts "Existing variable, empty"
declare __TEST_ARRRAY=""
__tlogtsig 1 __aarray_exists __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Existing variable, string"
declare __TEST_ARRAY="SOMETHINGSOMETHING"
__tlogtsig 1 __aarray_exists __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Existing non associative array, empty"
declare -a __TEST_ARRAY=()
__tlogtsig 1 __aarray_exists __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Existing non associative array, filled"
declare -a __TEST_ARRAY=(1 2 3 4 5)
__tlogtsig 1 __aarray_exists __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Existing associative array,empty."
declare -A __TEST_ARRAY=()
__tlogtsig 0 __aarray_exists __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Existing associative array,filled."
declare -A __TEST_ARRAY=()
__tlogtsig 0 __aarray_exists __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Existing nameref,empty."
declare -A __TEST_ARRAY=()
declare -n __TEST_ARRAY_NAMEREF="__TEST_ARRAY"
__tlogtsig 1 __aarray_exists __TEST_ARRAY_NAMEREF
unset -n __TEST_ARRAY_NAMEREF
unset __TEST_ARRAY

#####
#
# - __aarray_empty
#
unset $(set | grep -E '^(__TEST__|__T_).*' | awk -f "=" '{print $1}')

__tlogfs __aarray_empty

__tlogts "Error 101"
__tlogtsig 101 __aarray_empty

__tlogts "Error 102"
__tlogtsig 102 __aarray_empty __MISSING_ARRAY

__tlogts "Error 0"
declare -A __TEST_ARRAY=()
__tlogtsig 0 __aarray_empty __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Error 1"
declare -A __TEST_ARRAY=([0]=a [1]=b [2]=c)
__tlogtsig 1 __aarray_empty __TEST_ARRAY
unset __TEST_ARRAY

#####
#
# - __aarray_contains_key
#
unset $(set | grep -E '^(__TEST__|__T_).*' | awk -f "=" '{print $1}')
__tlogfs __aarray_contains_key

__tlogts "Error 101"
__tlogtsig 101 __aarray_contains_key

__tlogts "Error 102"
__tlogtsig 102 __aarray_contains_key __SOME_MISSING_ARRAY

__tlogts "Error 103"
declare -A __TEST_ARRAY=()
__tlogtsig 103 __aarray_contains_key __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Error 111"
declare -A __TEST_ARRAY=()
__tlogtsig 111 __aarray_contains_key __TEST_ARRAY SOMEKEY
unset __TEST_ARRAY

__tlogts "Error 1"
declare -A __TEST_ARRAY=([key1]=abc [key2]=def)
__tlogtsig 1 __aarray_contains_key __TEST_ARRAY SOMEKEY
unset __TEST_ARRAY

__tlogts "Error 0"
declare -A __TEST_ARRAY=([key1]=abc [key2]=def [SOMEKEY]=ghi)
__tlogtsig 0 __aarray_contains_key __TEST_ARRAY SOMEKEY
unset __TEST_ARRAY

#####
#
# - __aarray_add
#
unset $(set | grep -E '^(__TEST__|__T_).*' | awk -f "=" '{print $1}')
__tlogfs __aarray_add

__tlogts "Error 101"
__tlogtsig 101 __aarray_add

__tlogts "Error 102"
__tlogtsig 102 __aarray_add __MISSING_ARRAY

__tlogts "Error 102 (Existing, non associative array)"
declare -a __TEST_ARRAY=()
__tlogtsig 102 __aarray_add __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Errror 102 (Existing variable)"
declare __TEST_ARRAY="SOMESTRING"
__tlogtsig 102 __aarray_add __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Error 103"
declare -A __TEST_ARRAY=()
__tlogtsig 103 __aarray_add __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Existing array, contains key."
declare -A __TEST_ARRAY=([TESTKEY]="TESTVALUE")
__tlogtsig 1 __aarray_add __TEST_ARRAY TESTKEY TESTVALUE
unset __TEST_ARRAY

__tlogts "Existing array, missing key."
declare -A __TEST_ARRAY=()
if __aarray_add __TEST_ARRAY TESTKEY TESTVALUE; then
    if [[ ${#__TEST_ARRAY[@]} -gt 0 ]]; then
        unset __T_LOOP_ERROR
        for __T_KEY in "${!__TEST_ARRAY[@]}"; do
            if [[ "${__T_KEY}" == "TESTKEY" ]]; then
                declare -i __T_LOOP_ERROR=0
            fi
        done
        if [[ -z ${__T_LOOP_ERROR+x} ]]; then
            __tlogte "Key not found."
        else
            __tlogtp "Key found."
        fi
    else
        __tlogte "'__TEST_ARRAY' contains '0' elements ($?)."
    fi
else
    __tlogte "Could not add to '__TEST_ARRAY' ($?)."
fi

unset __TEST_ARRAY

#####
#
# - __aarray_add_always
#
unset $(set | grep -E '^(__TEST__|__T_).*' | awk -f "=" '{print $1}')
__tlogfs __aarray_add_always

__tlogts "Error 101"
__tlogtsig 101 __aarray_add_always

__tlogts "Error 102"
__tlogtsig 102 __aarray_add_always __MISSING_ARRAY

__tlogts "Error 102 (Existing, non associative array)"
declare -a __TEST_ARRAY=()
__tlogtsig 102 __aarray_add_always __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Errror 102 (Existing variable)"
declare __TEST_ARRAY="SOMESTRING"
__tlogtsig 102 __aarray_add_always __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Error 103"
declare -A __TEST_ARRAY=()
__tlogtsig 103 __aarray_add_always __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Existing array, contains key."
declare -A __TEST_ARRAY=([TESTKEY]="TESTVALUE")
__tlogtsig 0 __aarray_add_always __TEST_ARRAY TESTKEY TESTVALUE
unset __TEST_ARRAY

__tlogts "Existing array, missing key."
declare -A __TEST_ARRAY=()
if __aarray_add_always __TEST_ARRAY TESTKEY TESTVALUE; then
    if [[ ${#__TEST_ARRAY[@]} -gt 0 ]]; then
        unset __T_LOOP_ERROR
        for __T_KEY in "${!__TEST_ARRAY[@]}"; do
            if [[ "${__T_KEY}" == "TESTKEY" ]]; then
                declare -i __T_LOOP_ERROR=0
            fi
        done
        if [[ -z ${__T_LOOP_ERROR+x} ]]; then
            __tlogte "Key not found."
        else
            __tlogtp "Key found."
        fi
    else
        __tlogte "'__TEST_ARRAY' contains '0' elements ($?)."
    fi
else
    __tlogte "Could not add to '__TEST_ARRAY' ($?)."
fi

#####
#
# - __aarray_contains_value
#
unset $(set | grep -E '^(__TEST__|__T_).*' | awk -f "=" '{print $1}')
__tlogfs __aarray_contains_value

__tlogts "Error 101"
__tlogtsig 101 __aarray_contains_value

__tlogts "Error 102"
__tlogtsig 102 __aarray_contains_value __MISSING_ARRAY

__tlogts "Error 111"
declare -A __TEST_ARRAY=()
__tlogtsig 111 __aarray_contains_value __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Error 1"
declare -A __TEST_ARRAY=([a]=1 [b]=2 [c]=3)
__tlogtsig 1 __aarray_contains_value __TEST_ARRAY SOMEVALUE
unset __TEST_ARRAY

__tlogts "Error 0"
declare -A __TEST_ARRAY=([a]=1 [b]=2 [c]=3 [SOMEKEY]=SOMEVALUE)
__tlogtsig 0 __aarray_contains_value __TEST_ARRAY SOMEVALUE
unset __TEST_ARRAY

#####
#
# - __aarraay_get_key
#
unset $(set | grep -E '^(__TEST__|__T_).*' | awk -f "=" '{print $1}')
__tlogfs __aarray_get_key

__tlogts "Error 101"
__tlogtsig 101 __aarray_get_key

__tlogts "Error 102"
__tlogtsig 102 __aarray_get_key __SOME_MISSING_ARRAY

__tlogts "Error 103"
declare -A __TEST_ARRAY=()
__tlogtsig 103 __aarray_get_key __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Error 111"
declare -A __TEST_ARRAY=()
__tlogtsig 111 __aarray_get_key __TEST_ARRAY __SOME_VALUE
unset __TEST_ARRAY

__tlogts "Error 1"
declare -A __TEST_ARRAY=([a]=1 [b]=2 [c]=3)
__tlogtsig 1 __aarray_get_key __TEST_ARRAY __MISSING_KEY
unset __TEST_ARRAY

__tlogts "Error 0, stdout"
declare -A __TEST_ARRAY=([a]=0 [b]=1 [c]=2 [d]=2 [e]=2)
if __T_RESULT="$(__aarray_get_key __TEST_ARRAY "2")"; then
    if [[ "${__T_RESULT}" != "c d e" ]]; then
        __tlogte $?
    else
        __tlogtp $?
    fi
else
    __tlogte $?
fi

__tlogts "Error 0, out parameter."
unset __TEST_ARRAY __T_RET_OUT
unset -n __TEST_ARRAY __T_RET_OUT
declare -A __TEST_ARRAY=([a]=0 [b]=1 [c]=2 [d]=2 [e]=2)
declare -a __T_RET_OUT=()
if __aarray_get_key __TEST_ARRAY 2 __T_RET_OUT; then
    if [[ ${#__T_RET_OUT[@]} -gt 0 ]]; then
        unset __T_LOOP_ERROR
        for __T_RET in "${__T_RET_OUT[@]}"; do
            declare __T_LOOP_ERROR=1
            for __TE_RET in c d e; do
                if [[ "${__TE_RET}" == "${__T_RET}" ]]; then
                    unset __T_LOOP_ERROR
                fi
            done
        done
        if [[ -z ${__T_LOOP_ERROR+x} ]]; then
            __tlogtp
        else
            __tlogte "LOOP: (${__T_LOOP_ERROR})."
        fi
    else
        __tlogte "__T_RET_OUT: ($?)."
    fi
else
    __tlogte "__aarray_get_key ($?)."
fi
unset __TEST_ARRAY __T_RET_OUT
unset -n __TEST_ARRAY __T_RET_OUT

#####
#
# - __aarray_get_value
#
unset $(set | grep -E '^(__TEST__|__T_).*' | awk -f "=" '{print $1}')
__tlogfs __aarray_get_value

__tlogts "Error 101"
__tlogtsig 101 __aarray_get_value

__tlogts "Error 102"
__tlogtsig 102 __aarray_get_value __MISSING_ARRAY

__tlogts "Error 103"
unset __TEST_ARRAY
declare -A __TEST_ARRAY=()
__tlogtsig 103 __aarray_get_value __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Error 111"
declare -A __TEST_ARRAY=()
__tlogtsig 111 __aarray_get_value __TEST_ARRAY __SOME_KEY
unset __TEST_ARRAY

__tlogts "Error 1"
declare -A __TEST_ARRAY=([a]=1 [b]=2 [c]=3 [d]=4)
__tlogtsig 1 __aarray_get_value __TEST_ARRAY __MISSING_KEY
unset __TEST_ARRAY

__tlogts "Error 0, stdout"
unset __TEST_ARRAY __T_RESULT
unset -n __TEST_ARRAY __T_RESULT
declare -A __TEST_ARRAY=([a]=1 [b]=2 [c]=3 [d]=4)
declare __T_RESULT=""
if __T_RESULT="$(__aarray_get_value __TEST_ARRAY d)"; then
    if [[ "${__T_RESULT}" == "4" ]]; then
        __tlogtp
    else
        __tlogte "__T_RESULT: '${__T_RESULT}', expected: '4' ($?)."
    fi
else
    __tlogte "__T_RESULT: '${__T_RESULT}', expected '4', error function: ($?)"
fi
unset __TEST_ARRAY __T_RESULT

#####
#
# - __aarray_remove_key
#
unset $(set | grep -E '^(__TEST__|__T_).*' | awk -f "=" '{print $1}')
__tlogfs __aarray_remove_key

__tlogts "Error 101"
__tlogtsig 101 __aarray_remove_key

__tlogts "Error 102"
__tlogtsig 102 __aarray_remove_key __MISSING_ARRAY

__tlogts "Error 103"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -A __TEST_ARRAY=()
__tlogtsig 103 __aarray_remove_key __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Error 111"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -A __TEST_ARRAY=()
__tlogtsig 111 __aarray_remove_key __TEST_ARRAY __MISSING_KEY
unset __TEST_ARRAY

__tlogts "Error 122"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -A __TEST_ARRAY=([a]=1 [b]=2 [c]=3 [d]=4)
__tlogtsig 122 __aarray_remove_key __TEST_ARRAY __MISSING_KEY
unset __TEST_ARRAY

__tlogts "Error 0, no out parameter"
unset __TEST_ARRAY __T_ERROR __T_LOOP_ERROR
unset -n __TEST_ARRAY __T_ERROR __T_LOOP_ERROR
declare -A __TEST_ARRAY=([a]=1 [b]=2 [c]=3 [d]=4)
if __aarray_remove_key __TEST_ARRAY d; then
    declare -i __T_ERROR=$?

    for __T_KEY in "${!__TEST_ARRAY[@]}"; do
        declare -i __T_LOOP_ERROR=1
        for __TE_KEY in a b c; do
            if [[ "${__T_KEY}" == "${__TE_KEY}" ]]; then
                unset __T_LOOP_ERROR
            fi
        done
    done

    if [[ -z ${__T_LOOP_ERROR+x} ]]; then
        __tlogtp
    else
        __tlogte "Loop: (${__T_LOOP_ERROR})."
    fi
else
    __tlogte "Main: $($?)."
fi

__tlogts "Error 0, out parameter"
unset __TEST_ARRAY __T_ERROR __T_LOOP_ERROR __T_RET_OUT
unset -n __TEST_ARRAY __T_ERROR __T_LOOP_ERROR __T_RET_OUT
declare -A __TEST_ARRAY=([a]=1 [b]=2 [c]=3 [d]=4)
declare __T_RET_OUT=""
if __aarray_remove_key __TEST_ARRAY d __T_RET_OUT; then
    if [[ "${__T_RET_OUT}x" == "x" ]]; then
        __tlogte "__T_RET_OUT: '${__T_RET_OUT}' ($?)"
    elif [[ "${__T_RET_OUT}" == "4" ]]; then
        for __T_VALUE in "${__TEST_ARRAY[@]}"; do
            declare -i __T_LOOP_ERROR=80
            for __TE_VALUE in 1 2 3; do
                if [[ "${__T_VALUE}" == "${__TE_VALUE}" ]]; then
                    unset __T_LOOP_ERROR
                    break

                fi
            done
        done

        if [[ -z ${__T_LOOP_ERROR+x} ]]; then
            __tlogtp "__T_LOOP_ERROR"
        else
            __tlogte "__T_LOOP_ERROR: '${__T_LOOP_ERROR}'."
        fi
    else
        __tlogte "'__T_RET_OUT': '${__T_RET_OUT}' ($?)."
    fi
else
    __tlogte "Problem running '__aarray_remove_key' ($?)."
fi

#####
#
# - __aarray_remove_value
#
unset $(set | grep -E '^(__TEST__|__T_).*' | awk -f "=" '{print $1}')
__tlogfs __aarray_remove_value

__tlogts "Error 101"
__tlogtsig 101 __aarray_remove_value

__tlogts "Error 102"
__tlogtsig 102 __aarray_remove_value __MISSING_ARRAY

__tlogts "Error 111"
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -A __TEST_ARRAY=()
__tlogtsig 111 __aarray_remove_value __TEST_ARRAY
unset __TEST_ARRAY

__tlogts "Existing array/keys. Should work."
unset __TEST_ARRAY
unset -n __TEST_ARRAY
declare -A __TEST_ARRAY=([a]=1 [b]=1 [c]=2 [d]=2 [e]=2)
if __aarray_remove_value __TEST_ARRAY 2; then
    declare -i __T_RESULT=$?
    if [[ ${#__TEST_ARRAY[@]} -gt 0 ]]; then
        for __T_VALUE in "${__TEST_ARRAY[@]}"; do
            if [[ "${__T_VALUE}" == "2" ]]; then
                declare -i __T_LOOP_ERROR=123
            fi
        done
        if [[ -z ${__T_LOOP_ERROR+x} ]]; then
            __tlogtp
        else
            __tlogte "__T_LOOP_ERROR: '${__T_LOOP_ERROR}'."
        fi
    else
        __tlogtp "__TEST_ARRAY is empty."
    fi
else
    __tlogte "Problems running '__aarray_remove_value' ($?)."
fi

__tlogts "Existing array/keys. out parameter, Should work."
unset __TEST_ARRAY __T_RET_OUT
unset -n __TEST_ARRAY __T_RET_OUT
declare -A __TEST_ARRAY=([a]=1 [b]=1 [c]=2 [d]=2 [e]=2)
declare -a __T_RET_OUT=()
if __aarray_remove_value __TEST_ARRAY 2 __T_RET_OUT; then
    declare -i __T_RESULT=$?
    if [[ ${#__TEST_ARRAY[@]} -gt 0 ]]; then
        for __T_VALUE in "${__TEST_ARRAY[@]}"; do
            if [[ "${__T_VALUE}" == "2" ]]; then
                declare -i __T_LOOP_ERROR=123
            fi
        done
        if [[ -z ${__T_LOOP_ERROR+x} ]]; then
            if [[ ${#__T_RET_OUT[@]} -ne 3 ]]; then
                __tlogte "'__T_RET_ARRAY: '${#__T_RET_OUT[@]}' ($?)."
            else
                __tlogtp
            fi
        else
            __tlogte "__T_LOOP_ERROR: '${__T_LOOP_ERROR}'."
        fi
    else
        __tlogtp "__TEST_ARRAY is empty."
    fi
else
    __tlogte "Problems running '__aarray_remove_value' ($?)."
fi
