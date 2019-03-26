#!/bin/bash

function trataSaida()
{
tput cup 17 0 ;
echo Deseja finalizar a agenda? S para sim e outra tecla para nao
read fin
if [ $fin = S ]
then
	clear
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
					file=./agenda

					cadastrado=`grep -w ^$nome $file`
					if [ $cadastrado ]
					then
						tput cup 5 3 ;
						echo Usuario ja cadastrado. Deseja edita-lo? S-Sim,  Outra Tecla-Nao
						tput cup 6 3 ;
						read opt_cd
						
						if [ $opt_cd = 'S' ]
						then #editar
							echo oi
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
						tput cup 14 34 ;
						read confirm
						tput cup 15 34 ;
					

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
						aux=`grep -vw ^$nome $file`
						> $file
						for contato in $aux
						do
							echo $contato
							echo $contato>>$file 
						done
						tput cup 9 3 ;
						echo Usuario excluido.
						sleep 2
						echo; echo; echo; echo; echo; echo;
					fi
					echo ;;
				4) clear
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
						clear
						cat<menu_editar
						tput cup 4 34 ;
						echo $nome
						tput cup 12 34 ;
						read opt_ed
						
						case $opt_ed in
						1) tput cup 13 10;
							echo Novo nome:
							tput cup 13 20;
							read novo_nome
							sobr=`echo $cmd | awk -F : '{print $2}'`
							email=`echo $cmd | awk -F : '{print $3}'`
							tel=`echo $cmd | awk -F : '{print $4}'`
							
							aux=`grep -vw ^$nome $file`
							> $file
							for contato in $aux
							do
								echo $contato>>$file 
							done
							echo $novo_nome:$sobr:$email:$tel>>$file	
							echo ;;
						2) tput cup 13 10;
							echo Novo sobrenome:
							tput cup 13 25;
							read novo_sobr
							if [ ! $novo_sobr ]
							then
								tput cup 14 10;
								echo Sobrenome Invalido.
							else
								nome=`echo $cmd | awk -F : '{print $1}'`
								email=`echo $cmd | awk -F : '{print $3}'`
								tel=`echo $cmd | awk -F : '{print $4}'`
							
								aux=`grep -vw ^$nome $file`
								> $file
							for contato in $aux
							do
								echo $contato>>$file 
							done
							echo $nome:$novo_sobr:$email:$tel>>$file	
							fi
							echo ;;
						3) tput cup 13 10;
							echo Novo e-mail:
							tput cup 13 22;
							read novo_email
							nome=`echo $cmd | awk -F : '{print $1}'`
							sobr=`echo $cmd | awk -F : '{print $2}'`
							tel=`echo $cmd | awk -F : '{print $4}'`
							
							aux=`grep -vw ^$nome $file`
							> $file
							for contato in $aux
							do
								echo $contato>>$file 
							done
							echo $nome:$sobrenome:$novo_email:$tel>>$file	
							echo ;;
						4) tput cup 13 10;
							echo Novo telefone:
							tput cup 13 24;
							read novo_tel
							nome=`echo $cmd | awk -F : '{print $1}'`
							sobr=`echo $cmd | awk -F : '{print $2}'`
							email=`echo $cmd | awk -F : '{print $3}'`
							
							aux=`grep -vw ^$nome $file`
							> $file
							for contato in $aux
							do
								echo $contato>>$file 
							done
							echo $nome:$sobrenome:$email:$novo_tel>>$file	
							echo ;;
						*) echo ;;
						esac
						echo; echo; echo; echo; echo; echo;
					fi
					echo ;;
				5) clear 
					lista=`cat agenda | sort	` 
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
			echo Pressione Enter para continuar
			read
	done
	
else	#com parametros
	echo CP
fi

