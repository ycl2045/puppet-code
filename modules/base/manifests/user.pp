class base::user(){
    case $os['family'] {
        'RedHat': {

			if ! defined(Group['hfgroup']){
				group{'hfgroup':
					gid	=>	'601',
				}
			}
			
			@user{'appoper':
				ensure	=>	present,
				uid	=>	601,
				gid	=>	601,
				shell	=>	'/bin/bash',
                managehome	=>	true,
				notify	=>	Exec['appoper'],
			}

			exec{'appoper':
				command	=>	"/bin/echo q1w2E#R$|/usr/bin/passwd	appoper	--stdin",
				refreshonly	=>	true,
			}
			
            # emergeacc
            @user{'emergeacc':
                ensure	=>	present,
                gid	=>	'0',
                uid	=>	'0',
                shell	=>	'/bin/bash',
                allowdupe	=>	true,
                managehome	=>	true,
                notify	=>	Exec['emergeacc'],
            }

            exec{"emergeacc":
                command	=>	"/bin/echo 1qaz@WSX|/usr/bin/passwd	emergeacc --stdin",
                refreshonly	=>	true,
            }

            @user{'appcheck':
                ensure  =>      present,
                gid     =>      'hfgroup',
                uid     =>      '570',
                shell   =>      '/bin/bash',
                managehome      =>      true,
                notify  =>      Exec['appcheck'],
            }

            exec{"appcheck":
                command =>      "/bin/echo 1qaz@WSX|/usr/bin/passwd appcheck --stdin",
                refreshonly     =>      true,
            }

            @user{'sftpuser':
                ensure  =>      present,
                gid     =>      'hfgroup',
                uid     =>      '610',
                shell   =>      '/sbin/nologin',
                managehome      =>      true,
                notify  =>      Exec['sftpuser'],
            }

            exec{"sftpuser":
                command =>      "/bin/echo 1qaz@WSX|/usr/bin/passwd sftpuser --stdin",
                refreshonly     =>      true,
            }
			
			realize(User['appoper'])
			realize(User['appcheck'])
			realize(User['emergeacc'])
			realize(User['sftpuser'])
			
        }
        'windows':{
			@user { 'appoper':
                ensure => present,
                groups  =>  'administrators',
                 membership  =>  inclusive,
                notify  =>  Exec['appoper'],
            }

            exec{'appoper':
                command =>  "cmd.exe /c net user appoper q1w2E#R$",
                path    =>  "C:\\Windows\\System32",
                refreshonly     =>      true,
            }

            @user { 'emergeacc':
                ensure => present,
                groups  =>  'administrators',
                 membership  =>  inclusive,
				notify	=>	Exec['emergeacc'],
            }

			exec{'emergeacc':
				command	=>	"cmd.exe /c net user emergeacc 1qaz@WSX",
				path	=>	"C:\\Windows\\System32",	
                refreshonly     =>      true,
			}
			
            @user { 'appcheck':
                ensure => present,
                groups  =>  ['users','Remote Desktop Users'],
                membership  =>  inclusive,
				notify	=>	Exec['appcheck'],
            }

			exec{'appcheck':
                command =>  "cmd.exe /c net user appcheck 1qaz@WSX",
                path    =>  "C:\\Windows\\System32",
                refreshonly     =>      true,
            }

            @user { 'sftpuser':
                ensure => present,
                groups   => 'Users',
                membership  =>  inclusive,
				notify	=>	Exec['sftpuser'],
            }
			exec{'sftpuser':
                command =>  "cmd.exe /c net user sftpuser 1qaz@WSX",
                path    =>  "C:\\Windows\\System32",
				refreshonly	=>	true,
            }

		realize(User['appoper'])
		realize(User['emergeacc'])
		realize(User['appcheck'])
		realize(User['sftpuser'])

        }
        default: {
            # code
        }
    }

}

