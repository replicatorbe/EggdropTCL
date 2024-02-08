#
# Auteur sMug (J�r�me Fafchamps)
#Licence d'utilisation libre :
#
#Ce script est fourni tel quel, sans garantie d'aucune sorte, expresse ou implicite. L'auteur ne peut en aucun cas �tre tenu responsable #de tout dommage r�sultant de l'utilisation de ce script.
#
#Cependant, l'auteur esp�re que ce script sera utile � d'autres utilisateurs et contribuera � am�liorer leurs exp�riences avec Eggdrop.
#
#En utilisant ce script, vous acceptez ces termes de licence.


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
    putserv "KICK $chan $nick : Arr�te ton Flood! S'il te plait..."
    dccbroadcast "Attention : $nick ($uhost) utilise plus de  90 caract�res sans espace sur $chan !"
  }
}
putlog "Espace-IRC - caps v1.0 by sMug Charg�"
