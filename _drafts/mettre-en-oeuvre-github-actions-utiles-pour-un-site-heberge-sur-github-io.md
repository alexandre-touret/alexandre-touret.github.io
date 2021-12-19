---
title: Mettre en oeuvre Github Actions utiles pour un site hébergé sur Github pages
date: 2021-12-19 12:00:00


header:
  teaser: /assets/images/2021/12/github-1.jpg

tags:
  - github
  - jekyll
  - github-actions
  - planetlibre
---

![github](/assets/images/2021/12/github-1.jpg)

## Pourquoi mettre en oeuvre des GITHUB ACTIONS ?

Comme j'ai pu l'expliquer dans [mon précédent article](https://blog.touret.info/2021/12/06/migrer-un-blog-wordpress-vers-github-io/), je suis passé de [Wordpress](wordpress.com/) à [GITHUB Pages](https://pages.github.com/).

Une fois le site déployé une première fois, on voit qu'on a perdu pas mal d'automatisations qui sont réalisées par défaut dans Wordpress. Par exemple, vous devez construire votre site, publier des nouveaux articles et vérifier que tout est OK.

J'ai donc mis en oeuvre des GITHUB ACTIONS pour automatiser le plus d'actions possibles et me passer de tâches manuelles souvent rébarbatives.

Si vous souhaitez découvrir les GITHUB ACTIONS, je vous conseille [ce site](https://github.com/features/actions).

## Construction du site et déploiement

Dès qu'on touche à Jekyll et à l'hébergement sur Github Pages, on tombe sur certaines actions à réaliser telles que celle-ci:

```bash
bundle exec jekyll build 
``` 

J'ai donc réalisé les workflows suivants:

### Pour une feature branch (dans une Pull Request)
Je construis le site sans le déployer pour vérifier que la construction est correcte.

```yaml

name: Build Jekyll site

on:
  push:
    branches-ignore: (1)
      - main
      - gh-pages

jobs:
  jekyll:
    runs-on: ubuntu-latest # can change this to ubuntu-latest if you prefer
    steps:
      - name: 📂 setup (2)
        uses: actions/checkout@v2

        # include the lines below if you are using jekyll-last-modified-at
        # or if you would otherwise need to fetch the full commit history
        # however this may be very slow for large repositories!
        # with:
        # fetch-depth: '0'
      - name: 💎 setup ruby  (3)
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 2.6 # can change this to 2.7 or whatever version you prefer
          bundler-cache: true
      
      - name: 🔨 install dependencies & build site (4)
        run: bundle exec jekyll build
```

Voila ce que ce workflow réalise:

1. Il est exécuté à chaque push excepté sur les branches main et gh-pages. Ce sont les branches que j'utilise pour le déploiement du site après la validation d'une pull request.
2. Checkout du projet
3. Initialisation de Ruby et téléchargement des dépendances comme le ferait la commande ``bundle install``.
4. Construction du site

### Pour la branche main

Une fois que la pull request est validée, le code est poussé dans la branche main. On y exécute le code suivant:

```yaml
name: Build and deploy Jekyll site to GitHub Pages

on:
  push:
    branches:
      - main
jobs:
  jekyll:
    runs-on: ubuntu-latest # can change this to ubuntu-latest if you prefer
    steps:
      - name: 📂 setup
        uses: actions/checkout@v2
      - name: 💎 setup ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 2.6 # can change this to 2.7 or whatever version you prefer
          bundler-cache: true
      
      - name: 🔨 install dependencies & build site
        run: bundle exec jekyll build

      - name: 🚀 deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./_site
```

Ce dernier reprend le code du workflow suivant ( oui, j'aurai pu faire des workflows réutilisables... ) et ajoute l'étape de déploiement.
Le code généré sera copié dans la branche ``gh-pages``.


## Publication d'un article

Pour rédiger un article, j'utilise le mécanisme de feature branch et pull request. Pour automatiser la publication, le nommage des articles avec la date etc, j'ai mis en oeuvre le workflow suivant:


Je rédige les articles (comme celui-ci) et les positionne dans le répertoire ``_drafts``:

```bash
ls -R _drafts                                                                                               
quelques-github-actions-utiles-pour-un-site-jekyll-heberge-sur-github-io.md
```

J'associe un [milestone](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/about-milestones) à la [pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests). 

Dès que ces derniers sont terminés, le workflow décrit ci-dessous est exécuté. 
Il permet, via un script python de:
1. Identifier les articles dans le répertoire ``_drafts``
2. Vérifier que la date de publication spéficié dans l'en-tête est antérieure à la date courante (``now()``)
3. Copier le fichier dans le répertoire ``_posts`` en le renommant avec la date en préfixe.

```yaml
name: Publish Drafts
on: (1)
  milestone:
    types: [closed]
  workflow_dispatch:
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
      with:
        ref: main (2)
    - name: 📂 setup python
      uses: actions/setup-python@v2
      with:
        python-version: '3.7.7' # install the python version needed
    - name: 💎 install python packages (3)
      run: |
        python -m pip install --upgrade pip 
          
    - name: 🔨 execute py script  (4)
      run: python publish_drafts.py
          
    - name: 🔨 commit files (5)
      run: |
        if git ls-files -o  --exclude-standard; then
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add -A
          git commit -m "publish drafts" -a -S
          git push origin main
        else
          echo "No file to publish"
        fi
          
```

**Explication:**

1. Déclenchement manuel ou à la clôture d'un milestone
2. Récupération de la branche ``main``
3. Installation de packages python
4. Exécution du [script python réalisé pour l'occasion](https://github.com/alexandre-touret/alexandre-touret.github.io/blob/main/publish_drafts.py)
5. Commit et push

Une fois ce workflow réalisé, le workflow vu précédemment est automatiquement lancé et le site est généré une nouvelle fois. Bon ça fait deux constructions, mais au vu du temps pris, c'est négligeable.

## Uptime

J'aurai pu utiliser un tiers service tel que [uptime robot](https://uptimerobot.com/). 
Pour mon besoin, j'ai préféré opter pour un appel régulier du site et une vérification du code HTTP (``200``).

```yaml
# This is a basic workflow to help you get started with Actions

name: Uptime Monitoring

on:
  schedule: (1)
    - cron: '*/60 * * * *'

jobs:
  ping_site:
    runs-on: ubuntu-latest
    name: Ping the site
    steps:
    - name: Check the site
      id: hello
      uses: srt32/uptime@master
      with:
        url-to-hit: "https://blog.touret.info/robots.txt" (2)
        expected-statuses: "200,301"
```


**Explications**

1. Déclenchement toutes les heures de ce workflow
2. J'ai utilisé une GITHUB ACTION existante qui ping une URL et vérifie le code retour. Dans mon cas, j'ai utilisé l'URL du fichier [robots.txt](https://developers.google.com/search/docs/advanced/robots/intro?hl=fr) et je vérifie le code retour.


## Conclusion
J'ai réussi à plus ou moins automatiser tout le cycle de construction d'articles. 
C'est encore perfectible et loin de certaines fonctionnalités de Wordpress, mais je n'en ai pas réellement besoin.

Si vous souhaitez réutiliser ces workflows et les intégrer dans sites, vous pouvez les récupérer [sur ce repo GITHUB](https://github.com/alexandre-touret/alexandre-touret.github.io).

