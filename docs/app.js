/**
 * TG2D GED - GitHub Pages Interactive Controller
 * Built with Modern Web Standards
 */

document.addEventListener('DOMContentLoaded', () => {
  initTabs();
  initCopyButtons();
  initDocumentSimulator();
});

/* ==========================================================================
   1. Accessible Tabs System (Modern Web Guidance)
   ========================================================================== */
function initTabs() {
  const tablist = document.querySelector('[role="tablist"]');
  if (!tablist) return;

  const tabs = Array.from(tablist.querySelectorAll('[role="tab"]'));
  const panels = tabs.map(tab => {
    const panelId = tab.getAttribute('aria-controls');
    return document.getElementById(panelId);
  });

  function selectTab(selectedTab, moveFocus = true) {
    tabs.forEach((tab, index) => {
      const isSelected = tab === selectedTab;
      tab.setAttribute('aria-selected', isSelected ? 'true' : 'false');
      tab.tabIndex = isSelected ? 0 : -1;
      
      const panel = panels[index];
      if (panel) {
        if (isSelected) {
          panel.removeAttribute('hidden');
          panel.tabIndex = 0;
        } else {
          panel.setAttribute('hidden', '');
          panel.removeAttribute('tabindex');
        }
      }
    });

    if (moveFocus) {
      selectedTab.focus();
    }
  }

  // Keyboard navigation: Left, Right, Home, End
  tablist.addEventListener('keydown', (e) => {
    const currentIndex = tabs.indexOf(document.activeElement);
    if (currentIndex === -1) return;

    let targetIndex = null;
    if (e.key === 'ArrowRight' || e.key === 'ArrowDown') {
      targetIndex = (currentIndex + 1) % tabs.length;
    } else if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
      targetIndex = (currentIndex - 1 + tabs.length) % tabs.length;
    } else if (e.key === 'Home') {
      targetIndex = 0;
    } else if (e.key === 'End') {
      targetIndex = tabs.length - 1;
    }

    if (targetIndex !== null) {
      e.preventDefault();
      selectTab(tabs[targetIndex], true);
    }
  });

  // Click selection
  tabs.forEach(tab => {
    tab.addEventListener('click', () => {
      selectTab(tab, false);
    });
  });
}

/* ==========================================================================
   2. Copy to Clipboard with Accessible Toast Feedback
   ========================================================================== */
function initCopyButtons() {
  const copyButtons = document.querySelectorAll('.copy-btn');
  const toast = document.getElementById('toast');

  let toastTimer = null;
  function showToast(message) {
    if (!toast) return;
    toast.textContent = message;
    toast.removeAttribute('hidden');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => {
      toast.setAttribute('hidden', '');
    }, 2500);
  }

  copyButtons.forEach(btn => {
    btn.addEventListener('click', async () => {
      const textToCopy = btn.getAttribute('data-copy');
      if (!textToCopy) return;

      try {
        if (navigator.clipboard && window.isSecureContext) {
          await navigator.clipboard.writeText(textToCopy);
        } else {
          // Fallback for non-secure contexts
          const textarea = document.createElement('textarea');
          textarea.value = textToCopy;
          textarea.style.position = 'fixed';
          textarea.style.opacity = '0';
          document.body.appendChild(textarea);
          textarea.select();
          document.execCommand('copy');
          document.body.removeChild(textarea);
        }
        
        const originalText = btn.textContent;
        btn.textContent = '✓ Copié !';
        btn.style.background = 'var(--accent-cyan)';
        btn.style.color = '#031520';

        showToast('Commande copiée dans le presse-papier !');

        setTimeout(() => {
          btn.textContent = originalText;
          btn.style.background = '';
          btn.style.color = '';
        }, 2000);
      } catch (err) {
        showToast('Impossible de copier automatiquement');
      }
    });
  });
}

/* ==========================================================================
   3. Interactive Hero Document Simulator
   ========================================================================== */
