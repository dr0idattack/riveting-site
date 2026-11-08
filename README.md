# Riveting website

Three static pages that satisfy App Store Connect requirements:

| Page | App Store Connect field | URL |
| --- | --- | --- |
| `index.html` | Marketing URL (optional) | https://dr0idattack.github.io/riveting-site/ |
| `support.html` | **Support URL** (required, per version) | https://dr0idattack.github.io/riveting-site/support.html |
| `privacy.html` | **Privacy Policy URL** (required, app level) | https://dr0idattack.github.io/riveting-site/privacy.html |

App Review checks the Support URL on a phone: contact email must be visible above the FAQ. Do not reorder `support.html`.

## Deploy

1. Push `main`; GitHub Pages publishes the repo root.
2. First time: repo Settings > Pages > Build and deployment > Source: **Deploy from a branch**, branch `main`, folder `/ (root)`.
3. Open the three URLs above and confirm they render.

## App Store Connect

App Information: Privacy Policy URL = `privacy.html` URL above; Marketing URL = site root (optional).
Version Information: Support URL = `support.html` URL above (per localization).

App Privacy label: **Data Not Collected** (app has no analytics, accounts or servers; StoreKit purchases are handled by Apple). Keep this label and `privacy.html` in sync whenever an SDK or connected feature changes.

## Gate

```sh
./verify.sh        # local content checks
./verify.sh --live # run after deploy
```
