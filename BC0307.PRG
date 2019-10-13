select 1
use BCSUBCTA index BCSUBCTA
SELECT 2
USE BCCTAS INDEX BCCTAS
SAVE SCRE TO WSCRE99
store .t. to viendo
do while viendo
   RESTORE SCRE FROM WSCRE99
  * STORE 0 TO WTOTAL
   STORE SPACE(4) TO XCUENTA
   STORE "****" TO WRUPCTA
   @ 04,0 clear to 10,40
   @ 04,0 to 10,40
   @ 04,9 SAY " SUBCUENTAS BANCARIAS "
   @ 06,1 say "CUENTA      :"
   @ 08,1 say "SALIDA (M/I):"
   @ 06,14 GET XCUENTA
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF XCUENTA= SPACE(4)
      STORE "TODAS" TO WCUENTADES
   ELSE
      STORE "  "    TO WCUENTADES
   ENDIF
   @ 06,20 SAY WCUENTADES

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
   @ 08,20 SAY WSALIDES

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
      *** FIN FILTROS

      STORE CTA    TO WCTA
      STORE DESCRI TO WSUBCTADES
      IF WCTA <> WRUPCTA
         SELECT 2
         FIND &WCTA
         IF EOF()
            STORE "NO REGISTRADA EN MAESTRO" TO WCTADES
         ELSE
            STORE DESCRI                     TO WCTADES
         ENDIF
         STORE WCTA TO WRUPCTA
      ELSE
         STORE SPACE(30)                     TO WCTADES
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
         @ 2,00 SAY "LISTADO DE SUBCUENTAS POR CUENTA"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "CUENTA"
         @ 4,00 SAY "DESCRIPCION DE LA CUENTA"
         @ 4,40 SAY "SUBCTA"
         @ 4,48 SAY "DESCRIPCION DE LA PARTIDA"
         @ 5,00 SAY "------"
         @ 5,08 SAY "------------------------------"
         @ 5,40 SAY "------"
         @ 5,48 SAY "------------------------------"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA , 00 SAY CTA
      @ WLINEA , 08 SAY WCTADES
      @ WLINEA , 40 SAY SUBCTA
      @ WLINEA , 48 SAY WSUBCTADES
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