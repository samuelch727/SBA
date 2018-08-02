#!/bin/bash

LAZBUILD="lazbuild"
PROJECT="/Users/samuel/Documents/SelfProgramming/SBA/Programming/Main.lpi"

if $LAZBUILD $PROJECT; then

  if [ $1 = "test" ]; then
    "/Users/samuel/Documents/SelfProgramming/SBA/Programming/Main" 
  fi
fi
