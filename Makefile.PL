use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile1(
  META_MERGE => {
    q(meta-spec) => {
      version => 2
    },

    resources => {
      bugtracker => {
        web    => q{https://github.com/trapd00r/Hardware-Awtrix/issues},
        mailto => q{m@japh.se},
      },
      repository => {
        type  => 'git',
        url   => 'https://github.com/trapd00r/Hardware-Awtrix.git',
        web   => 'https://github.com/trapd00r/Hardware-Awtrix',
      },
    },
  },

# this makes version from logic fail - why?
#  META_ADD => {
#    provides => {
#      'File::LsColor' => {
#        file => 'lib/File/LsColor.pm',
#      },
#    },
#  },

  NAME             => q{Hardware::Awtrix},
  AUTHOR           => q{Magnus Woldrich <m@japh.se>},
  ABSTRACT         => q{Control an Awtrix LED Matrix Display with MQTT},
  VERSION_FROM     => q{lib/Hardware/Awtrix.pm},
  LICENSE          => q{perl},
  MIN_PERL_VERSION => 5.0040,
  EXE_FILES        => [ glob("bin/*") ],

  PREREQ_PM        => {
    q{JSON} => q{0},
  },

  MAN1PODS         => { },
  dist             => { COMPRESS => q{gzip -9f},    SUFFIX => q{gz}, },
  clean            => { FILES    => q{Hardware-Altrix-*},                  },
);

sub WriteMakefile1 {
  my %params = @_;
  my $eumm_version = $ExtUtils::MakeMaker::VERSION;
  $eumm_version = eval $eumm_version;
  die "EXTRA_META is deprecated" if exists $params{EXTRA_META};
  die "License not specified" if not exists $params{LICENSE};
  if ($params{AUTHOR} and ref($params{AUTHOR}) eq q{ARRAY}
      and $eumm_version < 6.5705) {
        $params{META_ADD}->{author}=$params{AUTHOR};
        $params{AUTHOR}=join(', ',@{$params{AUTHOR}});
  }
  if ($params{BUILD_REQUIRES} and $eumm_version < 6.5503) {
      #EUMM 6.5502 has problems with BUILD_REQUIRES
      $params{PREREQ_PM}={
        %{$params{PREREQ_PM} || {}} , %{$params{BUILD_REQUIRES}}
      };
      delete $params{BUILD_REQUIRES};
  }
  delete $params{CONFIGURE_REQUIRES} if $eumm_version < 6.52;
  delete $params{MIN_PERL_VERSION}   if $eumm_version < 6.48;
  delete $params{META_MERGE}         if $eumm_version < 6.46;
  delete $params{META_ADD}           if $eumm_version < 6.46;
  delete $params{LICENSE}            if $eumm_version < 6.31;
  delete $params{AUTHOR}             if $] < 5.005;
  delete $params{ABSTRACT_FROM}      if $] < 5.005;
  delete $params{BINARY_LOCATION}    if $] < 5.005;

  #delete $params{MAN3PODS}->{'README.pod'};

  WriteMakefile(%params);
}
