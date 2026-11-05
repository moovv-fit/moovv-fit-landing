// =============================================
// App store & Web links
// Loaded on every page, before main.js, so the nav link's href is already a
// destination URL by the time main.js binds smooth-scroll to a[href^="#"].
// =============================================
(function () {
  const APP_STORE_URL = 'https://apps.apple.com/in/app/moovvfit/id6793878794';
  const GOOGLE_PLAY_URL = 'https://play.google.com/store/apps/details?id=fit.moovv.app';
  const PWA_URL = 'https://app.moovv.fit';

  // Toggle flag: true while new bundle ID is under Apple App Store review
  const APPLE_REVIEW_PENDING = true;

  const ua = navigator.userAgent;
  // iPadOS reports itself as a Mac; touch support tells them apart.
  const isIOS = /iPhone|iPad|iPod/.test(ua) || (/Macintosh/.test(ua) && navigator.maxTouchPoints > 1);
  const isAndroid = /Android/.test(ua);

  // When Apple review is pending, iOS users open the Web App directly in Safari
  const iosTargetUrl = APPLE_REVIEW_PENDING ? PWA_URL : APP_STORE_URL;

  // On phones, "download the app" goes straight to the store or web app
  if (isIOS || isAndroid) {
    document.querySelectorAll('[data-download-link]').forEach(link => {
      link.href = isIOS ? iosTargetUrl : GOOGLE_PLAY_URL;
      link.dataset.store = isIOS ? (APPLE_REVIEW_PENDING ? 'web_safari' : 'app_store') : 'google_play';
      if (isIOS && APPLE_REVIEW_PENDING) {
        link.setAttribute('target', '_blank');
        link.setAttribute('rel', 'noopener noreferrer');
      }
    });
  }

  // Route App Store badge to web app while review is pending
  if (APPLE_REVIEW_PENDING) {
    document.querySelectorAll('[data-store="app_store"]').forEach(link => {
      link.href = PWA_URL;
      link.setAttribute('target', '_blank');
      link.setAttribute('rel', 'noopener noreferrer');
    });
  }

  document.addEventListener('click', e => {
    const link = e.target.closest('[data-store]');
    if (link && window.posthog) {
      posthog.capture('store_click', {
        store: link.dataset.store,
        placement: link.dataset.placement
      });
    }
  });
})();
