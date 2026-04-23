// ==UserScript==
// @name         Claude Vim Navigation
// @namespace    http://tampermonkey.net/
// @version      1.5
// @description  j/k scroll, i to focus prompt, Escape to unfocus, s toggle sidebar
// @match        https://claude.ai/*
// @grant        none
// @run-at       document-end
// ==/UserScript==

(function() {
  'use strict';
  console.log('[claude-vim] loaded');

  // px per animation frame (~60fps). Tune this to taste.
  const SCROLL_SPEED = 6;

  const held = { j: false, k: false };
  let rafId = null;

  // ── Scroll container ────────────────────────────────────────────────────
  function getScrollContainer() {
    for (const el of document.querySelectorAll('div')) {
      const style = getComputedStyle(el);
      const scrollable = style.overflowY === 'auto' || style.overflowY === 'scroll';
      if (scrollable && el.scrollHeight > el.clientHeight + 100) return el;
    }
    return document.documentElement;
  }

  // rAF loop — runs only while a scroll key is held
  function scrollLoop() {
    const container = getScrollContainer();
    if (held.j) container.scrollTop += SCROLL_SPEED;
    if (held.k) container.scrollTop -= SCROLL_SPEED;

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

  // ── Prompt helpers ──────────────────────────────────────────────────────
  function getMainInput() {
    return document.querySelector('[data-testid="chat-input"]');
  }

  function getSidebarToggle() {
    return document.querySelector('[data-testid="pin-sidebar-toggle"]');
  }

  function isAnyEditorFocused() {
    const active = document.activeElement;
    if (!active) return false;
    return (
      active.tagName === 'INPUT' ||
      active.tagName === 'TEXTAREA' ||
      active.isContentEditable ||
      !!active.closest('[contenteditable="true"]')
    );
  }

  function isMainInputFocused() {
    const input = getMainInput();
    return input && (document.activeElement === input || input.contains(document.activeElement));
  }

  function focusMainInput() {
    const input = getMainInput();
    if (!input) return;
    input.focus();
    const sel = window.getSelection();
    const range = document.createRange();
    range.selectNodeContents(input);
    range.collapse(false);
    sel.removeAllRanges();
    sel.addRange(range);
  }

  // ── Key handlers ────────────────────────────────────────────────────────
  window.addEventListener('keydown', function(e) {
    if (e.ctrlKey || e.altKey || e.metaKey) return;

    // Escape: unfocus main prompt only
    if (e.key === 'Escape' && isMainInputFocused()) {
      document.activeElement.blur();
      e.preventDefault();
      e.stopImmediatePropagation();
      return;
    }

    if (isAnyEditorFocused()) return;

    switch (e.key) {
      case 'j':
        if (!held.j) { held.j = true; startScrolling(); }
        e.preventDefault();
        e.stopImmediatePropagation();
        break;

      case 'k':
        if (!held.k) { held.k = true; startScrolling(); }
        e.preventDefault();
        e.stopImmediatePropagation();
        break;

      case 'i':
        focusMainInput();
        e.preventDefault();
        e.stopImmediatePropagation();
        break;

      case 's':
      case 'S': {
        const btn = getSidebarToggle();
        if (btn) btn.click();
        e.preventDefault();
        e.stopImmediatePropagation();
        break;
      }
    }
  }, true);

  window.addEventListener('keyup', function(e) {
    if (e.key === 'j') { held.j = false; if (!held.k) stopScrolling(); }
    if (e.key === 'k') { held.k = false; if (!held.j) stopScrolling(); }
  }, true);

  // Safety net: stop scrolling if window loses focus
  window.addEventListener('blur', function() {
    held.j = false;
    held.k = false;
    stopScrolling();
  });
})();
