############################
#                          #
#Configuration personnelle #
#                          #
############################

# Définissez ici le(s) nom(s) de votre(vos) salon(s) d'aide:
set salon_aide "#Aide"

############################
#                          #
# NE TOUCHEZ PLUS RIEN SI  #
# VOUS NE CONNAISSEZ PAS ! #
#                          #
############################

bind join - * pub:join
proc pub:join { nick uhost handle channel } {
	global salon_aide
	foreach a $salon_aide {
		if {[string equal -nocase $channel $a]} {
	        	putserv "NOTICE $nick :Bienvenue sur #Aide ! Tapez 12!aide afin de ne pas déranger les opérateurs pour les questions les plus courantes ;) - http://www.espace-irc.org - Adresse IRC: irc.espace-irc.org" 

		}
	}
}

bind pub - !aide pub:aide
proc pub:aide { nick uhost handle channel arg } {
	global salon_aide
	foreach a $salon_aide {
		if {[string equal -nocase $channel $a]} {
	        	putserv "NOTICE $nick :12!pseudo pour voir l'aide sur les commandes de NickServ"
        		putserv "NOTICE $nick :12!salon pour voir l'aide sur les commandes de ChanServ"
        		putserv "NOTICE $nick :12!robot pour voir l'aide sur les commandes de BotServ"
			putserv "NOTICE $nick :12!commandeaop les commandes aop"
			putserv "NOTICE $nick :12!access pour passer le salon en access levels"
			putserv "NOTICE $nick :12!autovoice pour mettre que le robot du salon voice auto" 
#			putserv "NOTICE $nick :12!quizz pour savoir comment avoir un quizz" 
#			putserv "NOTICE $nick :12!applet pour savoir comment mettre l'applet de Espace-iRC.org sur votre site"
		}
 	}
}



bind pub - !pseudo pub:ns
proc pub:ns { nick uhost handle channel arg } {
        global salon_aide
        foreach a $salon_aide {
                if {[string equal -nocase $channel $a]} {
			putserv "NOTICE $nick :Pour enregistrer votre pseudo, tapez la commande suivante:"
        		putserv "NOTICE $nick :12/msg NickServ REGISTER <Votre mot de passe> <Votre adresse mail>"
        		putserv "NOTICE $nick :Le mot de passe ne doit contenir qu'un seul mot et votre adresse mail doit être valide"
			putserv "NOTICE $nick :Pour vous identifier, tapez 12/msg NickServ IDENTIFY <Votre mot de passe>"
			putserv "NOTICE $nick :Pour changer de mot de passe tapez 12/msg NickServ SET PASSWORD <nouveau mot de passe>"
			putserv "NOTICE $nick :Pour activer la protection de votre pseudo : 12/msg NickServ SET KILL on"
			putserv "NOTICE $nick :Pour changer de pseudo, tapez 12/nick <nouveau pseudo>"
		}
	}
}

bind pub - !salon pub:cs
proc pub:cs { nick uhost handle channel arg } {
        global salon_aide
        foreach a $salon_aide {
                if {[string equal -nocase $channel $a]} {
			putserv "NOTICE $nick :Pour enregistrer votre salon, votre pseudo doit être enregistré. Si ca n'est pas le cas, tapez 12!pseudo"
	        	putserv "NOTICE $nick :Pour enregistrer votre salon, tapez la commande suivante:"
        		putserv "NOTICE $nick :12/msg ChanServ REGISTER <#Votre salon> <Mot de passe du salon> <Description du salon>"
        		putserv "NOTICE $nick :Le mot de passe ne doit contenir qu'un seul mot tandis que la description peut en contenir plusieurs"
      			putserv "NOTICE $nick :Pour afficher le topic tapez 12/msg ChanServ TOPIC <#Votre salon> <message>" 
			putserv "NOTICE $nick :Pour mettre un status op, halfop, ou voice, tapez 12!op <pseudo> !halfop  <pseudo> !voice <pseudo> (Necessite un robot sur le salon.)"
			putserv "NOTICE $nick :Pour kicker, deux commandes. S'il y a un robot sur le salon, tapez 12!kick <pseudo> <raison>. Sans robot : 12/k <pseudo> <raison>."
			putserv "NOTICE $nick :Pour bannir, deux commandes aussi. Tapez 12!kb <pseudo> <raison> s'il y a un robot. Sinon, 12/kb <pseudo> <raison>."
			putserv "NOTICE $nick :Pour se debannir d'un salon ou vous êtes aop, tapez 12/msg ChanServ unban <#Votre Salon>."
			putserv "NOTICE $nick :Pour changer un mode, tapez 12/mode <#Votre Salon> + <mode>. Remplacez le \"+\" par \"-\" pour l'oter."
		}
	}
}

