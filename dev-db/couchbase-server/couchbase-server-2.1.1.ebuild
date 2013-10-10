EAPI=5
inherit eutils

DESCRIPTION="Distributed key-value database management system"
HOMEPAGE="https://www.couchbase.com"

SLOT="0"
SRC_URI="http://packages.couchbase.com/releases/${PV}/${PN}_src-${PV}.tar.gz"
LICENSE="COUCHBASE INC. COMMUNITY EDITION"
KEYWORDS="~x86 ~amd64"
IUSE=""

# TODO:
# * add USE flags that enable features recursively in deps
# * learn how to autoinstall DEPEND at build time? make sure i've set the two vars correctly in all files
# * make sure all pertinent build options are present from Makefile in respective ebuild

RDEPEND="
   =dev-db/libvbucket-1.1.1
   =dev-db/couchbase-memcached-0.0.0
   =dev-db/libcouchstore-0.0.0
   =dev-db/ep-engine-0.0.0
   "
# TODO : find out in which ebuild each of these deps belongs
#     >=sys-libs/ncurses-5
#	 >=app-arch/snappy-1
#	 dev-libs/icu
#	 >=sys-devel/automake-1.10.3
#	 >=sys-devel/autoconf-2.13
#	 >=dev-libs/libevent-2.0.0
#	 >=dev-libs/cyrus-sasl-2
#	 >=dev-libs/openssl-0.9.8x

DEPEND=""
S="${WORKDIR}/${PN}_src"

# TODO: is this necessary??? in which ebuild(s)?
src_prepare() {
	epatch "${FILESDIR}/${PV}/Makefile.v8-fix.patch"
	epatch "${FILESDIR}/${PV}/healthchecker.Makefile.missing_cheetah_reports.patch"
	epatch "${FILESDIR}/${PV}/pidfile.patch"
}



src_compile() {
	#econf --prefix=/opt/couchbase
	# no top-level config script, ./configure in subdirs is run by the crappy top-level Makefile
	BUILD_COMPONENTS=$(make -p | grep "^BUILD_COMPONENTS " | sed 's/BUILD_COMPONENTS :=//')
	echo $BUILD_COMPONENTS
	BUILD_COMPONENTS="libvbucket memcached couchstore ep-engine bucket_engine moxi libconflate"
	echo $BUILD_COMPONENTS
	for comp in $BUILD_COMPONENTS; do
	  pushd $comp > /dev/null
	  case $comp in
	  bucket_engine)
		OPTS="CPPFLAGS=-I../memcached/include -I../ep-engine/include"
		 ;;
	  ep-engine)
		 OPTS="LDFLAGS=-L../couchstore"
		 ;;
	  *)
		 unset OPTS
		 ;;
	  esac
	  #econf --prefix=/opt/couchbase "${OPTS}"
	  econf "${OPTS}"
      emake DESTDIR="${D}" install "${OPTS}"
	  popd > /dev/null
	done
	#emake PREFIX=/opt/couchbase DESTDIR="${D}"
}

#src_compile() {
#	# this also installs each subcomponent, unfortunately
#	# PREFIX is embedded in .ini.in files, so it MUST be /opt/couchbase
#	#emake PREFIX=/opt/couchbase DESTDIR="${D}"
#	# the above wont work because not everything is relocated correctly
#	#emake PREFIX="${S}"/install/opt/couchbase
#	#emake PREFIX=/opt/couchbase
#	return
#}

src_install() {
	#emake PREFIX=/opt/couchbase DESTDIR="${D}"
	#mkdir -p "${D}"/opt/couchbase
	#cp -pPR "${WORKDIR}/${PN}_src/install"/* "${D}"/opt/couchbase
	rm -f "${D}"/opt/couchbase/${PV}/data
	rm -f "${D}"/opt/couchbase/${PV}/tmp

	dodir "/opt/couchbase/var/lib/couchbase/data"
	keepdir "/opt/couchbase/var/lib/couchbase/data"

	dodir "/opt/couchbase/var/lib/couchbase/tmp"
	dodir "/opt/couchbase/var/lib/couchbase/logs"
	dodir "/opt/couchbase/var/lib/couchbase/mnesia"

	chown -R couchbase:daemon "${D}/opt/couchbase" || die "Install failed!"

	newinitd "${FILESDIR}/${PV}/couchbase-server" couchbase-server
}

pkg_postinst() {
	elog "For fresh ebuilds check https://github.com/elitak/couchbase-overlay"
	elog "Bugtracker https://github.com/elitak/couchbase-overlay/issues"
}
