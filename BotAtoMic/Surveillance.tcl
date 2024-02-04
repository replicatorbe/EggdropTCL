##########################################################################
# Syst�me de surveillance des lamers                                     #
##########################################################################

  bind dcc   -  surveiller           dcc:surveiller
  bind dcc   o  +surveiller          dcc:+surveiller
  bind dcc   o  -surveiller          dcc:-surveiller
  bind dcc   o  chsurveiller         dcc:chsurveiller

proc heure {} {strftime "%H:%M"}
bind join S * join:indesirable
proc join:indesirable {nick host hand chan} {
  set msg "^C4Gardez l'oeil sur $nick : [getuser $hand Comment]."
  putserv "PRIVMSG #Moderation : -> $msg"
  putserv "PRIVMSG #Staff : -> $msg"
  dccbroadcast $msg
  foreach user [chanlist $chan o] {
        putquick "NOTICE $user :$msg"
  }
}

proc dcc:+surveiller {hand idx arg} {
  if {[llength $arg] < 2} {putdcc $idx "Syntaxe : .+surveiller <nick> <commentaire>"
                           return 0}
  if {[llength $arg] < 5} {putdcc $idx "Le commentaire doit �tre un peu plus explicite."
                           return 0}

  set nick [lindex $arg 0]
  set host [maskhost [getchanhost $nick]]
  set com [join [split [lrange $arg 1 end]]]
  if {[validuser $nick]} {
        if {[matchattr $nick S]} {
                putdcc $idx "$nick est d�j� dans la liste des usagers � surveiller."
                if {![validuser [nick2hand $nick]]} {
                        addhost $nick $host
                        putdcc $idx "Masque $host ajout�."
                        return
                }
        } elseif {[matchattr $hand A]} {
                chattr $nick -p
        } else {
                putdcc $idx "$nick est un user avec acc�s ici, je ne peux donc traiter �a directement."
                return
		}
  } else {
        if ![onchan $nick] {
                putdcc $idx "$nick n'est pas sur l� pr�sentement. Invite-le juste pour le adder ;-P"
                return 0
        }
        adduser $nick $host
        setuser $nick LASTON [unixtime]
  }
  chattr $nick +dS
  setuser $nick comment "$com ([date], [heure])"
  setuser $nick XTRA ADD $hand
  #si tu as un script de news : "Ajout d'un usager � la liste de gens � surveiller par $hand. ->  $nick  <- Motif: $com"
  putdcc $idx "Usager ajout�."
  return 1
}

proc dcc:-surveiller {hand idx arg} {
        set nick [lindex $arg 0]
        if {$nick == "" || ![matchattr $nick S]} {
                putdcc $idx "### Mauvaise syntaxe ou usager inconnu"
                putdcc $idx "    .-surveiller <nom d'usager (.surveiller)>"
        } else {
                deluser $nick
                putdcc $idx "J'ai retir� la mention surveiller de $nick"
                #si tu as un script de news : "admins $nick n'est plus un usager � surveiller. Il vient d'�tre r�habilit� par $hand."
        }
}

proc dcc:surveiller {hand idx arg} {
        putdcc $idx "Sont � surveiller :"
        foreach list [userlist S] {
                putdcc $idx "---> $list <--- ([getuser $list HOSTS]) -- par [getuser $list XTRA ADD]"
                putdcc $idx "     Motif:  [getuser $list Comment]"
        }
}

proc dcc:chsurveiller {handle idx arg} {
        if {$arg == ""} {
                putdcc $idx "## Syntaxe : chsurveiller <nick> <nouveau commentaire>"
                return
        }

        #Lamer � surveiller
        set lamer_handle [lindex $arg 0]
        set lamer_motif  [lrange $arg 1 end]
        if {![validuser $lamer_handle]} {
                putdcc $idx "Qui c'est, $lamer_handle ?"
                return
        } elseif {![matchattr $lamer_handle S]} {
                putdcc $idx "$lamer_handle n'est pas � surveiller mais [Level [getuserinfo $lamer_handle Niveau]] ;P"
                return
        } elseif {$lamer_motif == ""} {
                putdcc $idx "Actuellement, $lamer_handle est surveill� pour ce motif :"
                putdcc $idx [getuser $lamer_handle COMMENT]
                return
        } else {
                setuser $lamer_handle COMMENT "$lamer_motif ($handle, [date], [heure])"
                return 1
        }
}