EAPI=5

DESCRIPTION="bucket_engine from couchbase"
HOMEPAGE="https://www.couchbase.com"

SLOT="0"
SPN=couchbase-server
SPV=2.1.1
SRC_URI="http://packages.couchbase.com/releases/${SPV}/${SPN}_src-${SPV}.tar.gz"
LICENSE="COUCHBASE INC. COMMUNITY EDITION"
KEYWORDS="~x86 ~amd64"
IUSE=""

# FIXME
# XXX memcached is already required by ep-engine, so omitted
RDEPEND="
   =dev-db/ep-engine-2.1.1
   "
DEPEND=""
S="${WORKDIR}/${SPN}_src/bucket_engine"

pkg_postinst() {
	elog "For fresh ebuilds check https://github.com/elitak/couchbase-overlay"
	elog "Bugtracker https://github.com/elitak/couchbase-overlay/issues"
}