bind pub - !robot pub:bs
proc pub:bs { nick uhost handle channel arg } {
        global salon_aide
        foreach a $salon_aide {
                if {[string equal -nocase $channel $a]} {
	        	putserv "NOTICE $nick :Pour obtenir un robot sur votre salon, votre salon doit être enregistré. Si ce n'est pas le cas, tapez 12!salon"
        		putserv "NOTICE $nick :La liste des robots est disponible en tapant 12/msg BotServ BOTLIST"
        		putserv "NOTICE $nick :Ensuite, choisissez le pseudo de votre robot et tapez la commande suivante:"
       		 	putserv "NOTICE $nick :12/msg BotServ ASSIGN <#Nom du salon> <Pseudo du robot>"
        		putserv "NOTICE $nick :Pour faire parler le robot, tapez 12/msg BotServ SAY <#Votre salon> <message>"
			putserv "NOTICE $nick :Pour que le robot fasse une action (/me), 12/msg BotServ ACT <#Votre salon> <action>"
		}
	}
}


bind pub - !autovoice pub:autovoice
proc pub:autovoice { nick uhost handle channel arg } {
        global salon_aide
        foreach a $salon_aide {
                if {[string equal -nocase $channel $a]} {
			putserv "NOTICE $nick :Pour mettre un autovoice sur le salon, trois commandes a taper :"
			putserv "NOTICE $nick :12/msg ChanServ SET <#Votre Salon> XOP off"
			putserv "NOTICE $nick :12/msg ChanServ SET <#Votre Salon> SECURE off"
			putserv "NOTICE $nick :12/msg ChanServ LEVELS <#Votre Salon> SET AUTOVOICE 0"
		}
        }
}



bind pub - !commandeaop pub:aop
proc pub:aop { nick uhost handle channel arg } {
	global salon_aide
	foreach a $salon_aide {
		if {[string equal -nocase $channel $a]} {
			putserv "NOTICE $nick :Pour mettre un acces sop, aop, hop ou vop, remplacez le <aop> part l'acces choisi. Exemple : 12/msg ChanServ AOP <#Votre Salon> add <pseudo>"
			putserv "NOTICE $nick :Les grades : SOP = Super Op | AOP = Op | HOP = HalfOp | VOP = Voice"
		}
	}
}

bind pub - !quizz pub:quizz
proc pub:quizz { nick uhost handle channel arg } {
        global salon_aide
        foreach a $salon_aide {
                if {[string equal -nocase $channel $a]} {
			putserv "NOTICE $nick :Pour mettre un quizz sur votre salon il faut d'abord le telecharger."
			putserv "NOTICE $nick :Allez sur google et tapez les mots suivants pour faire la recherche : trivia bot irc."
			putserv "NOTICE $nick :Pour connecter le bot quizz sur le reseau, tapez 12/server irc.espace-irc.org -Dans la fenetre du quizz !- "
			putserv "NOTICE $nick :Puis, faites /12join <#Votre Salon> pour le faire rejoindre votre salon."
		}
	}
}

bind pub - !access pub:access
proc pub:access { nick uhost handle channel arg } {
        global salon_aide
        foreach a $salon_aide {
                if {[string equal -nocase $channel $a]} {
			putserv "NOTICE $nick :Pour mettre des access level, la commande est 12/msg ChanServ ACCESS <#Votre Salon> ADD <pseudo> <level>"
			putserv "NOTICE $nick :Levels est a remplacer par : 10 = sop | 5 = aop | 4 = hop |  3 = vop"
		}
	}
}

bind pub - !applet pub:applet
proc pub:applet { nick uhost handle channel arg } {
        global salon_aide
        foreach a $salon_aide {
                if {[string equal -nocase $channel $a]} {
			putserv "privmsg $salon_aide :Pour avoir un chat sur votre site,"
			putserv "PRIVMSG $salon_aide :Il faut se rendre sur **site*down** cliquez sur Inscription"
			putserv "PRIVMSG $salon_aide :Remplir le formulaire d'inscription. Ce formulaire permet déjà de configurer son futur applet de chat <page pour mettre sur son site>."
			putserv "PRIVMSG $salon_aide :Lorsque vous avez fini de complèter cette page, et qu'il y'a pas eu d'erreur. Il faut s'identifier sur Perso-Chat"
			putserv "PRIVMSG $salon_aide :Ainsi, vous aurez accès à l'espace membre"
			putserv "PRIVMSG $salon_aide :Vous pouvez vérifier votre configuration en cliquant sur Configuration"
			putserv "PRIVMSG $salon_aide :Pour installer le chat sur votre site internet , il suffit de cliquer sur <Installation>"
			putserv "PRIVMSG $salon_aide :Choisisr les couleurs de votre formulaire <vous pouvez les modifiers par la suite pour l'integration complete sur votre site> et validez"
			putserv "PRIVMSG $salon_aide :Vous recevez un code html à copier coller sur votre page internet"
			putserv "PRIVMSG $salon_aide :Il vous reste plus qu'a envoyer le fichier sur votre serveur web <upload ftp> et testez =)"
		}
	}
}
