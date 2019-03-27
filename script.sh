#!/bin/bash

function adicionar(){
	if [ ! -e "$1" ]; then #verifica se o arquivo não existe e cria 
		touch agenda
	fi 
	
	echo $2:$3:$4:$5>>$1
	echo Usuario cadastrado.
}

function excluir()
{
	cmd=`grep -wi ^$2 $1`
	if [ ! "$cmd" ] 
	then
		echo Nao encontrado.
	else
		aux=`grep -vwi ^$2 $1`
		> $1
		for contato in $aux
		do
			echo $contato>>$1 
		done
		echo Usuario excluido.
	fi
}

function editar(){ #$1 = arquivo, $2 = nome, $3 = sobrenome, $4 = email, $5 = telefone
	excluir $1 $2 > /dev/null
	adicionar $1 $2 $3 $4 $5 > /dev/null
	echo Usuario editado.
}

function listarTodos()
{
	clear
	i=6
	cat<menu_exibir
	for contato in $*
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
}

function mostrarEntrada()
{
	tput cup 6 3 ;
	echo Nome: $1
	tput cup 7 3 ;
	echo Sobrenome: $2
	tput cup 8 3 ;
	echo Email: $3
	tput cup 9 3 ;
	echo Telefone: $4
}

function trataSaida()
{
	tput cup 17 0 ;
	echo Deseja finalizar a agenda'?' S para sim e outra tecla para nao
	read fin
	if [ $fin = S ]
	then
		clear
		exit 0
	fi
}

function comandoAjuda()
{
	echo "Uso do comando:
Adicionar: ./script.sh add nome sobrenome email telefone
Listar: ./script.sh list
Remover: ./script.sh del nome
Procurar: ./script.sh search nome
Editar: ./script.sh edit nome sobrenome email telefone"
exit -1
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
			file=./agenda
			case $opt in 
				1) clear
					cat<menu_add
					tput cup 10 34 ;
					read nome
					#file=./agenda

					cmd=`grep -wi ^$nome $file`
					if [ $cmd ]
					then
						tput cup 5 3 ;
						echo Usuario ja cadastrado. Deseja edita-lo? S-Sim,  Outra Tecla-Nao
						tput cup 6 3 ;
						read opt_cd
						
						if [ $opt_cd = 'S' ]
						then 
							clear
							cat<menu_editar
							tput cup 4 34 ;
							echo $nome
							tput cup 12 34 ;
							read opt_ed
							
							sobr=`echo $cmd | awk -F : '{print $2}'`
							email=`echo $cmd | awk -F : '{print $3}'`
							tel=`echo $cmd | awk -F : '{print $4}'`
							
							
							case $opt_ed in
								1) tput cup 13 10;
									echo Novo nome:
									tput cup 13 20;
									read novo_nome
									tput cup 14 3;
									excluir $file $nome > /dev/null
									adicionar $file $novo_nome $sobr $email $tel > /dev/null
									echo Usuario editado.
									sleep 1
									clear
									cat<menu_pesquisa
									tput cup 6 3 ;
									echo Nome: $novo_nome
									tput cup 7 3 ;
									echo Sobrenome: $sobr
									tput cup 8 3 ;
									echo Email: $email
									tput cup 9 3 ;
									echo Telefone: $tel
									clear
									cat<menu_pesquisa
									mostrarEntrada $novo_nome $sobr $email $tel
									echo; echo; echo; echo; echo; echo;;
								2) tput cup 13 10;
									echo Novo sobrenome:
									tput cup 13 25;
									read novo_sobr
									tput cup 14 3;	
									editar $file $nome $novo_sobr $email $tel	
									sleep 1;
									clear
									cat<menu_pesquisa
									mostrarEntrada $nome $novo_sobr $email $tel
									echo; echo; echo; echo; echo; echo;;
								3) tput cup 13 10;
									echo Novo e-mail:
									tput cup 13 22;
									read novo_email
									tput cup 14 3;
									editar $file $nome $sobr $novo_email $tel
									sleep 1;
									clear
									cat<menu_pesquisa
									mostrarEntrada $nome $sobr $novo_email $tel
									echo; echo; echo; echo; echo; echo;;
								4) tput cup 13 10;
									echo Novo telefone:
									tput cup 13 24;
									read novo_tel
									tput cup 14 3;
									editar $file $nome $sobr $email $novo_tel
									sleep 1;
									clear
									cat<menu_pesquisa
									mostrarEntrada $nome $sobr $email $novo_tel
									echo; echo; echo; echo; echo; echo;;
								*) echo; echo; echo;
							esac
							#echo; echo; echo; echo;
							else
								echo; echo; echo; echo; echo; echo; echo; echo; echo;
							fi	
					else
						tput cup 11 34 ;
						read sobrenome
						tput cup 12 34 ;
						read email
						tput cup 13 34 ;
						read telefone
						tput cup 14 10 ;
						echo Digite S para confirmar:
						tput cup 14 34 ;
						read confirm
						tput cup 15 3 ;
						
						if [ $confirm = 'S' ]
						then
							adicionar $file $nome $sobrenome $email $telefone
						else
							echo Entrada não foi salva.
						fi								
					fi

					sleep 1
					echo ;;
				2) clear
					cat<menu_pesquisa
					tput cup 4 34 ;
					read nome
				
					#file=./agenda
					cmd=`grep -wi ^$nome $file`
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
					tput cup 9 3 ;
					excluir $file $nome
					
					sleep 1	
					echo; echo; echo; echo; echo; echo;
					
					echo ;;
				4) clear
					cat<menu_pesquisa
					tput cup 4 34 ;
					read nome
				
					#file=./agenda
					cmd=`grep -wi ^$nome $file`
					if [ ! "$cmd" ] 
					then
						tput cup 9 3 ;
						echo Nao encontrado.
						echo; echo; echo; echo; echo; echo;
					else	
						clear
						cat<menu_editar
						tput cup 4 34 ;
						echo $nome
						tput cup 12 34 ;
						read opt_ed
						
						sobr=`echo $cmd | awk -F : '{print $2}'`
						email=`echo $cmd | awk -F : '{print $3}'`
						tel=`echo $cmd | awk -F : '{print $4}'`
						
						
						case $opt_ed in
							1) tput cup 13 10;
								echo Novo nome:
								tput cup 13 20;
								read novo_nome
								tput cup 14 3;
								excluir $file $nome > /dev/null
								adicionar $file $novo_nome $sobr $email $tel > /dev/null
								echo Usuario editado.
								sleep 1
								clear
								cat<menu_pesquisa
								tput cup 6 3 ;
								echo Nome: $novo_nome
								tput cup 7 3 ;
								echo Sobrenome: $sobr
								tput cup 8 3 ;
								echo Email: $email
								tput cup 9 3 ;
								echo Telefone: $tel
								clear
								cat<menu_pesquisa
								mostrarEntrada $novo_nome $sobr $email $tel
								echo; echo; echo; echo; echo; echo;;
							2) tput cup 13 10;
								echo Novo sobrenome:
								tput cup 13 25;
								read novo_sobr
								tput cup 14 3;	
								editar $file $nome $novo_sobr $email $tel	
								sleep 1;
								clear
								cat<menu_pesquisa
								mostrarEntrada $nome $novo_sobr $email $tel
								echo; echo; echo; echo; echo; echo;;
							3) tput cup 13 10;
								echo Novo e-mail:
								tput cup 13 22;
								read novo_email
								tput cup 14 3;
								editar $file $nome $sobr $novo_email $tel
								sleep 1;
								clear
								cat<menu_pesquisa
								mostrarEntrada $nome $sobr $novo_email $tel
								echo; echo; echo; echo; echo; echo;;
							4) tput cup 13 10;
								echo Novo telefone:
								tput cup 13 24;
								read novo_tel
								tput cup 14 3;
								editar $file $nome $sobr $email $novo_tel
								sleep 1;
								clear
								cat<menu_pesquisa
								mostrarEntrada $nome $sobr $email $novo_tel
								echo; echo; echo; echo; echo; echo;;
							*) echo; echo; echo;
						esac
					fi
					echo ;;
				5) clear 
					lista=`cat $file | sort` 
					if [ ! "$lista" ] 
					then
						tput cup 9 3 ;
						echo Agenda vazia.
						echo; echo; echo; echo; echo; echo;
					else
						listarTodos $lista
					fi
					echo ;;
				6) clear
					exit 0 ;;
				*) clear
					echo Opcao invalida
					sleep 1	;;
			esac
			echo Pressione Enter para continuar
			read
	done
