# Floraud Website GoHugo
Je souhaitais faire un blog mais je trouvais ça trop lourd en ressources et administration de passer par un WordPress ou un Ghost avec une base de donnée. Après quelques recherches, Hugo semblait être une solution populaire et idéale pour mon besoin donc j'ai décidé de la tester. 

## docker-compose
Pour déployer le site, j'utilise un fichier **docker-compose.yml**. L'image docker provient de [HugoMods](https://docker.hugomods.com/docs/development/docker-compose/). 

L'image officielle est créée avec l'utilisateur hugo et sans la possibilité de lancer des commandes me permettant d'installer pagefind avec les droits requis.

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

Aujourd'hui, il m'est nécessaire de **relancer le docker-compose** à la création d'un article pour que **pagefind** (mon utilitaire de recherche) **puisse indexer les articles**.

Je l'ai choisi car c'est une solution locale.

## To Do
- [ ] Télécharger localement pagefind v1.3.0 et voir si possible de le monter localement au cas où un jour il n'est plus accessible.