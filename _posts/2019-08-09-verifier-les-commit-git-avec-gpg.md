---
id: 188
title: Vérifier les commit GIT avec GPG
date: 2019-08-09T16:13:21+02:00
author: admin
layout: post


timeline_notification:
  - "1565363602"
publicize_twitter_user:
  - touret_alex
  - logiciels libres
tags:
  - git
  - github
  - gitlab
  - gpg
  - Planet-Libre
---
Juste pour un pense bête, voici comment paramétrer [GIT](https://git-scm.com/) et [GITHUB](https://github.com/)/[GITLAB](https://about.gitlab.com/) pour signer les commits avec [GPG](https://gnupg.org).

<img loading="lazy" class="aligncenter wp-image-196 size-large" src="/assets/img/posts/2019/08/kelly-sikkema-c3rk5toz0qa-unsplash.jpg?w=612" alt="" width="612" height="408" /> 

## Configuration GPG

Exécutez la commande suivante :

<pre class="prettyprint prettyprinted"><span class="s1"><span class="pln">gpg --full-generate-key

Sélectionnez une clé RSA (question 1) de 4096 bits (question 2).</span></span>
```


<p class="prettyprint prettyprinted">
  <span class="s1"><span class="pln">Une fois cette commande effectuée, vous pouvez récupérer votre clé GPG avec cette commande:</span></span>
</p>

<p class="prettyprint prettyprinted">
  <span class="s1"><span class="pln">gpg &#8211;list-secret-keys &#8211;keyid-format LONG<br /> </span></span>
</p>

<pre>gpg --list-secret-keys --keyid-format LONG alexandre@....
/home/alexandre/.gnupg/pubring.kbx
----------------------------------
sec rsa4096/XXXXXXXXXX 2019-08-09 [SC]
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
uid [ ultime ] Alexandre Touret &lt;mon.mail.github.ou.gitlab@monprovider.fr&gt;
ssb rsa4096/XXXXXXXXXX 2019-08-09 [E]
```


<p class="prettyprint prettyprinted">
  <span class="s1"><span class="pln">Ensuite, il faut exécuter cette commande </span></span>
</p>

<pre>gpg --armor --export XXXXXXXXXX
```


## Configuration GIT

Indiquez la clé GPG à GIT

<pre>git config --local user.signingkey 6F9D7D5FCE959337
```


Et indiquez que vous voulez signer tous vos commits

<pre><span class="s1"><span class="pln">git </span></span><span class="s1"><span class="pln">config </span><span class="pun">--</span><span class="kwd">local </span><span class="pln">commit</span><span class="pun">.</span><span class="pln">gpgsign </span><span class="kwd">true</span></span>
```


Si vous ne faites pas cette dernière commande, vous devrez ajouter l&rsquo;option -S à chaque exécution de la commande git commit.

Exemple:

<pre>git -a -S -m "Ajout javadoc"
```


## Configuration GITHUB

Sur Github ( il y a la même chose sur gitlab), vous pouvez [dans vos paramètres](https://github.com/settings/keys) ajouter cette clé . De cette manière, vos prochains commits envoyés seront vérifiés.

<p class="prettyprint prettyprinted">
  <span class="s1"><span class="pln"> En espérant que ça serve à d&rsquo;autres 🙂<br /> </span></span>
</p>