EAPI=5
inherit eutils

DESCRIPTION="Distributed key-value database management system"
HOMEPAGE="htts://www.couchbase.com"

SLOT="0"
PROVIDE="dev-db/couchbase"
SRC_URI="http://packages.couchbase.com/releases/${PV}/${PN}_src-${PV}.tar.gz"
LICENSE="COUCHBASE INC. COMMUNITY EDITION"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5
	 >=app-arch/snappy-1
	 dev-libs/icu
	 >=sys-devel/automake-1.10.3
	 >=sys-devel/autoconf-2.13
	 >=dev-libs/libevent-2.0.0
	 >=dev-libs/cyrus-sasl-2
	 >=dev-libs/openssl-0.9.8x
	 >=dev-lang/v8-3.13.7
	 <dev-lang/v8-3.19.0
	 >=dev-lang/erlang-15[smp,kpoll]
	 <dev-lang/erlang-16"
	 
DEPEND=""
S="${WORKDIR}/${PN}_src"

pkg_setup() {
	dodir /opt/couchbase
	keepdir /opt/couchbase
	enewuser couchbase -1 -1 /opt/couchbase daemon
	enewgroup couchbase
	ewarn "You must start emerge with FEATURES=\"-sandbox\" to make it work!!!"
	ewarn "If emerge fails also try reemerge with MAKEOPTS=\"-j1\" before writing bug report."
}

src_prepare() {
	epatch "${FILESDIR}/${PV}/Makefile.v8-fix.patch"
}

src_configure() {
	return
}

src_install() {
	cp -pPR "${WORKDIR}/${PN}_src/install" "${D}"
	rm -f "${D}"/opt/couchbase/${PV}/data        
	rm -f "${D}"/opt/couchbase/${PV}/tmp
	
	sed -i "s/\/opt\/couchbase\/var\/lib\/couchbase\/couchbase-server.pid/\/var\/run\/couchbase-server.pid/" "${D}/opt/couchbase/bin/couchbase-server" || die "Install failed!"
	
	dodir "/opt/couchbase/var/lib/couchbase/data"
	keepdir "/opt/couchbase/var/lib/couchbase/data"
	
	dodir "/opt/couchbase/var/lib/couchbase/tmp"
	dodir "/opt/couchbase/var/lib/couchbase/logs"
	dodir "/opt/couchbase/var/lib/couchbase/mnesia"
	
	chown -R couchbase:daemon "${D}/opt/couchbase" || die "Install failed!"
	
	newinitd "${FILESDIR}/${PV}/couchbase-server" couchbase-server
}

pkg_postinst() {
	elog "For fresh ebuilds check https://bitbucket.org/SkeLLLa/m03geek-overlay"
	elog "Bugtracker https://bitbucket.org/SkeLLLa/m03geek-overlay/issues component:couchbase"
}