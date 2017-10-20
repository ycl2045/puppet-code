# == Class: jdk::params
#
class jdk::params {
    # resources
    # globle config
    $jdk_repository="10.3.10.10"
    case $os['family'] {
        /(RedHat|CentOS)/: {
           $jdk_install_file='jdk-6u101-linux-x64.bin'
           $media_dir='/data/media'
           $jdk_install_command="sh ${media_dir}/${jdk_install_file}"
           $java_home='/data/middleware/java/jdk1.6.0_101'
	   $java_bin="$java_home/bin/java"
	   $check_command="test -f $java_bin"
	   $provider=shell
	   $mkdir="mkdir -p "
        }
        'windows':{
            # code
            $media_dir='d:\data\middleware\media'
            $java_home='d:\data\middleware\java\jdk1.6.0_101'
            $jdk_install_file="jdk-6u101-windows-x64.exe"
            $jdk_install_command="${media_dir}\\${jdk_install_file} /s INSTALLDIR=${java_home} ADDLOCAL=\"ToolsFeature,SourceFeature\""
	    $java_bin="$java_home\\bin\\java"
	    $check_command="f (Test-Path $java_bin) {exit 0} else {exit 1}"
	    $provider=powershell
	    $mkdir="new-item -type directory -force -path "
        }
        default: {
            # code
        }
    }
}

