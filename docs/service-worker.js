const CACHE = 'a6c27c20b1e3b0912b4e06d0b049c4083744670b380ae310fd2909d78917b5b2';
const RUNTIME = 'runtime';
const PRECACHE_URLS = ['/assets/nunito-v16-latin-ext_latin-700_6e483e301899a8ab59b328ae7f155c29.woff',
'/assets/nunito-v16-latin-ext_latin-700_7ba344b9011888663eea78e71fc1af79.woff2',
'/assets/open-sans-v18-latin-ext_latin-700_5717b08cf679657595d0383d291a04c3.woff2',
'/assets/open-sans-v18-latin-ext_latin-regular_b7b7c77b83e9d67f6756aa2716f35eba.woff',
'/assets/open-sans-v18-latin-ext_latin-regular_be21e759f9abd15b8cef68d92cedc081.woff2',
'/external-stylesheets.css',
'/icon-120x120.png',
'/icon-128x128.png',
'/icon-144x144.png',
'/icon-152x152.png',
'/icon-167x167.png',
'/icon-16x16.png',
'/icon-180x180.png',
'/icon-192x192.png',
'/icon-196x196.png',
'/icon-256x256.png',
'/icon-32x32.png',
'/icon-36x36.png',
'/icon-48x48.png',
'/icon-512x512.png',
'/icon-57x57.png',
'/icon-72x72.png',
'/icon-76x76.png',
'/icon-96x96.png',
'/index.html',
'/index.js',
'/manifest.webmanifest'];

// On install precache all static resources
self.addEventListener('install', event => {
  event.waitUntil(
    caches
      .open(CACHE)
      .then(cache =>  {
        const promises =
          PRECACHE_URLS.map((url) =>
            cache
              .add(url)
              .catch(error => console.log(`Could not cache: ${url} - ${error}!`))
          )

        return Promise.all(promises)
      })
      .then(self.skipWaiting())
  );
});

// On activate remove all unused caches
self.addEventListener('activate', function(event) {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return cacheNames.filter(cacheName => cacheName !== CACHE);
    }).then(cachesToDelete => {
      return Promise.all(cachesToDelete.map(cacheToDelete => {
        return caches.delete(cacheToDelete);
      }));
    }).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  const url = event.request.url
  const origin = self.location.origin
  const isSameOrigin = url.startsWith(origin)
  let response = null

  // If we are on the same origin
  if (isSameOrigin) {
    // resolve the path
    const path = url.slice(origin.length)

    // Try to get the response from the cache if not available fall back to
    // the "index.html" file.
    response =
      caches
        .match(event.request)
        .then(cachedResponse => cachedResponse || caches.match("/index.html"))
  } else {
    response = fetch(event.request)
  }

  event.respondWith(response)
});