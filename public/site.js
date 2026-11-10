/* Nomcebo Printers: scroll-reveal animations + random hero slideshow */
(function () {
  'use strict';

  /* ---------- Slide-in on scroll ---------- */
  var SEL = '.hero > div, .wrap > .strip, .wrap > h1, .wrap > h2, .wrap > p, .wrap > .g, .wrap > .grid > *, #quote > div:not(.grid)';
  var els = [].slice.call(document.querySelectorAll(SEL)).filter(function (e) { return !e.closest('.nav'); });
  var counts = new Map();

  els.forEach(function (e) {
    var i = counts.get(e.parentNode) || 0;
    counts.set(e.parentNode, i + 1);
    e.style.setProperty('--d', Math.min(i, 6) * 0.09 + 's');
    e.classList.add('reveal');
  });
  var hero = document.querySelectorAll('.hero > div');
  if (hero[0]) hero[0].classList.add('from-left');
  if (hero[1]) hero[1].classList.add('from-right');

  function reveal(e) {
    e.classList.add('in');
    setTimeout(function () {
      e.classList.remove('reveal', 'in', 'from-left', 'from-right');
      e.style.removeProperty('--d');
    }, 1800);
  }
  if ('IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (x) {
        if (x.isIntersecting) { reveal(x.target); io.unobserve(x.target); }
      });
    }, { threshold: 0.12, rootMargin: '0px 0px -6% 0px' });
    els.forEach(function (e) { io.observe(e); });
  } else {
    els.forEach(reveal);
  }

  /* ---------- Random crossfading hero slideshow ---------- */
  var box = document.getElementById('show');
  if (!box) return;
  var pool = box.getAttribute('data-slides').split(',').map(function (s) {
    var p = s.split('|'); return { f: p[0], t: p[1] };
  });
  var cache = {}, bad = {}, cur = null;
  box.innerHTML = '';
  var cap = document.createElement('div');
  cap.className = 'cap';
  box.appendChild(cap);

  function pick() {
    var c = pool.filter(function (p) { return !bad[p.f] && (!cur || p.f !== cur.f); });
    return c.length ? c[Math.floor(Math.random() * c.length)] : null;
  }
  function show(p, im) {
    var old = cur && cache[cur.f];
    if (old) {
      old.classList.remove('on');
      old.classList.add('prev');
      setTimeout(function () { old.classList.remove('prev'); }, 1600);
    }
    im.classList.add('on');
    cap.classList.remove('on');
    setTimeout(function () { cap.textContent = p.t; cap.classList.add('on'); }, 500);
    cur = p;
    setTimeout(next, 5000);
  }
  function next() {
    var p = pick();
    if (!p) return;
    var im = cache[p.f];
    if (im) { show(p, im); return; }
    im = new Image();
    im.alt = p.t;
    cache[p.f] = im;
    im.onload = function () { show(p, im); };
    im.onerror = function () { bad[p.f] = 1; if (im.parentNode) im.parentNode.removeChild(im); next(); };
    box.insertBefore(im, cap);
    im.src = 'assets/' + p.f;
  }
  next();
})();