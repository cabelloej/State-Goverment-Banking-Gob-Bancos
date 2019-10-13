select 1
USE BCOPERA INDEX BCOPERA3
SELECT 2
USE BCCTAS  INDEX BCCTAS
SAVE SCRE TO WSCRE99
store .t. to viendo
do while viendo
   RESTORE SCRE FROM WSCRE99
   STORE SPACE(4)      TO XCUENTA
   STORE CTOD("01-01-"+   STR( YEAR(DATE()) )) TO XDESDE
   STORE CTOD("31-12-"+   STR( YEAR(DATE()) )) TO XHASTA
   STORE 0             TO WDEBI
   STORE 0             TO WCREDI
   STORE 0             TO WSALDO
   STORE 0             TO WSALDOANT
   STORE 0             TO WSALDOFIN
   STORE "****"        TO WRUPCTA

   @ 04,0 clear to 10,40
   @ 04,0 to 10,40
   @ 04,10 SAY " ESTADOS DE CUENTAS "
   @ 06,1 say "CUENTA      :"
   @ 07,1 say "FECHA >=    :"
   @ 08,1 say "FECHA <=    :"
   @ 09,1 say "SALIDA (M/I):"

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

   @ 07,14 GET XDESDE
   @ 08,14 GET XHASTA
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF
   IF XDESDE > XHASTA
      STORE "ERROR EN FECHAS, VERIFIQUE." TO MES
      DO AVISO WITH MES
      LOOP
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
      STORE 20 TO WSALTO
      STORE "MONITOR" TO WSALIDES
   ENDIF
   @ 09,14 SAY WSALIDES

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
      IF FECHA > XHASTA
         SELECT 1
         SKIP
         LOOP
      ENDIF
      IF ESTATUS = "AN"
         SELECT 1
         SKIP
         LOOP
      ENDIF
      *** CALCULA SALDO ANTERIOR
      IF FECHA < XDESDE
         STORE WSALDOANT + MONTO TO WSALDOANT
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
      *** FIN FILTROS
      *** CONTROL DE RUPTURA POR CUENTA
      IF CTA <> WRUPCTA
         STORE WSALDOFIN+WSALDO TO WSALDOFIN
         STORE WSALDOANT        TO WSALDO
         STORE 0                TO WSALDOANT
         STORE CTA              TO WRUPCTA
         SELECT 2
         FIND &WRUPCTA
         IF EOF()
            STORE "NO REGISTRADA EN MAESTRO" TO WCTADES
         ELSE
            STORE DESCRI                     TO WCTADES
         ENDIF
         STORE WLINEA+1 TO WLINEA
         IF WLINEA >=WSALTO
            STORE .F. TO WFLAGEXIT
            DO BC0314H
            IF WFLAGEXIT
               EXIT
            ENDIF
         ENDIF
         @ WLINEA,0 SAY REPLICATE("-",80)
         STORE WLINEA+1 TO WLINEA
         @ WLINEA,0 SAY  "CUENTA: "+WRUPCTA+"-"+WCTADES
         @ WLINEA ,65  SAY WSALDO picture "####,###,###.##"
      ENDIF

      STORE WLINEA+1 TO WLINEA
      IF WLINEA >=WSALTO
         DO BC0314H
      ENDIF
      SELECT 1
      @ WLINEA ,00  SAY FECHA
      @ WLINEA ,09  SAY TIPOPE
      @ WLINEA ,12  SAY NUMOPE
      IF TIPOPE = "DP" .OR. TIPOPE = "NC"
         STORE "C" TO WBALANCE
      ELSE
         IF TIPOPE = "CH" .OR. TIPOPE = "ND"
            STORE "D" TO WBALANCE
         ELSE
            STORE "?" TO WBALANCE
         ENDIF
      ENDIF
      IF WBALANCE = "D"
         @ WLINEA ,25  SAY MONTO picture "####,###,###.##"
         STORE WSALDO - MONTO TO WSALDO
         STORE WDEBI  + MONTO TO WDEBI
      ELSE
         IF WBALANCE = "C"
            @ WLINEA ,45  SAY MONTO picture "####,###,###.##"
            STORE WSALDO + MONTO TO WSALDO
            STORE WCREDI + MONTO TO WCREDI
         ENDIF
      ENDIF
      @ WLINEA ,65  SAY WSALDO picture "####,###,###.##"
      SELECT 1
      SKIP
   ENDDO
   *** ACUMULA ULTIMO SALDO DE ULTIMA CUENTA PROCESADA
   STORE WSALDOFIN+WSALDO TO WSALDOFIN
   IF WSALDOFIN <> 0
      STORE WLINEA+1 TO WLINEA
      @ WLINEA,0 SAY REPLICATE("-",80)
      STORE WLINEA+1 TO WLINEA
      @ WLINEA, 00  SAY "SALDO  INFORME:"
      @ WLINEA ,23  SAY WDEBI     picture "##,###,###,###.##"
      @ WLINEA ,43  SAY WCREDI    picture "##,###,###,###.##"
      @ WLINEA ,63  SAY WSALDOFIN picture "##,###,###,###.##"
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