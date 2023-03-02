---
title: Migrer un site Jekyll en Hugo
date: 2023-03-10 08:00:00

images:
    - /assets/images/2023/03/artiom-vallat-wKqm1UQMRqA-unsplash.webp
featuredImagePreview: /assets/images/2023/03/artiom-vallat-wKqm1UQMRqA-unsplash.webp
featuredImage: /assets/images/2023/03/artiom-vallat-wKqm1UQMRqA-unsplash.webp

tags:
- jekyll
- hugo

---

Il y a deux ans déjà, j'ai migré mon site Wordpress sur un site statique hébergé sur Github Pages.
Ce dernier était basé sur Ruby, Jekyll et Minimal mistakes.

Bien que le projet Minimal Mistakes ne donnait plus trop de signes de vie, le rendu convenait. 
Cependant, j'étais bloqué sur différents points:
La gestion d'articles en anglais et français
Le thème dark (inutile donc indispensable)
Quelques fonctionnalités manquantes: par ex. MermaidJS

J'ai donc décidé de le migrer sur Hugo.
Ce générateur de site est basé sur Go et est très rapide d'exécution.


## Démarrage

Je n'ai pas migré le site comme [indiquait la documentation](https://gohugo.io/commands/hugo_import_jekyll/).

J'ai préféré créer un nouveau site et copier coller le contenu existant, à savoir les images et les articles.

Je vous conseille de lire [la documentation](https://gohugo.io/getting-started/quick-start/) qui est bien faite.

Ensuite, j'ai choisi le [thème LoveIt](https://themes.gohugo.io/themes/loveit/).

Pour l'installer, il suffit de cloner le repo dans le répertoire ``themes``.

```bash
git submodule add https://github.com/dillonzq/LoveIt.git themes/LoveIt
```

## Reprise de données

J'ai copié les éléments suivants:

* Les fichiers statiques que j'avais à disposition (``CNAME``, ``robots.txt``) dans le répertoire ``static``
* Les images dansle répertoire ``static/assets/images``
* Les posts et pages statiques

## Travail sur les posts et images

### Les posts
J'ai ensuite modifié les noms des fichiers en enlevant les dates qui les préfixaient.

Ensuite, j'ai modifié les en-têtes de chaque post. 
J'ai pu le faire en automatisant avec VS CODE.

Voici le pattern que j'ai modifié:

```yml
header:
  teaser: /assets/images/2018/02/2000px-cygwin_logo-svg.png
```

en 

```yml
featuredImagePreview: /assets/images/2022/12/review.webp
```

Ca c'était le plus facile...

### Les images

Dans chaque post, j'ai revu les images et leur positionnement.

J'ai donc passé chaque article manuellement. 
Heureusement, je n'en avais pas une centaine...

J'ai ajouté quand je pouvais l'en-tête suivant:

```yml
featuredImage: /assets/images/2022/12/review.webp
```

et j'ai ajouté le code suivant pour centrer les images:

```markdown
{{< style "text-align:center" >}}
![dataflow](/assets/images/2022/08/maksym-tymchyk-vHO-yT1BDWk-unsplash.webp)
{{</ style >}}
```

## Configuration spécifique



