# == Define: idcos::osinstall::mkbootos
#
define idcos::osinstall::mkbootos () {
  # puppet code
  $temp_dir="/tmp/bootos"

  file { "$temp_dir":
    ensure => directory,
    mode => '0644',
  }

  exec { 'wget initrd.img':
    command => "wget -O - $yum_url/bootos/initrd.img | xz -d | cpio -id",
    cwd     =>  $temp_dir,
    # path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    # refreshonly => true,
  }

  exec { 'install igb':
    command => "wget $yum_url/bootos/$igb_latest && chroot $PWD `rpm -Uvh $igb_latest`",
    path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    # refreshonly => true,
    cwd   =>  $temp_dir,
  }

  exec { 'make initrd img':
    command => 'find . | cpio -co | xz -9 --format=lzma > $temp_dir/initrd.img',
    path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    # refreshonly => true,
    cwd   =>  $temp_dir,
  }

}
