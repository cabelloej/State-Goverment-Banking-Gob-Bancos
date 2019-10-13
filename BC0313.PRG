SELECT 1
USE BCSUBCTA INDEX BCSUBCTA
SELECT 2
USE BCCTAS   INDEX BCCTAS

SAVE SCRE TO WSCRE99
store .t. to viendo
do while viendo
   RESTORE SCRE FROM WSCRE99
   STORE 0             TO WTOTAL
   STORE 0             TO WSALDOCTA
   STORE SPACE(4)      TO XCUENTA
   STORE SPACE(4)      TO XSUBCUENTA
   STORE "****"        TO WRUPCTA
   STORE 0             TO WCOUNTRUP
   STORE .F. TO WENTRO
   @ 04,0 clear to 09,40
   @ 04,0 to 09,40
   @ 04,13 SAY " SALDOS POR CUENTAS "
   @ 06,1 say "CUENTA      :"
   @ 07,1 say "SUBCUENTA   :"
   @ 08,1 say "SALIDA      :"
   @ 06,14 GET XCUENTA
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF XCUENTA = SPACE(4)
      STORE "TODAS" TO WCTADES
   ELSE
      STORE "  "    TO WCTADES
   ENDIF
   @ 06,32 SAY WCTADES

   @ 07,14 GET XSUBCUENTA
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   IF XSUBCUENTA = SPACE(4)
      STORE "TODAS" TO WSUBCTADES
   ELSE
      STORE "  "    TO WSUBCTADES
   ENDIF
   @ 07,32 SAY WSUBCTADES

   STORE "SELECCIONE LA SALIDA: (M)ONITOR, (I)MPRESORA" TO TEX
   STORE "MI" TO WCH
   DO PREGUNTA
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   STORE WCH TO WSALIDA
   STORE 0   TO WPAGINA
   STORE 100 TO WLINEA
   IF WSALIDA = "I"
      STORE 55 TO WSALTO
      STORE "IMPRESORA" TO WSALIDES
   ELSE
      STORE 18 TO WSALTO
      STORE "MONITOR" TO WSALIDES
   ENDIF
   @ 08,14 SAY WSALIDES

   STORE "OPCIONES: (C)ONTINUAR, (S)ALIR" TO TEX
   STORE "CS" TO WCH
   DO PREGUNTA
   IF WCH = "S"
      exit
   ENDIF
   IF WSALIDA = "I"
      SET DEVI TO PRINT
   ELSE
      SET DEVI TO SCRE
   ENDIF

   SELECT 1
   GO TOP
   DO WHILE .NOT. EOF()
      *** FILTROS
      IF XCUENTA <> SPACE(4) .AND. XCUENTA <> CTA
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XSUBCUENTA <> SPACE(4) .AND. XSUBCUENTA <> SUBCTA
         SELECT 1
         SKIP
         LOOP
      ENDIF
      *** FIN FILTROS

      STORE .T. TO WENTRO
      STORE DESCRI TO WSUBCTADES
      IF CTA <> WRUPCTA
         STORE WCOUNTRUP + 1 TO WCOUNTRUP
         IF WCOUNTRUP > 1
            STORE WLINEA + 1 TO WLINEA
            @ WLINEA ,63 SAY "-----------------"
            STORE WLINEA + 1 TO WLINEA
            @ WLINEA ,32 SAY "SALDO CUENTA "+WRUPCTA+" Bs.:"
            @ WLINEA ,60 SAY WSALDOCTA PICTURE "#,###,###,###,###.##"
            STORE WLINEA + 1 TO WLINEA
            @ WLINEA, 00 SAY REPLICATE ("-",80)
            STORE 0 TO WSALDOCTA
         ENDIF
         STORE CTA TO WRUPCTA
         STORE .T. TO WDISCTA
         SELECT 2
         FIND &WRUPCTA
         IF EOF()
            STORE "NO REGISTRADA EN MAESTRO" TO WCTADES
         ELSE
            STORE DESCRI                     TO WCTADES
         ENDIF
      ELSE
         STORE .F. TO WDISCTA
      ENDIF
      SELECT 1
      STORE WLINEA+1 TO WLINEA
      IF WLINEA >=WSALTO
         STORE WPAGINA + 1 TO WPAGINA
         IF WSALIDA = "M"
            if WPAGINA <> 1
               STORE "OPRIMA <ENTER> PARA CONTINUAR o <ESC> PARA SALIR" TO MES
               DO AVISO WITH MES
               IF READKEY()=12 .OR. READKEY()=268
                  EXIT
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
         @ 2,00 SAY "LISTADO DE SALDO POR CUENTA"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "DESCRIPCION DE LA CUENTA"
         @ 4,32 SAY "DESCRIPCION DE LA SUBCUENTA"
         @ 4,63 SAY "            SALDO"
         @ 5,00 SAY "------------------------------"
         @ 5,32 SAY "------------------------------"
         @ 5,63 SAY "-----------------"
         STORE 6 TO WLINEA
      ENDIF
      IF WDISCTA
         @ WLINEA , 00 SAY WCTADES
      ENDIF
      SELECT 1
      @ WLINEA , 32 SAY WSUBCTADES
      @ WLINEA , 60 SAY SALDO PICTURE "#,###,###,###,###.##"
      STORE WSALDOCTA + SALDO TO WSALDOCTA
      STORE WTOTAL + SALDO TO WTOTAL
      SKIP
   ENDDO
   IF WENTRO
      *** IMPRIME ULTIMA CTA
      STORE WLINEA + 1 TO WLINEA
      @ WLINEA ,63 SAY "-----------------"
      STORE WLINEA + 1 TO WLINEA
      @ WLINEA ,32 SAY    "SALDO CUENTA "+WRUPCTA+" Bs.:"
      @ WLINEA ,60 SAY WSALDOCTA PICTURE "#,###,###,###,###.##"
      STORE WLINEA + 1 TO WLINEA
      @ WLINEA, 00 SAY REPLICATE ("-",80)
      STORE 0 TO WSALDOCTA
   ENDIF
   *** FIN ULTIMA CTA
   IF WTOTAL > 0
      @ WLINEA+1, 32  SAY "TOTAL INFORME:"
      @ WLINEA+1 ,60  SAY WTOTAL PICTURE "#,###,###,###,###.##"
   ENDIF
   IF WSALIDA = "M"
      STORE "OPRIMA <ENTER> PARA FINALIZAR" TO MES
      DO AVISO WITH MES
   ELSE
      EJECT
      SET DEVI TO SCRE
   ENDIF
ENDDO
close data
close index
return



