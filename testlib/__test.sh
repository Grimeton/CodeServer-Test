#!/usr/bin/env bash
set -o nounset
set -o errexit

declare -grx GLOBAL_DEBUG=1
declare -grx GLOBAL_VERBOSE=1
declare -grx C_DEBUG=1
declare -grx C_VERBOSE=1

declare __T_PWD="$(realpath "$(dirname "${0}")")"

# find the "images" subdirectory ...

function __trap_error() {
    echo "Error on line number: '${@}'."
    echo "BASH_SUBSHELL: ${BASH_SUBSHELL}"
    exit 252
}
trap '__trap_error ${LINENO} ${FUNCNAME[@]} ${BASH_SOURCE[@]}' ERR
declare -i __T_SEARCH_COUNTER=0
declare __T_SEARCH_DIRECTORY="${__T_PWD}"

while ([[ ! -d "${__T_SEARCH_DIRECTORY}/images" ]] && [[ ${__T_SEARCH_COUNTER} -lt 10 ]]); do
    __T_SEARCH_DIRECTORY+="/.."
    ((__T_SEARCH_COUNTER++)) || true
done

if [[ -d "${__T_SEARCH_DIRECTORY}/images" ]]; then
    if __T_SEARCH_DIRECTORY="$(realpath "${__T_SEARCH_DIRECTORY}/images")"; then
        true
    else
        echo "Cannot find the images directory. Exiting." >&2
        exit 253
    fi
fi

if [[ -f "${__T_SEARCH_DIRECTORY}/base/all/lib/lib_loader.sh" ]]; then

    if source "${__T_SEARCH_DIRECTORY}/base/all/lib/lib_loader.sh"; then
        echo "Loaded library successfully." >&2
        if __lib_package_load "base_print"; then
            echo "Loaded the print package..."
        else
            echo "Loading the print package failed..."
            exit 254
        fi
    else

        __T_ERROR=$?
        echo "Error loading library (${__T_ERROR})..." >&2
        return ${__T_ERROR}
    fi
fi

if declare -p __G_LIBRARIES >/dev/null 2>&1; then
    unset __G_LIBRARIES
fi
if declare -p __TESTS_DELETE_ARRAY >/dev/null 2>&1; then
    unset __TESTS_DELETE_ARRAY
fi

