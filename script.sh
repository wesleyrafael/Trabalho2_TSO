#!/bin/bash
			
adicionar(){
	if [ ! -e "$1" ]; then #verifica se o arquivo não existe e cria 
		touch agenda
	fi 
	
	echo $2:$3:$4:$5>>$1
	echo Contato salvo.
}

existe()
{
	cmd=`grep -wi ^$2 $1`
	if [ "$cmd" ] 
	then
		nomeExiste="S"
	else
		nomeExiste="N"
	fi
}

excluir()
{
	existe $1 $2
	if [ "$nomeExiste" = "N" ] 
	then
		echo Nao encontrado.
	else
		aux=`grep -vwi ^$2 $1`
		> $1
		for contato in $aux
		do
			echo $contato>>$1 
		done
		echo Contato excluido.
	fi
}

editar(){ #$1 = arquivo, $2 = nome, $3 = sobrenome, $4 = email, $5 = telefone
	excluir $1 $2 > /dev/null
	adicionar $1 $2 $3 $4 $5 > /dev/null
	echo Contato editado.
}

listarTodos()
{
	i=6
	cat<menu_exibir
	for contato in $*
		do	
			nome=`echo $contato | awk -F : '{print $1}'`						
			sobr=`echo $contato | awk -F : '{print $2}'`
			email=`echo $contato | awk -F : '{print $3}'`
			tel=`echo $contato | awk -F : '{print $4}'`						
			echo  Nome e Sobrenome: $nome $sobr	
			echo  Email: $email	
			echo  Telefone $tel
			echo
			let i++			
		done

			echo ------------------------------------------------------------------------
}

mostrarEntrada()
{
	tput cup 6 3 
	echo Nome: $1
	tput cup 7 3 
	echo Sobrenome: $2
	tput cup 8 3 
	echo Email: $3
	tput cup 9 3 
	echo Telefone: $4
}

trataSaida()
{
	tput cup 17 0 
	echo Deseja finalizar a agenda'?' S para sim e outra tecla para nao
	read fin
	if [ "$fin" = "S" ] || [ "$fin" = "s" ]
	then
		clear
		exit 0
	fi
}

mostrarErro()
{	
	if [ "$1" = "erro_add" ]
	then
		tput cup 5 3
	elif [ "$1" = "erro_edit" ]
	then
		tput cup 11 20
	fi
	echo $2
}

limparErro()
{
	if [ "$1" = "erro_add" ]
	then
		tput cup 5 3
	elif [ "$1" = "erro_edit" ]
	then
		tput cup 11 20
	fi
	echo "                              "
}

comandoAjuda()
{
	echo "Uso do comando:
Adicionar: ./script.sh -a nome sobrenome email telefone
Listar: ./script.sh -l
Remover: ./script.sh -d nome
Procurar: ./script.sh -s nome
Editar: ./script.sh -e nome sobrenome email telefone"
exit -1
} 

