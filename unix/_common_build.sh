#!/bin/bash
#################################################
# _common_tool.sh
#
# Inputs:
#   DKMLDIR: The location of the vendored directory 'diskuv-ocaml' containing
#      the file '.dkmlroot'.
#   TOPDIR: Optional. The project top directory containing 'dune-project'. If
#     not specified it will be discovered from DKMLDIR.
#
#################################################

# shellcheck disable=SC1091
. "$DKMLDIR"/vendor/drc/unix/_common_tool.sh

# [set_opamrootandswitchdir TARGETLOCAL_OPAMSWITCH TARGETGLOBAL_OPAMSWITCH]
#
# Either the local TARGETLOCAL_OPAMSWITCH switch or the global
# TARGETGLOBAL_OPAMSWITCH switch must be specified (not both).
#
# Outputs:
# - env:OPAMROOTDIR_BUILDHOST - [As per set_opamrootdir] The path to the Opam root directory that is usable only on the
#     build machine (not from within a container)
# - env:OPAMROOTDIR_EXPAND - [As per set_opamrootdir] The path to the Opam root directory switch that works as an
#     argument to `exec_in_platform`
# - env:OPAMSWITCHFINALDIR_BUILDHOST - Either:
#     The path to the switch that represents the build directory that is usable only on the
#     build machine (not from within a container). For an external (aka local) switch the returned path will be
#     a `.../_opam`` folder which is where the final contents of the switch live. Use OPAMSWITCHNAME_EXPAND
#     if you want an XXX argument for `opam --switch XXX` rather than this path which is not compatible.
# - env:OPAMSWITCHNAME_BUILDHOST - The name of the switch seen on the build host from `opam switch list --short`
# - env:OPAMSWITCHISGLOBAL - Either ON (switch is global) or OFF (switch is external; aka local)
# - env:OPAMSWITCHNAME_EXPAND - Use this output for `opam --switch OPAMSWITCHNAME_EXPAND`.
#     For known versions of Opam this is equivalent to OPAMSWITCHNAME_BUILDHOST.
set_opamrootandswitchdir() {
    set_opamrootandswitchdir_TARGETLOCAL=$1
    shift
    set_opamrootandswitchdir_TARGETGLOBAL=$1
    shift

    if [ -z "$set_opamrootandswitchdir_TARGETLOCAL" ] && [ -z "$set_opamrootandswitchdir_TARGETGLOBAL" ]; then
        echo "FATAL: Only one of TARGETLOCAL_OPAMSWITCH TARGETGLOBAL_OPAMSWITCH may be specified" >&2
        echo "FATAL: Got: '$set_opamrootandswitchdir_TARGETLOCAL' and '$set_opamrootandswitchdir_TARGETGLOBAL'" >&2
        exit 71
    fi
    if [ -n "$set_opamrootandswitchdir_TARGETLOCAL" ] && [ -n "$set_opamrootandswitchdir_TARGETGLOBAL" ]; then
        echo "FATAL: Only one of TARGETLOCAL_OPAMSWITCH TARGETGLOBAL_OPAMSWITCH may be specified" >&2
        echo "FATAL: Got: '$set_opamrootandswitchdir_TARGETLOCAL' and '$set_opamrootandswitchdir_TARGETGLOBAL'" >&2
        exit 71
    fi

    # Set OPAMROOTDIR_BUILDHOST and OPAMROOTDIR_EXPAND
    set_opamrootdir

    if [ -n "$set_opamrootandswitchdir_TARGETLOCAL" ]; then
        OPAMSWITCHISGLOBAL=OFF

        if [ -x /usr/bin/cygpath ]; then
            set_opamrootandswitchdir_BUILDHOST=$(/usr/bin/cygpath -aw "$set_opamrootandswitchdir_TARGETLOCAL")
        else
            set_opamrootandswitchdir_BUILDHOST="$set_opamrootandswitchdir_TARGETLOCAL"
        fi
        OPAMSWITCHFINALDIR_BUILDHOST="$set_opamrootandswitchdir_BUILDHOST${OS_DIR_SEP}_opam"
        OPAMSWITCHNAME_EXPAND="$set_opamrootandswitchdir_BUILDHOST"
        OPAMSWITCHNAME_BUILDHOST="$set_opamrootandswitchdir_BUILDHOST"
    else
        # shellcheck disable=SC2034
        OPAMSWITCHISGLOBAL=ON

        set_opamrootandswitchdir_BUILDHOST="$OPAMROOTDIR_BUILDHOST${OS_DIR_SEP}$set_opamrootandswitchdir_TARGETGLOBAL"
        if [ -x /usr/bin/cygpath ]; then
            set_opamrootandswitchdir_BUILDHOST=$(/usr/bin/cygpath -aw "$set_opamrootandswitchdir_BUILDHOST")
        fi
        # shellcheck disable=SC2034
        OPAMSWITCHFINALDIR_BUILDHOST="$set_opamrootandswitchdir_BUILDHOST"
        # shellcheck disable=SC2034
        OPAMSWITCHNAME_EXPAND="$set_opamrootandswitchdir_TARGETGLOBAL"
        # shellcheck disable=SC2034
        OPAMSWITCHNAME_BUILDHOST="$set_opamrootandswitchdir_TARGETGLOBAL"
    fi

}
