# ./show-attackers.sh syslog-sample
#2ASIX - ASO - 2020


[![N|Solid](http://www.institutpedralbes.cat/wp-content/uploads/2020/02/logo.jpg)](http://www.institutpedralbes.cat/)



Aquest script analitza un arxiu de logs (el podeu descarregar al mateix git) i ens dirà quines son les IPS amb més de 10 intents, el número total de intents de logueix, la IP que ha fet l'atac i la localització geogràfica de l'atac.

PS: El script **show-attackers** proporciona una documentació **in-line** més extensa. És necessari ser **root**!
[![N|Solid](https://i.imgur.com/pnQuwyv.png)](https://github.com/asixGV/show-attackers/blob/main/show-attackers.sh)


# Instal·lació
  - Descarregar geoiplookup!
  ```sh
  $ sudo su
  # apt-get install geoip-bin geoip-database
  ```
  - Executar show-attackers !
  ```sh
 $ sudo su
 # ./show-attackers.sh syslog-sample
  ```
  o també:
  ```sh
  $ sudo ./show-attackers.sh syslog-sample
  ```