if test "$#" -eq 0 
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
			case "$opt" in 
				1) clear
					cat<menu_add

					while
						tput cup 10 34
						echo ""
						tput cup 10 34 
						read nome
						[ -z "$nome" ]
					do
						mostrarErro erro_add "Nome não pode ser vazio."
					done
						limparErro erro_add

					existe $file $nome
					if [ "$nomeExiste" = "S" ]
					then
						tput cup 5 3 
						echo Contato ja cadastrado. Deseja edita-lo? S-Sim,  Outra Tecla-Nao
						tput cup 6 3 
						read opt_cd
						
						if [ "$opt_cd" = "S" ] || [ $opt_cd = "s" ]
						then 
							clear
							cat<menu_editar
							tput cup 4 34 
							echo $nome
							tput cup 12 34 
							read opt_ed
							nome=`echo $cmd | awk -F : '{print $1}'`
							sobr=`echo $cmd | awk -F : '{print $2}'`
							email=`echo $cmd | awk -F : '{print $3}'`
							tel=`echo $cmd | awk -F : '{print $4}'`
							
							case "$opt_ed" in
								1) tput cup 13 10
									echo Novo nome:
									while true
									do
										tput cup 13 20
										echo "                                          "
										tput cup 13 20
										read novo_nome
										existe $file $novo_nome

										if [ -z "$novo_nome"  ]
										then
											mostrarErro erro_edit "Nome não pode ser vazio."
											continue
										elif [ "$nomeExiste" == "S" ]
										then
											mostrarErro erro_edit "Nome ja cadastrado.     "
										else
											break
										fi
									done
									limparErro erro_edit

									tput cup 14 3
									excluir $file $nome > /dev/null
									adicionar $file $novo_nome $sobr $email $tel > /dev/null
									echo Contato editado.
									sleep 1
									clear
									cat<menu_pesquisa
									tput cup 6 3 
									echo Nome: $novo_nome
									tput cup 7 3 
									echo Sobrenome: $sobr
									tput cup 8 3 
									echo Email: $email
									tput cup 9 3 
									echo Telefone: $tel
									clear
									cat<menu_pesquisa
									mostrarEntrada $novo_nome $sobr $email $tel
									echo; echo; echo; echo; echo; echo;;
								2) tput cup 13 10
									echo Novo sobrenome:
									while
										tput cup 13 25
										echo "                                          "
										tput cup 13 25
										read novo_sobr
										[ -z "$novo_sobr" ]
									do
										mostrarErro erro_edit "Sobrenome não pode ser vazio."
									done
									limparErro erro_edit

									tput cup 14 3
									editar $file $nome $novo_sobr $email $tel	
									sleep 1
									clear
									cat<menu_pesquisa
									mostrarEntrada $nome $novo_sobr $email $tel
									echo; echo; echo; echo; echo; echo;;
								3) tput cup 13 10
									echo Novo e-mail:
									tput cup 13 22
									while
										tput cup 13 22
										echo "                                          "
										tput cup 13 22;
										read novo_email
										[ -z "$novo_email" ]
									do
										mostrarErro erro_edit "E-mail não pode ser vazio."
									done
									limparErro erro_edit
									tput cup 14 3
									editar $file $nome $sobr $novo_email $tel
									sleep 1
									clear
									cat<menu_pesquisa
									mostrarEntrada $nome $sobr $novo_email $tel
									echo; echo; echo; echo; echo; echo;;
								4) tput cup 13 10;
									echo Novo telefone:
									while
										tput cup 13 24
										echo "                                          "
										tput cup 13 24
										read novo_tel
										[ -z "$novo_tel" ]
									do
										mostrarErro erro_edit "Telefone não pode ser vazio."
									done
									limparErro erro_edit
									tput cup 14 3
									editar $file $nome $sobr $email $novo_tel
									sleep 1
									clear
									cat<menu_pesquisa
									mostrarEntrada $nome $sobr $email $novo_tel
									echo; echo; echo; echo; echo; echo;;
								*) echo; echo; echo;
							esac
							else
								echo; echo; echo; echo; echo; echo; echo; echo; echo;
							fi	
					else
						while
							tput cup 11 34; echo; tput cup 11 34;
							read sobrenome
							[ -z "$sobrenome" ]
						do
							mostrarErro erro_add "Sobrenome não pode ser vazio."
						done
						limparErro erro_add

						while
							tput cup 12 34 ; echo; tput cup 12 34 ;
							read email
							[ -z "$email" ]
						do
							mostrarErro erro_add "E-mail não pode ser vazio."
						done
						limparErro erro_add
						
						
						while
							tput cup 13 34 ; echo; tput cup 13 34 ;
							read telefone
							[ -z "$telefone" ] 
						do
							mostrarErro erro_add "Telefone não pode ser vazio."
						done
						limparErro erro_add

						tput cup 14 10 ;
						echo Digite S para confirmar:
						tput cup 14 34 ;
						read confirm
						tput cup 15 3 ;
						
						if [ "$confirm" = "S" ] || [ "$confirm" = "s" ]
						then
							adicionar $file $nome $sobrenome $email $telefone
						else
							echo Contato não foi salvo.
						fi								
					fi

					sleep 1
					echo ;;
				2) clear
					cat<menu_pesquisa
					tput cup 4 34 
					read nome
				
					cmd=`grep -wi ^$nome $file`
					if [ ! "$cmd" ] 
					then	
						tput cup 9 3 
						echo Nao encontrado.
						echo; echo; echo; echo; echo; echo;
					else
						nome=`echo $cmd | awk -F : '{print $1}'`
						sobr=`echo $cmd | awk -F : '{print $2}'`
						email=`echo $cmd | awk -F : '{print $3}'`
						tel=`echo $cmd | awk -F : '{print $4}'`
						tput cup 6 3 
						echo Nome: $nome
						tput cup 7 3 
						echo Sobrenome: $sobr
						tput cup 8 3 
						echo Email: $email
						tput cup 9 3 
						echo Telefone: $tel
						echo; echo; echo; echo; echo; echo;
					fi
					echo ;;
				3) clear
					cat<menu_pesquisa
					tput cup 4 34 
					read nome
					tput cup 2 32 
					echo Remover'  '
					tput cup 9 3 
					excluir $file $nome
					
					sleep 1	
					echo; echo; echo; echo; echo; echo;
					
					echo ;;
				4) clear
					cat<menu_pesquisa
					tput cup 4 34 
					read nome
				
					cmd=`grep -wi ^$nome $file`
					if [ ! "$cmd" ] 
					then
						tput cup 9 3 
						echo Nao encontrado.
						echo; echo; echo; echo; echo; echo;
					else	
						clear
						cat<menu_editar
						tput cup 4 34 
						echo $nome
						tput cup 12 34 
						read opt_ed
						nome=`echo $cmd | awk -F : '{print $1}'`
						sobr=`echo $cmd | awk -F : '{print $2}'`
						email=`echo $cmd | awk -F : '{print $3}'`
						tel=`echo $cmd | awk -F : '{print $4}'`
						
						case "$opt_ed" in
							1) tput cup 13 10
								echo Novo nome:
								while true
								do
									tput cup 13 20
									echo "                                          "
									tput cup 13 20
									read novo_nome
									existe $file $novo_nome

									if [ -z "$novo_nome"  ]
									then
										mostrarErro erro_edit "Nome não pode ser vazio."
										continue
									elif [ "$nomeExiste" == "S" ]
									then
										mostrarErro erro_edit "Nome ja cadastrado.     "
									else
										break
									fi
								done
								limparErro erro_edit

								tput cup 14 3
								excluir $file $nome > /dev/null
								adicionar $file $novo_nome $sobr $email $tel > /dev/null
								echo Contato editado.
								sleep 1
								clear
								cat<menu_pesquisa
								tput cup 6 3 
								echo Nome: $novo_nome
								tput cup 7 3 
								echo Sobrenome: $sobr
								tput cup 8 3 
								echo Email: $email
								tput cup 9 3 
								echo Telefone: $tel
								clear
								cat<menu_pesquisa
								mostrarEntrada $novo_nome $sobr $email $tel
								echo; echo; echo; echo; echo; echo;;
							2) tput cup 13 10
								echo Novo sobrenome:
								while
									tput cup 13 25
									echo "                                          "
									tput cup 13 25
									read novo_sobr
									[ -z "$novo_sobr" ]
								do
									mostrarErro erro_edit "Sobrenome não pode ser vazio."
								done
								limparErro erro_edit

								tput cup 14 3
								editar $file $nome $novo_sobr $email $tel	
								sleep 1
								clear
								cat<menu_pesquisa
								mostrarEntrada $nome $novo_sobr $email $tel
								echo; echo; echo; echo; echo; echo;;
							3) tput cup 13 10
								echo Novo e-mail:
								tput cup 13 22
								while
									tput cup 13 22
									echo "                                          "
									tput cup 13 22;
									read novo_email
									[ -z "$novo_email" ]
								do
									mostrarErro erro_edit "E-mail não pode ser vazio."
								done
								limparErro erro_edit
								tput cup 14 3
								editar $file $nome $sobr $novo_email $tel
								sleep 1
								clear
								cat<menu_pesquisa
								mostrarEntrada $nome $sobr $novo_email $tel
								echo; echo; echo; echo; echo; echo;;
							4) tput cup 13 10;
								echo Novo telefone:
								while
									tput cup 13 24
									echo "                                          "
									tput cup 13 24
									read novo_tel
									[ -z "$novo_tel" ]
								do
									mostrarErro erro_edit "Telefone não pode ser vazio."
								done
								limparErro erro_edit
								tput cup 14 3
								editar $file $nome $sobr $email $novo_tel
								sleep 1
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
						tput cup 9 3 
						echo Agenda vazia.
						echo; echo; echo; echo; echo; echo;
					else
						clear
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

	if [ "$1" != "-l" ] && [ "$1" != "-a" ] && [ "$1" != "-d" ] && [ "$1" != "-s" ] && [ "$1" != "-e" ] && [ "$1" != "-h" ]
	then
		echo Comando Invalido.
		comandoAjuda
	else
		while getopts "lha:d:s:e:" opt_in 
	do
		case "$opt_in" in
			  "l") 
					lista=`cat $file| sort` 
					if [ ! "$lista" ] 
					then
						echo Agenda vazia.
					else
						listarTodos $lista
					
					fi;;
			   "a") 
					if [ "$#" -eq 5 ]
					then
						existe $file $2
						if [ "$nomeExiste" = 'N' ]
						then
							adicionar $file $2 $3 $4 $5
						else
							echo Usuario com o nome fornecido ja existe.
						fi
					else
						echo Comando Invalido
						comandoAjuda
					fi				
					;;
			   "d") 
					if [ "$#" -eq 2 ]
					then
						excluir $file $2
					else
						echo Comando Invalido
						comandoAjuda
					fi;;

			   "s")
					if [ "$#" -eq 2 ]
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
			  "e") 
					if [ "$#" -eq 5 ]
					then
						existe $file $2
						if [ "$nomeExiste" = "N" ]
						then	
							echo Nao encontrado.
							echo Deseja inserir um novo registro com os dados fornecidos? S-Sim, Outra Tecla-Nao	
							read opt_inserir
							if [ "$opt_inserir" = "S" ] || [ "$opt_inserir" = "s" ]
							then
								adicionar $file $2 $3 $4 $5
							fi
						else
							editar $file $2 $3 $4 $5
						fi
					else
						echo Comando Invalido
						comandoAjuda
					fi;;
			  "h") 
					comandoAjuda;;
			  "?") 
					comandoAjuda;;
		esac
	done
	fi
fi

