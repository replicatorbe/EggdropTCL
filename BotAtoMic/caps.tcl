bind pubm - * caps_pubm
proc caps_pubm {nick uhost hand chan text } {
  if [matchattr $hand f] {return 0}
  if {$chan == "#quizz"} {return 0}
  if {([isvoice $nick $chan])} {return 0}
  if {([isop $nick $chan])} {return 0}
  set upper 0
  set space 0
  foreach i [split $text {}] {
    if [string match \[A-Z\] $i] {
      incr upper
    }
    if {$i == " "} {
      incr space
    }
  }
  if {$upper > 15} {
    putserv "NOTICE $nick : Veuilliez ne pas utilisez de MAJUSCULES sur ce canal! Merci."
    dccbroadcast "Attention : $nick ($uhost) utilise plus de 15 majuscules sur $chan"
  }
  if {$space == 0 && [string length $text] > 90} {
    putserv "KICK $chan $nick : Arrête ton Flood! S'il te plait..."
    dccbroadcast "Attention : $nick ($uhost) utilise plus de  90 caractères sans espace sur $chan !"
  }
}
putlog "Espace-IRC - caps v1.0 by sMug Chargé"
