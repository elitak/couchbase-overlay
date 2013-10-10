EAPI=5
inherit eutils

DESCRIPTION="libvbucket from couchbase"
HOMEPAGE="https://www.couchbase.com"

SLOT="0"
PROVIDE="dev-db/libvbucket"
SPN=couchbase-server
SPV=2.1.1
SRC_URI="http://packages.couchbase.com/releases/${SPV}/${SPN}_src-${SPV}.tar.gz"
LICENSE="COUCHBASE INC. COMMUNITY EDITION"
KEYWORDS="~x86 ~amd64"
IUSE=""

# FIXME
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
S="${WORKDIR}/${SPN}_src/libvbucket"

pkg_postinst() {
	elog "For fresh ebuilds check https://github.com/elitak/couchbase-overlay"
	elog "Bugtracker https://github.com/elitak/couchbase-overlay/issues"
}
