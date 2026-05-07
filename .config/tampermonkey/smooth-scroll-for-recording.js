// ==UserScript==
// @name         Smooth Scroll for Recording
// @namespace    http://tampermonkey.net/
// @version      1.3
// @description  Smoothly scroll page top-to-bottom at a constant speed
// @author       You
// @match        *://*/*
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function() {
  'use strict';

  // === CONFIG ===
  const PIXELS_PER_SECOND = 200; // scroll speed — same on every page
  const START_DELAY_MS = 3000;   // delay before scroll starts
  // ==============

  function smoothScroll() {
    window.scrollTo(0, 0);
    const start = 0;
    const end = document.documentElement.scrollHeight - window.innerHeight;
    const distance = end - start;
    const durationMs = (distance / PIXELS_PER_SECOND) * 1000;
    const startTime = performance.now();

    function step(now) {
      const elapsed = now - startTime;
      const t = Math.min(elapsed / durationMs, 1);
      window.scrollTo(0, start + distance * t);
      if (t < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  }

  function trigger() {
    const end = document.documentElement.scrollHeight - window.innerHeight;
    const totalSec = Math.round(end / PIXELS_PER_SECOND);
    btn.textContent = `(${totalSec}s scroll)`;
    btn.style.background = '#d73a49';
    setTimeout(() => {
      btn.style.display = 'none';
      smoothScroll();
      const durationMs = (end / PIXELS_PER_SECOND) * 1000;
      setTimeout(() => {
        btn.style.display = 'block';
        btn.textContent = '▶ Scroll';
        btn.style.background = '#2da44e';
      }, durationMs + 500);
    }, START_DELAY_MS);
  }

  const btn = document.createElement('button');
  btn.textContent = '▶ Scroll';
  Object.assign(btn.style, {
    position: 'fixed',
    bottom: '20px',
    right: '20px',
    zIndex: '999999',
    padding: '10px 16px',
    background: '#2da44e',
    color: '#fff',
    border: 'none',
    borderRadius: '6px',
    cursor: 'pointer',
    fontSize: '14px',
    fontFamily: 'system-ui, sans-serif',
    boxShadow: '0 2px 8px rgba(0,0,0,0.2)',
  });
  btn.addEventListener('click', trigger);
  document.body.appendChild(btn);
})();