function initDocumentSimulator() {
  const container = document.getElementById('demo-document-stream');
  const searchInput = document.getElementById('demo-search-input');
  const countBadge = document.getElementById('demo-count');
  const tagButtons = document.querySelectorAll('#demo-filter-tags .filter-chip');

  if (!container || !searchInput) return;

  const mockDocuments = [
    {
      id: 1,
      title: 'Facture_F2026-089_Lafarge_Betons.pdf',
      sub: 'Correspondant: Lafarge France · 14 Mars 2026',
      tag: 'Factures',
      icon: '📄'
    },
    {
      id: 2,
      title: 'Devis_D2026-44_VRD_Metropole_Grand_Paris.pdf',
      sub: 'Correspondant: Métropole Grand Paris · 10 Mars 2026',
      tag: 'Devis',
      icon: '📑'
    },
    {
      id: 3,
      title: 'PV_Reception_Chantier_Residence_Erables.pdf',
      sub: 'Chantier: Les Érables (Lot 02 Fondations) · 28 Fév 2026',
      tag: 'Chantiers',
      icon: '🏗️'
    },
    {
      id: 4,
      title: 'Rapport_Geotechnique_G2_TG2D_Sol.docx',
      sub: 'Bureau d’études: Geotec Ingénierie · 19 Jan 2026',
      tag: 'Technique',
      icon: '📐'
    },
    {
      id: 5,
      title: 'Contrat_Sous_Traitance_Gros_Oeuvre_2026.pdf',
      sub: 'Entreprise partenaire: Batisseurs Modernes · 05 Jan 2026',
      tag: 'Chantiers',
      icon: '📝'
    },
    {
      id: 6,
      title: 'Facture_F2026-012_Kiloutou_Engins.pdf',
      sub: 'Location matériel élévation · 02 Jan 2026',
      tag: 'Factures',
      icon: '📄'
    }
  ];

  let currentTag = 'all';
  let searchQuery = '';

  function render() {
    const filtered = mockDocuments.filter(doc => {
      const matchesTag = currentTag === 'all' || doc.tag === currentTag;
      const q = searchQuery.toLowerCase().trim();
      const matchesSearch = !q || 
        doc.title.toLowerCase().includes(q) || 
        doc.sub.toLowerCase().includes(q) || 
        doc.tag.toLowerCase().includes(q);
      return matchesTag && matchesSearch;
    });

    if (countBadge) {
      countBadge.textContent = `${filtered.length} document${filtered.length > 1 ? 's' : ''}`;
    }

    if (filtered.length === 0) {
      container.innerHTML = `
        <div style="text-align: center; padding: 2.5rem 1rem; color: var(--text-muted);">
          <div style="font-size: 1.8rem; margin-bottom: 0.5rem;">🔍</div>
          <p style="font-size: 0.88rem;">Aucun document ne correspond à votre recherche OCR.</p>
        </div>
      `;
      return;
    }

    container.innerHTML = filtered.map(doc => `
      <div class="doc-item" role="button" tabindex="0" title="Cliquer pour afficher l'aperçu Paperless">
        <div class="doc-info">
          <div class="doc-type-icon" aria-hidden="true">${doc.icon}</div>
          <div class="doc-meta">
            <div class="doc-title">${escapeHTML(doc.title)}</div>
            <div class="doc-sub">${escapeHTML(doc.sub)}</div>
          </div>
        </div>
        <span class="doc-tag">${escapeHTML(doc.tag)}</span>
      </div>
    `).join('');

    // Attach click listener to mock items
    container.querySelectorAll('.doc-item').forEach(item => {
      item.addEventListener('click', () => {
        const title = item.querySelector('.doc-title')?.textContent;
        const toast = document.getElementById('toast');
        if (toast && title) {
          toast.textContent = `Document ouvert : ${title}`;
          toast.removeAttribute('hidden');
          setTimeout(() => toast.setAttribute('hidden', ''), 2000);
        }
      });
    });
  }

  function escapeHTML(str) {
    return str.replace(/[&<>'"]/g, 
      tag => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', "'": '&#39;', '"': '&quot;' }[tag] || tag)
    );
  }

  // Search input handler
  searchInput.addEventListener('input', (e) => {
    searchQuery = e.target.value;
    render();
  });

  // Filter chip click handler
  tagButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      tagButtons.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      currentTag = btn.getAttribute('data-tag') || 'all';
      render();
    });
  });

  // Initial render
  render();
}
