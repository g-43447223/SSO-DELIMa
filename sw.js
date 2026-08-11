const CACHE_NAME = 'skpi-sso-v1';
const ASSETS = [
  './',
  './index.html',
  './manifest.json',
  './LOGO-SEKOLAH.png',
  './304.png',
  'https://cdn.tailwindcss.com',
  'https://unpkg.com/lucide@latest'
];

// Install Service Worker
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(ASSETS);
    })
  );
  self.skipWaiting();
});

// Activate & Hapus Cache Lama
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

// Handling Fetch Requests
self.addEventListener('fetch', (event) => {
  // Pastikan data API daripada Google Sheets sentiasa fresh (Network Only)
  if (event.request.url.includes('script.google.com')) {
    event.respondWith(fetch(event.request));
    return;
  }

  // Aset statik guna Stale-While-Revalidate
  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      const fetchPromise = fetch(event.request).then((networkResponse) => {
        caches.open(CACHE_NAME).then((cache) => {
          cache.put(event.request, networkResponse.clone());
        });
        return networkResponse;
      }).catch(() => cachedResponse);
      return cachedResponse || fetchPromise;
    })
  );
});
