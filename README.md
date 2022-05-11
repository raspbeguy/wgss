# WGSS

Wireguard Self-Service est un outil écrit en Bash pemettant à un parc d'utilisateurs de gérer les accès Wireguard à un réseau commun (en configuration _roadwarrior_) à l'aide d'une interface web.

Ce fichier README est destiné aux administrateurs du VPN. Une page d'aide à destination des utilisateurs finaux est disponible sur l'interface web.

## Installation

WGSS s'installe sur la machine servant de passerelle VPN.

Un serveur web avec support de CGI est requis, par exemple nginx avec fcgiwrap.

```
apt install nginx fcgiwrap
```

L'authentification se fait via LDAP. Il est donc nécessaire de disposer d'un serveur LDAP (pas nécéssairement sur la même machine) et d'installer les outils LDAP sur le serveur VPN.

```
apt install ldap-utils
```

Pour la génération des pages à partir de templates Jinja2, installer l'outil j2cli et quelques bibliothèques Python.

```
apt install j2cli python3-hurry.filesize python3-babel
```

Pour les manipulations d'adresses IP, installer ipcalc-ng.

```
apt install ipcalc-ng
```

Il est fait usage de la feuille de style [Bulma](https://bulma.io) et des icônes [Font Awesome](https://fontawesome.com/).

**TODO:** Script téléchargeant les feuilles de style et les icônes.

## Configuration

### Permissions

Il est nécessaire d'octroyer la permission d'utiliser wireguard à l'utilisateur exécutant le script (habituellement `www-data`). Pour cela, ajouter aux fichiers sudoers :

```
www-data        ALL=(ALL)       NOPASSWD:       /usr/bin/wg
```

### Fichier de configuration

Pour configurer l'outil, copier [config-sample.sh](config-sample.sh) vers `config.sh` et éditez le nouveau fichier.

Les variables `LDAP_*` concernent les paramètres du serveur LDAP.

* `LDAP_URL`: URL complète du serveur LDAP.
* `LDAP_USER_OBJ`: définition du type utilisateur en vigueur sur le serveur LDAP.
* `LDAP_GROUP_OBJ`: définition du type groupe en vigueur sur le serveur LDAP.
* `LDAP_ADMIN_GROUP`: nom du groupe des administrateurs.
* `LDAP_USER_GROUP`: nom du groupe des personnes autorisées à utiliser l'interface.

Les variables `SESSION_*` concernent la génération de jetons de sessions qui seront stockés dans un cookie des navigateurs web.

* `SESSION_ID_LEN`: nombre de caractères composant chaque jeton de session.
* `SESSION_PATH`: emplacement du dossier contenant les jetons de session générés.
* `SESSION_TERM`: durée de validité des sessions.

Les variables `WG_*` concernent la configuration du VPN.

* `WG_INTERFACE`: nom de l'interface réseau du VPN sur le serveur.
* `WG_PEERS`: chemin du fichier où seront inscrits les profils VPN des utilisateurs, contenant entre autres les noms de profils, les clefs publiques et les adresses IP.
* `WG_PUBKEY`: clef publique du serveur VPN.
* `WG_NET`: réseau dans lequel figureront les adresses IP des profils.
* `WG_DEST_NET`: réseau contenant les ressources cibles (le réseau d'entreprise).
* `WG_GW_IP`: adresse IP du serveur VPN (pour ne pas qu'elle soit attribuée à un profil utilisateur).
* `WG_ENDPOINT`: domaine et le port d'accès au serveur VPN, vu par l'extérieur.
* `WG_DNS`: serveur DNS que les utilisateurs doivent utiliser en interne.
* `WG_UP_DELAY`: délai maximal suivant le dernier handshake qualifiant un pair comme étant connecté.

### Configuration su serveur web

Copier et éditer le fichier [nginx-config](nginx-config) dans votre configuration nginx.

## Marge de progression

* Supporter plusieurs langues, dont l'anglais
* Gérer autre chose que LDAP
* Implémenter l'auto-génération de clef
