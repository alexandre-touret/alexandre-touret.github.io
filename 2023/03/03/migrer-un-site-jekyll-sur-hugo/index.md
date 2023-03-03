# Migrer un site Jekyll sur Hugo


Il y a deux ans déjà, j'ai migré [mon site Wordpress sur un site statique hébergé sur Github Pages](https://blog.touret.info/2021/12/06/migrer-un-blog-wordpress-vers-github-io/).
Ce dernier était basé sur [Ruby](https://www.ruby-lang.org/en/documentation/), [Jekyll](https://www.ruby-lang.org/en/documentation/) et [Minimal mistakes](https://mmistakes.github.io/minimal-mistakes/).

Bien que le projet Minimal Mistakes ne donnait plus trop de signes de vie, le rendu convenait. 

Cependant, j'étais bloqué sur différents points:
* La gestion d'articles en anglais et français
* Le thème dark (inutile donc indispensable)
* Quelques fonctionnalités manquantes: par ex. [MermaidJS](http://mermaid.js.org/)

J'ai donc décidé de le migrer sur [Hugo](https://gohugo.io/).
Ce générateur de site est basé sur [Go](https://go.dev) et est très rapide d'exécution.


## Démarrage

Je n'ai pas migré le site comme [indiquait la documentation](https://gohugo.io/commands/hugo_import_jekyll/).

J'ai préféré créer un nouveau site et copier coller le contenu existant, à savoir les images et les articles.

Je vous conseille de lire [la documentation](https://gohugo.io/getting-started/quick-start/) qui est bien faite.

Ensuite, j'ai choisi le [thème LoveIt](https://themes.gohugo.io/themes/loveit/).
Pour l'installer, il suffit de cloner le repo dans le répertoire ``themes``.

```bashs
git submodule add https://github.com/dillonzq/LoveIt.git themes/LoveIt
```

## Reprise de données

J'ai copié les éléments suivants:

* Les fichiers statiques que j'avais à disposition ([``CNAME``](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site), ``robots.txt``) dans le répertoire ``static``
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

J'ai donc passé chaque article manuellement. C'était réellement fastidieux. Pour être totalement franc, je n'ai paas cherché à automatiser ça. Je pense qu'un script shell, python aurait pu faire l'affaire.
Heureusement, je n'en avais pas une centaine...

J'ai ajouté quand je pouvais l'en-tête suivant (adaptez le chemin vers l'image ;-) ):

```yaml
featuredImage: /assets/images/2022/12/review.webp
images: ["/assets/images/2022/12/review.webp"]
```

Le premier attribut permet d'avoir une image d'en-tête pour l'article. 
Le second permet d'avoir l'image lors d'un partage sur un réseau social (ex. Twitter)

j'ai ajouté le code suivant pour centrer les images:

```markdown
{{</* style "text-align:center" */>}}
![dataflow](/assets/images/2022/08/maksym-tymchyk-vHO-yT1BDWk-unsplash.webp)
{{</* style */>}}
```

## Configuration

Pour garder les mêmes URLs, j'ai choisi de modifier le pattern d' URL pour inclure la date. C'est un vieux reliquat de mon blog Wordpress.

```toml
 [languages.fr.permalinks]
        posts = '/:year/:month/:day/:filename/'
```

Pour le reste, j'ai copié collé [l'exemple fourni par le thème](https://github.com/dillonzq/LoveIt/blob/master/exampleSite/config.toml) et renseigné les champs en fonction de ce que je voulais.

J'ai ensuite adapté [le multi langue pour avoir la possibilité de faire des articles en anglais et en français](https://github.com/alexandre-touret/alexandre-touret.github.io/blob/main/config.toml#L643).


### Moteur de recherche

J'utilise [Lunr](https://lunrjs.com/). Voici la configuration:

```toml
    [languages.en.params.search]
        enable = true
        type = "lunr"
        contentLength = 4000
        placeholder = ""
        maxResultLength = 10
        snippetLength = 50
        highlightTag = "em"
        absoluteURL = false
```

Il faut également penser à activer la sortie au format JSON:

```toml
# Options to make hugo output files
[outputs]
  home = ["HTML", "RSS", "JSON"]
  page = ["HTML", "MarkDown"]
  section = ["HTML", "RSS"]
  taxonomy = ["HTML", "RSS"]
  taxonomyTerm = ["HTML"]
```

### Commentaires

A l'instar de mon blog avec Jekyll, j'utilise [Utteranc.es](https://utteranc.es/).
Voici la configuration:

```toml
 [params.page.comment.utterances]
        enable = true
        # owner/repo
        repo = "alexandre-touret/alexandre-touret.github.io"
        issueTerm = "pathname"
        label = ""
        lightTheme = "github-light"
        darkTheme = "github-dark"
```

## Conclusion

Vous aurez bien compris que ma motivation principale derrière cette migration était d' avoir un support multi langue un peu sympa. 
Vous avez dans cet article les principales actions que j'ai réalisé. 

N'hésitez pas à regarder [la configuration](https://github.com/alexandre-touret/alexandre-touret.github.io/blob/main/config.toml) et [les articles](https://github.com/alexandre-touret/alexandre-touret.github.io/tree/main/content/posts) pour plus de détails.
