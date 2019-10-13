STORE WPAGINA + 1 TO WPAGINA
IF WSALIDA = "M"
   if WPAGINA <> 1
      STORE "OPRIMA <ENTER> PARA CONTINUAR o <ESC> PARA SALIR" TO MES
      DO AVISO WITH MES
      IF READKEY()=12 .OR. READKEY()=268
         STORE .T. TO WFLAGEXIT
         RETURN
      ENDIF
   endif
   @ 0,0 clear
ENDIF
IF WSALIDA = "M"
   @ 0,0 SAY QQWW
ELSE
   @ 0,0 SAY CHR(14)+QQWW
ENDIF
@ 1,60 SAY "PAGINA:"+STR(WPAGINA,4)
@ 2,0 SAY "ESTADOS DE CUENTAS"
@ 2,60 SAY "FECHA :"+DTOC(DATE())
@ 04,00  SAY "FECHA   "
@ 04,09  SAY "TO"
@ 04,12  SAY "No.OPERACION"
@ 04,25  SAY "        DEBITOS"
@ 04,45  SAY "       CREDITOS"
@ 04,65  SAY "          SALDO"
@ 05,00  SAY "--------"
@ 05,09  SAY "--"
@ 05,12  SAY "------------"
@ 05,25  SAY "---------------"
@ 05,45  SAY "---------------"
@ 05,65  SAY "---------------"
STORE 6 TO WLINEA
RETURN
