#!/bin/bash
#############################################################################
# Fix Certificate Renewal Issues
#
# This script fixes the certbot renewal configuration to use the Nginx
# plugin instead of standalone, which was causing port 80 conflicts.
#
# Usage:
#   Run this on the VM:
#   chmod +x fix-cert-renewal.sh && sudo ./fix-cert-renewal.sh
#
#############################################################################

set -e

DOMAIN="arrahmah.sasid.me"
RENEWAL_CONF="/etc/letsencrypt/renewal/${DOMAIN}.conf"
RENEWAL_HOOK_DIR="/etc/letsencrypt/renewal-hooks/post"
RENEWAL_HOOK="$RENEWAL_HOOK_DIR/arrahmah-reload.sh"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "============================================================"
echo "  Fixing Certificate Renewal Configuration"
echo "============================================================"
echo ""

# 1. Update renewal configuration to use Nginx plugin
echo "Step 1/4: Updating renewal configuration..."
if [ -f "$RENEWAL_CONF" ]; then
    # Backup original
    cp "$RENEWAL_CONF" "${RENEWAL_CONF}.backup"
    echo "✓ Backed up original config"

    # Replace standalone with nginx
    sed -i 's/authenticator = standalone/authenticator = nginx/g' "$RENEWAL_CONF"
    sed -i 's/installer = None/installer = nginx/g' "$RENEWAL_CONF"

    # Add installer if not present
    if ! grep -q "installer = " "$RENEWAL_CONF"; then
        sed -i '/authenticator = nginx/a installer = nginx' "$RENEWAL_CONF"
    fi

    echo "✓ Updated authenticator to use Nginx plugin"
else
    echo "✗ Renewal config not found at $RENEWAL_CONF"
    exit 1
fi

echo ""

# 2. Install renewal hook
echo "Step 2/4: Installing renewal hook..."
if [ ! -d "$RENEWAL_HOOK_DIR" ]; then
    mkdir -p "$RENEWAL_HOOK_DIR"
    echo "✓ Created renewal hook directory"
fi

if [ -f "$SCRIPT_DIR/certbot-renewal-hook.sh" ]; then
    cp "$SCRIPT_DIR/certbot-renewal-hook.sh" "$RENEWAL_HOOK"
    chmod +x "$RENEWAL_HOOK"
    echo "✓ Installed renewal hook"
else
    echo "✗ certbot-renewal-hook.sh not found in $SCRIPT_DIR"
    exit 1
fi

echo ""

# 3. Test renewal configuration
echo "Step 3/4: Testing renewal configuration (dry run)..."
if certbot renew --dry-run --cert-name "$DOMAIN"; then
    echo "✓ Renewal test passed!"
else
    echo "✗ Renewal test failed"
    echo "  Restoring backup..."
    mv "${RENEWAL_CONF}.backup" "$RENEWAL_CONF"
    exit 1
fi

echo ""

# 4. Force actual renewal (certificate is expired)
echo "Step 4/4: Forcing certificate renewal..."
if certbot renew --cert-name "$DOMAIN" --force-renewal; then
    echo "✓ Certificate renewed successfully!"

    # Reload Nginx
    echo "Reloading Nginx..."
    systemctl reload nginx
    echo "✓ Nginx reloaded"

    # Show new certificate info
    echo ""
    echo "New Certificate Info:"
    certbot certificates --cert-name "$DOMAIN"
else
    echo "✗ Certificate renewal failed"
    exit 1
fi

echo ""
echo "============================================================"
echo "✅ Certificate Renewal Fixed!"
echo "============================================================"
echo ""
echo "Summary:"
echo "  • Renewal method: Changed from 'standalone' to 'nginx'"
echo "  • Renewal hook: Installed at $RENEWAL_HOOK"
echo "  • Certificate: Renewed successfully"
echo "  • Nginx: Reloaded with new certificate"
echo ""
echo "Future renewals will:"
echo "  • Run automatically twice daily"
echo "  • Use Nginx plugin (no port conflicts)"
echo "  • Reload Nginx automatically via hook"
echo "  • Log to /var/log/arrahmah-cert-renewal.log"
echo ""
echo "============================================================"
