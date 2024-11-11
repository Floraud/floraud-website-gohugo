# Floraud Website GoHugo
Je souhaitais faire un blog mais je trouvais ça trop lourd en ressources et administration de passer par un WordPress ou un Ghost avec une base de donnée. Après quelques recherches, Hugo semblait être une solution populaire et idéale pour mon besoin donc j'ai décidé de la tester. 

## docker-compose
Pour déployer le site, j'utilise un fichier **docker-compose.yml**. L'image docker provient de [HugoMods](https://docker.hugomods.com/docs/development/docker-compose/). Pour le moment, je n'arrive pas à faire fonctionner l'image officielle sortie à la 0.135.0 car, bien que n'ayant pas d'erreur en lançant le docker-compose, la page web est inaccessible et offre des resets de connexion.

Pour lancer le site, dans le dossier docker, il faudra jouer la commande `docker compose -f <filename> up`

## Hugo
Le thème [Ananke](https://github.com/theNewDynamic/gohugo-theme-ananke) est le thème proposé dans le [quick start](https://gohugo.io/getting-started/quick-start/) du site Hugo et il semblait convenir à mon besoin. J'ai donc décidé de commencer avec et de l'adapter à mes envies.

### hugo.toml
C'est le fichier dans lequel on peut adapter la majorité de la configuration du site.

J'ai commenté la partie **SectionPagesMenu = "main"** afin de ne pas reprendre automatiquement l'arborescence des dossiers dans le menu. J'ai utilisé la partie **[[menu.main]]** du **sitemap** pour gérer cette partie.


### Contenu multimédia
J'ai réalisé qu'il y aurait certainement trop de contenu multimédia à stocker. J'ai donc décider de créer des liens vers une ressource externe plutôt que stocker la majorité dans les sources.

### Création d'article
Pour créer un article, il me suffit d'ajouter un fichier markdown dans le dossier **content**. Si je veux y ajouter une image, intégré au site, je l'ajoute dans le dossier **static*** et le tour est joué.

## Troubleshooting
### Dossier public
Le dossier public peut comporter plus d'entrées que prévu si on a effectué des essais. Par conséquent, il est possible de le supprimer à la main avant de créer le serveur avec docker compose et a priori il le recréera automatiquement.
