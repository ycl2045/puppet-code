# == Class: idcos::dcosengine
#
class idcos::dcosengine {
  # resources
  package{'redis':
  ensure  =>  installed,
}

  service{'redis':
  ensure  => running,
  }
}
