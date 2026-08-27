# Sofintel website

A dependency-light static site for GitHub Pages, styled after the Sofintel brand and the
MonyaCode page structure (sticky nav, hero, install tabs, features, packages, downloads,
news, footer).

Deployed by `.github/workflows/website.yml` to:

`https://sofintel.github.io/sofintel/`

To preview locally:

```sh
python3 -m http.server 8080 --directory website
```

Then open <http://localhost:8080>.
