// ==UserScript==
// @name         Smooth Scroll for Recording
// @namespace    http://tampermonkey.net/
// @version      1.2
// @description  Smoothly scroll page top-to-bottom for screen recordings
// @author       You
// @match        *://*/*
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function() {
  'use strict';

  // === CONFIG ===
  const DURATION_MS = 30000;   // total scroll time in ms
  const START_DELAY_MS = 3000; // delay before scroll starts
  // ==============

  function smoothScroll(durationMs) {
    window.scrollTo(0, 0);
    const start = 0;
    const end = document.documentElement.scrollHeight - window.innerHeight;
    const distance = end - start;
    const startTime = performance.now();

    function step(now) {
      const elapsed = now - startTime;
      const t = Math.min(elapsed / durationMs, 1);
      window.scrollTo(0, start + distance * t); // linear: constant speed
      if (t < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  }

  function trigger() {
    btn.textContent = `Scrolling in ${START_DELAY_MS / 1000}s…`;
    btn.style.background = '#d73a49';
    setTimeout(() => {
      btn.style.display = 'none'; // hide button so it's not in the recording
      smoothScroll(DURATION_MS);
      setTimeout(() => {
        btn.style.display = 'block';
        btn.textContent = '▶ Scroll';
        btn.style.background = '#2da44e';
      }, DURATION_MS + 500);
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
