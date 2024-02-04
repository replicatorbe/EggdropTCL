# TapaVu v1.1 (BSeen v1.4.2 modifié et corrigé)
# Neon's Web (http://www.eggdrop.online.fr)
# by Neon (chris.neon@bigfoot.com)

# *Description:
#  Le très connu BSeen ne nécessite pas de description je pense!
#  C'est vraiment du bon boulot, modifications et corrections mineures.

# *Commandes:
#  -pub: !tapavu <nick>
#  -dcc: .tapavu <nick> (idem que la commande publique)
#        .tapavufix     (corrige la DataBase)
#        .tapavustats   (infos sur la DataBase)

#####################################################################
## Configuration du Script ##########################################
#####################################################################

# Limite des entrées de la DataBase :
set tapavu(limit) 10000

# Caractères maximum d'un nickname :
set tapavu(nicksize) 15

# Channels où les demandes seront ignorés :
set tapavu(nopub) "#eggdrop"

# Channels où les réponses seront envoyés par notice à l'utilisateur :
set tapavu(quietchan) "#france #espace-irc #quizz"

# Channels que le Bot ignore (aucune entrée enregistrée) :
set tapavu(nolog) ""

# Channels que le Bot doit gérer -uniquement- :
set tapavu(log) ""

# SmartSearch permet de renvoyer la réponse la plus précise possible à l'utilisateur (0=non, 1=oui) :
set tapavu(smartsearch) 0

# Log des demandes DCC/Msg/Publiques (0=non, 1=oui) :
set tapavu(logqueries) 1

# Répertoire où sera stockée la DataBase :
set tapavu(path) "tapavu/"

# Préfixe des commandes du script :
set tapavu(command) "!"

# Anti flood sur les commandes du Bot x:y (x=nombre de fois, y=secondes) :
set tapavu(flood) 5:10

# Ignorer l'utilisateur après son flood (0=non, 1=oui) :
set tapavu(ignore) 1

# Si oui, combien de temps (en minutes) :
set tapavu(ignoretime) 1

# Laisser faire les utilisateurs ayant certains flags :
set tapavu(ignflags) "fmnov|fmnov"

#####################################################################
#####################################################################
#####################################################################

proc tapavu:flood:init {} {
global tapavu tapavuflood
set tapavu(floodnum) [lindex [split $tapavu(flood) :] 0]
set tapavu(floodtime) [lindex [split $tapavu(flood) :] 1]
set i [expr $tapavu(floodnum) - 1]
while {$i >= 0} {
   set tapavuflood($i) 0
   incr i -1
}
}
tapavu:flood:init

proc tapavu:flood {nick uhost} {
global tapavu tapavuflood botnick
if {$tapavu(floodnum) == 0} {
   return 0
}
set i [expr $tapavu(floodnum) - 1]
while {$i >= 1} {
   set tapavuflood($i) $tapavuflood([expr $i - 1])
   incr i -1
}
set tapavuflood(0) [unixtime]
if {[expr [unixtime] - $tapavuflood([expr $tapavu(floodnum) - 1])] <= $tapavu(floodtime)} {
   if {$tapavu(ignore)} {
      newignore [join [maskhost *!*[string trimleft $uhost ~]]] $botnick "Flood" $tapavu(ignoretime)
   }
   return 1
} {
   return 0
}
}

