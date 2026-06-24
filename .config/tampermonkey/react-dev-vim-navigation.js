// ==UserScript==
// @name         React.dev Vim Navigation
// @namespace    http://tampermonkey.net/
// @version      1.2
// @description  hjkl + gg/G + ]/[ headings + J/K fast scroll + s sidebar + ? help for react.dev
// @match        https://react.dev/*
// @grant        none
// @run-at       document-end
// ==/UserScript==

(function () {
  "use strict";

  if (!document.body) return;

  console.log("[react-dev-vim] loaded on", location.href);

  // --- Config ---
  const SCROLL_SPEED = 3;
  const SCROLL_SPEED_FAST = 12;

  // --- Sidebar toggle ---
  // Structure: div.grid.grid-cols-sidebar-content
  //              div.lg:-mt-16  ← sidebar column
  //              main           ← content column
  // We hide the sidebar column AND swap the grid to single-column
  let sidebarVisible = true;

  const asideEl = document.querySelector("aside");
  const sidebarColumn = asideEl?.closest('div[class*="lg:-mt-16"]');
  const gridEl = sidebarColumn?.parentElement;

  const sidebarStyle = document.createElement("style");
  sidebarStyle.textContent = `
        .vim-sidebar-hidden {
            display: none !important;
        }
        .vim-grid-no-sidebar {
            grid-template-columns: 1fr !important;
        }
    `;
  document.head.appendChild(sidebarStyle);

  function toggleSidebar() {
    if (!sidebarColumn) return;
    sidebarVisible = !sidebarVisible;
    sidebarColumn.classList.toggle("vim-sidebar-hidden", !sidebarVisible);
    if (gridEl) gridEl.classList.toggle("vim-grid-no-sidebar", !sidebarVisible);
  }

  // --- Smooth scroll state ---
  const held = { j: false, k: false, J: false, K: false };
  let rafId = null;

  function scrollLoop() {
    if (held.j) window.scrollBy(0, SCROLL_SPEED);
    if (held.k) window.scrollBy(0, -SCROLL_SPEED);
    if (held.J) window.scrollBy(0, SCROLL_SPEED_FAST);
    if (held.K) window.scrollBy(0, -SCROLL_SPEED_FAST);
    if (held.j || held.k || held.J || held.K)
      rafId = requestAnimationFrame(scrollLoop);
    else rafId = null;
  }

  function startScrolling() {
    if (!rafId) rafId = requestAnimationFrame(scrollLoop);
  }

  function stopScrolling() {
    if (rafId) {
      cancelAnimationFrame(rafId);
      rafId = null;
    }
  }

  function anyHeld() {
    return held.j || held.k || held.J || held.K;
  }

  // --- gg double-tap state ---
  let lastG = 0;

  // --- Heading jump state ---
  let headingIndex = -1;
  let scrollTimer = null;

  function getHeadings() {
    return Array.from(
      document.querySelectorAll(
        "article h1, article h2, article h3, main h1, main h2, main h3",
      ),
    ).filter(Boolean);
  }

  function jumpToHeading(direction) {
    const headings = getHeadings();
    if (!headings.length) return;

    if (direction === 1) {
      if (headingIndex === -1) {
        const scrollY = window.scrollY + 80;
        const next = headings.findIndex((h) => h.offsetTop > scrollY);
        headingIndex = next === -1 ? 0 : next;
      } else {
        headingIndex = Math.min(headingIndex + 1, headings.length - 1);
      }
    } else {
      if (headingIndex === -1) {
        const scrollY = window.scrollY + 80;
        headingIndex = headings.reduce((found, h, i) => {
          return h.offsetTop < scrollY - 30 ? i : found;
        }, -1);
        if (headingIndex === -1) return;
      } else {
        headingIndex = Math.max(headingIndex - 1, 0);
      }
    }

    headings[headingIndex].scrollIntoView({
      behavior: "smooth",
      block: "start",
    });
  }

  window.addEventListener(
    "scroll",
    () => {
      clearTimeout(scrollTimer);
      scrollTimer = setTimeout(() => {
        headingIndex = -1;
      }, 500);
    },
    { passive: true },
  );

  // --- Help overlay ---
  let helpVisible = false;

  const helpOverlay = document.createElement("div");
  helpOverlay.id = "vim-help-overlay";
  helpOverlay.innerHTML = `
        <div id="vim-help-box">
            <div id="vim-help-title">⌨ Keybindings</div>
            <table>
                <tr><td>j / k</td><td>Scroll down / up</td></tr>
                <tr><td>J / K</td><td>Scroll down / up (fast)</td></tr>
                <tr><td>h / l</td><td>Previous / next page</td></tr>
                <tr><td>g g</td><td>Jump to top</td></tr>
                <tr><td>G</td><td>Jump to bottom</td></tr>
                <tr><td>] / [</td><td>Next / prev heading</td></tr>
                <tr><td>s</td><td>Toggle sidebar</td></tr>
                <tr><td>?</td><td>Toggle this help</td></tr>
            </table>
            <div id="vim-help-close">press ? or Esc to close</div>
        </div>
    `;

  const style = document.createElement("style");
  style.textContent = `
        #vim-help-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.55);
            z-index: 99999;
            align-items: center;
            justify-content: center;
        }
        #vim-help-overlay.visible {
            display: flex;
        }
        #vim-help-box {
            background: #1e1e2e;
            color: #cdd6f4;
            border: 1px solid #45475a;
            border-radius: 10px;
            padding: 24px 32px;
            font-family: monospace;
            font-size: 14px;
            min-width: 320px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.5);
        }
        #vim-help-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 16px;
            color: #89b4fa;
            letter-spacing: 0.05em;
        }
        #vim-help-box table {
            border-collapse: collapse;
            width: 100%;
        }
        #vim-help-box td {
            padding: 5px 12px 5px 0;
        }
        #vim-help-box td:first-child {
            color: #a6e3a1;
            font-weight: bold;
            white-space: nowrap;
            width: 120px;
        }
        #vim-help-close {
            margin-top: 16px;
            font-size: 11px;
            color: #585b70;
            text-align: center;
        }
    `;

  document.head.appendChild(style);
  document.body.appendChild(helpOverlay);

  function toggleHelp() {
    helpVisible = !helpVisible;
    helpOverlay.classList.toggle("visible", helpVisible);
  }

  helpOverlay.addEventListener("click", (e) => {
    if (e.target === helpOverlay) toggleHelp();
  });

  // --- Prev / next page links ---
  function findNavLink(direction) {
    const rel = document.querySelector(`a[rel="${direction}"]`);
    if (rel) return rel;

    const navLinks = Array.from(
      document.querySelectorAll('a[href]:not([href^="#"])'),
    ).filter((a) => {
      const txt = a.textContent.toLowerCase();
      return direction === "prev"
        ? txt.includes("previous") ||
            a.getAttribute("aria-label")?.toLowerCase().includes("previous")
        : txt.includes("next") ||
            a.getAttribute("aria-label")?.toLowerCase().includes("next");
    });

    return navLinks[0] || null;
  }

  // --- Main key handler ---
  function handler(e) {
    const t = e.target;
    if (!t) return;
    if (
      t.tagName === "INPUT" ||
      t.tagName === "TEXTAREA" ||
      t.isContentEditable
    )
      return;
    if (e.ctrlKey || e.altKey || e.metaKey) return;

    if (e.key === "Escape") {
      if (helpVisible) {
        toggleHelp();
        e.preventDefault();
      }
      return;
    }

    let handled = true;
    switch (e.key) {
      case "j":
        if (!held.j) {
          held.j = true;
          startScrolling();
        }
        break;
      case "k":
        if (!held.k) {
          held.k = true;
          startScrolling();
        }
        break;
      case "J":
        if (!held.J) {
          held.J = true;
          startScrolling();
        }
        break;
      case "K":
        if (!held.K) {
          held.K = true;
          startScrolling();
        }
        break;
      case "h": {
        const prev = findNavLink("prev");
        if (prev) prev.click();
        break;
      }
      case "l": {
        const next = findNavLink("next");
        if (next) next.click();
        break;
      }
      case "g": {
        const now = Date.now();
        if (now - lastG < 400) {
          window.scrollTo({ top: 0, behavior: "smooth" });
          lastG = 0;
        } else {
          lastG = now;
        }
        break;
      }
      case "G":
        window.scrollTo({
          top: document.body.scrollHeight,
          behavior: "smooth",
        });
        break;
      case "]":
        jumpToHeading(1);
        break;
      case "[":
        jumpToHeading(-1);
        break;
      case "s":
      case "S":
        toggleSidebar();
        break;
      case "?":
        toggleHelp();
        break;
      default:
        handled = false;
    }

    if (handled) {
      e.preventDefault();
      e.stopImmediatePropagation();
    }
  }

  window.addEventListener("keydown", handler, true);

  window.addEventListener(
    "keyup",
    (e) => {
      if (e.key === "j") held.j = false;
      if (e.key === "k") held.k = false;
      if (e.key === "J") held.J = false;
      if (e.key === "K") held.K = false;
      if (!anyHeld()) stopScrolling();
    },
    true,
  );

  window.addEventListener("blur", () => {
    held.j = false;
    held.k = false;
    held.J = false;
    held.K = false;
    stopScrolling();
  });
})();
