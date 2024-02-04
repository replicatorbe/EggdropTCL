# Credits: this script was inspired by UserLimiter v0.32 by ^Fluffy^

# Channels in which to activate limiting, this should be a list like
# "#elephants #wildlife #etc". Leave it set to "" if you wish to activate
# limiting on all channels the bot is on.
set cl_chans "#quizz #ma-bimbo #Ados"

# Limit to set (number of users on the channel + this setting)
set cl_limit 15

# Limit grace (if the limit doesn't need to be changed by more than this,
# don't bother setting a new limit)
set cl_grace 7

# Frequency of checking whether a new limit needs to be set (in minutes)
set cl_timer 1


# Don't edit anything below unless you know what you're doing

proc cl_dolimit {} {
  global cl_chans cl_limit cl_grace cl_timer
  timer $cl_timer cl_dolimit
  foreach chan [string tolower [channels]] {
    if {$cl_chans != ""} {
      if {[lsearch -exact [split $cl_chans] [string tolower $chan]] == -1} {continue}
    }
    if {![botisop $chan]} {continue}
    set numusers [llength [chanlist $chan]]
    set newlimit [expr $numusers + $cl_limit]
    if {[string match *l* [lindex [getchanmode $chan] 0]]} {
      set currlimit [string range [getchanmode $chan] [expr [string last " " [getchanmode $chan]] + 1] end]
    } else {
      set currlimit 0
    }
    if {$newlimit == $currlimit} {continue}
    if {$newlimit > $currlimit} {
      set difference [expr $newlimit - $currlimit]
    } elseif {$currlimit > $newlimit} {
      set difference [expr $currlimit - $newlimit]
    }
    if {$difference <= $cl_grace} {continue}
    pushmode $chan "+l" "$newlimit"
    flushmode $chan
    putlog "chanlimit: set +l $newlimit on $chan"
  }
}

proc cl_dccdolimit {hand idx arg} {
  foreach timer [timers] {
    if {[string match *cl_dolimit* $timer]} {
      killtimer [lindex $timer 2]
    }
  }
  putidx $idx "Checking limits..."
  cl_dolimit
}

proc cl_dccstoplimit {hand idx arg} {
  foreach timer [timers] {
    if {[string match *cl_dolimit* $timer]} {
      killtimer [lindex $timer 2]
      putidx $idx "Limiting is now OFF."
      return 0
    }
  }
  putidx $idx "Limiting is already off."
}

proc cl_dccstartlimit {hand idx arg} {
  global cl_timer
  if {[string match *cl_dolimit* [timers]]} {
    putidx $idx "Limiting is already on."
    return 0
  }
  timer $cl_timer cl_dolimit
  putidx $idx "Limiting is now ON."
}

proc cl_startlimit {} {
  global cl_timer
  if {[string match *cl_dolimit* [timers]]} {return 0}
  timer $cl_timer cl_dolimit
}

set cl_chans [string tolower $cl_chans]

cl_startlimit

bind dcc m|m dolimit cl_dccdolimit
bind dcc m|m stoplimit cl_dccstoplimit
bind dcc m|m startlimit cl_dccstartlimit

if {$cl_chans == ""} {
  putlog "Loaded chanlimit.tcl v1.5 by slennox (active on all channels)"
} else {
  putlog "Loaded chanlimit.tcl v1.5 by slennox (active on: [join $cl_chans ", "])"
}
