# Programmmation par aspect avec Spring AOP

Une fois n'est pas coutume, voici un article qui reprend des basiques de la programmation. J'aborde une stack JAVA, mais c'est applicable à d'autres langages.

Il existe une fonctionnalité très intéressante dans Spring (et dans J(akarta)EE) que l'on oublie assez souvent : l'[AOP](https://fr.wikipedia.org/wiki/Programmation_orient%C3%A9e_aspect) ou encore la programmation par aspect. Cette manière de programmer permet notamment de séparer le code fonctionnel et technique.  
Si vous faites du JAVA, vous utilisez déjà l'[AOP](https://fr.wikipedia.org/wiki/Programmation_orient%C3%A9e_aspect). En effet, quand vous faites une insertion en base via JPA dans un EJB ou un bean annoté `@Transactional`, une transaction est initiée au début de la méthode et fermée à la fin.

Avec [Spring](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html) et notamment dans [Spring boot](https://github.com/spring-projects/spring-boot/), voici comment initier l'[AOP](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#aop-api-advice).

## Configuration maven

Ajouter le starter AOP:

```xml
<dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-aop</artifactId>
        </dependency>

```


## Activation des aspects 

Dans la configuration ci-dessous, je prendrai comme exemple le logging des méthodes ( un log en début de méthode et un log en fin ).   
  
La définition des aspects se fait dans des classes annotées par `@Configuration`.

```java
@Configuration
@Aspect
@ConditionalOnProperty(name = "debug.enabled", havingValue = "true")
public class DebuggingConfiguration {

private static final Logger LOGGER = LoggerFactory.getLogger(DebuggingConfiguration.class);
private static final String WITHIN_MY_PACKAGE = "within(my.package..*)";

/**
* Log before execution
*
* @param joinPoint the current method
*/
@Before(WITHIN_MY_PACKAGE)
public void logBeforeExecution(JoinPoint joinPoint) {
if (LOGGER.isTraceEnabled()) {
LOGGER.trace("Beginning of method : [{}]", joinPoint.getSignature().getName());
}
}

/**
* Log after execution
*
* @param joinPoint the current method
*/
@After(WITHIN_MY_PACKAGE)
public void logAfterExecution(JoinPoint joinPoint) {
if (LOGGER.isTraceEnabled()) {
LOGGER.trace("End of method : [{}]", joinPoint.getSignature().getName());
}
}
}
```


L'utilisation de l' annotation `@ConditionalOnProperty` me permet d'activer cette classe de configuration seulement si la propriété `debug.enabled` est initialisée à `true`.  
  
Les annotations `@Before` et `@After` indiquent à Spring AOP quand exécuter ces méthodes ou sur quelles méthodes. Dans mon cas, quand les méthodes appelées sont définies dans les classes d'un package défini.  
  
Pour plus de détails sur la syntaxe et les possibilités, vous pouvez vous référer [à la documentation](https://docs.spring.io/spring/docs/2.0.x/reference/aop.html).
