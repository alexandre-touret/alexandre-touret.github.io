# Music Scores As Code



Derrière ce nom pompeux qui peut effrayer, je vais essayer d'expliquer dans cet article comment on peut versionner facilement ses partitions et les publier sur le web.

En cherchant comment mettre de la documentation technique avec des diagrammes [PlantUml](https://plantuml.com/) dans des repos [GITLAB](https://about.gitlab.com/) et générés avec des pipelines, je me suis mis dans la tête de faire la même chose avec des partitions 🙂  
  
Depuis plusieurs années, j'utilise [lilypond](https://lilypond.org/) pour créer mes partitions. C'est un peu difficile de s'y mettre, mais une fois la syntaxe assimilée, la saisie d'une partition est beaucoup plus efficace. Le rendu des partitions est vraiment optimisé.  
Si vous voulez plus de détails sur le pourquoi du comment je vous conseille [cette page](https://lilypond.org/doc/v2.19/Documentation/essay-big-page).

Vous trouverez des exemples sur [le site](https://lilypond.org/text-input.fr.html).  
  
J'ai donc eu l'idée de:

  * Stocker ces partitions sur un repo github (_jusque là rien d'exceptionnel_)
  * Générer automatiquement les partitions au format PDF, PNG et MIDI via une [github action](https://github.com/features/actions) (_ça commence à devenir intéressant&#8230;_)
  * Les publier avec [les github pages](https://pages.github.com/) (_tant qu'à faire 🙂_)

## Stockage

Pourquoi stocker dans un référentiel de sources tel que Github ? Pour les non informaticiens : les partitions sont stockées au format texte. 

```latex
\version "2.12.1"

\header {
  title="Try a little tenderness"
  composer="Harry Woods, Jimmy Campbell & Reg Connely"
  subtitle = "Commitments Version"
  %poet = "Poete"
  instrument = "Piano"
  editor = "L'éditeur"
  %meter=\markup {\bold {"Remarque sur le rhythme"}}
  style = "Soul"
  maintainer = "Alexandre Touret"
  maintainerEmail = "alexandre.touret@free.fr"
  maintainerWeb = "http://blog.touret.info"     
  lastupdated = ""
  source = "Music room"
  footer = "Footer"
  copyright =\markup {\fontsize #-1.5
 "Delivered by A TOURET"}
}
upper=
\relative c'{
  \clef treble
  \time 4/4
  \tempo 4=176
  \key g \major
  
  d'2 (b4 e
  d2 b4 a 
  g2 g2 
  <e g,>2) <fis, c' d> 
  \bar "||"

```


[GIT](https://git-scm.com/) et [GITHUB](https://github.com) permettent de versionner facilement et pouvoir faire facilement un retour arrière en cas d'erreur.  
Aussi, GITHUB offre des [fonctionnalités « sociales » et collaboratives qui facilitent la revue des modifications](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) ( en cas de travail à plusieurs ).  
Bref, ça offre la sécurité d'une sauvegarde et la possibilité d'un retour arrière en cas d'erreur.  


## Générer les partitions avec une github action

Les [github actions](https://github.com/features/actions) sont des outils permettant:

<blockquote class="wp-block-quote">
  <p>
    GitHub Actions makes it easy to automate all your software workflows, now with world-class CI/CD. Build, test, and deploy your code right from GitHub. Make code reviews, branch management, and issue triaging work the way you want.
  </p>
</blockquote>

J'ai donc décidé de créer un workflow qui permet de générer les partitions au format lilypond.

J'ai mis à disposition [le code sur github](https://github.com/alexandre-touret/lilypond-github-action) sous [licence GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html). Elle est utilisable telle quelle.

Pour créer l'action, il faut créer un fichier action.yml à la racine du repo. Voici le contenu

```java
name: 'Lilypond Generator'
description: 'Run Lilypond tool with the given set of arguments to generate music sheets'
author: '@alexandre-touret'

inputs:
  args:
    description: 'Arguments for Lilyponid'
    required: true
    default: '-h'

runs:
    using: 'docker'
    image: 'Dockerfile'
    args:
      - ${{ inputs.args }}

branding:
  icon: 'underline'
  color: 'blue'
```


Vous aurez compris que ce fichier fait référence à une [image Docker](https://github.com/alexandre-touret/lilypond-github-action/blob/master/Dockerfile). Cette dernière n'est ni plus ni moins qu'une Debian avec lilypond d'installé.  
  
Pour l'utiliser dans un repo github, on peut créer une action qui l'utilise. Voici un exemple:

```java
jobs:
  build_sheets:
    runs-on: ubuntu-latest
    env:
        LILYPOND_FILES: "*.ly"
    steps:
      - name: Checkout Source 
        uses: actions/checkout@v1
      - name: Get changed files
        id: getfile
        run: |
          echo "::set-output name=files::$(find ${{github.workspace}} -name "${{ env.LILYPOND_FILES }}" -printf "%P\n" | xargs)"
      - name: LILYPOND files considered echo output
        run: |
          echo ${{ steps.getfile.outputs.files }}
      - name: Generate PDF music sheets
        uses: alexandre-touret/lilypond-github-action@master
        with:
            args: -V -f --pdf ${{ steps.getfile.outputs.files }}
```


A la dernière ligne on peut passer [les arguments nécessaires à lilypond](http://lilypond.org/doc/v2.18/Documentation/usage/command_002dline-usage).

## Publication

La c'est l'étape la plus facile :). Il suffit d'activer [les github pages](https://pages.github.com/) et de commiter et pusher les partitions générées

```java
- name: Push Local Changes
        run: |
          git config --local user.email "${{ secrets.GIT_USERNAME }}"
          git config --local user.name "${{ secrets.GIT_EMAIL }}"
          git add .
          git commit -m "Add changes" -a
      - name: Push changes
        uses: ad-m/github-push-action@master
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```


Il suffit de créer une page index.md à la racine et d'ajouter des liens vers les partitions générées ( dans mon cas, ça se passe dans le répertoire /docs ).  
Vous pouvez trouver un exemple [ici](https://alexandre-touret.github.io/piano-sheets-as-code/).

## Conclusion

Voila comment on peut générer un site avec des partitions crées avec Lilypond.  
Vous trouverez les différents liens ci-dessous. Peut être que je publierai cette action sur le marketplace une fois que j'aurai publié une documentation digne de ce nom :).  


  * [Action](https://github.com/alexandre-touret/lilypond-github-action)
  * [Exemple d'utilisation](https://github.com/alexandre-touret/piano-sheets-as-code)
  * [Exemple de site généré](https://alexandre-touret.github.io/piano-sheets-as-code/)
