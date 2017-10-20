class base::dir(){
	case $os['family'] {
		'RedHat':{
			
			@file { 
				'/data':
					ensure	=>	directory,
					owner	=>	'root',
					group	=>	'hfgroup',
					mode	=>	'775';
				}
			@file{
				'/log':
					ensure	=>	directory,
					owner	=>	'root',
					group	=>	'hfgroup',
					mode	=>	'775';
				}
			@file{
				'/data/middleware':
					ensure	=>	directory,
					owner	=>	'appoper',
					group	=>	'hfgroup',
					mode	=>	'775';
				}
			@file{
				'/data/middleware/media':
					ensure	=>	directory,
					owner	=>	'appoper',
					group	=>	'hfgroup',
					mode	=>	'775';
				}
			@file{
				'/log/WebSphere':
					ensure	=>	directory,
					owner	=>	'appoper',
					group	=>	'hfgroup',
					mode	=>	'755';
				}
			@file{
				'/log/WebSphere/AppSrv01':
					ensure	=>	directory,
					owner	=>	'appoper',
					group	=>	'hfgroup',
					mode	=>	'755';
				}
			@file{
				'/log/weblogic':
					ensure	=>	directory,
					owner	=>	'appoper',
					group	=>	'hfgroup',
					mode	=>	'755';
				}
			@file{
				'/log/weblogic/AdminServer':
					ensure	=>	directory,
					owner	=>	'appoper',
					group	=>	'hfgroup',
					mode	=>	'755';
				}
			@file{
				'/data/app':
					ensure	=>	directory,
					owner	=>	'appoper',
					group	=>	'hfgroup',
					mode	=>	'775';
				}
			@file{
				'/log/app':
					ensure	=>	directory,
					owner	=>	'appoper',
					group	=>	'hfgroup',
					mode	=>	'775';
			}
		realize(File['/data/'])
		realize(File['/data/middleware'])
		realize(File['/log'])
		realize(File['/log/weblogic'])
		realize(File['/log/weblogic/AdminServer'])
		realize(File['/log/WebSphere'])
		realize(File['/log/WebSphere/AppSrv01'])
	
		}
	'windows' :{
		@file{'c:/data':
			ensure	=>	directory,
		}
		@file{'c:/data/middleware':
			ensure	=>	directory,
		}
		@file{'c:/IBM/media':
			ensure	=>	directory,
		}
        @file{'c:/log':
            ensure => directory,
        }
        @file{'c:/log/WebSphere':
            ensure => directory,
        }
        @file{'c:/log/WebSphere/AppSrv01':
            ensure => directory,
        }
        @file{'c:/log/weblogic':
            ensure => directory,
        }
        @file{'c:/log/weblogic/AdminServer':
            ensure => directory,
        }
		Acl	{
			permissions => [
   				{ identity => 'Administrator', rights => ['full'] },
   				{ identity => 'appoper', rights => ['full'] },
   				{ identity => 'Users', rights => ['read','execute'] }
 			],
		}

		$dir_list=['c:/data','c:/data/middleware','c:/log','c:/log/WebSphere','c:/log/WebSphere/AppSrv01','c:/log/weblogic','c:/log/weblogic/AdminServer']

        realize(File['c:/data/'])
        realize(File['c:/data/middleware'])
        realize(File['c:/log'])
        realize(File['c:/log/weblogic'])
        realize(File['c:/log/weblogic/AdminServer'])
        realize(File['c:/log/WebSphere'])
        realize(File['c:/log/WebSphere/AppSrv01'])

		acl{$dir_list:}
		}
	}
}