proc tapavu:filt {data} {
regsub -all -- \\\\ $data \\\\\\\\ data
regsub -all -- \\\[ $data \\\\\[ data
regsub -all -- \\\] $data \\\\\] data
regsub -all -- \\\} $data \\\\\} data
regsub -all -- \\\{ $data \\\\\{ data
regsub -all -- \\\" $data \\\\\" data
return $data
}

proc tapavu:read {} {
global tapavulist userfile tapavu
if {![string match */* $userfile]} { set name [lindex [split $userfile .] 0] } {
   set temp [split $userfile /]
   set temp [lindex $temp [expr [llength $temp]-1]]
   set name [lindex [split $temp .] 0]
}
if {![file exists $tapavu(path)tapavu.db]} {
   if {![file exists $tapavu(path)tapavu.bak]} {
      putlog "DataBase introuvable! Création d'une nouvelle."
      return
   } {
      exec cp $tapavu(path)tapavu.bak $tapavu(path)tapavu.db
      putlog "Ancienne DataBase non trouvée, utilisation de la sauvegarde."
   }
}
set fd [open $tapavu(path)tapavu.db r]
while {![eof $fd]} {
   set inp [gets $fd]
   if {[eof $fd]} { break }
   if {[string trim $inp " "] == ""} { continue }
   set nick [lindex $inp 0]
   set tapavulist([string tolower $nick]) $inp
}
close $fd
putlog "Liste de la DataBase chargée ([array size tapavulist] au total)."
}

proc tapavu:update {} {
global tapavu
tapavu:save
tapavu:read
}

set tapavu(updater) 10402
if {[info exists tapavulist]} {
   if {[info exists tapavu(oldver)]} {
      if {$tapavu(oldver) < $tapavu(updater)} { tapavu:update }
   } { tapavu:update }
}
set tapavu(oldver) $tapavu(updater)
if {![info exists tapavulist] || [array size tapavulist] == 0} {
   putlog "Chargement de la DataBase..."
   tapavu:read
}


bind time -|- "*5 * * * *" tapavu:timedsave
proc tapavu:timedsave {min h d m y} {
tapavu:save
}

proc tapavu:save {} {
global tapavulist userfile tapavu
if {[array size tapavulist] == 0} { return }
if {![string match */* $userfile]} { set name [lindex [split $userfile .] 0] } {
   set temp [split $userfile /]
   set temp [lindex $temp [expr [llength $temp]-1]]
   set name [lindex [split $temp .] 0]
}
if {[file exists $tapavu(path)tapavu.db]} { catch { exec cp -f $tapavu(path)tapavu.db $tapavu(path)tapavu.bak } }
set fd [open $tapavu(path)tapavu.db w]
set id [array startsearch tapavulist]
putlog "Sauvegarde de la DataBase..."
puts $fd "#$tapavu(updater)"
while {[array anymore tapavulist $id]} {
   set item [array nextelement tapavulist $id]
   puts $fd "$tapavulist($item)"
}
array donesearch tapavulist $id
close $fd
}


if {[string trimleft [lindex $version 1] 0] >= 1050000} {
   bind part -|- * tapavu:part  
} {
   if {[lsearch -exact [bind part -|- *] tapavu:part] > -1} { unbind part -|- * tapavu:part }
   bind part -|- * tapavu:part:old
}

proc tapavu:part:old {a b c d} {tapavu:part $a $b $c $d ""}
proc tapavu:part {nick uhost hand channel reason} {
tapavu:add $nick "[list $uhost] [unixtime] part $channel [split $reason]"
}

bind join -|- * tapavu:join
proc tapavu:join {nick uhost hand channel} {
tapavu:add $nick "[list $uhost] [unixtime] join $channel"
}

bind sign -|- * tapavu:sign
proc tapavu:sign {nick uhost hand channel reason} {
tapavu:add $nick "[list $uhost] [unixtime] quit $channel [split $reason]"
}

bind kick -|- * tapavu:kick
proc tapavu:kick {nick uhost hand channel knick reason} {
tapavu:add $knick "[getchanhost $knick $channel] [unixtime] kick $channel [list $nick] [list $reason]"
}

bind nick -|- * tapavu:nick
proc tapavu:nick {nick uhost hand channel newnick} {
set time [unixtime]
tapavu:add $nick "[list $uhost] [expr $time -1] nick $channel [list $newnick]"
tapavu:add $newnick "[list $uhost] $time rnck $channel [list $nick]"
}

bind splt -|- * tapavu:splt
proc tapavu:splt {nick uhost hand channel} {
tapavu:add $nick "[list $uhost] [unixtime] splt $channel"
}

bind rejn -|- * tapavu:rejn
proc tapavu:rejn {nick uhost hand channel} {
tapavu:add $nick "[list $uhost] [unixtime] rejn $channel"
}

bind pub -|- $tapavu(command)seen tapavu:pub:req
proc tapavu:pub:req {nick uhost hand channel arg} {
if {$arg == ""} {
   puthelp "PRIVMSG $channel :Qui ça $nick ?"
   return 1
}
tapavu:pubreq $nick $uhost $hand $channel $arg 0
}

proc tapavu:pubreq {nick uhost hand channel arg no} {
global botnick tapavu
if ![matchattr $nick $tapavu(ignflags) $channel] {
   if {[tapavu:flood $nick $uhost]} {
      return 0
   }
}
set i 0
if {[lsearch -exact $tapavu(nopub) [string tolower $channel]] >= 0} { return 0 }
if {$tapavu(log) != "" && [lsearch -exact $tapavu(log) [string tolower $channel]] == -1} { return 0 }
set arg [tapavu:filt [join $arg]]
if {[lsearch -exact $tapavu(quietchan) [string tolower $channel]] >= 0} { set target "notice $nick" } { set target "privmsg $channel" }
if {[string match *\\\** [lindex $arg 0]]} {
   set output [tapavu:mask $channel $hand $arg]
   puthelp "$target :$output"
   return $tapavu(logqueries)
}
set data [tapavu:filt [string trimright [lindex $arg 0] ?!.,]]
if {[string tolower $nick] == [string tolower $data] } {
   puthelp "$target :$nick, tu me fais perdre mon temps !"
   return $tapavu(logqueries)
}
if {[string tolower $data] == [string tolower $botnick] } {
   puthelp "$target :Je suis là $nick !"
   return $tapavu(logqueries)
}
if {[onchan $data $channel]} {
   puthelp "$target :$nick, $data est ici !"
   return $tapavu(logqueries)
}
set output [tapavu:output $channel $nick $data $no]
if {$output == 0} { return 0 }
puthelp "$target :$output"
return $tapavu(logqueries)
}

proc tapavu:output {channel nick data no} {
global botnick tapavu version tapavulist
set data [string trimright [lindex $data 0] ?!.,]
if {$data == ""} { return 0 }
if {[string length $data] > $tapavu(nicksize)} { return 0 } 
if {$tapavu(smartsearch) != 1} { set no 1 }
if {$no == 0} {
   set matches ""
   set hand ""
   set addy ""
   if {[lsearch -exact [array names tapavulist] $data] != "-1"} { 
      set addy [lindex $tapavulist([string tolower $data]) 1]
      set hand [finduser $addy]
      foreach item [tapavu:mask dcc ? [maskhost $addy]] {
         if {[lsearch -exact $matches $item] == -1} { set matches "$matches $item" }
      }
   }
   if {[validuser $data]} { set hand $data }
   if {$hand != "*" && $hand != ""} {
      if {[string trimleft [lindex $version 1] 0]>1030000} { set hosts [getuser $hand hosts] } { set hosts [gethosts $hand] }
      foreach addr $hosts {
         foreach item [string tolower [tapavu:mask dcc ? $addr]] {
            if {[lsearch -exact [string tolower $matches] [string tolower $item]] == -1} { set matches [concat $matches $item] }
         }
      }
   }
   if {$matches != ""} {
      set matches [string trimleft $matches " "]
      set len [llength $matches]
      if {$len == 1} { return [tapavu:search $channel [lindex $matches 0]] }
      if {$len > 20} { return [concat Il y a $len réponses, précise un peu plus ta demande $nick.] }
      set matches [tapavu:sort $matches]
      set key [lindex $matches 0]
      if {[string tolower $key] == [string tolower $data]} { return [tapavu:search $channel $key] }
      if {$len <= 5} {
         set output [concat Il y a $len réponses (dans l'ordre) : [join $matches].]
         set output [concat $output  [tapavu:search $channel $key]]
         return $output
      } {
         set output [concat Il y a $len réponses, voici les 5 plus récentes (dans l'ordre) : [join [lrange $matches 0 4]].]
         set output [concat $output  [tapavu:search $channel $key]]
         return $output
      }
   }
}
set temp [tapavu:search $channel $data]
if {$temp != 0} { return $temp } {
   if {![validuser [tapavu:filt $data]] || [string trimleft [lindex $version 1] 0]<1030000} { 
      return "$nick, je me rapelle pas avoir vu $data."
   } {
      set tapavumatch [getuser $data laston]
      if {[getuser $data laston] == ""} { return "$nick, je me rapelle pas avoir vu $data." }
      if {($channel != [lindex $tapavumatch 1] || $channel == "bot" || $channel == "msg" || $channel == "dcc") && [validchan [lindex $tapavumatch 1]] && [lindex [channel info [lindex $tapavumatch 1]] 23] == "+secret"} {
         set channel "-secret-"
      } {
         set channel [lindex $tapavumatch 1]
      }
      return [concat $nick, $data était sur $channel il y a [tapavu:time [lindex $tapavumatch 0]].]
   }
}
}

proc tapavu:search {channel nick} {
global tapavulist
if {![info exists tapavulist]} { return 0 }
if {[lsearch -exact [array names tapavulist] [string tolower $nick]] != "-1"} { 
   set data [split $tapavulist([string tolower $nick])]
   set nick [join [lindex $data 0]]
   set addy [lindex $data 1]
   set time [lindex $data 2]
   set marker 0
   if {([string tolower $channel] != [string tolower [lindex $data 4]] || $channel == "dcc" || $channel == "msg" || $channel == "bot") && [validchan [lindex $data 4]] && [lindex [channel info [lindex $data 4]] 23] == "+secret"} {
      set channel "-secret-"
   } {
      set channel [lindex $data 4]
   }
   switch -- [lindex $data 3] {
      part { set output [concat $nick ($addy) est parti de $channel il y a [tapavu:time $time].] }
      quit { set output [concat $nick ($addy) a quitté $channel il y a [tapavu:time $time] ([join [lrange $data 5 e]]).] }
      kick { set output [concat $nick ($addy) a été ejecter de $channel par [lindex $data 5] il y a [tapavu:time $time] ([join [lrange $data 6 e]]).] }
      rnck { set output [concat [lindex $data 5] ($addy) a changé son pseudo pour $nick sur [lindex $data 4] il y a [tapavu:time $time].] }
      nick { set output [concat $nick ($addy) a changé son pseudo pour [lindex $data 5] sur [lindex $data 4] il y a [tapavu:time $time].] }
      splt { set output [concat $nick ($addy) est parti de $channel (split) il y a [tapavu:time $time].] }
      rejn { set output [concat $nick ($addy) a rejoint $channel après un split il y a [tapavu:time $time].] }
      join { set output [concat $nick ($addy) est arrivé sur $channel il y a [tapavu:time $time].] }
      default { set output "Error" }
   }
   return $output
} { return 0 }
}

proc tapavu:add {nick data} {
global tapavulist tapavu
if {[lsearch -exact $tapavu(nolog) [string tolower [lindex $data 3]]] >= 0 || ($tapavu(log) != "" && [lsearch -exact $tapavu(log) [string tolower [lindex $data 3]]] == -1)} { return }
set tapavulist([string tolower $nick]) "[tapavu:filt $nick] $data"
}

bind time -|-  "*5 * * * *" tapavu:trim

proc tapavu:lsortcmd {a b} {
global tapavulist
set a [lindex $tapavulist([string tolower $a]) 2]
set b [lindex $tapavulist([string tolower $b]) 2]
if {$a > $b} {
   return 1
} elseif {$a < $b} {
   return -1
} {
   return 0
}
}

proc tapavu:trim {min h d m y} {
global tapavu tapavulist
if {![info exists tapavulist] || ![array exists tapavulist]} { return }
set list [array names tapavulist]
set range [expr [llength $list] - $tapavu(limit) - 1]
if {$range < 0} { return }
set list [lsort -increasing -command tapavu:lsortcmd $list]
foreach item [lrange $list 0 $range] { unset tapavulist($item) }
}

proc tapavu:mask {ch nick arg} {
global tapavulist tapavu
set matches ""
set temp ""
set i 0
set arg [join $arg]
set channel [lindex $arg 1]
if {$channel != "" && [string trimleft $channel #] != $channel} {
   if {![validchan $channel]} { return "Je ne suis pas sur $channel." } { set channel [string tolower $channel] }
} {
   set channel ""
}
if {![info exists tapavulist]} { return "Aucune réponse pour $arg." }
set data [tapavu:filt [string tolower [lindex $arg 0]]]
set maskfix 1
while $maskfix {
   set mark 1
   if [regsub -all -- \\?\\? $data ? data] { set mark 0 }
   if [regsub -all -- \\*\\* $data * data] { set mark 0 }
   if [regsub -all -- \\*\\? $data * data] { set mark 0 }
   if [regsub -all -- \\?\\* $data * data] { set mark 0 }
   if $mark { break }
}
set id [array startsearch tapavulist]
while {[array anymore tapavulist $id]} {
   set item [array nextelement tapavulist $id]
   if {$item == ""} { continue }
   set i 0
   set temp ""
   set match [lindex $tapavulist($item) 0]
   set addy [lindex $tapavulist($item) 1]
   if {[string match $data $item![string tolower $addy]]} {
      set match [tapavu:filt $match]
      if {$channel != ""} {
         if {[string match $channel [string tolower [lindex $tapavulist($item) 4]]]} { set matches [concat $matches $match] }
      } { set matches [concat $matches $match] }
   }
}
array donesearch tapavulist $id
set matches [string trim $matches " "]
if {$nick == "?"} { return [tapavu:filt $matches] }
set len [llength $matches]
if {$len == 0} { return "$nick, je n'ai pas de données sur $arg." }
if {$len == 1} { return [tapavu:output $ch $nick $matches 1] }
if {$len > 20} { return "Il y a $len réponses à $arg, précise un peu plus ta demande $nick." }
set matches [tapavu:sort $matches]
if {$len <= 5} {
   set output [concat $nick, j'ai $len réponses à $arg (dans l'ordre) : [join $matches].]
} {
   set output "$nick, il y a $len réponses à $arg, voici les 5 plus récentes (dans l'ordre) : [join [lrange $matches 0 4]]."
}
return [concat $output [tapavu:output $ch $nick [lindex [split $matches] 0] 1]]
} 

proc tapavu:sort {data} {
global tapavulist
set data [tapavu:filt [join [lsort -decreasing -command tapavu:lsortcmd $data]]]
return $data
}

bind dcc mn| seenfix tapavu:dcc:fix
proc tapavu:dcc:fix {hand idx arg} {
global tapavulist
set total 0
set channel [string tolower [lindex $arg 0]]
set id [array startsearch tapavulist]
while {[array anymore tapavulist $id]} {
   set item [array nextelement tapavulist $id]
   if {$channel == [string tolower [lindex $tapavulist($item) 4]]} {
      incr total
      lappend remlist $item
   }
}
array donesearch tapavulist $id
if {$total > 0} {
   foreach item $remlist {unset tapavulist($item)}
}
if {$total == 0} {
   putdcc $idx "Aucune entrée n'a été effacée de la DataBase."
   return 1
} else {
   putdcc $idx "$total entrée(s) effacée(s) de la DataBase."
}
}

bind dcc -|- seen tapavu:dcc:req
proc tapavu:dcc:req {hand idx arg} {
tapavu:dccreq $hand $idx $arg 0
}

proc tapavu:dccreq {hand idx arg no} {
set arg [tapavu:filt [join $arg]]
global tapavu
if {[string match *\\\** [lindex $arg 0]]} {
   set output [tapavu:mask dcc $hand $arg]
   putdcc $idx $output
   return $tapavu(logqueries)
}
set search [tapavu:filt [lindex $arg 0]]
set output [tapavu:output dcc $hand $search $no]
if {$output == 0} { return 0 }
putdcc $idx "$output"
return $tapavu(logqueries)
}

bind dcc -|- seenstats tapavu:dcc:stats
proc tapavu:dcc:stats {hand idx arg} {
if {$arg == ""} { set arg [console $idx] }
putdcc $idx "[tapavu:stats [lindex $arg 0]]"
return 1
}

proc tapavu:stats {channel} {
global tapavulist tapavu
set channel [string tolower $channel]
if {![validchan $channel]} { return "Je ne suis pas sur $channel." }
set id [array startsearch tapavulist]
set totalc 0
set temp ""
while {[array anymore tapavulist $id]} {
   set item [array nextelement tapavulist $id]
   set tok [lindex $tapavulist($item) 2]
   if {$tok == ""} {
      putlog "Entrée endommagée : $item"
      continue
   }
   set time [lindex $tapavulist($item) 2]
   if {$time == ""} { continue }
   if {$channel == [string tolower [lindex $tapavulist($item) 4]]} { incr totalc }
}
array donesearch tapavulist $id
set total [array size tapavulist]
return "$channel représente [expr 100*$totalc/$total]% ($totalc/$total) des entrées. J'ai actuellement [array size tapavulist]/$tapavu(limit) entrées dans la DataBase."
}

proc tapavu:time {last} {
	set ans 0
	set jours 0
	set heures 0
	set mins 0
	set time [expr [unixtime] - $last]
	if {$time < 60} {return "$time sec"}
	if {$time >= 31536000} {
		set ans [expr int([expr $time/31536000])]
		set time [expr $time - [expr 31536000*$ans]]
	}
	if {$time >= 86400} {
		set jours [expr int([expr $time/86400])]
		set time [expr $time - [expr 86400*$jours]]
	}
	if {$time >= 3600} {
		set heures [expr int([expr $time/3600])]
		set time [expr $time - [expr 3600*$heures]]
	}
	if {$time >= 60} { set mins [expr int([expr $time/60])] }
	if {$ans == 0} { set output "" } elseif {$ans == 1} { set output "1 an," } { set output "$ans ans," }
	if {$jours == 1} { lappend output "1 jour," } elseif {$jours > 1} { lappend output "$jours jours," }
	if {$heures == 1} { lappend output "1 heure," } elseif {$heures > 1} { lappend output "$heures heures," }
	if {$mins == 1} { lappend output "1 minute" } elseif {$mins > 1} { lappend output "$mins minutes"}

	if {[lindex [ctime $last] 0] == "Mon"} { set jour "Lundi" }
	if {[lindex [ctime $last] 0] == "Tue"} { set jour "Mardi" }
	if {[lindex [ctime $last] 0] == "Wed"} { set jour "Mercredi" }
	if {[lindex [ctime $last] 0] == "Thu"} { set jour "Jeudi" }
	if {[lindex [ctime $last] 0] == "Fri"} { set jour "Vendredi" }
	if {[lindex [ctime $last] 0] == "Sat"} { set jour "Samedi" }
	if {[lindex [ctime $last] 0] == "Sun"} { set jour "Dimanche" }

	if {[lindex [ctime $last] 1] == "Jan"} { set mois "Janvier" }
	if {[lindex [ctime $last] 1] == "Feb"} { set mois "Février" }
	if {[lindex [ctime $last] 1] == "Mar"} { set mois "Mars" }
	if {[lindex [ctime $last] 1] == "Apr"} { set mois "Avril" }
	if {[lindex [ctime $last] 1] == "May"} { set mois "Mai" }
	if {[lindex [ctime $last] 1] == "Jun"} { set mois "Juin" }
	if {[lindex [ctime $last] 1] == "Jul"} { set mois "Juillet" }
	if {[lindex [ctime $last] 1] == "Aug"} { set mois "Août" }
	if {[lindex [ctime $last] 1] == "Sep"} { set mois "Septembre" }
	if {[lindex [ctime $last] 1] == "Oct"} { set mois "Octobre" }
	if {[lindex [ctime $last] 1] == "Nov"} { set mois "Novembre" }
	if {[lindex [ctime $last] 1] == "Dec"} { set mois "Décembre" }

	lappend output "($jour [lindex [ctime $last] 2] $mois [lindex [ctime $last] 4] à [lindex [ctime $last] 3])"

	return [string trimright [join $output] ", "]
}

putlog "TapaVu v1.1 by Neon loaded! modifier par BN_ChoCo -> remplacé par seen"