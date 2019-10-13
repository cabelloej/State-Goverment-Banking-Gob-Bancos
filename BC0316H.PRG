      STORE WPAGE + 1 TO WPAGE
      IF WSALIDA = "M"
         SET DEVI TO SCRE
         IF WPAGE <> 1
            STORE "OPRIMA <ENTER> PARA CONTINUAR" TO MES
            DO AVISO WITH MES
            @ 0,0 CLEAR
         ELSE
            @ 0,0 CLEAR
         ENDIF
         STORE QQWW TO WTOPHEAD
      ELSE
         SET DEVI TO PRINT
         STORE CHR(14)+QQWW TO WTOPHEAD
      ENDIF
      @ 00,00 SAY WTOPHEAD
      @ 01,00 SAY "DIRECCION DE ADMINISTRACION"
      @ 01,63 SAY "PAGINA:"+STR(WPAGE,3)
      @ 02,00 SAY "DEPARTAMENTO DE TESORERIA"
      @ 02,63 SAY "FECHA :"+DTOC(DATE())
      @ 03,00 SAY "CONCILIACION BANCARIA"
      @ 05,00 SAY "CUENTA: "+WCUENTA+" _ "+WCUENTADES
      @ 05,50 SAY "A"+CHR(165)+"O:"+STR(WYEAR,4)
      @ 05,65 SAY "MES:"+STR(WMONTH,2)
      @ 07,00 SAY "FECHA   "
      @ 07,11 SAY "TO"
      @ 07,14 SAY "No.OPERACION"
      @ 07,27 SAY "        DEBITOS"
      @ 07,47 SAY "       CREDITOS"
      @ 07,65 SAY "          SALDO"
      @ 08,00 SAY "--------"
      @ 08,11 SAY "--"
      @ 08,14 SAY "------------"
      @ 08,27 SAY "---------------"
      @ 08,47 SAY "---------------"
      @ 08,65 SAY "---------------"
      STORE 09 TO WLINE
      RETURN
