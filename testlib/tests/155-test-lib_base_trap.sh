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
# unset -f __log_write
# function __log_write() { return 0; }

#####
#
# - lib_base_trap.sh
#
__tlogls lib_base_trap

#####
#
# - __trap_signal_exists
#
__tlogfs __trap_signal_exists

__tlogts "Error 101 - Missing argument."
__tlogtsig 101 $(__trap_signal_exists)

__tlogts "Error 1 - Unknown signal name."
__tlogtsig 1 $(__trap_signal_exists SIGINVALID)

__tlogts "Error 1 - Unknown signal ID."
__tlogtsig 1 $(__trap_signal_exists 666)

__tlogts "Error 0 - Valid 'SIGWINCH'."
__tlogtsig 0 $(__trap_signal_exists SIGWINCH)

__tlogts "Error 0 - Valid '28'."
__tlogtsig 0 $(__trap_signal_exists 28)

#####
#
# - __trap_signal_name
#

__tlogfs __trap_signal_name

__tlogts "Error 101 - Missing argument."
__tlogtsig 101 $(__trap_signal_name)

__tlogts "Error 101 - Invalid argument."
__tlogtsig 101 $(__trap_signal_name SIGINVALID)

__tlogts "Error 0 - Valid, via stdout."
__tlogtsig 0 $(
    declare __T_RET=""
    if __T_RET="$(__trap_signal_name 28)"; then
        if [[ "${__T_RET}" == "SIGWINCH" ]]; then
            exit 0
        else
            exit 1
        fi
    else
        exit 201
    fi
)

__tlogts "Error 0 - Valid, OUT parameter."
__tlogtsig 0 $(
    declare __T_RET=""
    if __trap_signal_name 28 __T_RET; then
        if [[ "${__T_RET}" == "SIGWINCH" ]]; then
            exit 0
        else
            exit 201
        fi
    else
        exit 202
    fi
)

#####
#
# - __trap_signal_arrayname_get
#
__tlogfs __trap_signal_arrayname_get

__tlogts "Error 101 - Missing argument."
__tlogtsig 101 $(__trap_signal_arrayname_get)

__tlogts "Error 101 - Wrong argument."
__tlogtsig 101 $(__trap_signal_arrayname_get SIGINVALID)

__tlogts "Error 0 - Valid signal, via stdout."
__tlogtsig 0 $(
    declare __T_RET=""
    if __T_RET="$(__trap_signal_arrayname_get SIGWINCH)"; then
        if [[ "${__T_RET}" == "__TRAP_SIGNAL_ARRAY_SIGWINCH" ]]; then
            exit 0
        else
            exit 201
        fi
    else
        exit 202
    fi
)

__tlogts "Error 0 - Valid signal, via OUT parameter."
__tlogtsig 0 $(

    declare __T_RET_OUT=""
    if __trap_signal_arrayname_get 28 __T_RET_OUT; then
        if [[ "${__T_RET_OUT}" == "__TRAP_SIGNAL_ARRAY_SIGWINCH" ]]; then
            exit 0
        else
            exit 201
        fi
    else
        exit 202
    fi
)
#####
#
# - __trap_signal_array_exists
#
__tlogfs __trap_signal_array_exists

__tlogts "Error 101 - Missing argumnent."
__tlogtsig 101 $(__trap_signal_array_exists)

__tlogts "Error 101 - Wrong argument."
__tlogtsig 101 $(__trap_signal_array_exists SIGINVALID)

__tlogts "Error 1 - Array does not exist."
__tlogtsig 1 $(__trap_signal_array_exists SIGWINCH)

__tlogts "Error 0 - Array exists."
__tlogtsig 0 $(
    declare __T_ARRAYNAME=""
    if __trap_signal_arrayname_get SIGWINCH __T_ARRAYNAME; then
        if __variable_exists "${__T_ARRAYNAME}"; then
            if unset "${__T_ARRAYNAME}"; then
                true
            else
                exit 201
            fi
        fi
        if declare -agx "${__T_ARRAYNAME}=()"; then
            __trap_signal_array_exists SIGWINCH
        else
            exit 211
        fi
    else
        exit 221
    fi
)
__tlogfe

