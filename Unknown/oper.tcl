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
# Ce script fournit la possibilité à votre eggdrop de s'auto-oper dans les channels irc!
# Pre-requis nécessaire : l'eggdrop doit être IRCop / 
# Version 2003
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


#################################################################################################
######################################### A PAS MODIFIER ########################################
#################################################################################################

#############
# S'auto op #
#############

bind join - * coucou 

proc coucou {nick host handle channel} { 
global botnick 
if {$nick =="$botnick"} { 

putserv "MODE $botnick +q"
putserv "MODE $channel +o $botnick"
return 0 
} 
}

############
# putlog   #
############

putlog "Espace-IRC.Net - Auto OP by sMug" 

