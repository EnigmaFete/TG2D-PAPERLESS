#!/usr/bin/env bash
set -e

INSTALL_DIR="${1:-/opt/paperless/paperless-ngx}"
BRANDING_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../branding" && pwd)"

echo "[TG2D-Branding] Application de la charte graphique TG2D Cyan sur $INSTALL_DIR..."

if [ ! -d "$BRANDING_DIR" ]; then
  echo "Erreur : dossier branding introuvable à $BRANDING_DIR"
  exit 1
fi

STATIC_DEST="$INSTALL_DIR/static"
DOCS_STATIC="$INSTALL_DIR/src/documents/static"

mkdir -p "$STATIC_DEST" "$DOCS_STATIC"

# 1. Copier le logo et les favicons
for dest in "$STATIC_DEST" "$DOCS_STATIC" "$STATIC_DEST/paperless/img"; do
  mkdir -p "$dest"
  cp -f "$BRANDING_DIR/logo.png" "$dest/logo.png" 2>/dev/null || true
  cp -f "$BRANDING_DIR/icon-192.png" "$dest/icon-192.png" 2>/dev/null || true
  cp -f "$BRANDING_DIR/icon-512.png" "$dest/icon-512.png" 2>/dev/null || true
  cp -f "$BRANDING_DIR/apple-touch-icon.png" "$dest/apple-touch-icon.png" 2>/dev/null || true
  cp -f "$BRANDING_DIR/favicon.ico" "$dest/favicon.ico" 2>/dev/null || true
  cp -f "$BRANDING_DIR/favicon-32x32.png" "$dest/favicon-32x32.png" 2>/dev/null || true
  cp -f "$BRANDING_DIR/favicon-16x16.png" "$dest/favicon-16x16.png" 2>/dev/null || true
done

# Copier vers les sous-dossiers frontend
for frontend_dir in "$STATIC_DEST/frontend/"* "$DOCS_STATIC/frontend/"*; do
  if [ -d "$frontend_dir" ]; then
    cp -f "$BRANDING_DIR/logo.png" "$frontend_dir/logo.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/icon-192.png" "$frontend_dir/icon-192.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/icon-512.png" "$frontend_dir/icon-512.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/apple-touch-icon.png" "$frontend_dir/apple-touch-icon.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/favicon.ico" "$frontend_dir/favicon.ico" 2>/dev/null || true
  fi
done

# 2. Mise à jour des snippets de template (Logo SVG & icône)
SNIPPET_DIR="$INSTALL_DIR/src/documents/templates/paperless-ngx/snippets"
mkdir -p "$SNIPPET_DIR"

cat << 'SNIPPET_LOGO' > "$SNIPPET_DIR/svg_logo.html"
<img src="/static/logo.png" alt="T.G.2.D" style="max-height: 85px; max-width: 100%; object-fit: contain;" {{ extra_attrs }} />
SNIPPET_LOGO

cat << 'SNIPPET_LEAF' > "$SNIPPET_DIR/svg_leaf.html"
<img src="/static/icon-192.png" alt="T.G.2.D" style="height: 32px; width: 32px; object-fit: contain; vertical-align: middle;" {{ extra_attrs }} />
SNIPPET_LEAF

# 3. Patch du style TG2D Cyan & Noir sobre
python3 -c "
import glob, re

custom_css = '''/* TG2D-CUSTOM-START */
:root {
  --bs-primary: #02c5f1 !important;
  --bs-primary-rgb: 2, 197, 241 !important;
  --pngx-primary: 191, 98% !important;
  --pngx-primary-lightness: 48% !important;
  --pngx-primary-text-contrast: #ffffff !important;
}
.byline { display: none !important; }
.navbar {
  background: #09131b !important;
  border-bottom: 2px solid rgba(2, 197, 241, 0.35) !important;
}
.navbar-brand img, .brand-logo {
  height: 44px !important;
  max-height: 48px !important;
  width: auto !important;
  object-fit: contain !important;
  filter: drop-shadow(0 2px 8px rgba(2, 197, 241, 0.35)) !important;
}
.btn-primary, button.btn-primary {
  background: linear-gradient(135deg, #02c5f1 0%, #00b4d8 100%) !important;
  border: none !important;
  color: #ffffff !important;
  font-weight: 600 !important;
  box-shadow: 0 4px 14px rgba(2, 197, 241, 0.35) !important;
}
a { color: #02c5f1 !important; }
/* TG2D-CUSTOM-END */'''

for css_file in glob.glob('$STATIC_DEST/frontend/*/styles.css') + glob.glob('$DOCS_STATIC/frontend/*/styles.css'):
    try:
        with open(css_file, 'r') as f:
            c = f.read()
        c = re.sub(r'/\* TG2D-CUSTOM-START \*/.*?/\* TG2D-CUSTOM-END \*/', '', c, flags=re.DOTALL)
        c += '\n' + custom_css + '\n'
        with open(css_file, 'w') as f:
            f.write(c)
    except Exception as e:
        print(f'Warning: {e}')
" 2>/dev/null || true

# Nettoyer les fichiers pré-compressés pour que les modifications prennent effet
find "$STATIC_DEST" "$DOCS_STATIC" -name "*.gz" -delete 2>/dev/null || true
find "$STATIC_DEST" "$DOCS_STATIC" -name "*.br" -delete 2>/dev/null || true

echo "[TG2D-Branding] Charte graphique appliquée avec succès !"