function __tlog_start() {
    declare -Agx __G_LIBRARIES=()
    declare -Agx __G_LIBRARIES_TOTAL=()
    declare -Agx __G_TABLE_FORMAT_FUNCTION=()
    declare -Agx __G_TABLE_FORMAT_LIBRARY=()
    declare -Agx __G_TABLE_FORMAT_TOTAL=()
    declare -agx __TESTS_DELETE_ARRAY=()

    declare __T_CN="COLUMN1"
    __G_TABLE_FORMAT_FUNCTION[${__T_CN}_ALIGN]="left"
    __G_TABLE_FORMAT_FUNCTION[${__T_CN}_HEADER_TEXT]="Tests"
    __G_TABLE_FORMAT_FUNCTION[${__T_CN}_HEADER_ALIGN]="left"
    __G_TABLE_FORMAT_FUNCTION[${__T_CN}_DATA_NAME_REGEX_MATCH]=1
    __G_TABLE_FORMAT_FUNCTION[${__T_CN}_DATA_VALUE_DISPLAY_NAME]=1
    __G_TABLE_FORMAT_FUNCTION[${__T_CN}_DATA_VALUE_DISPLAY_NAME_REGEX]='^__([A-Za-z0-9]+)__$'
    __G_TABLE_FORMAT_FUNCTION[${__T_CN}_DATA_VALUE_DISPLAY_NAME_REGEX_INDEX]=1
    unset __T_CN

    declare __T_CN="COLUMN2"
    __G_TABLE_FORMAT_FUNCTION[${__T_CN}_ALIGN]="left"
    __G_TABLE_FORMAT_FUNCTION[${__T_CN}_HEADER_TEXT]="Result"
    __G_TABLE_FORMAT_FUNCTION[${__T_CN}_HEADER_ALIGN]="left"
    __G_TABLE_FORMAT_FUNCTION[${__T_CN}_DATA_NAME_REGEX_MATCH]=1
    unset __T_CN

    declare __T_CN="COLUMN1"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_ALIGN]="left"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_HEADER_TEXT]="Function Name"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_HEADER_ALIGN]="left"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_NAME_PREFIX]="__Total__"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_NAME_REGEX_MATCH]=1
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_VALUE_DISPLAY_NAME]=1
    unset __T_CN

    declare __T_CN="COLUMN2"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_ALIGN]="center"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_HEADER_TEXT]="PASSED"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_HEADER_ALIGN]="center"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_NAME_PREFIX]="__Passed__"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_NAME_REGEX_MATCH]=1
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_VALUE_CALCULATE_TOTAL]=1
    unset __T_CN

    declare __T_CN="COLUMN3"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_ALIGN]="center"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_HEADER_TEXT]="WARNING"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_HEADER_ALIGN]="center"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_NAME_PREFIX]="__Warning__"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_NAME_REGEX_MATCH]=1
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_VALUE_CALCULATE_TOTAL]=1
    unset __T_CN

    declare __T_CN="COLUMN4"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_ALIGN]="center"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_HEADER_TEXT]="FAILED"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_HEADER_ALIGN]="center"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_NAME_PREFIX]="__Failed__"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_NAME_REGEX_MATCH]=1
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_VALUE_CALCULATE_TOTAL]=1
    unset __T_CN

    declare __T_CN="COLUMN5"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_ALIGN]="center"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_HEADER_TEXT]="TOTAL"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_HEADER_ALIGN]="center"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_NAME_PREFIX]="__Total__"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_NAME_REGEX_MATCH]=1
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_VALUE_CALCULATE_TOTAL]=1
    unset __T_CN

    declare __T_ARRAYNAME="__G_TABLE_FORMAT_LIBRARY_COLUMN6_PREFIX_ARRAY_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
    declare -Agx "${__T_ARRAYNAME}=()"
    declare -n __G_TABLE_FORMAT_LIBRARY_COLUMN6_PREFIX_ARRAY="${__T_ARRAYNAME}"
    __G_TABLE_FORMAT_LIBRARY_COLUMN6_PREFIX_ARRAY[FAILED]='\u001b[31m'
    __G_TABLE_FORMAT_LIBRARY_COLUMN6_PREFIX_ARRAY[PASSED]='\u001b[32m'
    __G_TABLE_FORMAT_LIBRARY_COLUMN6_PREFIX_ARRAY[WARNING]='\u001b[33m'
    unset __T_ARRAYNAME
    declare __T_ARRAYNAME="__G_TABLE_FORMAT_LIBRARY_COLUMN6_SUFFIX_ARRAY_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
    declare -Agx "${__T_ARRAYNAME}=()"
    declare -n __G_TABLE_FORMAT_LIBRARY_COLUMN6_SUFFIX_ARRAY="${__T_ARRAYNAME}"
    __G_TABLE_FORMAT_LIBRARY_COLUMN6_SUFFIX_ARRAY[FAILED]='\u001b[0m'
    __G_TABLE_FORMAT_LIBRARY_COLUMN6_SUFFIX_ARRAY[PASSED]='\u001b[0m'
    __G_TABLE_FORMAT_LIBRARY_COLUMN6_SUFFIX_ARRAY[WARNING]='\u001b[0m'
    unset __T_ARRAYNAME

    declare __T_CN="COLUMN6"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_ALIGN]="center"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_HEADER_TEXT]="STATUS"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_HEADER_ALIGN]="center"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_NAME_PREFIX]="__Status__"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_NAME_REGEX_MATCH]=1
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_VALUE_REGEX_FORMULA]='^(FAILED|PASSED|WARNING)$'
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_VALUE_REGEX_MATCH_PREFIX_ARRAY]="${!__G_TABLE_FORMAT_LIBRARY_COLUMN6_PREFIX_ARRAY}"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_VALUE_REGEX_MATCH_SUFFIX_ARRAY]="${!__G_TABLE_FORMAT_LIBRARY_COLUMN6_SUFFIX_ARRAY}"
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_VALUE_REGEX_MATCH_PREFIX_MATCH]='\u001b[32m'
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_VALUE_REGEX_MATCH_SUFFIX_MATCH]='\u001b[0m'
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_VALUE_REGEX_NOMATCH_PREFIX]='\u001b[31m'
    __G_TABLE_FORMAT_LIBRARY[${__T_CN}_DATA_VALUE_REGEX_NOMATCH_SUFFIX]='\u001b[0m'
    unset __T_CN

    declare __T_CN="COLUMN1"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_ALIGN]="left"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_TEXT]="Library"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_ALIGN]="left"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_FORMULA]='^__(__Failed__|__Passed__|__Status__|__Total__|__Warning__)____([a-zA-Z][a-zA-Z_]+[a-zA-Z]____[a-zA-Z_]+)__$'
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_MATCH]=2
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_DISPLAY_NAME]=1
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_DISPLAY_NAME_REGEX]='^([a-zA-Z][a-zA-Z_]+[a-zA-Z])____.*$'
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_DISPLAY_NAME_REGEX_INDEX]=1
    unset __T_CN

    declare __T_CN="COLUMN2"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_ALIGN]="left"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_TEXT]="Function Name"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_ALIGN]="left"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_FORMULA]='^__(__Failed__|__Passed__|__Status__|__Total__|__Warning__)____([a-zA-Z][a-zA-Z_]+[a-zA-Z]____[a-zA-Z_]+)__$'
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_MATCH]=2
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_DISPLAY_NAME]=1
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_DISPLAY_NAME_REGEX]='^[a-zA-Z][a-zA-Z_]+[a-zA-Z]____(.*)$'
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_DISPLAY_NAME_REGEX_INDEX]=1
    unset __T_CN

    declare __T_CN="COLUMN3"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_ALIGN]="center"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_TEXT]="PASSED"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_ALIGN]="center"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_FORMULA]='^____Passed______([a-zA-Z][a-zA-Z_]+[a-zA-Z]____[a-zA-Z_]+)__$'
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_MATCH]=1
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_CALCULATE_TOTAL]=1
    unset __T_CN

    declare __T_CN="COLUMN4"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_ALIGN]="center"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_TEXT]="WARNING"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_ALIGN]="center"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_FORMULA]='^____Warning______([a-zA-Z][a-zA-Z_]+[a-zA-Z]____[a-zA-Z_]+)__$'
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_MATCH]=1
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_CALCULATE_TOTAL]=1
    unset __T_CN

    declare __T_CN="COLUMN5"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_ALIGN]="center"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_TEXT]="FAILED"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_ALIGN]="center"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_FORMULA]='^____Failed______([a-zA-Z][a-zA-Z_]+[a-zA-Z]____[a-zA-Z_]+)__$'
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_MATCH]=1
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_CALCULATE_TOTAL]=1
    unset __T_CN

    declare __T_CN="COLUMN6"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_ALIGN]="center"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_TEXT]="TOTAL"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_ALIGN]="center"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_FORMULA]='^____Total______([a-zA-Z][a-zA-Z_]+[a-zA-Z]____[a-zA-Z_]+)__$'
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_MATCH]=1
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_CALCULATE_TOTAL]=1
    unset __T_CN

    declare __T_CN="COLUMN7"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_ALIGN]="center"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_TEXT]="STATUS"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_HEADER_ALIGN]="center"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_FORMULA]='^____Status______([a-zA-Z][a-zA-Z_]+[a-zA-Z]____[a-zA-Z_]+)__$'
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_NAME_REGEX_MATCH]=1
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_REGEX_FORMULA]='^(FAILED|PASSED|WARNING)$'
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_REGEX_MATCH_PREFIX_ARRAY]="${!__G_TABLE_FORMAT_LIBRARY_COLUMN6_PREFIX_ARRAY}"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_REGEX_MATCH_SUFFIX_ARRAY]="${!__G_TABLE_FORMAT_LIBRARY_COLUMN6_SUFFIX_ARRAY}"
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_REGEX_MATCH_PREFIX]='\u001b[35m'
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_REGEX_MATCH_SUFFIX]='\u001b[0m'
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_REGEX_NOMATCH_PREFIX]='\u001b[36;1m'
    __G_TABLE_FORMAT_TOTAL[${__T_CN}_DATA_VALUE_REGEX_NOMATCH_SUFFIX]='\u001b[0m'
    unset __T_CN

    __tlog "\n\n"
    __tlog "===== BEGINNING TESTS.... ====="
    trap __tlog_end EXIT
}
function __tlog_end() {
    declare __T_REGEX_STATUS='^____Status__.*$'
    if [[ -z ${__G_LIBRARIES[@]+x} ]]; then
        return 0
    fi
    if [[ -n ${__G_LIBNAME+x} ]]; then
        __tlogle
    fi
    trap -- EXIT
    __tlog "\n\n"
    __tlog "Some overall statistics of all libraries...\n\n"
    __print_table __G_LIBRARIES_TOTAL __G_TABLE_FORMAT_TOTAL
    __tlog "\n\n"
    __tlog "Overall status of all tests: "
    for __T_NAME in "${!__G_LIBRARIES_TOTAL[@]}"; do
        if [[ "${__T_NAME}" =~ ${__T_REGEX_STATUS} ]]; then
            if [[ "${__G_LIBRARIES_TOTAL[${__T_NAME}]}" == "FAILED" ]]; then
                __T_ERROR=1
                break
            elif [[ "${__G_LIBRARIES_TOTAL[${__T_NAME}]}" == "WARNING" ]]; then
                __T_ERROR=2
                break
            elif [[ "${__G_LIBRARIES_TOTAL[${__T_NAME}]}" == "PASSED" ]]; then
                __T_ERROR=0
            else
                __T_ERROR=3
                break
            fi
        fi
    done
    if [[ ${__T_ERROR} == 0 ]]; then
        __tlogp " PASS."
        __T_RET=0
    elif [[ ${__T_ERROR} == 1 ]]; then
        __tloge " FAILED."
        __T_RET=1
    elif [[ ${__T_ERROR} == 2 ]]; then
        __tlogw " WARNING."
        __T_RET=0
    else
        __tloge " UNKNOWN."
        __T_RET=3
    fi
    __tlog "===== END: Enf ot tests. =====\n"
    return ${__T_RET}
}
function __tlogle() {

    if [[ -n ${__G_FUNCTION+x} ]]; then
        __tlogfe
    fi
    __tlog "\n"
    __tlog "Some statistics about tests of library '${__G_LIBNAME}'.\n"
    __tlog "\n"
    __print_table "${__G_LIBRARIES[${__G_LIBNAME}]}" __G_TABLE_FORMAT_LIBRARY
    declare -n __T_COPYTABLE="${__G_LIBRARIES[${__G_LIBNAME}]}"
    declare __T_NAME_NEW=""
    declare __T_NAME_REGEX='^(__Failed__|__Passed__|__Status__|__Total__|__Warning__)(.+)$'
    declare __T_NAME_REGEX_TOTAL='^(__Failed__|__Passed__|__Status__|__Total__|__Warning__)$'
    for __T_NAME in "${!__T_COPYTABLE[@]}"; do
        if [[ "${__T_NAME}" =~ ${__T_NAME_REGEX} ]]; then
            __T_NAME_NEW="__${BASH_REMATCH[1]}____${__G_LIBNAME}____${BASH_REMATCH[2]}__"
            __G_LIBRARIES_TOTAL[${__T_NAME_NEW}]="${__T_COPYTABLE[${__T_NAME}]}"
        elif [[ "${__T_NAME}" =~ ${__T_NAME_REGEX_TOTAL} ]]; then
            true
            #__T_NAME_NEW="__${BASH_REMATCH[1]}____${__G_LIBNAME}____${__G_LIBNAME}__"
            #__G_LIBRARIES_TOTAL[${__T_NAME_NEW}]="${__T_COPYTABLE[${__T_NAME}]}"
        else
            exit 245
        fi
    done
    unset -n __T_COPYTABLE __T_NAME_NEW
    __tlog "\n\n=== End tests on library '${__G_LIBNAME}'. ===\n\n"
    unset __G_LIBNAME

}
function __tlogls() {

    if ! declare -p __G_LIBRARIES >/dev/null 2>&1; then
        __tlog "ERROR: __G_LIBRARIES IS NOT INITIALIZED."
        exit 31
    fi
    if [[ -n ${__G_LIBNAME+x} ]]; then
        __tlogle
    fi

    if [[ "${@:1:1}x" == "x" ]]; then
        exit 99
    fi
    declare __P_LIBNAME="${@:1:1}"
    unset __G_LIBNAME __G_ARRAYNAME

    declare -gx __G_LIBNAME="${__P_LIBNAME%%.*}"

    if [[ -z ${__G_LIBRARIES[${__G_LIBNAME}]+x} ]]; then
        declare -gx __G_ARRAYNAME="__G_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
        declare -Agx "${__G_ARRAYNAME}=([__Total__]=0 [__Failed__]=0 [__Passed__]=0 [__Warning__]=0)"
        declare -gn __G_ERRORS="${__G_ARRAYNAME}"
        declare -gx __G_LIBRARIES[${__G_LIBNAME}]="${__G_ARRAYNAME}"
    else
        __tlog "\n\n=== Library '${__G_LIBNAME}' already exists..\n\n"
        exit 99
    fi
    __tlog "\n\n=== Beginning tests on library '${__G_LIBNAME}'. ===\n\n"
}
function __tlogfe() {
    declare __T_RESULT=""
    if [[ -z ${__G_FUNCTION+x} ]]; then
        echo "'__G_FUNCTION' does not exist...." >&2
        exit 100
    elif [[ "${__G_FUNCTION}x" == "x" ]]; then
        echo "'__G_FUNCTION' is empty..." >&2
        exit 101
    elif __T_RESULT="$(type -t "${__G_FUNCTION}")"; then
        if [[ "${__T_RESULT,,}" != "function" ]]; then
            echo "'__G_FUNCTION' is set to a non function..." >&2
            exit 102
        fi
    else
        echo "'__G_FUNCTION' type cannot be determined. Exiting..."
        exit 103
    fi
    if [[ -n ${__G_MESSAGE_CURRENT+x} ]]; then
        __tlog "\nEnding still running test: "
        __tlogte
    fi
    if [[ ${__G_ERRORS[__Failed__${__G_FUNCTION}]} -gt 0 ]]; then
        __G_ERRORS[__Status__${__G_FUNCTION}]="FAILED"
    elif [[ ${__G_ERRORS[__Warning__${__G_FUNCTION}]} -gt 0 ]]; then
        __G_ERRORS[__Status__${__G_FUNCTION}]="WARNING"
    else
        __G_ERRORS[__Status__${__G_FUNCTION}]="PASSED"
    fi

    __tlog "\n"
    __tlog "Overall statistics of '${__G_FUNCTION}'...\n\n"

    __G_TABLE_FORMAT_FUNCTION[COLUMN1_DATA_NAME_REGEX_FORMULA]="^(__Failed__|__Passed__|__Total__|__Warning__)${__G_FUNCTION}$"
    __G_TABLE_FORMAT_FUNCTION[COLUMN2_DATA_NAME_REGEX_FORMULA]="^(__Failed__|__Passed__|__Total__|__Warning__)${__G_FUNCTION}$"
    if __print_table "${!__G_ERRORS}" __G_TABLE_FORMAT_FUNCTION; then
        true
    else
        __T_ERROR=$?
        echo "__T_ERROR: '${__T_ERROR}'."
    fi
    __tlog "\nOverall Status:"
    if [[ ${__G_ERRORS[__Failed__${__G_FUNCTION}]} -gt 0 ]]; then
        __tloge " ERROR\n"
    elif [[ ${__G_ERRORS[__Warning__${__G_FUNCTION}]} -gt 0 ]]; then
        __tlogw " SKIPPED."
    else
        __tlogp " PASSED\n"
    fi
    __tlog "End of tests on function '${__G_FUNCTION}'.\n"
    unset __G_FUNCTION
}
function __tlogfs() {

    declare __T_REGEX_ARRAY_ASSOCIATIVE='^declare -[^\ ]*A[^\ ]*\ .*$'

    if [[ -z ${__G_LIBNAME+x} ]]; then
        __tlog "Error. Library name is not initialized...."
        exit 21
    fi

    if [[ -n ${__G_FUNCTION+x} ]]; then
        __tlogfe
    fi

    if [[ "${@:1:1}x" == "x" ]]; then
        __tloge "No function name given. Exiting."
        exit 100
    elif __T_RES="$(type -t "${@:1:1}")"; then
        if [[ "${__T_RES,,}" == "function" ]]; then
            declare -gx __G_FUNCTION="${@:1:1}"
        else
            __tloge "'${@:1:1}' is not a function. Exiting."
            exit 121
        fi
    else
        __tloge "Type of '${@:1:1}' cannot be determined. Exiting..."
        exit 122
    fi
    declare __T_RESULT=""
    if [[ -z ${__G_FUNCTION+x} ]]; then
        __tloge "'__G_FUNCTION' does not exist..."
        exit 100
    elif [[ "${__G_FUNCTION}x" == "x" ]]; then
        __tloge "'__G_FUNCTION' is empty..."
        exit 101
    elif __T_RESULT="$(type -t "${__G_FUNCTION}")"; then
        if [[ "${__T_RESULT,,}" != "function" ]]; then
            __tloge "'__G_FUNCTION' is not a function..."
            exit 102
        fi
    else
        __tloge "'__G_FUNCTION' type cannot be determined. Exiting..."
        exit 103
    fi

    if [[ -z ${__G_ERRORS[__Total__${__G_FUNCTION}]+x} ]]; then
        __G_ERRORS[__Passed__${__G_FUNCTION}]=0
        __G_ERRORS[__Failed__${__G_FUNCTION}]=0
        __G_ERRORS[__Total__${__G_FUNCTION}]=0
        __G_ERRORS[__Warning__${__G_FUNCTION}]=0
    elif [[ "${__G_ERRORS[__Total__${__G_FUNCTION}]}x" == "x" ]]; then
        __G_ERRORS[__Passed__${__G_FUNCTION}]=0
        __G_ERRORS[__Failed__${__G_FUNCTION}]=0
        __G_ERRORS[__Total__${__G_FUNCTION}]=0
        __G_ERRORS[__Warning__${__G_FUNCTION}]=0
    elif [[ ! "${__G_ERRORS[__Total__${__G_FUNCTION}]}" =~ ${__D_TEXT_REGEX_NUMBER} ]]; then
        __G_ERRORS[__Passed__${__G_FUNCTION}]=0
        __G_ERRORS[__Failed__${__G_FUNCTION}]=0
        __G_ERRORS[__Total__${__G_FUNCTION}]=0
        __G_ERRORS[__Warning__${__G_FUNCTION}]=0
    fi
    __tlog "\n"
    __tlog "Starting tests on function '${__G_FUNCTION}'...\n"
    __tlog "\n"
}
function __tlog() {
    echo -en "${@}" >&2
}
function __tlogd() {
    __tlog_del_add "${@}"
}
function __tlog_del_add() {
    if [[ "${@:1:1}x" == "x" ]]; then
        return 0
    else
        declare -a __P_FILES=("${@:1}")
    fi
    __tlog_del_init

    for __T_FILE in "${__P_FILES[@]}"; do
        if [[ -f "${__T_FILE}" ]] ||
            [[ -d "${__T_FILE}" ]] ||
            [[ -L "${__T_FILE}" ]]; then
            __TESTS_DELETE_ARRAY+=("${__T_FILE}")
        fi
    done
}
function __tlog_del_init() {
    if [[ -z ${__TESTS_DELETE_ARRAY[@]+x} ]]; then
        declare -agx __TESTS_DELETE_ARRAY=("$(mktemp -d)")
    elif [[ ${#__TESTS_DELETE_ARRAY[@]} -lt 1 ]]; then
        declare -agx __TESTS_DELETE_ARRAY=("$(mktemp -d)")
    else
        return 0
    fi
    return 0

}
function __tlog_del_list() {
    __tlog_del_init
    if [[ ${#__TESTS_DELETE_ARRAY[@]} -gt 0 ]]; then
        __tlog "\n================================================================================\n"
        __tlog "The following files/folders are left from the broken test for you to examine:\n"
        __tlog "================================================================================\n"
        for __TESTS_DELETE_ITEM in "${__TESTS_DELETE_ARRAY[@]}"; do
            __tlog "${__TESTS_DELETE_ITEM}\n"
        done
        __tlog "\n================================================================================\n"
        __tlog "END\n"
        __tlog "================================================================================\n"
    fi
    __tlog_del_reset
    return 0
}
function __tlog_del_delete() {

    __tlog_del_init
    if [[ "${FUNCNAME[1]}" == "tlogte" ]]; then
        __tlog_del_list
    else
        if [[ ${#__TESTS_DELETE_ARRAY[@]} -gt 0 ]]; then
            for __TESTS_DELETE_ITEM in "${__TESTS_DELETE_ARRAY[@]}"; do

                if [[ -f "${__TESTS_DELETE_ITEM}" ]] ||
                    [[ -L "${__TESTS_DELETE_ITEM}" ]]; then
                    #rm -f "${__TESTS_DELETE_ITEM}"
                    true
                elif [[ -d "${__TESTS_DELETE_ITEM}" ]]; then
                    #rm -rf "${__TESTS_DELETE_ITEM}"
                    true
                elif [[ -e "${__TESTS_DELETE_ITEM}" ]]; then
                    __tloge "ERROR: FILETYPE of '${__TESTS_DELETE_ITEM}' not supported."
                fi
            done
        fi
    fi
    __tlog_del_reset
    return 0

}
function __tlog_del_reset() {
    unset __TESTS_DELETE_ARRAY __TESTS_TMP
    declare -agx __TESTS_DELETE_ARRAY=()
}
function __tlog_file_content() {
    if [[ "${@:1:1}x" == "x" ]]; then
        return 2
    elif [[ ! -f "${@:1:1}" ]]; then
        return 3
    else
        declare __TLOG_FILE="${@:1:1}"
    fi

    if [[ "${@:2:1}x" == "x" ]]; then
        cat "${__TLOG_FILE}"
    else
        if [[ "(cat "${__TLOG_FILE}")" == "${@:2}" ]]; then
            return 0
        fi
        return 1
    fi
}
function __tlog_file_empty() {
    if [[ "${@:1:1}x" == "x" ]]; then
        return 2
    elif [[ ! -f "${@:1:1}" ]]; then
        return 3
    fi

    if [[ "$(cat "${@:1:1}")" == "" ]]; then
        return 0
    fi
    return 1
}
function __tlog_mktempd() {
    __tlog_mktemp "${@}"
}
function __tlog_mktempf() {
    __tlog_mktemp "${@}"
}
function __tlog_mktemp() {

    if [[ "${@:1:1}x" == "x" ]]; then
        return 2
    elif declare -p "${@:1:1}" >/dev/null 2>&1; then
        declare -n __T_RETURN_NAME="${@:1:1}"
    else
        return 3
    fi
    __tlog_del_init
    if [[ "${FUNCNAME[1]}" == "__tlog_mktempd" ]]; then
        __TESTS_DELETE_ARRAY+=("$(mktemp -p "${__TESTS_DELETE_ARRAY[0]}" -d)")
    else
        __TESTS_DELETE_ARRAY+=("$(mktemp -p "${__TESTS_DELETE_ARRAY[0]}")")
    fi
    __T_RETURN_NAME="${__TESTS_DELETE_ARRAY[-1]}"
    return 0
}
function __tloge() {

    if [[ "${@:1}x" == "x" ]]; then
        declare __P_LOG_MESSAGE=""
    else
        declare __P_LOG_MESSAGE="${@:1}"
    fi

    echo -en "${__D_TERMINAL_COLOURS_RED}" >&2
    echo -en "${__P_LOG_MESSAGE}" >&2
    echo -e "${__D_TERMINAL_COLOURS_NONE}" >&2

    return 0
}
function __tlogp() {

    if [[ "${@:1}x" == "x" ]]; then
        declare __P_LOG_MESSAGE=""
    else
        declare __P_LOG_MESSAGE="${@:1}"
    fi

    echo -en "${__D_TERMINAL_COLOURS_GREEN}" >&2
    echo -en "${__P_LOG_MESSAGE}" >&2
    echo -e "${__D_TERMINAL_COLOURS_NONE}" >&2

    return 0
}
function __tlogte() {
    declare __T_REGEX_NUMBER='^[0-9]+$'
    if [[ "${@}x" == "x" ]]; then
        __T_LOG_MESSAGE=" ERROR."
    elif [[ "{@}" =~ ${__T_REGEX_NUMBER} ]]; then
        __T_LOG_MESSAGE=" ERROR (${@})."
    else
        __T_LOG_MESSAGE=" ERROR: ${@}"
    fi

    if [[ -z ${__G_MESSAGE_CURRENT+x} ]]; then
        __tloge "\nERROR:"
        __tlog " '${FUNCNAME[0]}': There's no test going on right now."
        exit 123
    fi

    declare __T_RESULT=""
    if [[ -z ${__G_FUNCTION+x} ]]; then
        __tloge "'__G_FUNCTION' does not exist...."
        exit 100
    elif [[ "${__G_FUNCTION}x" == "x" ]]; then
        __tloge "'__G_FUNCTION' is empty..."
        exit 101
    elif __T_RESULT="$(type -t "${__G_FUNCTION}")"; then
        if [[ "${__T_RESULT,,}" != "function" ]]; then
            __tloge "'__G_FUNCTION' is set to a non function..."
            exit 102
        fi
    else
        __tloge "'__G_FUNCTION' type cannot be determined. Exiting..."
        exit 103
    fi

    ((__G_ERRORS[__Failed__${__G_FUNCTION}]++)) || true
    ((__G_ERRORS[__Failed__]++)) || true
    __tloge "${__T_LOG_MESSAGE}"
    __tlog_del_delete
    unset __G_MESSAGE_CURRENT
    return 0
}
function __tlogtp() {
    unset __T_LOG_MESSAGE
    unset -n __T_LOG_MESSAGE
    declare __T_REGEX_NUMBER='^[0-9]+$'
    if [[ "${@}x" == "x" ]]; then
        declare -- __T_LOG_MESSAGE=" PASS."
    elif [[ "${@}" =~ ${__T_REGEX_NUMBER} ]]; then
        declare -- __T_LOG_MESSAGE=" PASS (${@})."
    else
        declare -- __T_LOG_MESSAGE="${@}"
    fi

    if [[ -z ${__G_MESSAGE_CURRENT+x} ]]; then
        __tloge "\nERROR:"
        __tlog " '${FUNCNAME[0]}': There's no test going on right now."
        exit 123
    fi

    ((__G_ERRORS[__Passed__${__G_FUNCTION}]++)) || true
    ((__G_ERRORS[__Passed__]++)) || true
    __tlog_del_delete
    __tlog_del_reset
    __tlogp "${__T_LOG_MESSAGE}"
    unset __G_MESSAGE_CURRENT
}
function __tlogts() {
    declare __T_RESULT=""
    if [[ -z ${__G_FUNCTION+x} ]]; then
        __tloge "'__G_FUNCTION' does not exist...."
        return 100
    elif [[ "${__G_FUNCTION}x" == "x" ]]; then
        __tloge "'__G_FUNCTION' is empty..."
        return 101
    elif __T_RESULT="$(type -t "${__G_FUNCTION}")"; then
        if [[ "${__T_RESULT,,}" != "function" ]]; then
            __tloge "'__G_FUNCTION' is set to a non function..."
            return 102
        fi
    else
        __tloge "'__G_FUNCTION' type cannot be determined. Exiting..."
        return 103
    fi
    if [[ -n ${__G_MESSAGE_CURRENT+x} ]]; then
        __tloge "\nError:"
        __tlog " There's still a test in progress on '${__G_MESSAGE_CURRENT}'."
        return 123
    fi
    ((__G_ERRORS[__Total__${__G_FUNCTION}]++)) || true
    ((__G_ERRORS[__Total__]++)) || true

    declare __T_LOG_MESSAGE=" -- '${__G_FUNCTION}' "${@}""
    declare -gx __G_MESSAGE_CURRENT="${__T_LOG_MESSAGE}"
    __tlog "${__T_LOG_MESSAGE}"
    __tlog_del_reset
    unset __T_LOG_MESSAGE
}
function __tlogtsig() {
    declare -r __T_REGEX_NUMBER='^[0-9]+$'
    if [[ "${@:1:1}x" == "x" ]]; then
        return 2
    elif [[ ! "${@:1:1}" =~ ${__T_REGEX_NUMBER} ]]; then
        return 3
    else
        declare -i __P_SIGNAL_WANTED=${@:1:1}
    fi

    if [[ "${@:2:1}x" == "x" ]]; then
        return 12
    elif [[ "${@:2:1}" =~ ${__T_REGEX_NUMBER} ]]; then
        declare __P_SIGNAL_GOT=${@:2:1}
    elif [[ "$(type -t "${@:2:1}")" == "function" ]]; then
        declare __P_FUNCTION="${@:2:1}"
    else
        return 14
    fi

    if [[ "${@:3:1}x" == "x" ]]; then
        declare -a __P_FUNCTIONPARAMETERS=()
    else
        declare -a __P_FUNCTIONPARAMETERS=("${@:3}")
    fi

    if [[ -n ${__P_FUNCTION+x} ]]; then
        if [[ ${#__P_FUNCTIONPARAMETERS[@]} -gt 0 ]]; then
            if ${__P_FUNCTION} "${__P_FUNCTIONPARAMETERS[@]}"; then
                declare -i __T_ERROR=$?
            else
                declare -i __T_ERROR=$?
            fi
        else
            if ${__P_FUNCTION}; then
                declare -i __T_ERROR=$?
            else
                declare -i __T_ERROR=$?
            fi
        fi
        declare -i __T_SIGNAL_GOT=${__T_ERROR}
    else
        declare -i __T_SIGNAL_GOT=${__P_SIGNAL_GOT}
    fi
    if [[ ${__T_SIGNAL_GOT} -eq ${__P_SIGNAL_WANTED} ]]; then
        __tlogtp ${__T_SIGNAL_GOT}
    else
        __tlogte ${__T_SIGNAL_GOT}
    fi

    return 0
}
function __tlogtw() {
    unset __T_LOG_MESSAGE
    unset -n __T_LOG_MESSAGE
    declare __T_REGEX_NUMBER='^[0-9]+$'
    if [[ "${@}x" == "x" ]]; then
        declare -- __T_LOG_MESSAGE=" WARNING."
    elif [[ "${@}" =~ ${__T_REGEX_NUMBER} ]]; then
        declare -- __TLOG_MESSAGE=" WARNING (${@})."
    else
        declare -- __T_LOG_MESSAGE="${@}"
    fi
    if [[ -z ${__G_MESSAGE_CURRENT+x} ]]; then
        __tloge "\nERROR:"
        __tlog " '${FUNCNAME[0]}': There's no test going on right now."
        exit 123
    fi

    ((__G_ERRORS[__Warning__${__G_FUNCTION}]++)) || true
    ((__G_ERRORS[__Warning__]++)) || true
    __tlogw "${__T_LOG_MESSAGE}"
    __tlog_del_delete
    unset __G_MESSAGE_CURRENT
}
function __tlogw() {

    if [[ "${@:1}x" == "x" ]]; then
        declare __P_LOG_MESSAGE=""
    else
        declare __P_LOG_MESSAGE="${@:1}"
    fi

    echo -en "${__D_TERMINAL_COLOURS_YELLOW}" >&2
    echo -en "${__P_LOG_MESSAGE}" >&2
    echo -e "${__D_TERMINAL_COLOURS_NONE}" >&2

    return 0
}
######
#
# - Tests to test the library

__tlog_start
#####
#
# - lib_base.sh
#

#
# - END: lib_base.sh
#
#####
unset -f __log_write
unset -f __log__print
function __log__print() { return 0; }
function __log__write() { return 0; }

if [[ -d "${__T_PWD}/tests" ]]; then
    for ___T_FILE in "${__T_PWD}/tests/"*.sh; do
        if [[ -f "${___T_FILE}" ]]; then
            source "${___T_FILE}"
        fi
    done
fi