#####
#
# - __trap_signal_array_create
#
__tlogfs __trap_signal_array_create

__tlogts "Error 101 - Missing argument."
__tlogtsig 101 $(__trap_signal_array_create)

__tlogts "Error 101 - Wrong argument."
__tlogtsig 101 $(__trap_signal_array_create SIGINVALID)

__tlogts "Valid signal, checking for arrayname.."
__tlogtsig 0 $(
    declare __T_ARRAYNAME=""
    declare __TE_ARRAYNAME=""
    declare __TE_REGEX_ARRAY='^declare -[^\ ]*a[^\ ]*\ .*$'
    declare __TE_SIGNALNAME="SIGWINCH"

    shopt -u nocasematch

    if __trap_signal_arrayname_get "${__TE_SIGNALNAME}" __TE_ARRAYNAME; then
        if __trap_signal_array_create "${__TE_SIGNALNAME}" __T_ARRAYNAME; then
            if [[ "${__T_ARRAYNAME}" == "${__TE_ARRAYNAME}" ]]; then
                declare __T_RET=""
                if __T_RET="$(declare -p "${__T_ARRAYNAME}" 2>/dev/null)"; then
                    if [[ "${__T_RET}" =~ ${__TE_REGEX_ARRAY} ]]; then
                        exit 0
                    else
                        exit 201
                    fi
                else
                    exit 202
                fi
            else
                exit 203
            fi
        else
            exit 204
        fi
    else
        exit 205
    fi
)

####
#
# - __trap_signal_array_delete
__tlogfs __trap_signal_array_delete

__tlogts "Error 101 - Missing argument."
__tlogtsig 101 $(__trap_signal_array_delete)

__tlogts "Error 101 - Wrong argument."
__tlogtsig 101 $(__trap_signal_array_delete SIGINVALID)

__tlogts "Error 0 - Valid array, created then deleted."
__tlogtsig 0 $(

    declare __T_ARRAYNAME=""
    declare __T_SIGNALNAME="SIGWINCH"
    if __trap_signal_arrayname_get "${__T_SIGNALNAME}" __T_ARRAYNAME; then
        if declare -p "${__T_ARRAYNAME}" >/dev/null 2>&1; then
            if unset "${__T_ARRAYNAME}"; then
                true
            else
                exit 211
            fi
        fi

        if __trap_signal_array_create "${__T_SIGNALNAME}"; then
            if declare -p "${__T_ARRAYNAME}" >/dev/null 2>&1; then
                if __trap_signal_array_delete "${__T_SIGNALNAME}"; then
                    if declare -p "${__T_ARRAYNAME}" >/dev/null 2>&1; then
                        exit 201
                    else
                        exit 0
                    fi
                else
                    exit 202
                fi
            else
                exit 203
            fi
        else
            exit 204
        fi
    else
        exit 205
    fi
)

####
#
# - __trap_signal_registered
#
__tlogfs __trap_signal_registered

__tlogts "Error 101 - Argument missing."
__tlogtsig 101 $(__trap_signal_registered)

__tlogts "Error 101 - Argument wrong."
__tlogtsig 101 $(__trap_signal_registered SIGINVALID)

__tlogts "Error 1 - Existing signal not registered."
__tlogtsig 1 $(__trap_signal_registered SIGWINCH)

__tlogts "Error 0 - Existing signal registered."
__tlogtsig 0 $(
    trap -- SIGWINCH
    trap "__trap_run blehblubb" SIGWINCH
    __trap_signal_registered SIGWINCH
)

#####
#
# - __trap_signal_register
#
__tlogfs __trap_signal_register

