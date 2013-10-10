EAPI=5

DESCRIPTION="${PN#couchbase-} from couchbase"
HOMEPAGE="https://www.couchbase.com"

SLOT="0"
SPN=couchbase-server
SPV=2.1.1
SRC_URI="http://packages.couchbase.com/releases/${SPV}/${SPN}_src-${SPV}.tar.gz"
LICENSE="COUCHBASE INC. COMMUNITY EDITION"
KEYWORDS="~x86 ~amd64"
IUSE=""

# FIXME
RDEPEND="
	 >=dev-lang/v8-3.13.7
	 <dev-lang/v8-3.19.0
	 >=dev-lang/erlang-15[smp,kpoll]
	 <dev-lang/erlang-16
"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${SPN}_src/${PN#couchbase-}"

pkg_postinst() {
	elog "For fresh ebuilds check https://github.com/elitak/couchbase-overlay"
	elog "Bugtracker https://github.com/elitak/couchbase-overlay/issues"
}
