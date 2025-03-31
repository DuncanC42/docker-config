# Projet de fin de BUT 3 : Jeux avec CPAM

![Symfony](https://img.shields.io/badge/Symfony-API-000000?logo=symfony&logoColor=white)
![Vue.js](https://img.shields.io/badge/Vue.js-Client-4FC08D?logo=vue.js&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/DB-PostgreSQL-336791?logo=postgresql&logoColor=white)
![Dockerized](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)
![Made by Code & Inné Team](https://img.shields.io/badge/Made%20with-%F0%9F%92%9C%20by%20Code%20&%20Inné-blueviolet)
![Work in Progress](https://img.shields.io/badge/status-%F0%9F%9A%A7%20WIP-orange)

## Sommaire

1. [Contexte](#contexte)
2. [Fonctionnalités](#fonctionnalités)
3. [Technologies utilisées](#technologies-utilisées)
4. [Structure du projet](#structure-du-projet)
5. [Mise en place de l'environnement de développement](#mise-en-place-de-lenvironnement-de-développement)
6. [Utilisation de Git](#utilisation-de-git)
7. [Démarrage rapide](#démarrage-rapide) *(à compléter si besoin plus tard)*
8. [Contribuer](#contribuer) *(à initier pour plus tard)*

---

## Contexte

Ce projet consiste à développer une suite d'applications incluant des serious games visant à sensibiliser et former le public aux services proposés par la CPAM. Le projet comprend également une application administrateur pour le management des joueurs et la gestion des données.

## Fonctionnalités

- **API Symfony** : application PHP - Symfony permettant l'enregistrement, l'envoi de données ainsi que l'authentification.
- **Application client** : intégrant les jeux développés pour la CPAM.
- **Application admin** : tableau de bord pour la gestion des utilisateurs et des données.

## Technologies utilisées

- **Langages** : `PHP`, `JavaScript`, `Vue.js`
- **Framework** : `Symfony`
- **Base de données** : `PostgreSQL`
- **Outils** : `Docker`, `Swagger`

## Structure du projet

```plaintext
. // Dossier principal à créer
├── backend // Dossier pour l'API Symfony
│   └── apiCodeine // récupéré via git clone
├── docker-config // configuration Docker (repo à cloner)
├── frontend // application cliente avec les jeux (repo à cloner)
└── panelAdmin // application de gestion administrateur (repo à cloner)
```


## Mise en place de l'environnement de développement

1. Créez un dossier principal :
```sh
mkdir %nom_du_dossier%
```

2. récupérer les sources :
```shell
git clone https://github.com/DuncanC42/docker-config.git
git clone https://github.com/DuncanC42/frontend.git
git clone https://github.com/DuncanC42/panelAdmin.git
mkdir backend
cd backend
git clone https://github.com/DuncanC42/apiCodeine.git
cd ..

```

3. Configuration des variables d'environnement :
- Dans `/docker-config/.env`
```.env
POSTGRES_ROOT_PASSWORD=mot_de_passe_root_postgres

POSTGRES_USER=nom_user_progress
POSTGRES_PASSWORD=mot_de_passe_user
POSTGRES_DB=nom_database


PGADMIN_DEFAULT_EMAIL=adresse_mail
PGADMIN_DEFAULT_PASSWORD=password123
PGADMIN_CONFIG_SERVER_MODE=False
```

- Dans `/backend/apiCodeine/.env` :

```.env
DATABASE_URL="pgsql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@app_sf_db:5432/${POSTGRES_DB}?serverVersion=14&charset=utf8"
```

Normalement une fois que ceci est fait l'environnement est presque prêt !

4. Démarrage des services docker
```sh
cd docker-config
docker compose up -d --build # build uniquement si nécessaire
```

5. vérifications
- http://localhost:8080 -> pour l'application avec les jeux
- http://localhost:8081 -> pour le logiciel panel administrateur
- http://localhost:8060 -> pour pgAdmin

6. Démarrer l'api Symfony
```bash
docker exec -it app_sf_web bash # rentre dans le terminal du conteneur
cd apiCodeine && symfony serve --allow-all-ip -d # lance symfony
exit # sors du terminal du conteneur
```
L'API est désormais disponible sur : http://localhost:8050/


## Utilisation de git

Si vous en êtes là c'est que vous vous apprêtez à proposer quelque chose de nouveau, bonne chance dans cette mission !

Voici comment vous allez vous y prendre :

1. Mettez vous dans le repertoire concerné par la modification

2. Rendez vous sur la branche principale (*en théorie master*)
```sh
git switch master
```

3. Récupérez les dernières évolutions
```sh
git pull
```

4. Créez une nouvelle branche depuis master
```sh
git checkout -b #%numeroUS%-%description_fonctionnalitée% master
```

5. Normalement vous êtes directement sur votre nouvelle branche vous pouvez maintenant faire vos développements ! :100:

6. Au cours de vos développement n'hésitez pas à faire le plus de commit possible pour un suivi plus simple et plus sécurisant

7. Vous avez terminé votre dev, il faut maintenant le partager avec tout le monde mais avant ça, il faut se mettre à jour par rapport aux autre
```sh
git switch master
```
on retourne sur master puis
```sh
git pull
```
8. Maintenant qu'on est à jour on retourne sur sa branche où on prépare l'évolution
```sh
git switch %nom_de_la_banche%
```

9. Maintenant on arrive au moment où il faut prier pour ne pas que quelqu'un ait fait une modification qui viendrait vous embêter
```sh
git rebase master
```

Si vous avez des conflits il faut les régler dans l'IDE sans tout casser ! Sinon appel à un ami authorisé...

10. **Si et seulement si** il n'y a pas plus de conflits vous pouvez push !
```sh
git push
```

11. Maintenant rendez vous sur la page github correspondant au repo puis selectionnez => *compare & pull request*

Renseignez les informations relatives à votre développement, en quoi il consiste, ce qu'il y a de nouveaux etc...

12. Puis cliquez sur le bouton *Create pull request* pour valider celle-ci

13. Demandez à un de vos collègue de valider votre pull request puis de faire un **Squash and merge**








