const CACHE_NAME = 'skpi-sso-v3';
const ASSETS = [
  './',
  './index.html',
  './dashboard.html',
  './manifest.json',
  './LOGO-SEKOLAH.png',
  './SSO.png',
  './304.png',
  './icon-192.png',
  './icon-512.png'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(ASSETS);
    })
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) {
            return caches.delete(key);
          }
        })
      );
    })
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  const req = event.request;
  if (req.method !== 'GET') return;

  // Data API Google Sheets sentiasa fresh (Network Only)
  if (req.url.includes('script.google.com')) {
    event.respondWith(fetch(req));
    return;
  }

  // CDN: network-first dengan fallback cache
  if (req.url.includes('cdn.tailwindcss.com') || req.url.includes('unpkg.com') || req.url.includes('cdn.jsdelivr.net')) {
    event.respondWith(
      fetch(req).then((res) => {
        const copy = res.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(req, copy)).catch(() => {});
        return res;
      }).catch(() => caches.match(req))
    );
    return;
  }

  // Aset statik: Stale-While-Revalidate
  event.respondWith(
    caches.match(req).then((cached) => {
      const fetchPromise = fetch(req).then((networkResponse) => {
        if (networkResponse && networkResponse.status === 200) {
          caches.open(CACHE_NAME).then((cache) => {
            cache.put(req, networkResponse.clone());
          });
        }
        return networkResponse;
      }).catch(() => cached);
      return cached || fetchPromise;
    }).catch(() => caches.match('./index.html'))
  );
});
