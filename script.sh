#!/bin/bash

function trataSaida()
{
tput cup 17 0 ;
echo Deseja finalizar a agenda? S para sim e outra tecla para nao
read opt
if [ $opt = S ]
then
	exit 0
fi
}

if test $# -eq 0 
then 	#sem parametros
	while true
		
	do
		trap trataSaida SIGINT 
		clear
		cat<menu_princ
		while
			tput cup 10 34 ; read opt
			["$opt"=""]
		do
			:
		done
			case $opt in 
				1) clear
					cat<menu_add
					tput cup 10 34 ;
					read nome
					tput cup 11 34 ;
					read sobrenome
					tput cup 12 34 ;
					read email
					tput cup 13 34 ;
					read telefone
					tput cup 14 34 ;
					read confirm
					tput cup 15 34 ;
					
					file=./agenda
					if [ ! -e "$file" ]; then #verifica se o arquivo não existe. Se não existir, cria o arquivo.
					    touch agenda
					fi 
					
					if test $confirm = 'S'
					then
						echo $nome:$sobrenome:$email:$telefone>>$file
						echo Entrada salva com sucesso.
					else
						echo Entrada não foi salva.
					fi	

					sleep 1
					echo ;;
				2) clear
					cat<menu_pesquisa
					tput cup 4 34 ;
					read nome
				
					file=./agenda
					cmd=`grep -w ^$nome $file`
					if [ ! "$cmd" ] 
					then	
						tput cup 9 3 ;
						echo Nao encontrado.
						echo; echo; echo; echo; echo; echo;
					else
						sobr=`echo $cmd | awk -F : '{print $2}'`
						email=`echo $cmd | awk -F : '{print $3}'`
						tel=`echo $cmd | awk -F : '{print $4}'`
						tput cup 6 3 ;
						echo Nome: $nome
						tput cup 7 3 ;
						echo Sobrenome: $sobr
						tput cup 8 3 ;
						echo Email: $email
						tput cup 9 3 ;
						echo Telefone: $tel
						echo; echo; echo; echo; echo; echo;
					fi
					echo ;;
				3) clear
					cat<menu_pesquisa
					tput cup 4 34 ;
					read nome
				
					file=./agenda
					cmd=`grep -w ^$nome $file`
					if [ ! "$cmd" ] 
					then
						tput cup 9 3 ;
						echo Nao encontrado.
						echo; echo; echo; echo; echo; echo;
					else
						aux=`grep -v $nome $file`
						echo $aux
						echo Usuario excluido.
						echo; echo; echo; echo; echo; echo;
					fi
					echo ;;
				4) clear
					echo ;;
				5) clear 
					lista=`cat agenda`
					if [ ! "$lista" ] 
					then
						tput cup 9 3 ;
						echo Agenda vazia.
						echo; echo; echo; echo; echo; echo;
					else
						i=6
						cat<menu_exibir
						for contato in $lista
						do	
							nome=`echo $contato | awk -F : '{print $1}'`						
							sobr=`echo $contato | awk -F : '{print $2}'`
							email=`echo $contato | awk -F : '{print $3}'`
							tel=`echo $contato | awk -F : '{print $4}'`						
							tput cup $i 0 ;	
							echo '|' $nome $sobr	
							tput cup $i 32 ;
							echo '|' $email	
							tput cup $i 55 ;
							echo '|' $tel
							tput cup $i 72 ;
							echo '|'
							let i++			
						done

						echo ------------------------------------------------------------------------
					fi
					echo ;;
				6) clear
					exit 0 ;;
				*) clear
					echo Opcao invalida
					sleep 1	;;
			esac
			echo Tecle Enter para continuar
			read
	done
	
else	#com parametros
	echo CP
fi

