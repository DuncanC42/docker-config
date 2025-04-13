# Documentation Projet Serious Game
### Transmission de projet vers la CPAM
![Symfony](https://img.shields.io/badge/Symfony-API-000000?logo=symfony&logoColor=white)
![Vue.js](https://img.shields.io/badge/Vue.js-Client-4FC08D?logo=vue.js&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/DB-PostgreSQL-336791?logo=postgresql&logoColor=white)
![Dockerized](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)
![Made by Code & Inné Team](https://img.shields.io/badge/Made%20with-%F0%9F%92%9C%20by%20Code%20&%20Inné-blueviolet)
![Work in Progress](https://img.shields.io/badge/status-%F0%9F%9A%A7%20WIP-orange)

## Sommaire

- [Introduction](#introduction)
- [Prérequis](#prérequis)
    - [Environnement technique](#environnement-technique)
    - [Accès et permissions](#accès-et-permissions)
- [Détails des services exposés](#détails-des-services-exposés)
    - [API](#api)
    - [Frontend](#frontend)
    - [Admin](#admin)
    - [PgAdmin](#pgadmin)
    - [Database](#database)
- [Configuration de l'environnement](#configuration-de-lenvironnement)
    - [Installation des sources](#installation-des-sources)
    - [Variables d'environnement](#variables-denvironnement)
    - [Environnement de développement](#environnement-de-développement)
    - [Environnement de production](#environnement-de-production)
    - [Environnements personnalisés](#environnements-personnalisés)
- [Communication entre les services](#communication-entre-les-services)
- [Accès aux interfaces](#accès-aux-interfaces)
- [Équipe de développement](#équipe-de-développement)
- [Remerciements](#remerciements)

---

## Introduction
Ce guide a pour but de permettre la reprise du projet de "Serious Game" par les équipes techniques de la CPAM. À la fin de ce document vous devriez avoir compris l'architecture globale de notre projet, sa configuration et le fonctionnement de chacun des services en général.

## Prérequis
### Environnement technique :
Ce projet a été mis en place sur un environnement Linux (*I use arch btw*) Il sera donc plus simple à mettre en place sur **un environnement Linux/MacOs**. Il reste tout de même possible de le mettre en place sur un environnement **Windows avec WSL** de préférence. Nous avons également mis en place un environnement Dockerisé prenez ainsi vos dispositions pour installer **docker** et **docker compose**.  
*Point de vigilance : Il est possible que certaines des images utilisées ne soient pas compatibles avec votre architecture, si cela arrive, il faudra que vous trouviez des alternatives.*
Nous avons aussi utilisé pour le versionning **GIT** avec quatre repository distinct pour faciliter les évolutions de chaque partie sans que cela vienne interférer avec les autres.  
Cf. [Lien vers les repository](https://github.com/stars/DuncanC42/lists/sae-cpam)

### Accès et permissions
Étant sur un environnement dockerisé, il est tout à fait possible que vous ne puissiez exécuter certaines commandes de la manière traditionnelle. Pour la plupart des commandes, vous devrez donc vous connecter au conteneur correspondant puis effectuer votre commande. Pour se faire :
```sh
# Repérez le nom du conteneur auquel sur lequel vous souhaitez effectuer la commande
docker ps

# Puis connectez vous y de cette manière 
docker exec -it <container_name/container_id> /bin/bash
```

Il est possible que certains fichiers ne soient pas modifiables, car créé par Root depuis le conteneur, si ça vous arrive un petit `chmod` vous aidera.

## Détails des services exposés
### API
Service déployant une api PHP-Symfony qui va servir d'intermédiaire entre les applications front et la base de données.  
Il va exposer deux ports :
- **8050** : port de communication pour l'api REST en fonctionnement classique
- **8051** : port de communication pour l'api Websocket afin de permettre l'échange en double canaux de données.

### Frontend
Service qui va déployer le serious game et qui repose sur Vite et VueJs.
Il sera accessible depuis le port **8080**.

### Admin
Service permettant l'étude et la gestion des différentes données qui ressortent du serious game.  
Il est accessible depuis le port **8081**.

### PgAdmin
Service qui va exposer l'outil de management de base de données pour PostgresSQL, PgAdmin.  
Il est accessible depuis le port **8060**.  
Il faudrait revoir la configuration de celui-ci, car il peut être un peu fastidieux de s'y reconnecter à chaque fois, en attendant un logiciel en local à la Dbeaver fait très bien le travail.

### Database
Service sur lequel la base de données PostgresSQL est exposée. Elle se situe sur le port **5432**.


## Configuration de l'environnement
### Installation des sources
Pour mettre en place l'environnement que ça soit en développement ou bien en production vous devrez vous placer si possible dans un espace dédié au projet, puis vous  cloner ce repository qui est central au sein du projet.
```sh
git clone https://github.com/DuncanC42/docker-config.git
```
Une fois cloné, vous retrouverez un fichier `createEnv.sh` son but est comme son nom l'indique de vous faciliter la mise en place de l'environnement, il va donc tout seul venir cloner les autres repository ou bien mettre à jour ceux qui sont déjà existants.
**Attention** si vous êtes sous windows, il est possible que vous ne puissiez exécuter le script, car il est configuré en **LF** ainsi, vous pouvez l'ouvrir dans un éditeur de code type vscode et venir modifier vous-même **CRLF → LF**. Pour l'exécuter :
```sh
./createEnv.sh
```
Si vous avez une erreur comme quoi le fichier n'existe pas, retournez sur le point d'attention un peu plus haut. Si vous avez un problème de droit un petit `chmod +x createEnv.sh` fera l'affaire puis réessayez.

### Variables d'environnement
Pour fonctionner correctement, vous devez avant tout de chose créer un fichier **.env** dans le dossier *docker-config*, les variables d'environnement seront ensuite repartagées entre les autres dossiers pour alimenter leurs propres variables d'environnement.
Voici le contenu type du `.Env`, à personnaliser selon vos choix.

```.env
# Nom du projet (préfixe pour tous les conteneurs, réseaux et volumes)
PROJECT_NAME=CPAM_Serious_Game

URI=localhost

# Configuration des ports
API_PORT=8050
WS_PORT=8051
DB_PORT=5432
PGADMIN_PORT=8060
FRONTEND_PORT=8080
ADMIN_PORT=8081

# Configuration de la base de données
POSTGRES_USER=app_user
POSTGRES_PASSWORD=<your_password>
POSTGRES_DB=app_db

# Configuration de PGAdmin
PGADMIN_DEFAULT_EMAIL=your.email@example.com
PGADMIN_DEFAULT_PASSWORD=<pgadmin_password>
PGADMIN_CONFIG_SERVER_MODE=False

# Configuration de l'environnement Node
NODE_ENV=development

SYMFONY_ENV=dev 


DATABASE_URL="pgsql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@database:5432/${POSTGRES_DB}?serverVersion=14&charset=utf8"

JWT_SECRET_KEY=%kernel.project_dir%/config/jwt/private.pem
JWT_PUBLIC_KEY=%kernel.project_dir%/config/jwt/public.pem
JWT_PASSPHRASE=<pass_phrase>
```
*À noter : il faudra y faire quelques modifications si cet environnement est destiné à la production, nous aborderons celà plus tard.*

### Environnement de développement
Normalement si vous avez suivi les étapes précédentes cet environnement est déjà quasiment prêt, il vous suffit maintenant de vous rendre dans le répertoire de votre API et d'exécuter les lignes suivantes :

```sh
mkdir -p config/jwt
openssl genpkey -out config/jwt/private.pem -aes256 -algorithm rsa -pkeyopt rsa_keygen_bits:4096
openssl pkey -in config/jwt/private.pem -out config/jwt/public.pem -pubout
```

Elles vont chacune créer une clé privée et publique pour le JWT, il vous sera demandé de rentrer une passphrase, c'est celle-ci qui est renseignée dans le fichier `.env` à la ligne `JWT_PASSPHRASE`.

Après ça il ne vous restera plus qu'à lancer le programme pour se faire rendez-vous dans le dossier `docker-config` et exécutez la commande suivante :
```sh
docker compose build # Si c'est la première fois que vous le lancez ou si vous avez fait des modifications

docker compose up -d # Pour le lancer en arrière plan
```

### Environnement de production

Pour la mise en place de l'environnement de production, vous devriez répéter les mêmes étapes que pour l'environnement de développement **MAIS** en modifiant le fichier `.env` pour y mettre les bonnes valeurs ou au moins :
```sh
URI=<vps-ip>
NODE_ENV=production
SYMFONY_ENV=prod
```
Il faudra également penser à générer les clés JWT de la même manière que pour l'environnement de développement.
```sh
mkdir -p config/jwt
openssl genpkey -out config/jwt/private.pem -aes256 -algorithm rsa -pkeyopt rsa_keygen_bits:4096
openssl pkey -in config/jwt/private.pem -out config/jwt/public.pem -pubout
```
Vous pouvez maintenant démarrer votre environnement de production, mais **Attention,** suivez bien les étapes suivantes pour le rendre opérationnel.
```sh
docker compose build # Si c'est la première fois que vous le lancez ou si vous avez fait des modifications
docker compose up -d # Pour le lancer en arrière plan
```


*À noter que l'environnement de développement lui génère des valeurs par défauts via des fixtures, qui peuvent s'avérer utiles, mais que ce n'est pas le cas pour l'environnement de production. Vous avez tout de même des modifications à effectuer pour rendre votre environnement de production opérationnel.*

```sh
./insert_base_data.sh
```
Cela va générer les données des tables de jeu, paramètres et token qui sont nécessaires au bon fonctionnement de l'application.

Maintenant l'environnement de production est prêt !

### Environnements personnalisés
- Hybride :
  Nous aurions aimé mettre en place une sorte d'environnement hybride où le frontend avec les serious game se trouverait à un endroit et le panel d'administration à un autre un peu comme un intranet. Ça serait une sorte d'environnement micro-services ce qui semble réalisable par l'utilisation de docker.
- Gestion via sous-domaine :
  Il serait également possible de faire de la gestion des applications via des sous-domaines, mais cela nécessiterait de mettre en place un reverse proxy (Nginx par exemple) et nous n'avons pas eu le temps de le faire. Ainsi, vous pourriez gérer les applications via des sous-domaines comme `admin.NOM_DOMAINE`, `game.NOM_DOMAINE`, `api.NOM_DOMAINE`...

## Communication entre les services

Avant de tester la communication entre les différents services, il est important de vérifier si chaque service fonctionne correctement de manière individuelle. Pour cela, vous pouvez vous rendre sur [http://195.15.214.143:8050/](http://195.15.214.143:8050/) afin de tester les différents endpoints de l'API de manière isolée.

Dans le **Frontend** et le **Panel d'administration**, une méthode générique appelée `fetchBackend` est utilisée pour interroger l'API. Cette méthode permet de spécifier l'endpoint souhaité, la méthode de transfert (GET, POST, etc.), ainsi que les paramètres nécessaires.

L'URI et le PORT utilisés pour interroger l'API sont modifiés dynamiquement en fonction des valeurs définies dans le fichier `.env` du dossier `docker-config`, qui est partagé entre tous les services pour centraliser la configuration.

### Schéma de l'architecture
```mermaid
flowchart TD
    Frontend["Frontend VueJS 
    (Port 8080)"]
    Panel["Panel Admin VueJS 
    (Port 8081)"]
    API["API Codeine (PHP/Symfony) 
    REST: Port 8050
    WebSocket: Port 8051"]
    DB[(Base de donnée
    PostgreSQL
    Port 5432)]
    PGAdmin["PGAdmin
    (Port 8060)"]
    
    Frontend -->|Requêtes REST
    Port 8050| API
    Frontend <-->|WebSocket
    Port 8051| API
    Panel -->|Requêtes REST
    Port 8050| API
    Panel <-->|WebSocket
    Port 8051| API
    API -->|Lecture/Écriture| DB
    PGAdmin -->|Visualisation| DB
    
    classDef vue fill:#42b883,stroke:#35495e,color:white
    classDef api fill:#7b95ad,stroke:#35495e,color:white
    classDef db fill:#336791,stroke:#35495e,color:white
    classDef tool fill:#ff6b6b,stroke:#35495e,color:white
    
    class Frontend,Panel vue
    class API api
    class DB db
    class PGAdmin tool
```

## Accès aux interfaces
Actuellement, vous pouvez accéder à un environnement de production disponible de manière temporaire sur un vps que j'ai acheté : 
- API et documentation : [http://195.15.214.143:8050](http://195.15.214.143:8050/)
- Serious Game : [http://195.15.214.143:8080](http://195.15.214.143:8080/)
- Panel d'administration : [http://195.15.214.143:8081](http://195.15.214.143:8081/)
- PgAdmin : [http://195.15.214.143:8060](http://195.15.214.143:8060)

**Attention** : L'abonnement à mon vps expire le 08/05/2025.

## Équipe de développement
- Nathan : https://github.com/nfilaux
- Maxime : https://github.com/MaximeDrdn
- Kilian : https://github.com/KilianHod
- Timéo : https://github.com/Huntshi
- Duncan : https://github.com/DuncanC42

## Remerciements
Merci à l'équipe de la CPAM pour leur confiance et leur soutien tout au long de ce projet. Merci à l'IUT de Lannion de nous avoir permis de participer à cette expérience nouvelle et formatrice. Nous espérons que ce Serious Game sera un outil précieux pour la formation et la sensibilisation aux différents services proposés par la CPAM. Et merci à chacun des membres de l'équipe de développement sans qui ce projet n'aurait pas été possible.