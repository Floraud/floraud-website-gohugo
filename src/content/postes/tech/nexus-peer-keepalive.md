+++
title = 'Cisco Nexus - Configuration du Peer Keepalive'
categories = ["Tech"]
tags = ["Reseau", "Cisco", "Nexus"]
featured_image = "/images/tech/nexus-peer-keepalive_cover_monisha-selvakumar.webp"
date = 2025-01-01T13:14:22+01:00
+++

Dans le cadre de la configuration des **vPC** sur des **cœurs de réseau Cisco Nexus 9000 et 5000** on croise régulièrement le concept du **peer keepalive**, ce concept est très important à maîtriser car **s'il est mal configuré, il peut y avoir d'importants impacts de production**. Alors, **comment le configurer ?**

<!--more-->

## Qu'est-ce qu'un vPC ?

C'est un **virtual Port-Channel** qui permet de **relier un équipement physique, tel qu'un serveur, à deux switchs physiques différents en montant un seul port-channel en un agrégat de lien**. Cela permet de redonder physiquement les liens et d'utiliser en permanence les deux liens sans avoir besoin de spanning-tree tel que ci-dessous :

![Topologie vPC](/images/tech/nexus-peer-keepalive_vpc.webp)

Pour que cela fonctionne, sur Cisco Nexus, nous devons déclarer ce que l'on appelle un **vPC domain**. Mais **qu'est-ce que c'est ?**

Le vPC domain est un **groupement permettant de lier nos deux switchs**, on les qualifie l'un pour l'autre de peer device. Chaque switch gère la moitié du trafic, et dans le cas où l'un serait injoignable, l'autre switch gérerait l'ensemble du trafic avec un temps de convergence et un impact imperceptible.

Dans ce cadre, le **peer keepalive permet aux switchs de connaître leur état de santé respectif**.

## Problème rencontré

Durant mon expérience professionnelle, un incident important est survenu lors de l'arrêt électrique simultané de 2 Cisco Nexus (lors d'une panne électrique sur un datacenter par exemple). Le peer keepalive était mal configuré sur les 2 Cisco Nexus composant le vPC domain. Ils n'ont alors pas pu se voir, monter leur Peer-link (le vPC Peer-link est le lien sur lequel se font les échanges de données du vPC domain), les vPC étaient alors en état **Suspended By vPC** et le réseau était **KO**. Un ingénieur a dû se déplacer d'urgence pour aller bricoler le vPC domain et faire remonter le réseau.

En bref, **si le peer keepalive n'est pas correctement configuré alors le vPC Peer-link ne monte pas et vos vPCs sont NOK**.

## Solution
Après avoir consulté les **[Best Practices Cisco](https://www.cisco.com/c/dam/en/us/td/docs/switches/datacenter/sw/design/vpc_design/vpc_best_practices_design_guide.pdf)**, j'ai décidé de reprendre la configuration du peer keepalive depuis le début en plusieurs étapes :

### 1. Brancher les câbles et effectuer les contrôles habituels

Par habitude :
- Je sauvegarde la configuration. 
- Je contrôle l'état et le `show run` des différents éléments que je vais configurer par la suite pour m'assurer que les futures interfaces, PO ou autre ne sont pas déjà configurés/utilisés.

### 2. Création d'une nouvelle VRF

Sur chaque équipement :
```
conf t
vrf context vpc_keepalive
end
```

Et on contrôle avec `show vrf` pour voir apparaître la nouvelle vrf créée.

### 3. Configuration des ports ainsi que leur channel-group sur les deux switchs

Sur chaque équipement :
```
conf t

int Eth1/1
description vpc_keepalive_in_po1
channel-group 1 mode active
no shut

int Eth1/2
description vpc_keepalive_in_po1
channel-group 1 mode active
no shut
```

### 4. Configuration du port-channel sur chaque switch ainsi qu'une adresse IP différente

Switch 1 :
```
interface port-channel1
description vpc_keepalive
no switchport
vrf member vpc_keepalive
ip address 192.0.2.1/24
no shutdown
```

Switch 2 :
```
interface port-channel1
description vpc_keepalive
no switchport
vrf member vpc_keepalive
ip address 192.0.2.2/24
no shutdown
```

On contrôle le tout avec les commandes ci-dessous :
- `sh run int po1`
- `sh run int eth1/1-2`
- `sh port-channel summary`
- `sh int Eth1/-2 status`

### 5. Modification du peer-keepalive existant

Switch 1 :
```
vpc domain 1
peer-keepalive destination 192.0.2.2 source 192.0.2.1 vrf vpc_keepalive
end
```

Switch 2 :
```
vpc domain 1
peer-keepalive destination 192.0.2.1 source 192.0.2.2 vrf vpc_keepalive
end
```

On contrôle que la commande est bien passée : `sh run vpc`.

### 6. Contrôles post-configuration

- `sh vpc`
```
vPC domain id : 1
Peer status : peer adjacency formed ok
vPC keep-alive status : peer is alive
Configuration consistency status : success
Per-vlan consistency status : success
Type-2 consistency status : success
```

- `sh vpc peer-keepalive`
```
vPC keep-alive status : peer is alive
--Peer is alive for : (5375314) seconds, (808) msec
--Send status : Success
--Last send at : 2024.10.23 11:40:21 194 ms
--Sent on interface : po1
--Receive status : Success
--Last receive at : 2024.10.23 11:40:21 194 ms
--Received on interface : po1
--Last update from peer : (0) seconds, (956) msec

vPC Keep-alive parameters
--Destination : 192.0.2.2
--Keepalive interval : 1000 msec
--Keepalive timeout : 5 seconds
--Keepalive hold timeout : 3 seconds
--Keepalive vrf : vpc_keepalive
```
Et on oublie pas son `copy run start` ! 😉

## Conclusion
**Bien configurer son peer keepalive** permet de laisser l'équipe réseau dormir sur ses deux oreilles lors d'un incident aussi grave que l'arrêt électrique d'un datacenter. On a ainsi la **certitude que nos Cisco Nexus seront capables de reprendre la main correctement une fois de nouveau alimentés électriquement**.

Pour aller plus loin on pense aussi à mettre en place la supervision de ce lien afin de s'assurer de ne plus jamais être surpris.

*Photo de bannière par [Monisha Selvakumar](https://unsplash.com/fr/@monishaselv?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash) sur [Unsplash](https://unsplash.com/fr/photos/un-gros-plan-dune-fleur-avec-beaucoup-de-lumieres-floues-qv8f7x7QtZo?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)*
