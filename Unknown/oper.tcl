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
# Commands HELPER BOT par sMug J�r�me Fafchamps         #
#########################################################
# 
# Ce script fournit la possibilit� � votre eggdrop de s'auto-oper dans les channels irc!
# Pre-requis n�cessaire : l'eggdrop doit �tre IRCop / 
# Version 2003
#
# Pour utiliser ces commandes, ajoutez simplement ce script � votre configuration Eggdrop.
#
#Pour toute question ou suggestion, n'h�sitez pas � contacter l'auteur � l'adresse suivante : jerome@fafchamps.be
#
#Ce script est mis � disposition selon les termes de la licence suivante :
#
#Licence d'utilisation libre :
#
#Ce script est fourni tel quel, sans garantie d'aucune sorte, expresse ou implicite. L'auteur ne peut en aucun cas �tre tenu responsable #de tout dommage r�sultant de l'utilisation de ce script.
#
#Cependant, l'auteur esp�re que ce script sera utile � d'autres utilisateurs et contribuera � am�liorer leurs exp�riences avec Eggdrop.
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

