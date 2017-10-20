#!/usr/bin/env bash
# version 0.1
# wangsu@idcos.com

export LC_ALL=C
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

exec 3>&1
exec &>/dev/null

[[ $# -lt 1 ]] && echo "Usage: $0 --name=idcos-collect-cli --version=1.0.1 --release=23.el6 --architecture=x86_64 --depends='nginx tomcat' --vendor=CentOS --license=BSD --packager='yunji@idcos.com' --description='pkg command for idcos' --preinstall=/path/of/script --postinstall=/path/of/script --preuninstall=/path/of/script --postuninstall=/path/of/script --directory=/path/of/dir" >&3 && exit 1

# define something...
while [ $# -gt 0 ]; do
    case $1 in
        --name*)
            if [ "$1" != "${1##--name=}" ]; then
                _name=${1##--name=}
            else
                _name=$2
                shift
            fi
            ;;
        --version*)
            if [ "$1" != "${1##--version=}" ]; then
                _version=${1##--version=}
            else
                _version=$2
                shift
            fi
            ;;
        --release*)
            if [ "$1" != "${1##--release=}" ]; then
                _release=${1##--release=}
            else
                _release=$2
                shift
            fi
            ;;
        --architecture*)
            if [ "$1" != "${1##--architecture=}" ]; then
                _architecture=${1##--architecture=}
            else
                _architecture=$2
                shift
            fi
            ;;
        --depends*)
            if [ "$1" != "${1##--depends=}" ]; then
                _depends=${1##--depends=}
            else
                _depends=$2
                shift
            fi
            ;;
        --vendor*)
            if [ "$1" != "${1##--vendor=}" ]; then
                _vendor=${1##--vendor=}
            else
                _vendor=$2
                shift
            fi
            ;;
        --license*)
            if [ "$1" != "${1##--license=}" ]; then
                _license=${1##--license=}
            else
                _license=$2
                shift
            fi
            ;;
        --packager*)
            if [ "$1" != "${1##--packager=}" ]; then
                _packager=${1##--packager=}
            else
                _packager=$2
                shift
            fi
            ;;
        --description*)
            if [ "$1" != "${1##--description=}" ]; then
                _description=${1##--description=}
            else
                _description=$2
                shift
            fi
            ;;
        --preinstall*)
            if [ "$1" != "${1##--preinstall=}" ]; then
                _preinstall=${1##--preinstall=}
            else
                _preinstall=$2
                shift
            fi
            ;;
        --postinstall*)
            if [ "$1" != "${1##--postinstall=}" ]; then
                _postinstall=${1##--postinstall=}
            else
                _postinstall=$2
                shift
            fi
            ;;
        --preuninstall*)
            if [ "$1" != "${1##--preuninstall=}" ]; then
                _preuninstall=${1##--preuninstall=}
            else
                _preuninstall=$2
                shift
            fi
            ;;
        --postuninstall*)
            if [ "$1" != "${1##--postuninstall=}" ]; then
                _postuninstall=${1##--postuninstall=}
            else
                _postuninstall=$2
                shift
            fi
            ;;
        --directory*)
            if [ "$1" != "${1##--directory=}" ]; then
                _directory=${1##--directory=}
            else
                _directory=$2
                shift
            fi
            ;;
    esac
    shift
done


prefix=`awk -F\" '/installDir/{print $4}' /home/sharedata/soft/file/${_name}-${_version}/init.json`

echo $prefix

fpm -f \
    -s dir \
    -t rpm \
    -n $_name \
    -v $_version \
    -a x86_64 \
    -m yunji@idcos.com \
    --license BSD \
    --vendor CentOS \
    --description none \
    --url none \
    --prefix $prefix/$_name"-"$_version \
    $(for i in $_depends; do echo -n "--depends $i "; done) \
    --before-install $_preinstall \
    --after-install $_postinstall \
    --before-remove $_preuninstall \
    --after-remove $_postuninstall \
    -C $_directory

_md5=$(md5sum ${_name}-${_version}-1.x86_64.rpm | awk '{ print $1 }')

rpmsPath="/home/www/rpms"

mkdir -p "$rpmsPath"

#rm -f /home/www/rpms/${_name}-${_version}-1.x86_64.rpm

cp -f ${_name}-${_version}-1.x86_64.rpm /home/www/rpms
cp -f ${_name}-${_version}-1.x86_64.rpm /var/www/html/yum/idcos/Packages/ && (cd /var/www/html/yum/idcos/; createrepo .)

_ret=$?

# return status
cat >&3 <<EOF
{"rpm":"$_name","return_code":"$_ret","md5":"$_md5"}
EOF
