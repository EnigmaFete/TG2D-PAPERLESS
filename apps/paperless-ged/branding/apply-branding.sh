#!/usr/bin/env bash
set -e

echo "[TG2D-Branding] Applying custom TG2D branding and color scheme..."

BRANDING_DIR="/usr/src/paperless/branding"
if [ ! -d "$BRANDING_DIR" ]; then
  BRANDING_DIR="/tmp/branding"
fi

# 1. Copy logo, icons and favicon to all static directories
for dest in /usr/src/paperless/static /usr/src/paperless/src/documents/static /usr/src/paperless/static/paperless/img; do
  mkdir -p "$dest"
  cp -f "$BRANDING_DIR/logo.png" "$dest/logo.png" 2>/dev/null || true
  cp -f "$BRANDING_DIR/icon-192.png" "$dest/icon-192.png" 2>/dev/null || true
  cp -f "$BRANDING_DIR/icon-512.png" "$dest/icon-512.png" 2>/dev/null || true
  cp -f "$BRANDING_DIR/apple-touch-icon.png" "$dest/apple-touch-icon.png" 2>/dev/null || true
  cp -f "$BRANDING_DIR/favicon.ico" "$dest/favicon.ico" 2>/dev/null || true
  cp -f "$BRANDING_DIR/favicon-32x32.png" "$dest/favicon-32x32.png" 2>/dev/null || true
  cp -f "$BRANDING_DIR/favicon-16x16.png" "$dest/favicon-16x16.png" 2>/dev/null || true
done

