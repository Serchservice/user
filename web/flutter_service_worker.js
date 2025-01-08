'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"favicon-16x16.png": "84c1bfa2a0e6892ddebded5515260898",
"flutter_bootstrap.js": "f51413ea484d665d5f5c5b2deedad246",
"version.json": "ae0619413e6d8cbc407fcc64ac76ff1d",
"splash/img/light-2x.png": "7ccdea2edce5dfaf188c7bb0c3da6343",
"splash/img/branding-4x.png": "c23d48a339d6a347c33218086da93326",
"splash/img/dark-4x.png": "6aba2a8b13dec66e1ecb1ef086cb12ff",
"splash/img/branding-dark-1x.png": "c76c889990f419bba214c105a1c682e1",
"splash/img/light-3x.png": "263e9d45b1bee932774efdd82b82e822",
"splash/img/dark-3x.png": "263e9d45b1bee932774efdd82b82e822",
"splash/img/light-4x.png": "6aba2a8b13dec66e1ecb1ef086cb12ff",
"splash/img/branding-2x.png": "ab8a9eb24ec8b37bf4fd00b7e9f4cd9f",
"splash/img/branding-3x.png": "f45785e101c494fc0d0cc014eb236d00",
"splash/img/dark-2x.png": "7ccdea2edce5dfaf188c7bb0c3da6343",
"splash/img/dark-1x.png": "95046463b14d3471393d0181f2b525bf",
"splash/img/branding-dark-4x.png": "c23d48a339d6a347c33218086da93326",
"splash/img/branding-1x.png": "c76c889990f419bba214c105a1c682e1",
"splash/img/branding-dark-2x.png": "ab8a9eb24ec8b37bf4fd00b7e9f4cd9f",
"splash/img/light-1x.png": "95046463b14d3471393d0181f2b525bf",
"splash/img/branding-dark-3x.png": "f45785e101c494fc0d0cc014eb236d00",
"favicon.ico": "f5eadce68ebe1f3b00a9c20bd1c9dcba",
"index.html": "259e35b83b03715bcdf8dbe9c08f3aa5",
"/": "259e35b83b03715bcdf8dbe9c08f3aa5",
"android-chrome-192x192.png": "6e7d364616f6702f2e69ae94c3043a15",
"apple-touch-icon.png": "8e54bda1e0ffc2d1d80947d245fc39ba",
"main.dart.js": "f8829a8abdd58f59a08df3e52e9f84f5",
".well-known/apple-app-site-association.json": "2735534adcf8306bf989067edc5a0d34",
".well-known/assetlinks.json": "34f753267296934dd776017da85bfa78",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"android-chrome-512x512.png": "986f902eac67663006579530525d5cad",
"site.webmanifest": "053100cb84a50d2ae7f5492f7dd7f25e",
"icons/Icon-192.png": "d690b966a3370a9d7f06d48087aee4e0",
"icons/Icon-maskable-192.png": "d690b966a3370a9d7f06d48087aee4e0",
"icons/Icon-maskable-512.png": "2f7dc1e52d4a2c22ed0ac470b265ad39",
"icons/Icon-512.png": "2f7dc1e52d4a2c22ed0ac470b265ad39",
"manifest.json": "3590b8c0011001d045fa644b6908fc12",
"robots.txt": "4386bbd46eee29200b43580c40468051",
"assets/asset/anim/wallet.png": "381ed1cffb2410910376bef3c0925d5f",
"assets/asset/anim/review.png": "6cfc22ea0d3bf5d67224c312d310b232",
"assets/asset/anim/verified.png": "ffb8bf972443da7a132601aa05ab1ec9",
"assets/asset/anim/notes.png": "5eb9b3eae77b1821956546d808ced18d",
"assets/asset/anim/darkWallpaper.png": "091f3f980db7e416b3591c1a6e756cbb",
"assets/asset/anim/lightWallpaper.png": "438b52de3200edd30bd83aefe34e982b",
"assets/asset/anim/messages.png": "d45b92b88f2886e7818598cfa18ad6c1",
"assets/asset/anim/serch_chat.png": "42a45cd846466007de246ae35665558d",
"assets/asset/app/user.png": "198f4d4fcc319e7ab94a7d1df8b6f2f1",
"assets/asset/app/business.png": "ce352d15f6a433d55c24d9e9b685ba05",
"assets/asset/app/provider.png": "e8955eb4aaf3fb60970e4857e628cafb",
"assets/asset/app/nearby.png": "96fe50484dc43fba4ddf475debeb9a6e",
"assets/asset/social/instagram.png": "ae78a71349b68cdec8178362dcced4b4",
"assets/asset/social/twitter.png": "6582c5b6c68c15e9619746582fb4129a",
"assets/asset/social/whatsapp.png": "93eceab7764f20c2b7d220d9d7c0af19",
"assets/asset/social/facebook.png": "de3dc7aec21d0c84d048526feb5328bc",
"assets/asset/social/message.png": "a42c93ad906166ff29c4d699d33c1bc4",
"assets/asset/social/snapchat.png": "3965ca1f5dbd773fa88f79fd610e7c7b",
"assets/asset/common/sharedLink.png": "7d55df8877c998d9e9eb79ad31e2b5e5",
"assets/asset/common/speak-to.png": "bd5e3c759dcddd063eacccee7850e3f4",
"assets/asset/common/speak.png": "356ad0246b4811953dca4bd1f894f6d5",
"assets/asset/common/drive-to.png": "7fd268826d846a151d67b3b3eff7b7c6",
"assets/asset/common/referralProgram.png": "3129c2831cc540855ad57e2fe7de6631",
"assets/asset/common/account.png": "785960c96043c736b940d5566f502dea",
"assets/asset/common/skill.png": "88292680a39d28dbb95b1cd2b47d1533",
"assets/asset/common/countries.json": "ea22339de84df8424693fded785bfd3b",
"assets/asset/common/connect.png": "d90dbb6abf96a7723db4e97efe64a764",
"assets/asset/common/request.png": "cb161e1e24242b63d0d9ebbfd6d9a573",
"assets/asset/common/google_map_style.json": "0bc926b57222d37e93dbd2d63372f404",
"assets/asset/common/bookmark.png": "bde0e1492dedc8cb7a48e16f3c408ada",
"assets/asset/common/logo.png": "8b484938e6eb526f3f729d353b5d6c86",
"assets/asset/common/onboard2.png": "5e32dbb17bd2203f64701b780f019fd3",
"assets/asset/common/drive.png": "33a1e114b6d31190c1fe1e0ad00af01d",
"assets/asset/common/share.png": "c8109b9bb939c80ac8253f97e1d2f7e4",
"assets/asset/common/notLaunched.png": "785397012a43b10b3caaf5b07747835d",
"assets/asset/common/onboard1.png": "54c47c44229b94514aba5f921681f11d",
"assets/asset/common/personal.png": "5f72d30026f2705f61cb8809867e83da",
"assets/asset/common/gender.png": "b18b5fc52368a3d1881682d674bc379c",
"assets/asset/common/account_trust.png": "eb1f098acbc12669d48527a45887e249",
"assets/asset/audio/incoming.m4a": "61270caeec66706dddb999566fcde064",
"assets/asset/audio/connect.m4a": "c48cc14514807334ad7cb4b981f764cd",
"assets/asset/audio/outgoing.m4a": "c59f73609148899fea5af2d76000ce11",
"assets/asset/audio/notify.m4a": "b476d703d5ec6574036927533f75794f",
"assets/asset/audio/schedule.m4a": "ce339c08e900319e5eac448bcf8cdf68",
"assets/asset/audio/message.m4a": "e6179057303b444799a0232781f9e4cb",
"assets/asset/map/world.png": "cc972b14e76da37a89aa682ec523579c",
"assets/asset/map/fly.png": "087023dc77d6cf6b1ac2abfe5c25152f",
"assets/asset/map/openstreetmap.png": "ed886fab8c104191559683c7753f1292",
"assets/asset/map/destination.png": "83e4dea4f5febacc0404cf85a93ac9c3",
"assets/asset/map/google-maps.png": "30f0baf2a9e5ee0251fe7d7026e74ceb",
"assets/asset/map/up-right.png": "442fbd8120ae812a2a15f9d0dcac7afa",
"assets/asset/map/map-right.png": "55f53a18e6f097a64cf9fff2329e37c5",
"assets/asset/map/drive.png": "8d0088dcfdb6f048bf4c143732147d0b",
"assets/asset/map/location.png": "3bb67badf1820534c9763b8c7fc129d0",
"assets/asset/map/current.png": "34970dac4afe79f9695695f499704c3f",
"assets/asset/map/bing.png": "ea9bdeeae4e415fe5f3e28f4186991cf",
"assets/asset/logo/logo-splash-screen-android-12.png": "8a80f8e403398d998648609ac9a23b1a",
"assets/asset/logo/logo-splash-screen.png": "5f213fad559bfb71a1ff6e6a1eb88c81",
"assets/asset/logo/smeBlack.png": "7c654cd938ee785a028efc0d4a067ea1",
"assets/asset/logo/tagWhite.png": "69204574b78370ea4e83cd4b68e2d0c1",
"assets/asset/logo/splashBlack.png": "06c85c2bfe313c51eed9bd08897fe7bb",
"assets/asset/logo/favicon_dark.png": "e862dde983a604b15f8190d2ac1604b5",
"assets/asset/logo/favicon_light.png": "6c29b7c677a4b9841ed0616c69df2791",
"assets/asset/logo/branding-splash-screen.png": "9fe230769b972994e5639a1827c78d4e",
"assets/asset/logo/logo.png": "8b484938e6eb526f3f729d353b5d6c86",
"assets/asset/logo/logo_icon.png": "42575525044142e6ba8ba7ee296d9411",
"assets/asset/logo/branding-splash-screen-android-12.png": "9aa177944482321c125388cfed935c25",
"assets/asset/logo/tagBlack.png": "83fdc95c893ec0e379ea7dba9c0d126d",
"assets/asset/logo/splashWhite.png": "963fe7cc50b2739f6839b890fb9042f0",
"assets/asset/theme/window_dark.png": "c4d0bd15571a42340352bb4cb8cd0308",
"assets/asset/theme/window_light.png": "9013d43b9f141c3bf3b6e3a4ecac5a88",
"assets/asset/conversation/diy.png": "e7f75c7baea7cecd772c8fbb23c2b2e4",
"assets/asset/conversation/video-call.png": "98f0f33cecf8d96ecdfb3ab41307b19d",
"assets/asset/conversation/video-chat.png": "b537124030a61dbe3eb8af3ec73443e9",
"assets/asset/conversation/voice.png": "1c902a38674894188ee735a9474f91c8",
"assets/asset/conversation/phone-voice.png": "825e931b4d9ca57c7861172424299941",
"assets/AssetManifest.json": "01249d691762a158b887822f84591864",
"assets/NOTICES": "38c33c1aad9b4efb70a242224ae996bf",
"assets/FontManifest.json": "31931c471eab20183511d15ab769744f",
"assets/AssetManifest.bin.json": "02455c1f347f685b46b6a03f88bbd84a",
"assets/packages/photo_gallery/images/grey.bmp": "3c1df92d469b25a207c3d1af665aafd8",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c97cc6ed1c3a68c288ebad4461bc25d",
"assets/packages/map_launcher/assets/icons/mappls.svg": "1a75722e15a1700115955325fe34502b",
"assets/packages/map_launcher/assets/icons/citymapper.svg": "58c49ff6df286e325c21a28ebf783ebe",
"assets/packages/map_launcher/assets/icons/sygicTruck.svg": "242728853b652fa765de8fba7ecd250f",
"assets/packages/map_launcher/assets/icons/naver.svg": "ef3ef5881d4a2beb187dfc87e23b6133",
"assets/packages/map_launcher/assets/icons/tencent.svg": "4e1babec6bbab0159bdc204932193a89",
"assets/packages/map_launcher/assets/icons/copilot.svg": "b412a5f02e8cef01cdb684b03834cc03",
"assets/packages/map_launcher/assets/icons/truckmeister.svg": "416d2d7d2be53cd772bc59b910082a5b",
"assets/packages/map_launcher/assets/icons/yandexNavi.svg": "bad6bf6aebd1e0d711f3c7ed9497e9a3",
"assets/packages/map_launcher/assets/icons/yandexMaps.svg": "3dfd1d365352408e86c9c57fef238eed",
"assets/packages/map_launcher/assets/icons/tmap.svg": "50c98b143eb16f802a756294ed04b200",
"assets/packages/map_launcher/assets/icons/petal.svg": "76c9cfa1bfefb298416cfef6a13a70c5",
"assets/packages/map_launcher/assets/icons/doubleGis.svg": "ab8f52395c01fcd87ed3e2ed9660966e",
"assets/packages/map_launcher/assets/icons/here.svg": "aea2492cde15953de7bb2ab1487fd4c7",
"assets/packages/map_launcher/assets/icons/tomtomgofleet.svg": "5b12dcb09ec0a67934e6586da67a0149",
"assets/packages/map_launcher/assets/icons/mapswithme.svg": "87df7956e58cae949e88a0c744ca49e8",
"assets/packages/map_launcher/assets/icons/osmandplus.svg": "31c36b1f20dc45a88c283e928583736f",
"assets/packages/map_launcher/assets/icons/google.svg": "cb318c1fc31719ceda4073d8ca38fc1e",
"assets/packages/map_launcher/assets/icons/googleGo.svg": "cb318c1fc31719ceda4073d8ca38fc1e",
"assets/packages/map_launcher/assets/icons/mapyCz.svg": "f5a198b01f222b1201e826495661008c",
"assets/packages/map_launcher/assets/icons/kakao.svg": "1c7c75914d64033825ffc0ff2bdbbb58",
"assets/packages/map_launcher/assets/icons/osmand.svg": "639b2304776a6794ec682a926dbcbc4c",
"assets/packages/map_launcher/assets/icons/tomtomgo.svg": "493b0844a3218a19b1c80c92c060bba7",
"assets/packages/map_launcher/assets/icons/flitsmeister.svg": "44ba265e6077dd5bf98668dc2b8baec1",
"assets/packages/map_launcher/assets/icons/baidu.svg": "22335d62432f9d5aac833bcccfa5cfe8",
"assets/packages/map_launcher/assets/icons/apple.svg": "6fe49a5ae50a4c603897f6f54dec16a8",
"assets/packages/map_launcher/assets/icons/waze.svg": "311a17de2a40c8fa1dd9022d4e12982c",
"assets/packages/map_launcher/assets/icons/amap.svg": "00409535b144c70322cd4600de82657c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "e91470399405a5fb3c00057f7e9dd94c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "b797febcf78b50622db7ed7b416b8759",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "90e7c6a514ac845857b8adbbc948b08b",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "83c878235f9c448928034fe5bcba1c8a",
"assets/packages/stream_video_flutter/images/call_background.jpg": "036491bc8ddea81e3b0763d363a7ae6e",
"assets/packages/stream_video_flutter/fonts/StreamIcons.ttf": "ba91e91a4e3aef03b5bd34cce233ab66",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "6eb58709c5a5ec07c666ce132f565b54",
"assets/fonts/MaterialIcons-Regular.otf": "aa2a095b937b6917f3e16d5d9bcd0c34",
"favicon-32x32.png": "00b01aee3de01742e2f365e3854cca8f",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