else	#com parametros
	file=./agenda
	case $1 in
		  "list") 
				if [ $# -eq 1 ]
				then
					lista=`cat $file| sort` 
					if [ ! "$lista" ] 
					then
						tput cup 9 3 ;
						echo Agenda vazia.
						echo; echo; echo; echo; echo; echo;
					else
						listarTodos $lista
					fi
				else
					echo Comando Invalido
					comandoAjuda
				fi;;
		   "add") 
				if [ $# -eq 5 ]
				then
					adicionar $file $2 $3 $4 $5
				else
					echo Comando Invalido
					comandoAjuda
				fi				
				;;
		   "del") 
				if [ $# -eq 2 ]
				then
					excluir $file $2
				else
					echo Comando Invalido
					comandoAjuda
				fi;;

		"search")
				if [ $# -eq 2 ]
				then
					cmd=`grep -wi ^$2 $file`
					if [ ! "$cmd" ] 
					then	
						echo Nao encontrado.
					else
						sobr=`echo $cmd | awk -F : '{print $2}'`
						email=`echo $cmd | awk -F : '{print $3}'`
						tel=`echo $cmd | awk -F : '{print $4}'`
						echo Dados de $2
						echo Nome: $2
						echo Sobrenome: $sobr
						echo Email: $email
						echo Telefone: $tel
					fi
				else
					echo Comando Invalido
					comandoAjuda
				fi;;	
		  "edit") 
				if [ $# -ge 2 ] && [ $# -le 5 ] 
				then
					cmd=`grep -wi ^$2 $file`
					if [ ! "$cmd" ] 
					then	
						echo Nao encontrado.
					else
						editar $file $2 $3 $4 $5
					fi
				else
					echo Comando Invalido
					comandoAjuda
				fi;;
		  "help") 
				comandoAjuda;;
		       *) 
				echo Comando Invalido; comandoAjuda;;
	esac
#	while getopts "lha:d:s:e:" OPT; do
#		case "$OPT" in
#			"l") echo list;;
#			"a") echo add;;
#			"d") echo del;;
#			"s") echo search;;
#			"e") echo edit;;
#			"h") echo 'help';;
#			"?") echo -1;;
#		esac
#	done
fi

