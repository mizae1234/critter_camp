/**
 * Critter Camp - Master App & 16-Screen Prototype Viewer Logic
 */

document.addEventListener('DOMContentLoaded', async () => {
  let screens = [];
  let currentIndex = 0;
  let currentMode = 'interactive'; // 'interactive' | 'screenshot' | 'code'
  let currentScale = 1.0;
  let autoPlayTimer = null;
  let activeCategory = 'All';

  // DOM Elements
  const sidebarCategories = document.getElementById('sidebarCategories');
  const searchInput = document.getElementById('searchInput');
  const screenCountBadge = document.getElementById('screenCountBadge');
  const flowPillNav = document.getElementById('flowPillNav');
  const filmstripTrack = document.getElementById('filmstripTrack');
  const gridCardsContainer = document.getElementById('gridCardsContainer');
  const gridModal = document.getElementById('gridModal');

  // Stage Elements
  const screenIframe = document.getElementById('screenIframe');
  const screenshotViewer = document.getElementById('screenshotViewer');
  const screenshotImg = document.getElementById('screenshotImg');
  const codeViewer = document.getElementById('codeViewer');
  const codeContent = document.getElementById('codeContent');
  const codeFilename = document.getElementById('codeFilename');
  const deviceFrame = document.getElementById('deviceFrame');

  // Toolbar & Inspector Elements
  const currentScreenIndex = document.getElementById('currentScreenIndex');
  const currentScreenTitle = document.getElementById('currentScreenTitle');
  const zoomLevel = document.getElementById('zoomLevel');
  const inspectTitle = document.getElementById('inspectTitle');
  const inspectId = document.getElementById('inspectId');
  const inspectDim = document.getElementById('inspectDim');
  const inspectFile = document.getElementById('inspectFile');
  const inspectCategory = document.getElementById('inspectCategory');
  const flowStepButtons = document.getElementById('flowStepButtons');

  // Buttons
  const btnPrevScreen = document.getElementById('btnPrevScreen');
  const btnNextScreen = document.getElementById('btnNextScreen');
  const btnGridView = document.getElementById('btnGridView');
  const btnCloseGrid = document.getElementById('btnCloseGrid');
  const btnAutoPlay = document.getElementById('btnAutoPlay');
  const playIcon = document.getElementById('playIcon');
  const btnOpenDirect = document.getElementById('btnOpenDirect');
  const btnCopyCode = document.getElementById('btnCopyCode');
  const btnZoomIn = document.getElementById('btnZoomIn');
  const btnZoomOut = document.getElementById('btnZoomOut');
  const btnZoomReset = document.getElementById('btnZoomReset');
  const modeButtons = document.querySelectorAll('.mode-btn');

  // 1. Fetch Manifest
  try {
    const res = await fetch('manifest.json');
    screens = await res.json();
    screenCountBadge.textContent = screens.length;
  } catch (err) {
    console.error('Failed to load manifest.json', err);
    return;
  }

  // Categories list
  const categories = ['All', ...new Set(screens.map(s => s.category))];

  // 2. Render Categories & Flows
  function renderFlowPills() {
    flowPillNav.innerHTML = '';
    categories.forEach(cat => {
      const btn = document.createElement('button');
      btn.className = `flow-pill ${cat === activeCategory ? 'active' : ''}`;
      btn.textContent = cat;
      btn.addEventListener('click', () => {
        activeCategory = cat;
        renderFlowPills();
        renderSidebar();
      });
      flowPillNav.appendChild(btn);
    });
  }

  // 3. Render Sidebar
  function renderSidebar(filterQuery = '') {
    sidebarCategories.innerHTML = '';
    const query = filterQuery.toLowerCase().trim();

    const filtered = screens.filter((s, idx) => {
      const matchesCat = activeCategory === 'All' || s.category === activeCategory;
      const matchesText = !query || s.title.toLowerCase().includes(query) || s.slug.includes(query);
      return matchesCat && matchesText;
    });

    // Group by category
    const groups = {};
    filtered.forEach(s => {
      if (!groups[s.category]) groups[s.category] = [];
      groups[s.category].push(s);
    });

    Object.keys(groups).forEach(cat => {
      const groupEl = document.createElement('div');
      groupEl.className = 'category-group';

      const titleEl = document.createElement('div');
      titleEl.className = 'category-title';
      titleEl.textContent = cat;
      groupEl.appendChild(titleEl);

      groups[cat].forEach(s => {
        const originalIndex = screens.findIndex(item => item.id === s.id);
        const itemEl = document.createElement('div');
        itemEl.className = `screen-item ${originalIndex === currentIndex ? 'active' : ''}`;
        itemEl.innerHTML = `
          <span class="screen-item-num">${String(originalIndex + 1).padStart(2, '0')}</span>
          <span class="screen-item-title">${s.title}</span>
        `;
        itemEl.addEventListener('click', () => {
          selectScreen(originalIndex);
        });
        groupEl.appendChild(itemEl);
      });

      sidebarCategories.appendChild(groupEl);
    });
  }

  // 4. Render Bottom Filmstrip
  function renderFilmstrip() {
    filmstripTrack.innerHTML = '';
    screens.forEach((s, idx) => {
      const item = document.createElement('div');
      item.className = `filmstrip-item ${idx === currentIndex ? 'active' : ''}`;
      item.title = `${idx + 1}. ${s.title}`;
      item.innerHTML = `
        <img src="${s.screenshotFile}" alt="${s.title}">
        <span class="filmstrip-badge">${idx + 1}</span>
      `;
      item.addEventListener('click', () => {
        selectScreen(idx);
      });
      filmstripTrack.appendChild(item);
    });
  }

  // 5. Render Grid Cards Gallery
  function renderGridCards() {
    gridCardsContainer.innerHTML = '';
    screens.forEach((s, idx) => {
      const card = document.createElement('div');
      card.className = `grid-card ${idx === currentIndex ? 'active' : ''}`;
      card.innerHTML = `
        <div class="grid-card-img-wrap">
          <img src="${s.screenshotFile}" alt="${s.title}" loading="lazy">
        </div>
        <div class="grid-card-footer">
          <span class="grid-card-num">Screen ${String(idx + 1).padStart(2, '0')}</span>
          <span class="grid-card-title">${s.title}</span>
          <span class="grid-card-cat">${s.category}</span>
        </div>
      `;
      card.addEventListener('click', () => {
        selectScreen(idx);
        gridModal.classList.remove('open');
      });
      gridCardsContainer.appendChild(card);
    });
  }

  // 6. Select and Display Screen
  async function selectScreen(index) {
    if (index < 0 || index >= screens.length) return;
    currentIndex = index;
    const s = screens[currentIndex];

    // Update Toolbar & Titles
    currentScreenIndex.textContent = `${String(currentIndex + 1).padStart(2, '0')} / ${String(screens.length).padStart(2, '0')}`;
    currentScreenTitle.textContent = s.title;

    // Update Inspector Info
    inspectTitle.textContent = s.title;
    inspectId.textContent = s.id;
    inspectDim.textContent = `${s.width || '390'} x ${s.height || '844'} (Mobile)`;
    inspectFile.textContent = s.htmlFile.split('/').pop();
    inspectCategory.textContent = s.category;

    // Flow Step Buttons in Inspector
    flowStepButtons.innerHTML = '';
    if (currentIndex > 0) {
      const prevBtn = document.createElement('button');
      prevBtn.className = 'flow-jump-btn';
      prevBtn.innerHTML = `<span>← Prev: ${screens[currentIndex - 1].title}</span>`;
      prevBtn.addEventListener('click', () => selectScreen(currentIndex - 1));
      flowStepButtons.appendChild(prevBtn);
    }
    if (currentIndex < screens.length - 1) {
      const nextBtn = document.createElement('button');
      nextBtn.className = 'flow-jump-btn';
      nextBtn.innerHTML = `<span>Next: ${screens[currentIndex + 1].title} →</span>`;
      nextBtn.addEventListener('click', () => selectScreen(currentIndex + 1));
      flowStepButtons.appendChild(nextBtn);
    }

    // Update View Modes
    // Mode 1: Interactive HTML
    screenIframe.src = s.htmlFile;

    // Mode 2: Screenshot Image
    screenshotImg.src = s.screenshotFile;

    // Mode 3: Source Code
    codeFilename.textContent = s.htmlFile.split('/').pop();
    codeContent.textContent = 'Loading source code...';
    try {
      const codeRes = await fetch(s.htmlFile);
      const codeText = await codeRes.text();
      codeContent.textContent = codeText;
    } catch (e) {
      codeContent.textContent = 'Failed to load source code.';
    }

    // Refresh Active State in UI
    renderSidebar(searchInput.value);
    renderFilmstrip();

    // Scroll active thumbnail into view
    const activeThumb = filmstripTrack.children[currentIndex];
    if (activeThumb) {
      activeThumb.scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' });
    }
  }

  // 7. View Mode Switcher
  function setViewMode(mode) {
    currentMode = mode;
    modeButtons.forEach(btn => {
      btn.classList.toggle('active', btn.dataset.mode === mode);
    });

    if (mode === 'interactive') {
      deviceFrame.style.display = 'flex';
      screenshotViewer.style.display = 'none';
      codeViewer.style.display = 'none';
    } else if (mode === 'screenshot') {
      deviceFrame.style.display = 'none';
      screenshotViewer.style.display = 'flex';
      codeViewer.style.display = 'none';
    } else if (mode === 'code') {
      deviceFrame.style.display = 'none';
      screenshotViewer.style.display = 'none';
      codeViewer.style.display = 'flex';
    }
  }

  modeButtons.forEach(btn => {
    btn.addEventListener('click', () => setViewMode(btn.dataset.mode));
  });

  // 8. Scale / Zoom Logic
  function applyScale(scale) {
    currentScale = Math.max(0.5, Math.min(1.5, scale));
    deviceFrame.style.transform = `scale(${currentScale})`;
    zoomLevel.textContent = `${Math.round(currentScale * 100)}%`;
  }

  btnZoomIn.addEventListener('click', () => applyScale(currentScale + 0.1));
  btnZoomOut.addEventListener('click', () => applyScale(currentScale - 0.1));
  btnZoomReset.addEventListener('click', () => applyScale(1.0));

  // 9. Auto Play Mode
  function toggleAutoPlay() {
    if (autoPlayTimer) {
      clearInterval(autoPlayTimer);
      autoPlayTimer = null;
      playIcon.textContent = 'play_arrow';
      btnAutoPlay.classList.remove('primary');
    } else {
      playIcon.textContent = 'pause';
      btnAutoPlay.classList.add('primary');
      autoPlayTimer = setInterval(() => {
        const next = (currentIndex + 1) % screens.length;
        selectScreen(next);
      }, 3500);
    }
  }
  btnAutoPlay.addEventListener('click', toggleAutoPlay);

  // 10. Direct Open & Copy Code
  btnOpenDirect.addEventListener('click', () => {
    if (screens[currentIndex]) {
      window.open(screens[currentIndex].htmlFile, '_blank');
    }
  });

  btnCopyCode.addEventListener('click', () => {
    navigator.clipboard.writeText(codeContent.textContent).then(() => {
      btnCopyCode.innerHTML = `<span class="material-symbols-outlined">check</span> Copied!`;
      setTimeout(() => {
        btnCopyCode.innerHTML = `<span class="material-symbols-outlined">content_copy</span> Copy HTML`;
      }, 2000);
    });
  });

  // 11. Search Filter
  searchInput.addEventListener('input', (e) => {
    renderSidebar(e.target.value);
  });

  // 12. Grid Gallery Modal
  btnGridView.addEventListener('click', () => {
    renderGridCards();
    gridModal.classList.add('open');
  });

  btnCloseGrid.addEventListener('click', () => {
    gridModal.classList.remove('open');
  });

  // Navigation Prev/Next
  btnPrevScreen.addEventListener('click', () => {
    if (currentIndex > 0) selectScreen(currentIndex - 1);
    else selectScreen(screens.length - 1);
  });

  btnNextScreen.addEventListener('click', () => {
    if (currentIndex < screens.length - 1) selectScreen(currentIndex + 1);
    else selectScreen(0);
  });

  // 13. Keyboard Shortcuts
  window.addEventListener('keydown', (e) => {
    // If typing in search box, ignore navigation shortcuts
    if (document.activeElement === searchInput) return;

    if (e.key === 'ArrowRight') {
      btnNextScreen.click();
    } else if (e.key === 'ArrowLeft') {
      btnPrevScreen.click();
    } else if (e.key === 'g' || e.key === 'G') {
      gridModal.classList.toggle('open');
      if (gridModal.classList.contains('open')) renderGridCards();
    } else if (e.key === 'Escape') {
      gridModal.classList.remove('open');
    } else if (e.key === ' ') {
      e.preventDefault();
      toggleAutoPlay();
    } else if (e.key === '1') {
      setViewMode('interactive');
    } else if (e.key === '2') {
      setViewMode('screenshot');
    } else if (e.key === '3') {
      setViewMode('code');
    }
  });

  // Initialize
  renderFlowPills();
  renderSidebar();
  renderFilmstrip();
  selectScreen(0);
});
