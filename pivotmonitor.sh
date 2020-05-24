#!/usr/bin/env bash

toggle () {
	if [ $PIVOTOUTPUT == "all" ]; then
		for MNT in "${PIVOT[@]}"; do
			PVT=$(echo $MNT | cut -d ',' -f 1)
			case $(echo $MNT | cut -d ',' -f 2) in
				normal)
					xrandr --output $PVT --rotate inverted
					unset PVT
					exit 0
					;;
				inverted)
					xrandr --output $PVT --rotate normal
					unset PVT
					exit 0
					;;
				left)
					xrandr --output $PVT --rotate right
					unset PVT
					exit 0
					;;
				right)
					xrandr --output $PVT --rotate left
					unset PVT
					exit 0
					;;
			esac
		done
	else
		for MNT in "${PIVOT[@]}"; do
			PVT=$(echo $MNT | cut -d ',' -f 1)
			if [ $PVT == $PIVOTOUTPUT ]; then
				case $(echo $MNT | cut -d ',' -f 2) in
					normal)
						xrandr --output $PVT --rotate inverted
						unset PVT
						exit 0
						;;
					inverted)
						xrandr --output $PVT --rotate normal
						unset PVT
						exit 0
						;;
					left)
						xrandr --output $PVT --rotate right
						unset PVT
						exit 0
						;;
					right)
						xrandr --output $PVT --rotate left
						unset PVT
						exit 0
						;;
				esac
			fi
		done
	fi		
}

clockwise () {
	if [ $PIVOTOUTPUT == "all" ]; then
                for MNT in "${PIVOT[@]}"; do
                        PVT=$(echo $MNT | cut -d ',' -f 1)
                        case $(echo $MNT | cut -d ',' -f 2) in
                                normal)
                                        xrandr --output $PVT --rotate right
                                        unset PVT
                                        exit 0
                                        ;;
                                inverted)
                                        xrandr --output $PVT --rotate left
                                        unset PVT
                                        exit 0
                                        ;;
                                left)
                                        xrandr --output $PVT --rotate normal
                                        unset PVT
                                        exit 0
                                        ;;
                                right)
                                        xrandr --output $PVT --rotate inverted
                                        unset PVT
                                        exit 0
                                        ;;
                        esac
                done
        else
                for MNT in "${PIVOT[@]}"; do
                        PVT=$(echo $MNT | cut -d ',' -f 1)
                        if [ $PVT == $PIVOTOUTPUT ]; then
                                case $(echo $MNT | cut -d ',' -f 2) in
                                        normal)
                                                xrandr --output $PVT --rotate right
                                                unset PVT
                                                exit 0
                                                ;;
                                        inverted)
                                                xrandr --output $PVT --rotate left
                                                unset PVT
                                                exit 0
                                                ;;
                                        left)
                                                xrandr --output $PVT --rotate normal
                                                unset PVT
                                                exit 0
                                                ;;
                                        right)
                                                xrandr --output $PVT --rotate inverted
                                                unset PVT
                                                exit 0
                                                ;;
                                esac
                        fi
                done
        fi
}

counterclockwise () {
	if [ $PIVOTOUTPUT == "all" ]; then
                for MNT in "${PIVOT[@]}"; do
                        PVT=$(echo $MNT | cut -d ',' -f 1)
                        case $(echo $MNT | cut -d ',' -f 2) in
                                normal)
                                        xrandr --output $PVT --rotate left
                                        unset PVT
                                        exit 0
                                        ;;
                                inverted)
                                        xrandr --output $PVT --rotate right
                                        unset PVT
                                        exit 0
                                        ;;
                                left)
                                        xrandr --output $PVT --rotate inverted
                                        unset PVT
                                        exit 0
                                        ;;
                                right)
                                        xrandr --output $PVT --rotate normal
                                        unset PVT
                                        exit 0
                                        ;;
                        esac
                done
        else
                for MNT in "${PIVOT[@]}"; do
                        PVT=$(echo $MNT | cut -d ',' -f 1)
                        if [ $PVT == $PIVOTOUTPUT ]; then
                                case $(echo $MNT | cut -d ',' -f 2) in
                                        normal)
                                                xrandr --output $PVT --rotate left
                                                unset PVT
                                                exit 0
                                                ;;
                                        inverted)
                                                xrandr --output $PVT --rotate right
                                                unset PVT
                                                exit 0
                                                ;;
                                        left)
                                                xrandr --output $PVT --rotate inverted
                                                unset PVT
                                                exit 0
                                                ;;
                                        right)
                                                xrandr --output $PVT --rotate normal
                                                unset PVT
                                                exit 0
                                                ;;
                                esac
                        fi
                done
        fi
}

version () {
	echo -e "Monitor pivot script v0.17.113-1\nWritten by Sidney Jeong, GNU GPL 3.0"
	exit 0
}

usage () {
	echo -e "Usage: pivotmonitor.sh [options]\n\n-o|--output [output|all] Specifies output to pivot. all tries to turn all outputs at the same time.\n-t|--toggle Toggle mode. Rotates the output 180 degrees.\n--cw|--clockwise Clockwise mode. Rotates the output 90 degrees clockwise.\n--ccw|--counterclockwise Counterclockwise mode. Rotater the output 90 degrees counterclockwise.\n-v|--version Shows version info of this script.\n-h|--help|--usage Shows this message."
	exit 0
}

declare -a PIVOT=()

OUTPUTLIST="$(xrandr -q | awk '{ print $1;}' | grep -iv -E '(screen|[0-9].*x[0-9].*)')"

readarray -t OUTPUTARRAY <<< "$OUTPUTLIST"

for MON in "${OUTPUTARRAY[@]}"; do
	if [ -n "$(xrandr -q | grep -E "$MON.*inverted.*inverted")" ]; then
		PIVOT+=("$MON,inverted")
	elif [ -n "$(xrandr -q | grep -E "$MON.*left.*left")" ]; then
		PIVOT+=("$MON,left")
	elif [ -n "$(xrandr -q | grep -E "$MON.*right.*right")" ]; then
		PIVOT+=("$MON,right")
	elif [ -n "$(xrandr -q | grep -iE "$MON.*dis")" ]; then
		PIVOT+=("$MON,disconnected")
	else
		PIVOT+=("$MON,normal")
	fi
done

while test $# -gt 0; do
	case "$1" in
		-t|--toggle)
			toggle
			shift
			;;
		--cw|--clockwise)
			clockwise
			shift
			;;
		--ccw|--conterclockwise)
			counterclockwise
			shift
			;;
		-v|--version)
			version
			shift
			;;
		-o|--output)
			shift
			if test $# -gt 0; then
				if [[ "${OUTPUTARRAY[@]}" =~ "$1" ]] || [ $1 == "all" ]; then
					export PIVOTOUTPUT=$1
				elif [[ "${PIVOT[@]}" =~ "$1,disconnected" ]]; then
					echo -e "The output you selected is currently disconnected.\nCheck your monitor connection and retry."
				else
					echo -e "Wrong output specified.\nPossible outputs are: ${OUTPUTARRAY[*]} all"
					exit 1
				fi
			else
				echo -e "No output specified.\nPossible outputs are: ${OUTPUTARRAY[*]} all"
				exit 1
			fi
			shift
			;;
		*)
			usage
			shift
			;;
	esac
done

