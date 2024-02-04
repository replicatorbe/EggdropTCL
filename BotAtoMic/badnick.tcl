###########################################################################
################################  27/04/2002  #############################
############################  badnick.tcl  v1.0  ###################
###########################################################################
### 		Author: 	sMug	(Jérôme Fafchamps)					    ###
### 		IRC:						                                ###
###########################################################################
set BandNicks { "*fuck*"
		*chaudasse*
            *penis*
            *connard*
            *conard*
		*batar*
            *prostitu*
		*sexe*
		*couill*
		*vagin*
		*salop*
            *flood*
            *uworl*
            *hitler*
            *suce*
            *poitrine*
            *chatte*en*
            *baiseur*
            *baise*ta*
            *gro*merd*
            *enculer*
            *gro*sein*
            *le*pen*
            *gros*nichon*
		*coquine*
            *queue*
            *gro*sexe*
            *pipeuse*
            *pipeur*
            *puceau*
            *pucelle*
            *fai*caca*
            *F_U_C_K*
            *S_A_L_O_P*
            *C_O_N_N_A_R*
            *T_A_M_E_R*
            *E_N_C_U_L*
            *foutre*
		*hacke*
            *fil*pute*
            *homosex*
            *sodomi*
            *baise*
            *cochonn*
            *pedophil*
            *hotmail*
            *phreaking*
            *carding*
            *grosse*pute*
            *killerdeop*
            *branlette*
            *gueule*
            *proxy*
}

set BandNickChan "*"

set ZBan "Change de pseudo!"

###########################################################################

bind join - * BandNick

proc BandNick {nick uhost hand chan} {
 global botnick BandNickChan BandNicks channel ZName ZZ ZBan text
 if {(([lsearch -exact [string tolower $BandNickChan] [string tolower $chan]] != -1)  || ($BandNickChan == "*"))} {
  set temp 0
	foreach i [string tolower $BandNicks] {
	if {[string match *$i* [string tolower $nick]]} {
	set BadReason "$ZBan"
   putserv "KICK $chan $nick :$ZBan"
 #  newchanban $chan $nick*!*@* $botnick $BadReason 20
 putserv "MODE $chan +b $nick*!*@*"
   dccbroadcast "Attention : Une personne sur $chan a un mauvais pseudo ($nick)($uhost)"
   putserv "NOTICE $nick : Ton pseudo ($nick) est interdit sur $chan . Pour changer de pseudo tape : /nick ton_nouveau_pseudo"
   putserv "NOTICE $nick : Pour rejoindre le salon une fois que tu as changé de pseudo tape : /join $chan ! Si tu n'y arrives pas, rejoinds le salon #Aide" 
return 0

 	}
 	}
	}	
	}

bind nick - * banned_nicks 

proc banned_nicks {nick uhost hand chan newnick } {
   global botnick ZBan BandNickChan BandNicks channel text 
if {([isop $newnick $chan])} {return 0}     
if {(([lsearch -exact [string tolower $BandNickChan] [string tolower $chan]] != -1)  || ($BandNickChan == "*"))} {
  set temp 0
	foreach i [string tolower $BandNicks] {
	if {[string match *$i* [string tolower $newnick]]} {
	set BadReason "$ZBan"
   putserv "KICK $chan $newnick :$ZBan"
 #  newchanban $chan $newnick*!*@* $botnick $BadReason 20
 putserv "MODE $chan +b $newnick*!*@*"
   dccbroadcast "Attention : Une personne sur $chan a un mauvais pseudo ($nick)($uhost)"
   putserv "NOTICE $newnick : Pour rejoindre le canal une fois que tu as changé de pseudo tape : /join $chan" 
return 0
}
}
}
}

putlog "Espace-IRC - Badnick v1.0 by sMug Chargé"
