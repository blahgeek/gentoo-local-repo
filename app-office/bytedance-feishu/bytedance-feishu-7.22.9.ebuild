# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# customization: firejail

EAPI=8
inherit desktop unpacker xdg
DESCRIPTION="
飞书（Feishu）
飞书整合即时消息、日历、音视频会议、云文档、工作台等功能于一体，成就团队和个人，更高效、更愉悦。 "
HOMEPAGE="https://www.feishu.cn/download"
SRC_URI="
	amd64? ( https://share.z1k.dev/FnD9/download/Feishu-linux_x64-${PV}.deb )
"

S="${WORKDIR}"
LICENSE="Feishu-EULA"
SLOT="0"
KEYWORDS="amd64"

RESTRICT="strip mirror bindist"

DEPEND="
app-misc/ca-certificates
dev-libs/nss
x11-libs/libX11
x11-libs/libxcb
x11-libs/libXext
x11-misc/xdg-utils
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	unpacker "${S}/usr/share/man/man1/bytedance-feishu-stable.1.gz"
	unpacker "${S}/usr/share/doc/bytedance-feishu-stable/changelog.gz"
}

src_install() {
	insinto "/"
	doins -r "${S}/opt/"
	domenu "${S}/usr/share/applications/bytedance-feishu.desktop"

	# dosym -r /opt/bytedance/feishu/bytedance-feishu /usr/bin/bytedance-feishu-stable
	doman "${S}/bytedance-feishu-stable.1"
	dodoc "${S}/changelog"
	local size
	for size in 16 24 32 48 64 128 256 ; do
		newicon -s ${size} "${S}/opt/bytedance/feishu/product_logo_${size}.png" ${PN}.png
	done
	newicon -s scalable "${S}/opt/bytedance/feishu/product_logo_256.svg" ${PN}.svg

	fperms +x "/opt/bytedance/feishu/bytedance-feishu"
	fperms +x "/opt/bytedance/feishu/feishu"
	fperms +x "/opt/bytedance/feishu/vulcan/vulcan"
	fperms +x "/opt/bytedance/feishu/vulcan/vulcan_crashpad_handler"

	dobin "${FILESDIR}/firejail/feishu"
	# /usr/bin/bytedance-feishu-stable is used by desktop entry
	dosym -r /usr/bin/feishu /usr/bin/bytedance-feishu-stable
	insinto "/etc/firejail/"
	doins "${FILESDIR}/firejail/feishu.profile"
}
