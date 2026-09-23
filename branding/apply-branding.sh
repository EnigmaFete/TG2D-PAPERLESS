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
  cp -f "$BRANDING_DIR/favicon.ico" "$dest/favicon.ico" 2>/dev/null || true
done

# Copy to all frontend locale asset directories
for frontend_dir in /usr/src/paperless/static/frontend/* /usr/src/paperless/src/documents/static/frontend/*; do
  if [ -d "$frontend_dir" ]; then
    cp -f "$BRANDING_DIR/logo.png" "$frontend_dir/logo.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/icon-192.png" "$frontend_dir/icon-192.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/icon-512.png" "$frontend_dir/icon-512.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/icon-192.png" "$frontend_dir/apple-touch-icon.png" 2>/dev/null || true
    cp -f "$BRANDING_DIR/favicon.ico" "$frontend_dir/favicon.ico" 2>/dev/null || true
  fi
done

# 2. Update SVG logo and leaf snippets
cat << 'SNIPPET_LOGO' > /usr/src/paperless/src/documents/templates/paperless-ngx/snippets/svg_logo.html
<img src="/static/logo.png" alt="TG2D" style="max-height: 85px; max-width: 100%; object-fit: contain;" {{ extra_attrs }} />
SNIPPET_LOGO

cat << 'SNIPPET_LEAF' > /usr/src/paperless/src/documents/templates/paperless-ngx/snippets/svg_leaf.html
<img src="/static/icon-192.png" alt="TG2D" style="height: 32px; width: 32px; object-fit: contain; vertical-align: middle;" {{ extra_attrs }} />
SNIPPET_LEAF

# 3. Create full base.html with embedded premium TG2D Cyan & White theme
cat << 'BASE_HTML' > /usr/src/paperless/src/documents/templates/paperless-ngx/base.html
<!doctype html>
{% load static i18n %}
<html lang="fr">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="author" content="TG2D">
        <meta name="robots" content="noindex,nofollow">
        <title>{% block head_title %}TG2D - Gestion Documentaire{% endblock head_title %}</title>
        <link rel="icon" type="image/x-icon" href="/static/favicon.ico">
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
                <img src="/static/logo.png" width="290" class="logo mb-4" alt="TG2D" />
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

# 4. Inject global TG2D styles into index.html
python3 -c "
path = '/usr/src/paperless/src/documents/templates/index.html'
with open(path) as f:
    c = f.read()

custom_style = '''
<style>
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
  max-height: 48px !important;
  width: auto !important;
  object-fit: contain !important;
}
.navbar-brand .brand-title,
.navbar-brand .brand-copy,
.navbar-brand .title,
.navbar-brand .custom-title,
.navbar-brand-container .title,
.navbar-brand-container .custom-title {
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
</style>
'''

if '</head>' in c and 'navbar-brand .brand-title' not in c:
    c = c.replace('</head>', custom_style + '\n</head>')
    with open(path, 'w') as f:
        f.write(c)
" 2>/dev/null || true

# 5. Remove all precompressed .br and .gz files for base.css, bootstrap, and styles.css
rm -f /usr/src/paperless/static/base.css.gz /usr/src/paperless/static/base.css.br
rm -f /usr/src/paperless/static/bootstrap.min.css.gz /usr/src/paperless/static/bootstrap.min.css.br
rm -f /usr/src/paperless/static/frontend/*/styles.css.gz /usr/src/paperless/static/frontend/*/styles.css.br
rm -f /usr/src/paperless/src/documents/static/frontend/*/styles.css.gz /usr/src/paperless/src/documents/static/frontend/*/styles.css.br

echo "[TG2D-Branding] Branding applied successfully!"