__tlogts "Error 101 - Missing argument."
__tlogtsig 101 $(__trap_signal_register)

__tlogts "Error 101 - Wrong argument."
__tlogtsig 101 $(__trap_signal_register SIGINVALID)

__tlogts "Error 0 - Valid signal, can be registered."
__tlogtsig 0 $(
    if __trap_signal_register SIGWINCH; then
        if __trap_signal_registered SIGWINCH; then
            exit 0
        else
            exit 201
        fi
    else
        exit 202
    fi
)
__tlogts "Error 1 - Valid signal, already registered."
__tlogtsig 1 $(
    if __trap_signal_register SIGWINCH; then
        if __trap_signal_registered SIGWINCH; then
            true
        else
            exit 201
        fi
    else
        exit 202
    fi
    __trap_signal_register SIGWINCH
)

#####
#
# - __trap_signal_unregister
#
__tlogfs __trap_signal_unregister

__tlogts "Error 101 - Missing argument."
__tlogtsig 101 $(__trap_signal_unregister)

__tlogts "Error 101 - Wrong argument."
__tlogtsig 101 $(__trap_signal_unregister SIGINVALID)

__tlogts "Error 1 - Valid signal, not registered."
__tlogtsig 1 $(
    __trap_signal_unregister "SIGWINCH"
)

__tlogts "Error 0 - Valid signal, registered first, then unregistered."
__tlogtsig 0 $(
    declare __TE_SIGNALNAME="SIGWINCH"
    if __trap_signal_register "${__TE_SIGNALNAME}"; then
        if __trap_signal_registered "${__TE_SIGNALNAME}"; then
            if __trap_signal_unregister "${__TE_SIGNALNAME}"; then
                if __trap_signal_registered "${__TE_SIGNALNAME}"; then
                    exit 201
                else
                    exit 0
                fi
            else
                exit 202
            fi
        else
            exit 203
        fi
    else
        exit 204
    fi
)

#####
#
# - __trap_function_registered
#
__tlogfs __trap_function_registered

__tlogts "Error 101 - Missing argument."
__tlogtsig 101 $(__trap_function_registered)

__tlogts "Error 101 - Wrong argument."
__tlogtsig 101 $(__trap_function_registered 1234)

__tlogts "Error 102 - Missing Argument #2"
__tlogtsig 102 $(__trap_function_registered SIGWINCH)

__tlogts "Error 0 - Valid Function, Valid Arrayname, Everything exists, should not error out."
__tlogtsig 0 $(
    declare __TE_ARRAYNAME=""
    declare __TE_FUNCTIONNAME="__test_function_name"
    declare __TE_SIGNALNAME="SIGWINCH"
    if __trap_signal_arrayname_get "${__TE_SIGNALNAME}" __TE_ARRAYNAME; then
        if declare -p "${__TE_ARRAYNAME}" >/dev/null 2>&1; then
            if unset "${__TE_ARRAYNAME}"; then
                true
            else
                exit 201
            fi
        fi
        if declare -agx "${__TE_ARRAYNAME}=("${__TE_FUNCTIONNAME}")"; then
            __trap_function_registered "${__TE_SIGNALNAME}" "${__TE_FUNCTIONNAME}"
        else
            exit 211
        fi
    else
        exit 212
    fi
)

__tlogts "Error 1 - Invalid Function, Valid Arrayname, should error out."
__tlogtsig 1 $(
    declare __TE_ARRAYNAME=""
    declare __TE_FUNCTIONNAME="__test_function_name"
    declare __TE_SIGNALNAME="SIGWINCH"
    if __trap_signal_arrayname_get "${__TE_SIGNALNAME}" __TE_ARRAYNAME; then
        if declare -p "${__TE_ARRAYNAME}" >/dev/null 2>&1; then
            if unset "${__TE_ARRAYNAME}"; then
                true
            else
                exit 201
            fi
        fi
        if declare -agx "${__TE_ARRAYNAME}=("${__TE_FUNCTIONNAME}")"; then
            __trap_function_registered "${__TE_SIGNALNAME}" __test_invalid_function_name
        else
            exit 211
        fi
    else
        exit 212
    fi
)

