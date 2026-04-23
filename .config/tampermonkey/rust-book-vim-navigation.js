// ==UserScript==
// @name         Rust Book Vim Navigation
// @namespace    http://tampermonkey.net/
// @version      1.1
// @description  hjkl + s keybindings for the Rust Book
// @match        https://doc.rust-lang.org/book/*
// @match        https://doc.rust-lang.org/stable/book/*
// @match        https://doc.rust-lang.org/nightly/book/*
// @match        https://rust-lang.github.io/book/*
// @grant        none
// @run-at       document-end
// ==/UserScript==

(function() {
  'use strict';
  console.log('[rust-book-vim] loaded on', location.href);

  const SCROLL_AMOUNT = 80;

  function handler(e) {
    const t = e.target;
    if (!t) return;
    if (t.tagName === 'INPUT' || t.tagName === 'TEXTAREA' || t.isContentEditable) return;
    if (e.ctrlKey || e.altKey || e.metaKey) return;

    let handled = true;
    switch (e.key) {
      case 'k':
        window.scrollBy({ top: -SCROLL_AMOUNT, behavior: 'smooth' });
        break;
      case 'j':
        window.scrollBy({ top: SCROLL_AMOUNT, behavior: 'smooth' });
        break;
      case 'h': {
        const prev = document.querySelector('a.nav-chapters.previous, a[rel="prev"], .mobile-nav-chapters.previous');
        if (prev) prev.click();
        break;
      }
      case 'l': {
        const next = document.querySelector('a.nav-chapters.next, a[rel="next"], .mobile-nav-chapters.next');
        if (next) next.click();
        break;
      }
      case 'S': {
        const label = document.getElementById('mdbook-sidebar-toggle');
        if (label) {
          label.click();
        } else {
          // Fallbacks
          const anchor = document.getElementById('mdbook-sidebar-toggle-anchor');
          const old = document.getElementById('sidebar-toggle');
          if (anchor) anchor.click();
          else if (old) old.click();
        }
        break;
      }
      default:
        handled = false;
    }
    if (handled) {
      e.preventDefault();
      e.stopImmediatePropagation();
    }
  }

  // Capture phase = we run BEFORE mdBook's own key handlers
  window.addEventListener('keydown', handler, true);
})();
