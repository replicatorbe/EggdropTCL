###########################################################################
################################  27/04/2003  #############################
############################  banflooders.tcl  v1.0  ###################
###########################################################################
### 		Author: 	sMug	(J�r�me Fafchamps)					      ###
### 		IRC:					                                   	###
###########################################################################

bind flud - pub bfldr
bind flud - ctcp bfldr

proc bfldr {nick uhost hand type channel} {
  global banmask botnick
  if {$channel == "*"} {return 0}
  if {([isvoice $nick $channel])} {return 0}
  if {([isop $nick $channel])} {return 0}  
  if {([ishalfop $nick $channel])} {return 0}  


set banmask "*!*[string range $uhost [string first "@" $uhost] end]"

                                   
#newchanban $channel $banmask $botnick " Flood ! Vous �tes Banni 30 minutes." 35
putserv "mode $channel +b $banmask"
putserv "kick $channel $nick Flood ! Vous �tes malheureusement banni"
putserv "notice $nick :Flood : Attendez 120 minutes pour revenir sur ce canal!"
dccbroadcast "Attention : $nick ($uhost) � �t� banni de $channel pour son FLOOD !"
}

putlog "Espace-IRC - Banflooders v1.0 by sMug Charg�"
