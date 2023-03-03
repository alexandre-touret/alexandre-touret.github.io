# Passer votre application Java8 en Java11

Java 8 est encore largement utilisé dans les entreprises aujourd'hui. Il y a même certains frameworks qui n'ont pas encore sauté le pas.  
Je vais essayer d'exposer dans cette article les étapes à réaliser pour migrer (simplement) votre application JAVA8 en JAVA 11.

Dans cet article, je prendrai comme postulat que l'application se construit avec Maven.

## Pré-requis

Tout d'abord vérifiez votre environnement d'exécution cible! Faites un tour du coté de la documentation et regardez le support de JAVA.

Si vous utilisez des FRAMEWORKS qui utilisent des FAT JARS, faites de même (ex. pour spring boot, utilisez au moins la version 2.1.X).

Ensuite, vous aurez sans doute à mettre à jour maven ou gradle. Préférez les dernières versions.

## Configuration maven

Les trois plugins à mettre à jour obligatoirement sont :

  * [maven-compiler-plugin](https://maven.apache.org/plugins/maven-compiler-plugin/)
  * [maven-surefire-plugin](https://maven.apache.org/surefire/maven-surefire-plugin/)
  * [maven-failsafe-plugin](https://maven.apache.org/surefire/maven-failsafe-plugin/)

### Maven compiler plugin

```xml
<plugin>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.8.1</version>
        <configuration>
          <release>11</release>
          <encoding>UTF-8</encoding>
        </configuration>
      </plugin>
```


## maven surefire / failsafe plugin

Pour ces deux plugins, ajouter la configuration suivante:

```xml
<plugin>
        <artifactId>maven-surefire-plugin</artifactId>
        <version>2.22.2</version>
        <configuration>
        [...]
          <argLine>--illegal-access=permit</argLine>
          [...]
        </configuration>
      </plugin>
```


## Mise à jour des librairies

Bon,la il n'y a pas de magie. Vous devez mettre à jour toutes vos librairies. Mis à part si vous utilisez des librairies exotiques, la plupart supportent JAVA 11 maintenant.

C'est une bonne opportunité de faire le ménage dans vos fichiers `pom.xml` 🙂

## APIS supprimées du JDK

Si vous faites du XML, SOAP ou que vous utilisiez l'API activation, vous devez désormais embarquer ces librairies. Le JDK ne les inclut plus par défaut.

Par exemple:

```xml
<dependency>
            <groupId>com.sun.xml.bind</groupId>
            <artifactId>jaxb-core</artifactId>
            <version>2.3.0.1</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>com.sun.xml.bind</groupId>
            <artifactId>jaxb-impl</artifactId>
            <version>2.3.0.1</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>javax.xml.bind</groupId>
            <artifactId>jaxb-api</artifactId>
            <version>2.3.1</version>
        </dependency>

```


## Modularisation avec JIGSAW

Bon là &#8230; je vous déconseille de partir directement sur la modularisation, surtout si vous migrez une application existante. Bien que la modularité puisse aider à réduire vos images docker en construisant vos propres JRE et d'améliorer la sécurité, elle apporte son lot de complexité.  
Bref pour la majorité des applications, je vous déconseille de l'intégrer.

## Conclusion

Avec toutes ces manipulations, vous devriez pouvoir porter vos applications sur JAVA11. Il y aura sans doute quelques bugs. Personnellement, j'en ai eu avec CGLIB vs Spring AOP sur une classe instrumentée avec un constructeur privé. Sur ce coup j'ai contourné ce problème ( je vous laisse deviner comment 🙂 ).