__tlogts "Error 1 - Valid signal and function name, but array is missing. Errors out."
__tlogtsig 1 $(__trap_function_registered SIGWINCH __test_function_name)

#####
#
# - __trap_function_register
#

__tlogfs __trap_function_register

__tlogts "Error 101 - Missing argument."
__tlogtsig 101 $(__trap_function_register)

__tlogts "Error 101 - Wrong argument."
__tlogtsig 101 $(__trap_function_register SIGINVALID)

__tlogts "Error 102 - Missing argument."
__tlogtsig 102 $(__trap_function_register SIGWINCH)

__tlogts "Error 102 - Wrong argument."
__tlogtsig 102 $(__trap_function_register SIGWINCH __missing_function)

__tlogts "Error 0 - Signal/function valid."
__tlogtsig 0 $(
    function __test_function() { return 0; }
    __trap_function_register SIGWINCH __test_function
)

__tlogts "Error 1 - Signal/function valid, but already registered."
__tlogtsig 1 $(
    function __test_function() { return 0; }
    if __trap_function_register SIGWINCH __test_function; then
        __trap_function_register SIGWINCH __test_function
    else
        return 201
    fi

)

#####
#
# - __trap_function_unregister
#
__tlogfs __trap_function_unregister

__tlogts "Error 101 - Missing argument."
__tlogtsig 101 $(__trap_function_unregister)

__tlogts "Error 101 - Wrong argument."
__tlogtsig 101 $(__trap_function_unregister SIGINVALID)

__tlogts "Error 102 - Missing argument #2."
__tlogtsig 102 $(__trap_function_unregister SIGWINCH)

__tlogts "Error 0 - Unregister existing function from existing signal."
__tlogtsig 0 $(
    function __test_function_name_124() {
        echo "${FUNCNAME[0]}"
        return 0
    }
    if __trap_function_register SIGWINCH __test_function_name_124; then
        if __trap_function_registered SIGWINCH __test_function_name_124; then
            if __trap_function_unregister SIGWINCH __test_function_name_124; then
                if __trap_function_registered SIGWINCH __test_function_name_124; then
                    exit 201
                else
                    exit 0
                fi
            else
                exit 202
            fi
        else
            exit 203
        fi
    else
        exit 204
    fi
)

__tlogts "Error 131 - Unregister non existing function from existing signal."
__tlogtsig 131 $(
    function __test_function_name_125() {
        echo "${FUNCNAME[0]}"
        return 0
    }
    if __trap_function_register SIGWINCH __test_function_name_125; then
        __trap_function_unregister SIGWINCH __test_invalid_function_name
    else
        exit 202
    fi
)

#####
#
# - __trap_run
#
__tlogfs __trap_run

__tlogts "Error 101 - Missing arguments."
__tlogtsig 101 $(__trap_run)

__tlogts "Error 101 - Wrong argument."
__tlogtsig 101 $(__trap_run SIGINVALID)

__tlogts "Error 113 - Not registered signal."
__tlogtsig 113 $(
    __trap_run SIGWINCH
)

__tlogts "Error 0 - Unregister an invalid function from an empty signal registration."
__tlogtsig 0 $(
    if __trap_signal_register SIGWINCH __some_function; then
        __trap_run SIGWINCH
    else
        exit 201
    fi

)

__tlogts "Error 0 - Running a valid, registered function."
__tlogtsig 0 $(
    function __test_function() { return 0; }
    if __trap_function_register SIGWINCH __test_function; then
        if __trap_function_registered SIGWINCH __test_function; then
            __trap_run SIGWINCH
        else
            exit 201
        fi
    else
        exit 202
    fi

)
__tlogfe
__tlogle
