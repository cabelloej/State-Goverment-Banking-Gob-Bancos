select 1
use BCPARTID index BCPARTID
SAVE SCRE TO WSCRE99
store .t. to viendo
do while viendo
   RESTORE SCRE FROM WSCRE99
  * STORE 0 TO WTOTAL
   STORE SPACE(2) TO XANO
   STORE SPACE(2) TO XTIP
   STORE SPACE(3) TO XORI
   @ 04,0 clear to 10,40
   @ 04,0 to 10,40
   @ 04,6 SAY " CLASIFICACION DE CUENTAS "
   @ 06,1 say "GRUPO       :"
   @ 07,1 say "SUBGRUPO    :"
   @ 08,1 say "RENGLON     :"
   @ 09,1 say "SALIDA (M/I):"
   @ 06,14 GET XANO
   @ 07,14 GET XTIP
   @ 08,14 GET XORI
   READ
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
   @ 09,20 SAY WSALIDES

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
      IF XANO <> SPACE(2) .AND. XANO <> ANO
         SELECT 1
         SKIP
         LOOP
      ENDIF

      IF XTIP <> SPACE(2) .AND. XTIP <> TIP
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF XORI <> SPACE(3) .AND. XORI <> ORG
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
         @ 2,0 SAY "CLASIFICACION DE CUENTAS"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "GP-SG-RNG"
         @ 4,12 SAY "DESCRIPCION"
         @ 5,00 SAY "-----------------------------------------"
         @ 5,12 SAY "------------------------------"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA ,00 SAY  ANO+"_"+TIP+"_"+ORG
      @ WLINEA ,12 SAY DESCRI
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