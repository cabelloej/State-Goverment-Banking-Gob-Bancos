select 1
use BCBANCOS index BCBANCOS
select 2
use BCSUCUR  index BCSUCUR
SAVE SCRE TO WSCRE99
store .t. to viendo
do while viendo
   RESTORE SCRE FROM WSCRE99
  * STORE 0 TO WTOTAL
   STORE SPACE(4) TO XBANCO
   STORE SPACE(4) TO XSUCUR
   @ 04,0 clear to 11,40
   @ 04,0 to 11,40
   @ 04,10 SAY " SUCURSALES POR BANCO "
   @ 06,1 say "BANCO       :"
   @ 08,1 say "SUCURSAL    :"
   @ 10,1 say "SALIDA (M/I):"
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

   @ 08,14 GET XSUCUR
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF XSUCUR = SPACE(4)
      STORE "TODAS" TO WSUCURDES
   ELSE
      STORE "  "    TO WSUCURDES
   ENDIF
   @ 08,20 SAY WSUCURDES

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
   @ 10,20 SAY WSALIDES

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

   SELECT 2
   GO TOP
   DO WHILE .NOT. EOF()
      *** FILTROS
      IF XBANCO <> SPACE(4) .AND. XBANCO <> BANCO
         SELECT 2
         SKIP
         LOOP
      ENDIF
      IF XSUCUR <> SPACE(4) .AND. XSUCUR <> SUCURSAL
         SELECT 2
         SKIP
         LOOP
      ENDIF
      *** FIN FILTROS

      STORE BANCO TO QBANCO
      SELECT 1
      FIND &QBANCO
      IF EOF()
         STORE "NO REGISTRADO EN MAESTRO" TO WBANCODES
      ELSE
         STORE DESCRI                     TO WBANCODES
      ENDIF
      SELECT 2
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
         @ 2,0 SAY "LISTADO DE SUCURSALES POR BANCO"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "BANCO"
         @ 4,40 SAY "SUCURSAL"
         @ 5,00 SAY "-----------------------------------"
         @ 5,40 SAY "-----------------------------------"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA , 00 SAY BANCO+"-"+WBANCODES
      @ WLINEA , 40 SAY SUCURSAL+"-"+DESCRI
      SELECT 2
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