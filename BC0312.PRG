select 1
USE BCOPERA index BCOPERA1

SAVE SCRE TO WSCRE99
store .t. to viendo
do while viendo
   RESTORE SCRE FROM WSCRE99
   STORE SPACE(4)      TO XCUENTA
   STORE SPACE(4)      TO XSUBCUENTA
   STORE CTOD("01-01-"+   STR( YEAR(DATE()) )) TO XDESDE
   STORE CTOD("31-12-"+   STR( YEAR(DATE()) )) TO XHASTA
   STORE SPACE(2)      TO XTIPOPE
   STORE SPACE(12)     TO XNUMOPE
   STORE 0             TO XMONTO1
   STORE 9999999999.99 TO XMONTO2
   STORE SPACE(2)      TO XESTATUS
   STORE SPACE(2)      TO XTIPREF
   STORE SPACE(12)     TO XNUMREF
   STORE SPACE(12)     TO XBENEFI

   @ 04,0 clear to 19,40
   @ 04,0 to 19,40
   @ 04,10 SAY " OPERACIONES BANCARIAS "
   @ 06,1 say "CUENTA      :"
   @ 07,1 say "SUBCUENTA   :"
   @ 08,1 say "FECHA >=    :"
   @ 09,1 say "FECHA <=    :"
   @ 10,1 say "TIPO OPERAC.:"
   @ 11,1 say "No.  OPERAC.:"
   @ 12,1 say "MONTO >=    :"
   @ 13,1 say "MONTO <=    :"
   @ 14,1 say "ESTATUS     :"
   @ 15,1 say "TIPO REFCIA.:"
   @ 16,1 say "No.  REFCIA.:"
   @ 17,1 say "BENEFICIARIO:"
   @ 18,1 say "SALIDA (M/I):"

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

   @ 08,14 GET XDESDE
   @ 09,14 GET XHASTA
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   IF XDESDE > XHASTA
      STORE "ERROR EN FECHAS, VERIFIQUE." TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF

   @ 10,14 GET XTIPOPE
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   IF XTIPOPE = SPACE(2)
      STORE "TODOS" TO WTIPOPEDES
   ELSE
      STORE "  "    TO WTIPOPEDES
   ENDIF
   @ 10,32 SAY WTIPOPEDES

   @ 11,14 GET XNUMOPE
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   IF XNUMOPE = SPACE(12)
      STORE "TODOS" TO WNUMOPEDES
   ELSE
      STORE "  "    TO WNUMOPEDES
   ENDIF
   @ 11,32 SAY WNUMOPEDES

   @ 12,14 GET XMONTO1 PICTURE "####,###,###.##"
   @ 13,14 GET XMONTO2 PICTURE "####,###,###.##"
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   IF XMONTO1 > XMONTO2
      STORE "ERROR EN MONTOS, VERIFIQUE" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF

   @ 14,14 GET XESTATUS
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   IF XESTATUS = SPACE(2)
      STORE "TODOS" TO WESTATDES
   ELSE
      STORE "  "    TO WESTATDES
   ENDIF
   @ 14,32 SAY WESTATDES

   @ 15,14 GET XTIPREF
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   IF XTIPREF = SPACE(2)
      STORE "TODOS" TO WTIPREFDES
   ELSE
      STORE "  "    TO WTIPREFDES
   ENDIF
   @ 15,32 SAY WTIPREFDES

   @ 16,14 GET XNUMREF
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   IF XNUMREF = SPACE(12)
      STORE "TODOS" TO WNUMREFDES
   ELSE
      STORE "  "    TO WNUMREFDES
   ENDIF
   @ 16,32 SAY WNUMREFDES

   @ 17,14 GET XBENEFI
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   IF XBENEFI = SPACE(12)
      STORE "TODOS" TO WBENEFIDES
   ELSE
      STORE "  "    TO WBENEFIDES
   ENDIF
   @ 17,32 SAY WBENEFIDES


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
      STORE 22 TO WSALTO
      STORE "MONITOR" TO WSALIDES
   ENDIF
   @ 18,14 SAY WSALIDES

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
      IF FECHA >= XDESDE .AND. FECHA <= XHASTA
         *** PASA BIEN
      ELSE
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XTIPOPE <> SPACE(2) .AND. XTIPOPE <> TIPOPE
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XNUMOPE <> SPACE(12) .AND. XNUMOPE <> NUMOPE
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XNUMOPE <> SPACE(12) .AND. XNUMOPE <> NUMOPE
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF MONTO >= XMONTO1 .AND. MONTO <= XMONTO2
         *** PASA BIEN
      ELSE
         SELECT 1
         SKIP
         LOOP
      ENDIF

      IF XESTATUS <> SPACE(2) .AND. XESTATUS <> ESTATUS
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XTIPREF  <> SPACE(2) .AND. XTIPREF  <> TIPREF
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XNUMREF  <> SPACE(12) .AND. XNUMREF  <> NUMREF
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XBENEFI  <> SPACE(12) .AND. XBENEFI  <> BENEFI
         SELECT 1
         SKIP
         LOOP
      ENDIF
      *** FIN FILTROS

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
         @ 2,0 SAY "LISTADO DE OPERACIONES"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 04,01  SAY "CTA "
         @ 04,06  SAY "SCTA"
         @ 04,11  SAY "FECHA   "
         @ 04,20  SAY "TO"
         @ 04,23  SAY "No.OPERACION"
         @ 04,36  SAY "DESCRIPCION            "
         @ 04,62  SAY "ST"
         @ 04,65  SAY "          MONTO"
         @ 05,01  SAY "----"
         @ 05,06  SAY "----"
         @ 05,11  SAY "--------"
         @ 05,20  SAY "--"
         @ 05,23  SAY "------------"
         @ 05,36  SAY "------------------------"
         @ 05,62  SAY "--"
         @ 05,65  SAY "---------------"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA ,01  SAY CTA
      @ WLINEA ,06  SAY SUBCTA
      @ WLINEA ,11  SAY FECHA
      @ WLINEA ,20  SAY TIPOPE
      @ WLINEA ,23  SAY NUMOPE
      @ WLINEA ,36  SAY SUBSTR(DESCRI,1,24)
      @ WLINEA ,62  SAY ESTATUS
      @ WLINEA ,65  SAY MONTO picture "####,###,###.##"
      SELECT 1
      SKIP
   ENDDO
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