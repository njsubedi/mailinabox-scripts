#!/bin/bash

BRAND_NAME="My Company Mailbox"
BRAND_LOGO="https://example.com/example.png"

set -eou pipefail

# Mail HELO
sed -ie 's|^smtpd_banner=.*|smtpd_banner=$myhostname ESMTP '"$BRAND_NAME"' (Ubuntu/Postfix)|g' /etc/postfix/main.cf

# Login Page Support URL
sed -ie "s|mailinabox.email|$(hostname)|g" /usr/local/lib/roundcubemail/config/config.inc.php

# Login Page Logo
sed -ie 's|/images/logo.svg|'"$BRAND_LOGO"'|g' /usr/local/lib/roundcubemail/public_html/skins/elastic/templates/login.html
