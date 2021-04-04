#!/usr/bin/env bash

# Créditos: @adi1090x

# Modificado By: @k4k4rot0

dir="~/.config/polybar/scripts/rofi"
uptime=$( uptime --pretty | sed 's/up //' | sed 's/\ years\?,/y/' | sed 's/\ weeks\?,/w/' | sed 's/\ days\?,/d/' | sed 's/\ hours\?,\?/h/' | sed 's/\ minutes\?/m/')

rofi_command="rofi -theme $dir/powermenu.rasi"

# Opções
shutdown=" Desligar"
reboot=" Reiniciar"
lock=" Bloquear Tela"
suspend=" Suspender"
logout=" Encerrar Sessão"
user=" Trocar de Usuário"

# Confirmação
confirm_exit() {
	rofi -dmenu\
	-i\
	-no-fixed-num-lines\
	-p " Tem certeza? : "\
	-theme $dir/confirmacao.rasi
}


# Mensagem
msg() {
	rofi -theme "$dir/mensagem.rasi" -e " Opções disponíveis são: - sim / SIM / s / S / não / NÃO / nao / n / N"
}


# Variável passada para rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown\n$user"

chosen="$(echo -e "$options" | $rofi_command -p "Tempo de Atividade: $uptime" -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
		ans=$(confirm_exit &)
		if [[ $ans == "sim" || $ans == "SIM" || $ans == "s" || $ans == "S" ]]; then
			systemctl poweroff
		elif [[ $ans == "não" || $ans == "nao" || $ans == "NÃO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $reboot)
		ans=$(confirm_exit &)
		if [[ $ans == "sim" || $ans == "SIM" || $ans == "s" || $ans == "S" ]]; then
			systemctl reboot
		elif [[ $ans == "não" || $ans == "nao" || $ans == "NÃO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $lock)
		if [[ -f $HOME/.local/bin/lockscreen ]]; then
			lockscreen
		elif [[ -f /usr/bin/betterlockscreen ]]; then
			betterlockscreen -l
		fi
        ;;
    $suspend)
		ans=$(confirm_exit &)
		if [[ $ans == "sim" || $ans == "SIM" || $ans == "s" || $ans == "S" ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $ans == "não" || $ans == "nao" || $ans == "NÃO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $logout)
		ans=$(confirm_exit &)
		if [[ $ans == "sim" || $ans == "SIM" || $ans == "s" || $ans == "S" ]]; then
			if 
			[[ "$DESKTOP_SESSION" == "i3" ]]; then
				i3-msg exit
			fi
		elif [[ $ans == "não" || $ans == "nao" || $ans == "NÃO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $user)
		ans=$(confirm_exit &)
		if [[ $ans == "sim" || $ans == "SIM" || $ans == "s" || $ans == "S" ]]; then
			if 
			[[ "$DESKTOP_SESSION" == "i3" ]]; then
				i3-msg exit
			fi
		elif [[ $ans == "não" || $ans == "nao" || $ans == "NÃO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
esac