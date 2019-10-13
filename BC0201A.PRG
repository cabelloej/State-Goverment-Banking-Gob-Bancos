SAVE SCRE TO SCRE0200
STORE DATE()    TO WFECHA
STORE SPACE(2)  TO WTIPOPE
STORE SPACE(12) TO WNUMOPE
STORE SPACE(28) TO WOPERADES
STORE SPACE(2)  TO WTIPREF
STORE SPACE(12) TO WNUMREF
STORE SPACE(12) TO WBENEFI
STORE "0000"    TO WSUBCTA
STORE .T. TO WOPE
DO WHILE WOPE
        SET COLOR TO W+/B+
   @ 00,00 CLEAR
   @ 00,00 SAY  QQWW
   @ 01,00 SAY "OPERACIONES BANCARIAS (INCLUIR MOVIMIENTOS)"
   @ 02,00 SAY "+------------------------------------------------------------------------------+"
   @ 03,00 SAY "|CUENTA      :                                                                 |"
   @ 04,00 SAY "|------------------------------------------------------------------------------|"
   @ 05,00 SAY "|SUBCUENTA   :                                                                 |"
   @ 06,00 SAY "|------------------------------------------------------------------------------|"
   @ 07,00 SAY "|FECHA       :                                                                 |"
   @ 08,00 SAY "|------------------------------------------------------------------------------|"
   @ 09,00 SAY "|SERIAL      :                                                                 |"
   @ 10,00 SAY "|------------------------------------------------------------------------------|"
   @ 11,00 SAY "|OPERACION   :                                                                 |"
   @ 12,00 SAY "|------------------------------------------------------------------------------|"
   @ 13,00 SAY "|DESCRIPCION :                                                                 |"
   @ 14,00 SAY "|------------------------------------------------------------------------------|"
   @ 15,00 SAY "|REFERENCIA  :                                                                 |"
   @ 16,00 SAY "|------------------------------------------------------------------------------|"
   @ 17,00 SAY "|BENEFICIARIO:                                                                 |"
   @ 18,00 SAY "|------------------------------------------------------------------------------|"
   @ 19,00 SAY "|MONTO       :                                                                 |"
   @ 20,00 SAY "|------------------------------------------------------------------------------|"
   @ 21,00 SAY "|ESTATUS     :                                                                 |"
   @ 22,00 SAY "+------------------------------------------------------------------------------+"
   *** ESTATUS = ET=En Transito, CO=Conciliada, AN=Anulada

   @ 03,15 GET WCUENTA
   READ
   IF READKEY()=12 .OR. READKEY()=268
      STORE .F. TO WACTX
      SELECT 3
      GO TOP
      STORE RECNO() TO WINICIO0
      STORE .T.     TO FLAGJUMP0
      STORE 0       TO WREVERSE0
      EXIT
   ENDIF
   SELECT 1
   FIND &WCUENTA
   IF EOF()
      STORE "CUENTA NO REGISTRADA, VERIFIQUE." TO MES
      DO AVISO WITH MES
      LOOP
   ELSE
      STORE DESCRI TO WCTADES
   ENDIF
   @ 03,20 SAY WCTADES

   *** VERIFICAR OPERADOR DE LA CUENTA
   STORE WUSERCODE+WCUENTA TO WACCESO
   SELECT 7
   FIND &WACCESO
   IF EOF()
      STORE "OPERADOR NO AUTORIZADO EN ESTA CUENTA, VERIFIQUE." TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   *** FIN VERIFICACION DE OPERADOR

   @ 05,15 GET WSUBCUENTA
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP 
   ENDIF
   STORE WCUENTA+WSUBCUENTA  TO WCLAVESUB
   SELECT 2
   FIND &WCLAVESUB
   IF EOF()
      STORE "NO REGISTRADA" TO WSUBDESCRI
   ELSE
      STORE DESCRI          TO WSUBDESCRI
   ENDIF
   STORE SALDO TO WSALDO
   @ 05,20 SAY WSUBDESCRI

   @ 07,15 GET WFECHA
   READ
   IF READKEY()=12 .OR. READKEY()=268
      LOOP
   ENDIF

   STORE BCDATOS->SERIAL + 1 TO WSERIAL
   STORE WSERIAL   TO WNUMBERN
   STORE SPACE(12) TO WNUMBERC
   DO STRNUMBER
   STORE WNUMBERC  TO WSERIAL
   @ 09,15 SAY WSERIAL

   STORE .T. TO WGETTO
   DO WHILE WGETTO
      STORE "OPCIONES: CH=Cheque, DP=Deposito, ND=Nota de Debito, NC=Nota de Credito" to mes
      DO MENSAJE WITH MES
      @ 11,15 GET WTIPOPE
      READ
      IF READKEY()=12 .OR. READKEY()=268
         STORE .F. TO WGETTO
         EXIT
      ENDIF
      IF WTIPOPE = "CH"
         STORE "CHEQUE" TO WTIPOPEDES
      ELSE
         IF WTIPOPE = "DP"
            STORE "DEPOSITO" TO WTIPOPEDES
         ELSE
            IF WTIPOPE = "ND"
               STORE "NOTA DE DEBITO" TO WTIPOPEDES
            ELSE
               IF WTIPOPE = "NC"
                  STORE "NOTA DE CREDITO" TO WTIPOPEDES
               ELSE
                  LOOP
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      @ 11,20 SAY WTIPOPEDES+" NUMERO:"
      IF WTIPOPE = "CH"
         STORE BCCTAS->CHEQUE + 1 TO WCHEQUE
         STORE WCHEQUE            TO WNUMBERN
         STORE SPACE(12)          TO WNUMBERC
         DO STRNUMBER
         STORE WNUMBERC           TO WCHEQUE
         STORE WCHEQUE TO WNUMOPE
         @ 11,50 GET WNUMOPE
         READ
      ELSE
         STORE .T. TO WGETNUMOPE
         DO WHILE WGETNUMOPE
            STORE "INGRESE EL NUMERO DE LA OPERACION" TO MES
            DO MENSAJE WITH MES
            @ 11,50 GET WNUMOPE
            READ
            IF READKEY()=12 .OR. READKEY()=268
               STORE .F. TO WGETNUMOPE
               EXIT
            ENDIF
            IF WNUMOPE = SPACE(12)
               LOOP
            ELSE
               EXIT
            ENDIF
         ENDDO
         IF .NOT. WGETNUMOPE
            LOOP
         ENDIF
      ENDIF
      *** VERIFICAR QUE LA OPERACION NO ESTE REPETIDA PARA LA CUENTA (NO LA SUBCUENTA)
      STORE WCUENTA+WTIPOPE+WNUMOPE TO WCLAVEOPE
      SELECT 3
      SET ORDER TO 2
      FIND &WCLAVEOPE
      SET ORDER TO 1
      IF .NOT. EOF()
         STORE "ERROR, ESTA OPERACION YA ESTA REGISTRADA PARA ESTA CUENTA, VERIFIQUE." TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
      *** FIN DE VERIFICACION
      EXIT
   ENDDO
   IF .NOT. WGETTO
      LOOP
   ENDIF

   STORE .F. TO WGETDES
   DO WHILE .NOT. WGETDES
      @ 13,15 GET WOPERADES
      READ
      IF READKEY()=12 .OR. READKEY()=268
         STORE .F. TO WGETDES
         EXIT
      ENDIF
      IF WOPERADES <> SPACE(28)
         STORE .T. TO WGETDES
      ENDIF
   ENDDO
   IF .NOT. WGETDES
      LOOP
   ENDIF

   STORE .T.       TO WGETTIPREF
   DO WHILE WGETTIPREF
      STORE "REFERENCIA O SOPORTE DE LA OPERACION, ?=CONSULTAR" TO MES
      DO MENSAJE WITH MES
      @ 15,15 GET WTIPREF
      READ
      IF READKEY()=12 .OR. READKEY()=268
         STORE .F. TO WGETTIPREF
         EXIT
      ENDIF
      IF AT("?",WTIPREF)>0
      ***** VENTANA PARA CONS/SELEC REF
         STORE 10 TO LIBRREF
         STORE 25 TO CIBRREF
             DO BCWINTR
             STORE CODIGO TO WTIPREF
         LOOP
      ENDIF
      SELECT 4
      SEEK WTIPREF
      IF EOF()
         STORE "TIPO DE DOCUMENTO REFERENCIAL DE LA OPERACION NO ESTA DEFINIDO, VERIFIQUE" TO MES
         DO AVISO WITH MES
         LOOP
      ELSE
         STORE DESCRI TO WREFERDES
      ENDIF
      @ 15,20 SAY WREFERDES+" NUMERO:"
      STORE .T. TO WGETNUMREF
      DO WHILE WGETNUMREF
         STORE "INGRESE EL NUMERO DEL DOCUMENTO REFERENCIAL DE LA OPERACION" TO MES
         DO MENSAJE WITH MES
         @ 15,60 GET WNUMREF
         READ
         IF READKEY()=12 .OR. READKEY()=268
            STORE .F. TO WGETNUMREF
            EXIT
         ENDIF
         IF WNUMREF = SPACE(12)
            LOOP
         ELSE
            EXIT
         ENDIF
      ENDDO
      IF .NOT. WGETNUMREF
         LOOP
      ENDIF
      EXIT
   ENDDO
   IF .NOT. WGETTIPREF
      LOOP
   ENDIF

   IF WTIPOPE = "CH" .OR. WTIPOPE = "ND"
      STORE .T.       TO WASKBENEFI
      STORE .T.       TO WGETBENEFI
   ELSE
      STORE .T.       TO WASKBENEFI
      STORE .F.       TO WGETBENEFI
   ENDIF
   DO WHILE WGETBENEFI
      STORE "BENEFICIARIO DE LA OPERACION BANCARIA (? = CONSULTAR)" TO MES
      DO MENSAJE WITH MES
      @ 17,15 GET WBENEFI
      READ
      IF WBENEFI=SPACE(12) .OR. READKEY()=12 .OR. READKEY()=268
         STORE .F. TO WGETBENEFI
         STORE .F. TO WASKBENEFI
         EXIT
      ENDIF
      IF AT("?",WBENEFI)>0
         SAVE SCRE TO S99
         @ 2,0 CLEAR
         DO BC0108
         RESTORE SCRE FROM S99
         LOOP
      ENDIF
      SELECT 5
      FIND &WBENEFI
      IF EOF()
         STORE "BENEFICIARIO NO REGISTRADO, INGRESAR ? (S/N)" TO TEX
         STORE "SN" TO WCH
         DO PREGUNTA
         IF WCH = "S"
            SAVE SCRE TO WSCREBEN
            DO BC0108
            RESTORE SCRE FROM WSCREBEN
         ENDIF
         LOOP
      ELSE
         STORE DESCRI TO WBENEFIDES
      ENDIF
      @ 17,30 SAY WBENEFIDES
      STORE "BENEFICIARIO CORECTO ? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         LOOP
      ELSE
         EXIT
      ENDIF
   ENDDO
   IF .NOT. WASKBENEFI
      LOOP
   ENDIF

   STORE .F. TO WGETMONTO
   DO WHILE .NOT. WGETMONTO
      STORE 0 TO WMONTO
      @ 19,15 GET WMONTO PICTURE "##########.##"
      READ
      @ 19,15 SAY WMONTO PICTURE "#,###,###,###.##"
      IF READKEY()=12 .OR. READKEY()=268
         STORE .F. TO WGETMONTO
         EXIT
      ENDIF
      IF WMONTO <> 0
         IF (WTIPOPE = "CH" .OR. WTIPOPE = "ND")  .AND. WMONTO > WSALDO
            STORE "AVISO: MONTO DE OPERACION MAYOR QUE SALDO :"+STR(WSALDO,12,2)+" DE SUBCTA" TO MES
            DO AVISO WITH MES
         ENDIF
         STORE .T. TO WGETMONTO
      ENDIF
   ENDDO
   IF .NOT. WGETMONTO
      LOOP
   ENDIF

   *** ESTA VARIABLE (WCONCI) DEBE SER DEFINIDA POR EL PROGRAMA QUE LLAME A BC0200
   *** E INDICA SI EL SISTEMA DEBE GRABAR LA OPERACION COMO YA CONCILIADA O NO
   IF WCONCI
      STORE "CO"          TO WESTATUS
      STORE "CONCILIADA"  TO WESTATUSDES
   ELSE
      STORE "ET"          TO WESTATUS
      STORE "EN TRANSITO" TO WESTATUSDES
   ENDIF
   @ 21,15 SAY WESTATUS
   @ 21,20 SAY WESTATUSDES

   STORE "CONFORME ? (S/N)" TO TEX
   STORE "SN" TO WCH
   DO PREGUNTA
   IF WCH = "N"
      LOOP
   ENDIF

   *** ACTUALIZA SUBCTA
   STORE WCUENTA+WSUBCUENTA TO WCLAVESUB
   SELECT 2
   FIND &WCLAVESUB
   IF EOF()
      STORE "ERROR FATAL: SUBCUENTA NO LOCALIZADA EN MAESTRO DE SUBCTAS." TO MES
      DO AVISO WITH MES
      STORE "OPERACION RECHAZADA, OPRIMA ENTER PARA CONTINUAR" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   DO RECLOC
   IF WTIPOPE = "DP" .OR. WTIPOPE = "NC"
      REPLACE SALDO WITH SALDO+WMONTO
   ELSE
      REPLACE SALDO WITH SALDO-WMONTO
   ENDIF
   UNLOCK

   *** REGISTRA LA OPERACION
   SELECT 3
   DO FILLOC
   APPEND BLANK
   UNLOCK ALL
   DO RECLOC
   REPLACE CTA    WITH WCUENTA
   REPLACE SUBCTA WITH WSUBCUENTA
   REPLACE FECHA  WITH WFECHA
   REPLACE SERIAL WITH WSERIAL
   REPLACE TIPOPE WITH WTIPOPE
   REPLACE NUMOPE WITH WNUMOPE
   REPLACE TIPREF WITH WTIPREF
   REPLACE NUMREF WITH WNUMREF
   REPLACE BENEFI WITH WBENEFI
   REPLACE MONTO  WITH WMONTO
   REPLACE DESCRI WITH WOPERADES
   REPLACE ESTATUS WITH WESTATUS
   UNLOCK

   *** ACTUALIZA NUMERO DE CHEQUE
   IF WTIPOPE = "CH"
      SELECT 1
      DO RECLOC
      REPLACE CHEQUE WITH CHEQUE + 1
   ENDIF

   *** ACTUALIZA EL SERIAL DE OPERACIONES
   SELECT 6
   DO RECLOC
   REPLACE SERIAL WITH SERIAL+1
   UNLOCK
   FLUSH
   SELECT 3
ENDDO
RESTORE SCRE FROM SCRE0200
SELECT 3
RETURN
