# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils

PNAME="couchbase-server-enterprise"
DESCRIPTION="Distributed key-value database management system"
HOMEPAGE="http://www.couchbase.com"
SRC_URI="x86? ( http://packages.couchbase.com/releases/${PV}/${PNAME}_x86_${PV}.deb )
        amd64? ( http://packages.couchbase.com/releases/${PV}/${PNAME}_x86_64_${PV}.deb )"

#RESTRICT="fetch"

LICENSE="COUCHBASE INC. ENTERPRISE EDITION"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5
		>=dev-libs/libevent-1.4.13
		>=dev-libs/cyrus-sasl-2
		>=dev-libs/openssl-0.9.8e
		<dev-libs/openssl-1.0.0"
#		!net-misc/memcached"
DEPEND=""


pkg_setup() {
	enewuser couchbase -1 -1 /opt/couchbase daemon
	enewgroup couchbase

	ewarn "This package provides only a port from binary .deb package 
built by 
Couchbase for another linux distributions."
        ewarn "It's not properly tested on this distribution and may have some bugs."
        ewarn "Use it with caution on production systems! Stablity of true Enterprise edition is not guaranteed!."
}

src_unpack() {
	ar x "${DISTDIR}"/${A}
	cd ${WORKDIR}
	tar xzf data.tar.gz
}

src_install() {
	cp -pPR "${WORKDIR}"/opt "${D}"
	rm -f "${D}"/opt/couchbase/${PV}/data
	rm -f "${D}"/opt/couchbase/${PV}/tmp
	
	sed -i "s/\/opt\/couchbase\/var\/lib\/couchbase\/couchbase-server.pid/\/var\/run\/couchbase-server.pid/" "${D}/opt/couchbase/bin/couchbase-server" || die "Install failed!"

	dodir "/opt/couchbase/var/lib/couchbase/data"
	keepdir "/opt/couchbase/var/lib/couchbase/data"

	dodir "/opt/couchbase/var/lib/couchbase/logs"
	dodir "/opt/couchbase/var/lib/couchbase/mnesia"
	dodir "/opt/couchbase/var/lib/couchbase/tmp"

	

	chown -R couchbase:daemon "${D}/opt/couchbase" || die "Install failed!"

	newinitd "${FILESDIR}/${PV}/couchbase-server" couchbase-server
}
