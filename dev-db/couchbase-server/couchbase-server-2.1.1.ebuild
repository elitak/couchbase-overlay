EAPI=5
inherit eutils

DESCRIPTION="${PN} (main erlang lib) from couchbase"
HOMEPAGE="https://www.couchbase.com"

SLOT="0"
SRC_URI="http://packages.couchbase.com/releases/${PV}/${PN}_src-${PV}.tar.gz"
LICENSE="COUCHBASE INC. COMMUNITY EDITION"
KEYWORDS="~x86 ~amd64"
IUSE=""

# FIXME
RDEPEND="
	=dev-db/couchbase-couchdb-2.1.1
	=dev-db/geocouch-2.1.1
	=dev-db/portsigar-2.1.1
	>=dev-lang/erlang-15[smp,kpoll]
	<dev-lang/erlang-16
"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}_src/ns_server"

user=couchbase
group=daemon

pkg_setup() {
	enewuser $user -1 -1 /var/lib/couchbase daemon
	#enewgroup $group

	# reread docs about sandbox and remove this
	#ewarn "You must start emerge with FEATURES=\"-sandbox\" to make it work!!!"
	# whats j1?
	#ewarn "If emerge fails also try reemerge with MAKEOPTS=\"-j1\" before writing bug report."
}

src_prepare() {
   epatch ${FILESDIR}/${PV}/Makefile_paths.patch
   epatch ${FILESDIR}/${PV}/couchbase-server.sh.in.patch
   epatch ${FILESDIR}/${PV}/static_config.in.patch
}

src_configure() {
   # CHOST and CBUILD interfere here since ./configure isn't a real configure script...
   #unset CBUILD
   #unset CHOST
   #econf
   # instead, just emulate its output (just writes this file)
   # remember to indent with hard-tabs here!
	cat <<-EOF > .configuration
		prefix=/usr
		couchdb_src=../couchdb
	EOF
}

src_install() {
	emake DESTDIR="${D}" install
	fowners $user:$group /var/lib/couchbase

	# These are necessary since neither the initscript nor the erlang procs
	# create them.
	dodir /var/log/couchbase
	fowners $user:$group /var/log/couchbase
	dodir /var/tmp/couchbase
	fowners $user:$group /var/tmp/couchbase

	newinitd "${FILESDIR}/${PV}/couchbase-server.initd" couchbase-server
}

pkg_postinst() {
	elog "For fresh ebuilds check https://github.com/elitak/couchbase-overlay"
	elog "Bugtracker https://github.com/elitak/couchbase-overlay/issues"
}
