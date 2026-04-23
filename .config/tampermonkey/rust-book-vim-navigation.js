// ==UserScript==
// @name         Rust Book Vim Navigation
// @namespace    http://tampermonkey.net/
// @version      1.2
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

  const SCROLL_SPEED = 3; // px per frame — tune to taste

  const held = { j: false, k: false };
  let rafId = null;

  function scrollLoop() {
    if (held.j) window.scrollBy(0, SCROLL_SPEED);
    if (held.k) window.scrollBy(0, -SCROLL_SPEED);

    if (held.j || held.k) {
      rafId = requestAnimationFrame(scrollLoop);
    } else {
      rafId = null;
    }
  }

  function startScrolling() {
    if (!rafId) rafId = requestAnimationFrame(scrollLoop);
  }

  function stopScrolling() {
    if (rafId) { cancelAnimationFrame(rafId); rafId = null; }
  }

  function handler(e) {
    const t = e.target;
    if (!t) return;
    if (t.tagName === 'INPUT' || t.tagName === 'TEXTAREA' || t.isContentEditable) return;
    if (e.ctrlKey || e.altKey || e.metaKey) return;

    let handled = true;
    switch (e.key) {
      case 'j':
        if (!held.j) { held.j = true; startScrolling(); }
        break;
      case 'k':
        if (!held.k) { held.k = true; startScrolling(); }
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
      case 's':
      case 'S': {
        const label = document.getElementById('mdbook-sidebar-toggle');
        if (label) {
          label.click();
        } else {
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

  window.addEventListener('keydown', handler, true);

  window.addEventListener('keyup', function(e) {
    if (e.key === 'j') { held.j = false; if (!held.k) stopScrolling(); }
    if (e.key === 'k') { held.k = false; if (!held.j) stopScrolling(); }
  }, true);

  window.addEventListener('blur', function() {
    held.j = false;
    held.k = false;
    stopScrolling();
  });
})();
