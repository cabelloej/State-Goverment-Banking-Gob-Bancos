STORE PAGINA+1 TO PAGINA
IF WSALIDA = "M"
   IF PAGINA <> 1
      STORE "OPRIMA <ENTER> PARA CONTINUAR" TO MES
      DO AVISO WITH MES
   ENDIF
   @ 0,0 CLEAR
ENDIF

@ 1,00 SAY CHR(18)
IF WSALIDA = "M"
   @ 0,0 SAY QQWW
ELSE
   @ 0,0 SAY CHR(14)+QQWW
ENDIF
@ 1,00 SAY "SALDOS POR CLASIFICACION"
@ 1,60 SAY "FECHA : "+DTOC(DATE())
@ 2,60 SAY "PAGINA: "+STR(PAGINA,3)
@ 3,00SAY CHR(15)
@ 3,00 SAY "CODIGO"
@ 3,10 SAY "BANCO"
@ 3,45 SAY "TIPO DE CUENTA"
@ 3,80 SAY "No. DE CUENTA"
@ 3,115 SAY "        BOLIVARES"
@ 4,00 SAY "------"
@ 4,10 SAY "------------------------------"
@ 4,45 SAY "------------------------------"
@ 4,80 SAY "------------------------------"
@ 4,115 SAY "-----------------"
STORE 5 TO LINEA
RETURN