# Copy to all frontend locale asset directories
for frontend_dir in /usr/src/paperless/static/frontend/* /usr/src/paperless/src/documents/static/frontend/*; do
  if [ -d "$frontend_dir" ]; then
    cp -f "$BRANDING_DIR/logo.png" "$frontend_dir/logo.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/icon-192.png" "$frontend_dir/icon-192.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/icon-512.png" "$frontend_dir/icon-512.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/icon-512-maskable.png" "$frontend_dir/icon-512-maskable.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/apple-touch-icon.png" "$frontend_dir/apple-touch-icon.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/favicon.ico" "$frontend_dir/favicon.ico" 2>/dev/null || true
    cp -f "$BRANDING_DIR/favicon-32x32.png" "$frontend_dir/favicon-32x32.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/favicon-16x16.png" "$frontend_dir/favicon-16x16.png" 2>/dev/null || true
  fi
done

# 2. Update SVG logo and leaf snippets
cat << 'SNIPPET_LOGO' > /usr/src/paperless/src/documents/templates/paperless-ngx/snippets/svg_logo.html
<img src="/static/logo.png" alt="T.G.2.D" style="max-height: 85px; max-width: 100%; object-fit: contain;" {{ extra_attrs }} />
SNIPPET_LOGO

cat << 'SNIPPET_LEAF' > /usr/src/paperless/src/documents/templates/paperless-ngx/snippets/svg_leaf.html
<img src="/static/icon-192.png" alt="T.G.2.D" style="height: 32px; width: 32px; object-fit: contain; vertical-align: middle;" {{ extra_attrs }} />
SNIPPET_LEAF

# 3. Create full base.html with embedded premium TG2D Cyan & White theme
cat << 'BASE_HTML' > /usr/src/paperless/src/documents/templates/paperless-ngx/base.html
<!doctype html>
{% load static i18n %}
<html lang="fr">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="author" content="T.G.2.D">
        <meta name="robots" content="noindex,nofollow">
        <title>{% block head_title %}T.G.2.D - Gestion Documentaire{% endblock head_title %}</title>
        <link rel="icon" type="image/x-icon" href="/static/favicon.ico?v=tg2d_pin">
        <link rel="icon" type="image/png" sizes="32x32" href="/static/favicon-32x32.png?v=tg2d_pin">
        <link rel="icon" type="image/png" sizes="16x16" href="/static/favicon-16x16.png?v=tg2d_pin">
        <link rel="apple-touch-icon" sizes="180x180" href="/static/apple-touch-icon.png?v=tg2d_pin">
        <link rel="shortcut icon" href="/static/favicon.ico?v=tg2d_pin">
        <link href="{% static 'bootstrap.min.css' %}" rel="stylesheet">
        <link href="{% static 'base.css' %}" rel="stylesheet">
        <style>
            :root {
                --bs-primary: #02c5f1 !important;
                --bs-primary-rgb: 2, 197, 241 !important;
                --pngx-primary: #02c5f1 !important;
                --pngx-primary-hover: #00b4d8 !important;
                --pngx-primary-active: #0096c7 !important;
            }
            body {
                background: linear-gradient(135deg, #09131b 0%, #0d1e2b 50%, #08121a 100%) !important;
                color: #ffffff !important;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif !important;
                min-height: 100vh;
                margin: 0;
            }
            p, label, span, h1, h2, h3, h4, h5, h6 {
                color: #ffffff !important;
            }
            .byline {
                display: none !important;
            }
            .form-accounts {
                max-width: 400px !important;
                min-width: 320px !important;
                background: rgba(16, 33, 46, 0.88) !important;
                backdrop-filter: blur(18px) !important;
                -webkit-backdrop-filter: blur(18px) !important;
                border: 1px solid rgba(2, 197, 241, 0.35) !important;
                border-radius: 20px !important;
                padding: 2.75rem 2.25rem !important;
                box-shadow: 0 20px 50px -10px rgba(0, 0, 0, 0.75), 0 0 35px rgba(2, 197, 241, 0.22) !important;
            }
            .logo {
                max-width: 290px !important;
                height: auto !important;
                filter: drop-shadow(0 4px 20px rgba(2, 197, 241, 0.4)) !important;
                margin-bottom: 1.75rem !important;
            }
            .form-floating input.form-control {
                background-color: #142533 !important;
                border: 1px solid #244157 !important;
                color: #ffffff !important;
                border-radius: 10px !important;
                font-size: 1rem !important;
            }
            .form-floating input.form-control:focus {
                background-color: #182e3f !important;
                border-color: #02c5f1 !important;
                color: #ffffff !important;
                box-shadow: 0 0 0 0.25rem rgba(2, 197, 241, 0.35) !important;
            }
            .form-floating label {
                color: #8da4b5 !important;
            }
            .form-floating input.form-control:focus ~ label {
                color: #02c5f1 !important;
            }
            .btn.btn-primary, button.btn-primary, .btn-primary, button[type="submit"] {
                background: linear-gradient(135deg, #02c5f1 0%, #00b4d8 100%) !important;
                background-color: #02c5f1 !important;
                border: none !important;
                color: #ffffff !important;
                font-weight: 700 !important;
                font-size: 1.05rem !important;
                letter-spacing: 0.03em !important;
                border-radius: 10px !important;
                padding: 0.8rem 1.5rem !important;
                box-shadow: 0 6px 20px rgba(2, 197, 241, 0.45) !important;
                transition: all 0.25s ease !important;
                cursor: pointer;
            }
            .btn.btn-primary:hover, button.btn-primary:hover, button[type="submit"]:hover {
                background: linear-gradient(135deg, #00d4ff 0%, #02c5f1 100%) !important;
                transform: translateY(-2px) !important;
                box-shadow: 0 8px 25px rgba(2, 197, 241, 0.6) !important;
                color: #ffffff !important;
            }
            .btn-link {
                color: #02c5f1 !important;
                text-decoration: none !important;
            }
            .btn-link:hover {
                color: #63e1fc !important;
                text-decoration: underline !important;
            }
        </style>
    </head>
    <body class="text-center">
        <div class="position-absolute top-50 start-50 translate-middle">
            <form class="form-accounts" id="form-account" method="post">
                {% csrf_token %}
                <img src="/static/logo.png" width="290" class="logo mb-4" alt="T.G.2.D" />
                {% for message in messages %}
                    <div class="alert alert-{{ message.level_tag }}" role="alert">
                    {{ message }}
                    </div>
                {% endfor %}
                {% block form_top_content %}
                {% endblock form_top_content %}
                {% if form.errors %}
                    <div class="alert alert-danger" role="alert" style="background: rgba(220, 53, 69, 0.2); border: 1px solid #dc3545; color: #ff8585;">
                        {% for field, errors in form.errors.items %}
                            {% for error in errors %}
                                {{ error }}
                            {% endfor %}
                        {% endfor %}
                    </div>
                {% elif request.GET.sharelink_notfound %}
                    <div class="alert alert-danger" role="alert">
                    {% translate "Share link was not found." %}
                    </div>
                {% elif request.GET.sharelink_expired %}
                    <div class="alert alert-danger" role="alert">
                    {% translate "Share link has expired." %}
                    </div>
                {% endif %}
                {% block form_content %}
                {% endblock form_content %}
            </form>
            {% block after_form_content %}
            {% endblock after_form_content %}
        </div>
    </body>
</html>
BASE_HTML

# 4. Inject global TG2D styles and cache-busted icon links into index.html and styles.css
python3 -c "
import re
import glob

custom_style = '''/* TG2D-CUSTOM-START */
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
/* Ensure logo container and link expand to display full logo */
.navbar-brand-container {
  display: flex !important;
  align-items: center !important;
  min-width: fit-content !important;
}
.navbar-brand,
.navbar-brand.slim,
a.navbar-brand,
a.navbar-brand.slim {
  max-width: none !important;
  width: auto !important;
  min-width: 140px !important;
  height: 100% !important;
  padding: 0 0.75rem !important;
  display: flex !important;
  align-items: center !important;
}
/* Enlarge TG2D Logo prominently in the navbar */
.navbar-brand img,
.navbar-brand .brand-logo,
.navbar-brand.slim .brand-logo,
img.brand-logo,
.brand-logo {
  height: 44px !important;
  max-height: 48px !important;
  min-height: 40px !important;
  width: auto !important;
  max-width: 180px !important;
  min-width: 120px !important;
  object-fit: contain !important;
  display: block !important;
  filter: drop-shadow(0 2px 8px rgba(2, 197, 241, 0.35)) !important;
  margin: 0 !important;
}
@media (max-width: 575.98px) {
  .navbar-brand,
  .navbar-brand.slim,
  a.navbar-brand,
  a.navbar-brand.slim {
    min-width: 100px !important;
  }
  .navbar-brand img,
  .navbar-brand .brand-logo,
  img.brand-logo {
    height: 36px !important;
    max-height: 38px !important;
    max-width: 130px !important;
    min-width: 90px !important;
  }
}
.navbar-brand .brand-title,
.navbar-brand .brand-copy,
.navbar-brand .title,
.navbar-brand .custom-title,
.navbar-brand-container .title,
.navbar-brand-container .custom-title,
.navbar-brand .brand-mark,
.navbar-brand .brand-mark-slim {
  display: none !important;
}
.btn-primary, button.btn-primary, .btn.btn-primary {
  background: linear-gradient(135deg, #02c5f1 0%, #00b4d8 100%) !important;
  background-color: #02c5f1 !important;
  border: none !important;
  color: #ffffff !important;
  box-shadow: 0 4px 14px rgba(2, 197, 241, 0.35) !important;
}
.btn-primary:hover, button.btn-primary:hover {
  background: linear-gradient(135deg, #00d4ff 0%, #02c5f1 100%) !important;
  color: #ffffff !important;
}
.nav-pills .nav-link.active, .page-item.active .page-link {
  background-color: #02c5f1 !important;
  border-color: #02c5f1 !important;
  color: #ffffff !important;
}
.form-check-input:checked {
  background-color: #02c5f1 !important;
  border-color: #02c5f1 !important;
}
a { color: #02c5f1 !important; }
a:hover { color: #00b4d8 !important; }
/* TG2D-CUSTOM-END */'''

# Patch index.html
path = '/usr/src/paperless/src/documents/templates/index.html'
try:
    with open(path) as f:
        c = f.read()

    icon_tags = '''
\t<link rel=\"icon\" type=\"image/x-icon\" href=\"/static/favicon.ico?v=tg2d_pin\">
\t<link rel=\"icon\" type=\"image/png\" sizes=\"32x32\" href=\"/static/favicon-32x32.png?v=tg2d_pin\">
\t<link rel=\"icon\" type=\"image/png\" sizes=\"16x16\" href=\"/static/favicon-16x16.png?v=tg2d_pin\">
\t<link rel=\"apple-touch-icon\" sizes=\"180x180\" href=\"/static/apple-touch-icon.png?v=tg2d_pin\">
\t<link rel=\"shortcut icon\" href=\"/static/favicon.ico?v=tg2d_pin\">
'''

    # Remove old icon references to ensure no conflicts
    c = re.sub(r'<link rel=\"icon\"[^>]*>\n?', '', c)
    c = re.sub(r'<link rel=\"shortcut icon\"[^>]*>\n?', '', c)
    c = re.sub(r'<link rel=\"apple-touch-icon\"[^>]*>\n?', '', c)

    if '<head>' in c:
        c = c.replace('<head>', '<head>' + icon_tags)

    # Clean existing custom styles if present
    c = re.sub(r'<style>\s*/\* TG2D-CUSTOM-START \*/.*?/\* TG2D-CUSTOM-END \*/\s*</style>', '', c, flags=re.DOTALL)
    c = re.sub(r'<style>\s*:root\s*\{\s*--bs-primary:.*?</style>', '', c, flags=re.DOTALL)

    style_tag = f'<style>\n{custom_style}\n</style>'
    if '</head>' in c:
        c = c.replace('</head>', style_tag + '\n</head>')

    with open(path, 'w') as f:
        f.write(c)
    print('index.html patched')
except Exception as e:
    print('Failed to patch index.html:', e)

# Patch styles.css in all locales
for css_path in glob.glob('/usr/src/paperless/static/frontend/*/styles.css') + glob.glob('/usr/src/paperless/src/documents/static/frontend/*/styles.css'):
    try:
        with open(css_path) as f:
            css_content = f.read()
        css_content = re.sub(r'/\* TG2D-CUSTOM-START \*/.*?/\* TG2D-CUSTOM-END \*/', '', css_content, flags=re.DOTALL)
        css_content += '\n' + custom_style + '\n'
        with open(css_path, 'w') as f:
            f.write(css_content)
    except Exception as e:
        print(f'Failed to patch {css_path}:', e)
print('styles.css files patched')
" 2>/dev/null || true

# 5. Update webmanifest app names and colors
for m in /usr/src/paperless/static/frontend/*/manifest.webmanifest /usr/src/paperless/src/documents/static/frontend/*/manifest.webmanifest; do
  if [ -f "$m" ]; then
    sed -i 's/"name": *"[^"]*"/"name": "T.G.2.D - Gestion Documentaire"/g' "$m" 2>/dev/null || true
    sed -i 's/"short_name": *"[^"]*"/"short_name": "T.G.2.D"/g' "$m" 2>/dev/null || true
    sed -i 's/"theme_color": *"[^"]*"/"theme_color": "#02c5f1"/g' "$m" 2>/dev/null || true
  fi
done

# 6. Remove all precompressed .br and .gz files across static tree
find /usr/src/paperless/static /usr/src/paperless/src/documents/static -name "*.gz" -delete 2>/dev/null || true
find /usr/src/paperless/static /usr/src/paperless/src/documents/static -name "*.br" -delete 2>/dev/null || true

echo "[TG2D-Branding] Branding applied successfully!"
