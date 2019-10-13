select 1
use BCCTAS   index BCCTAS

*** BASE DE DATOS QUE DEBERIA USARSE PARA VER DESCRIPCION DE CODIGOS
*select 2
*use BCBANCOS index BCBANCOS
*select 3
*use BCSUCUR  index BCSUCUR
*select 4
*use BCTIPCTA index BCTIPCTA

SAVE SCRE TO WSCRE99
store .t. to viendo
do while viendo
   RESTORE SCRE FROM WSCRE99
  * STORE 0 TO WTOTAL
   STORE SPACE(4) TO XBANCO
   STORE SPACE(4) TO XSUCUR
   STORE SPACE(4) TO XTIPCTA
   STORE SPACE(4) TO XCUENTA
   STORE CTOD("01-01-"+   STR( YEAR(DATE()) )) TO XDESDE
   STORE CTOD("31-12-"+   STR( YEAR(DATE()) )) TO XHASTA
   @ 04,0 clear to 13,40
   @ 04,0 to 13,40
   @ 04,15 SAY " CUENTAS "
   @ 06,1 say "BANCO       :"
   @ 07,1 say "SUCURSAL    :"
   @ 08,1 say "TIPO DE CTA.:"
   @ 09,1 say "CUENTA      :"
   @ 10,1 say "APERTURA >= :"
   @ 11,1 say "APERTURA <= :"
   @ 12,1 say "SALIDA (M/I):"
   @ 06,14 GET XBANCO
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF XBANCO = SPACE(4)
      STORE "TODOS" TO WBANCODES
   ELSE
      STORE "  "    TO WBANCODES
   ENDIF
   @ 06,20 SAY WBANCODES

   IF XBANCO <> SPACE(4)
      @ 07,14 GET XSUCUR
      READ
      IF READKEY()=12 .OR. READKEY()=268
         EXIT
      ENDIF
      IF XSUCUR = SPACE(4)
         STORE "TODAS" TO WSUCURDES
      ELSE
         STORE "  "    TO WSUCURDES
      ENDIF
      @ 07,20 SAY WSUCURDES
   ENDIF

   @ 08,14 GET XTIPCTA
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF XTIPCTA = SPACE(2)
      STORE "TODAS" TO WTIPCTADES
   ELSE
      STORE "  "    TO WTIPCTADES
   ENDIF
   @ 08,20 SAY WTIPCTADES

   @ 09,14 GET XCUENTA
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF XCUENTA = SPACE(4)
      STORE "TODAS" TO WCUENTADES
   ELSE
      STORE "  "    TO WCUENTADES
   ENDIF
   @ 09,20 SAY WCUENTADES

   @ 10,14 GET XDESDE
   @ 11,14 GET XHASTA
   READ
   IF XDESDE > XHASTA
      STORE "ERROR EN FECHAS, VERIFIQUE." TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF

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
   @ 12,20 SAY WSALIDES

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
      IF XBANCO <> SPACE(4) .AND. XBANCO <> BANCO
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XSUCUR <> SPACE(4) .AND. XSUCUR <> SUCURSAL
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XTIPCTA <> SPACE(2) .AND. XTIPCTA <> TIPO
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XCUENTA <> SPACE(4) .AND. XCUENTA <> CTA
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF APERTURA>=XDESDE .AND. APERTURA<=XHASTA
         *** PASA BIEN
      ELSE
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
         @ 2,0 SAY "LISTADO DE CUENTAS"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "BCO."
         @ 4,05 SAY "SCL."
         @ 4,10 SAY "TP"
         @ 4,13 SAY "CTA."
         @ 4,18 SAY "DESCRIPCION"
         @ 4,49 SAY "NUMERO DE CUENTA"
         @ 4,70 SAY "APERTURA"

         @ 5,00 SAY "----"
         @ 5,05 SAY "----"
         @ 5,10 SAY "--"
         @ 5,13 SAY "----"
         @ 5,18 SAY "------------------------------"
         @ 5,49 SAY "--------------------"
         @ 5,70 SAY "--------"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA,00 SAY BANCO
      @ WLINEA,05 SAY SUCURSAL
      @ WLINEA,10 SAY TIPO
      @ WLINEA,13 SAY CTA
      @ WLINEA,18 SAY DESCRI
      @ WLINEA,49 SAY NUMEROCTA
      @ WLINEA,70 SAY APERTURA
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