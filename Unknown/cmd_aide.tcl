#########################################################
##                                                     ##
##     ___   __ _  __ _  __| |_ __  ___  _ __          ##
##    / _ \ / _` |/ _` |/ _` | '__|/ _ \| '_ \         ##
##   |  __/| (_| | (_| | (_| | |  | (_) | |_) |        ##
##    \___| \__, |\__, |\__,_|_|   \___/| .__/         ##
##          |___/ |___/                 |_|            ##
##                                                     ##
##                                                     ##
#########################################################
#########################################################
# Commands HELPER BOT par sMug Jérôme Fafchamps         #
#########################################################
# 
# Ce script fournit un ensemble de commandes utiles pour votre bot Eggdrop.
# Version 2004
#
# Pour utiliser ces commandes, ajoutez simplement ce script à votre configuration Eggdrop.
#
#Pour toute question ou suggestion, n'hésitez pas à contacter l'auteur à l'adresse suivante : jerome@fafchamps.be
#
#Ce script est mis à disposition selon les termes de la licence suivante :
#
#Licence d'utilisation libre :
#
#Ce script est fourni tel quel, sans garantie d'aucune sorte, expresse ou implicite. L'auteur ne peut en aucun cas être tenu responsable #de tout dommage résultant de l'utilisation de ce script.
#
#Cependant, l'auteur espère que ce script sera utile à d'autres utilisateurs et contribuera à améliorer leurs expériences avec Eggdrop.
#
#En utilisant ce script, vous acceptez ces termes de licence.
#
#########################################################


#####################
# Mode d'emploi :   #
#####################

# Pour les commandes sur le chan choisis ! suivis de votre commande habituel.
# Pour nommer des helpers ou les retirer mettez le flag +vH (en majuscule globalement).
# ATTENTION TOUT LES IRCOPS DOIVENT AVOIR LE FLAG +O (majuscule global) sinon le TCL BuGs (message de on join)

# Quel salon ce tcl est activer pour les commandes
set mc_re(chan) "#Aide"

#####################
#   Commandes       #
#####################

bind join - * pub:join
proc pub:join { nick uhost handle channel } {
	global aide
	foreach a #aide {
		if {[string equal -nocase $channel $a]} {
	        	putserv "NOTICE $nick :Bienvenue sur #aide ! Je suis Unknown ! Le robot d'aide de Espace-IRC. Si tu veux que je t'aide, pose ta question en une seule ligne. ;)" 
		}
	}
}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !ns pub:auth
proc pub:auth { nick uhost hand channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $mc_re(chan) :$t1 Pour vous identifiez, tapez: /ns identify motdepasse"

}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !ns_register pub:cs
proc pub:cs { nick uhost hand channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $mc_re(chan) :$t1 Pour vous enregistrer, tapez: /ns register tonpass tonmail"

}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !cs_register pub:chanserv
proc pub:chanserv { nick uhost hand channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $mc_re(chan) :$t1 Pour enregistrer un salon, veuilliez d'abord enregistrer votre pseudo et tapez: /cs register #tonchan tonpass descriptiondusalon"

}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !assign pub:assign
proc pub:assign { nick uhost hand channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $mc_re(chan) :$t1 Pour mettre un bot sur votre salon, tapez : /bs assign #tonsalon nomdubot"

}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !botlist pub:botlist
proc pub:botlist { nick uhost hand channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $mc_re(chan) :$t1 Pour voir la liste des bots disponibles sur le réseau, tapez : /bs botlist"

}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !ban pub:ban
proc pub:ban { nick uhost hand channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $mc_re(chan) :$t1 Pour bannir une personne (+b), tapez : /mode #salon +b sonpseudo"
putserv "PRIVMSG $mc_re(chan) :$t1 où tu peux bannir en tapant : /cs ban #salon sonpseudo"


}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !keeptopic pub:keeptopic
proc pub:keeptopic { nick uhost hand channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $mc_re(chan) :$t1 Pour bloquer le topic, tapez : /cs set #salon keeptopic on"

}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !topic pub:topic
proc pub:topic { nick uhost hand channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $mc_re(chan) :$t1 Pour changer le topic de votre salon, tapez /cs topic #salon votretopic"

}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !clearbans pub:clearbans
proc pub:clearbans { nick uhost handle channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $channel :$t1 Pour enlever tout les bannis de votre salon, tapez : /cs CLEAR #Aide bans"
}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !showcommands pub:cmd
proc pub:cmd { nick uhost handle channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $channel :$t1 Pour voir toutes les commandes de chanserv disponible.. tapez: /cs help"

}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !op pub:alex
proc pub:alex { nick uhost handle channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $channel :$t1 Pour vous opez sur votre salon, tapez: /cs op #tonsalon pseudo !"

}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !access pub:access
proc pub:access { nick uhost handle channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $channel :$t1 Pour voir tous les accès d'un canal, tapez: /cs access #tonsalon list !"

}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !xquestion pub:question
proc pub:question { nick uhost handle channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $channel :$t1 Avez vous une question ?"

}


set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !me pub:me
proc pub:me { nick uhost handle channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $channel :$t1 Pour faire une action, tapez : /me votre-action"
}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !drop pub:unreg
proc pub:unreg { nick uhost handle channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $channel :$t1 Pour effacer un salon, tapez: /cs drop #salon raison"
}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !kb pub:kb
proc pub:kb { nick uhost handle channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $channel :$t1 Pour éjecter et bannir une personne, tapez : /kban #salon pseudo"
}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !list pub:list
proc pub:list { nick uhost handle channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $channel :$t1 Pour voir la liste complète des canaux, tapez : /list"
}

set mc_re(chan) [string tolower $mc_re(chan)]
bind pub - !ignore pub:ignore
proc pub:ignore { nick uhost handle channel args } {
set t1 [lindex $args 0]
global mc_resp mc_re ; set args [string tolower [lindex $args 0]]
if {[lsearch -exact $mc_re(chan) [string tolower $channel]] == "-1"} {return 0}
putserv "PRIVMSG $channel :$t1 Pour ignorer une personne, tapez : /ignore pseudo"
}




