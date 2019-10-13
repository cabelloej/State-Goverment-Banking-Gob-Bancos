SAVE  SCRE      TO SCRE0200
STORE FECHA     TO WFECHA
STORE TIPOPE    TO WTIPOPE,WULTTIPOPE
STORE NUMOPE    TO WNUMOPE,WULTNUMOPE
STORE DESCRI    TO WOPERADES
STORE TIPREF    TO WTIPREF,WULTTIPREF
STORE NUMREF    TO WNUMREF
STORE BENEFI    TO WBENEFI,WULTBENEFI
STORE SERIAL    TO WSERIAL
STORE MONTO     TO WMONTO,WULTMONTO
STORE ESTATUS   TO WESTATUS
STORE IMPRESO   TO WIMPRESO
STORE .T. TO WOPE
DO WHILE WOPE
   SET COLOR TO W+/B+
   @ 00,00 CLEAR
   @ 00,00 SAY  QQWW
   @ 01,00 SAY "OPERACIONES BANCARIAS (MODIFICAR MOVIMIENTOS)"
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

   *** INICIO DE MUESTRA DE INFORMACION DEL REGISTRO
   @ 03,15 SAY WCUENTA
   SELECT 1
   FIND &WCUENTA
   IF EOF()
      STORE "NO REGISTRADA EN MAESTRO" TO WCTADES
   ELSE
      STORE DESCRI TO WCTADES
   ENDIF
   @ 03,20 SAY WCTADES
   @ 05,15 SAY WSUBCUENTA

   STORE WCUENTA+WSUBCUENTA  TO WCLAVESUB
   SELECT 2
   FIND &WCLAVESUB
   IF EOF()
      STORE "NO REGISTRDA" TO WSUBDESCRI
   ELSE
      STORE DESCRI         TO WSUBDESCRI 
   ENDIF
   *** CREA  WSALDOANT PARA VERIFICAR QUE EL MONTO INGRESADO SEA VALIDO
   IF WULTTIPOPE = "DP" .OR. WULTTIPOPE = "NC"
      STORE SALDO-WULTMONTO TO WSALDOANT
   ELSE
      STORE SALDO+WULTMONTO TO WSALDOANT
   ENDIF
   ***
   @ 05,20 SAY WSUBDESCRI
   @ 07,15 SAY WFECHA
   @ 09,15 SAY WSERIAL
   @ 11,15 SAY WTIPOPE
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
               STORE "NO DEFINIDO" TO WTIPOPEDES
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   @ 11,20 SAY WTIPOPEDES+" NUMERO:"
   @ 11,50 SAY WNUMOPE
   @ 13,15 SAY WOPERADES
   @ 15,15 SAY WTIPREF
   SELECT 4
   FIND &WTIPREF
   IF EOF()
      STORE "TIPO DE DOCUMENTO NO DEFINIDO" TO WREFERDES
   ELSE
      STORE DESCRI TO WREFERDES
   ENDIF
   @ 15,20 SAY WREFERDES+" NUMERO:"
   @ 15,60 SAY WNUMREF
   @ 17,15 SAY WBENEFI
   IF WBENEFI <> SPACE(12)
      SELECT 5
      FIND &WBENEFI
      IF EOF()
         STORE "BENEFICIARIO NO REGISTRADO" TO WBENEFIDES
      ELSE
         STORE DESCRI TO WBENEFIDES
      ENDIF
   ELSE
      STORE SPACE(25) TO WBENEFIDES
   ENDIF
   @ 17,30 SAY WBENEFIDES
   @ 19,15 SAY WMONTO PICTURE "#,###,###,###.##"
   @ 21,15 SAY WESTATUS
   IF WESTATUS = "ET"
      STORE "EN TRANSITO" TO WESTATUSDES
   ELSE
      IF WESTATUS = "CO"
         STORE "CONCILIADA" TO WESTATUSDES
      ELSE
         IF WESTATUS = "AN"
            STORE "ANULADA" TO WESTATUSDES
         ELSE
            STORE "????????????" TO WESTATUSDES
         ENDIF
      ENDIF
   ENDIF
   @ 21,20 SAY WESTATUSDES

   *** VERIFICAR OPERADOR DE LA CUENTA
   STORE WUSERCODE+WCUENTA TO WACCESO
   SELECT 7
   FIND &WACCESO
   IF EOF()
      STORE "OPERADOR NO AUTORIZADO EN ESTA CUENTA, VERIFIQUE." TO MES
      DO AVISO WITH MES
      EXIT
   ENDIF
   *** FIN VERIFICACION DE OPERADOR

   SELECT 3
   IF ESTATUS = "CO"
      STORE "OPERACION CONCILIADA EL MES "+STR(MONTH(ESTATFECHA),2)+" DE "+STR(YEAR(ESTATFECHA),4) TO MES
      DO AVISO WITH MES
      EXIT
   ENDIF
   IF ESTATUS = "AN"
      STORE "ERROR, ESTA OPERACION ESTA ANULADA CON FECHA "+DTOC(ESTATFECHA) TO MES
      DO AVISO WITH MES
      EXIT
   ENDIF

   STORE "OPCIONES: (M)ODIFICAR, (A)NULAR, (S)ALIR" TO TEX
   STORE "MAS" TO WCH
   DO PREGUNTA
   STORE WCH TO WMAS
   IF WMAS= "S"
      EXIT
   ELSE
      IF WMAS="A"
         STORE "ESTA SEGURO QUE DESEA ANULAR ESTA OPERACION ? (S/N)" TO TEX
         STORE "NS" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            EXIT
         ELSE
            SELECT 3
            DO RECLOC
            REPLACE ESTATUS    WITH "AN"
            REPLACE ESTATFECHA WITH DATE()
            *** ASIGNA NUEVO SALDO
            SELECT 2
            IF WTIPOPE = "DP" .OR. WTIPOPE = "NC"
               REPLACE SALDO WITH SALDO-WMONTO
            ELSE
               IF WTIPOPE = "CH" .OR. WTIPOPE = "ND"
                  REPLACE SALDO WITH SALDO+WMONTO
               ENDIF
            ENDIF
            UNLOCK
            FLUSH
         ENDIF
         EXIT
      ENDIF
   ENDIF

   IF WTIPOPE = "CH" .AND. WIMPRESO = 1
      STORE "ESTE CHEQUE YA SE EMITIO, NO PUEDE SER MODIFICADO" TO MES
      DO AVISO WITH MES
      EXIT
   ENDIF
   *** INICIO DE MODIFICACION
   STORE FECHA TO WLASTFECHA
   @ 07,15 GET WFECHA
   READ
   IF READKEY()=12 .OR. READKEY()=268
      EXIT
   ENDIF
   IF WFECHA <> WLASTFECHA
      STORE .T.     TO FLAGJUMP0
      STORE RECNO() TO WINICIO0
      STORE 0       TO WREVERSE0
   ENDIF

   *IF WTIPOPE <> "CH"
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
                     STORE "NO DEFINIDO" TO WTIPOPEDES
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         @ 11,20 SAY WTIPOPEDES+" NUMERO:"
         STORE .T. TO WGETNUMOPE
         DO WHILE WGETNUMOPE
            STORE "INGRESE EL NUMERO DEL TIPO DE DOCUMENTO DE LA OPERACION" TO MES
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
         SELECT 3
         STORE RECNO() TO WRETORNO
         IF WTIPOPE <> WULTTIPOPE .OR. WNUMOPE <> WULTNUMOPE
            *** VERIFICAR QUE LA OPERACION NO ESTE REPETIDA PARA LA CUENTA (NO LA SUBCUENTA)
            STORE WCUENTA+WTIPOPE+WNUMOPE TO WCLAVEOPE
            SET ORDER TO 2
            FIND &WCLAVEOPE
            SET ORDER TO 1
            IF .NOT. EOF()
               STORE "ERROR, ESTA OPERACION YA ESTA REGISTRADA PARA ESTA CUENTA, VERIFIQUE." TO MES
               DO AVISO WITH MES
               STORE WULTTIPOPE TO WTIPOPE
               STORE WULTNUMOPE TO WNUMOPE
               GO WRETORNO
               LOOP
            ENDIF
            *** FIN DE VERIFICACION
         ENDIF
         GO WRETORNO
         EXIT
      ENDDO
      IF .NOT. WGETTO
         LOOP
      ENDIF
   *ENDIF

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

   STORE .T. TO WGETTIPREF
   DO WHILE WGETTIPREF
      STORE "DOCUMENTO REFERENCIAL DE LA OPERACION BANCARIA" TO MES
      DO MENSAJE WITH MES
      @ 15,15 GET WTIPREF
      READ
      IF READKEY()=12 .OR. READKEY()=268
         STORE .F. TO WGETTIPREF
         EXIT
      ENDIF
      SELECT 4
      SEEK WTIPREF
      IF EOF()
         STORE "TIPO DE DOCUMENTO REFERENCIAL DE LA OPERACION NO ESTA DEFINIDO, VERIFIQUE" TO MES
         DO AVISO WITH MES
         STORE WULTTIPREF TO WTIPREF
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
      @ 19,15 GET WMONTO PICTURE "#,###,###,###.##"
      READ
      IF READKEY()=12 .OR. READKEY()=268
         STORE .F. TO WGETMONTO
         EXIT
      ENDIF
      IF WMONTO <> 0
         IF (WTIPOPE = "CH" .OR. WTIPOPE = "ND") .AND. WMONTO > WSALDOANT
            STORE "MONTO DE LA OPERACION MAYOR QUE SALDO :"+STR(WSALDOANT,12,2)+" DE LA SUBCTA" TO MES
            DO AVISO WITH MES
            *STORE WULTMONTO TO WMONTO
            *LOOP
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
   *** REVERSA SALDO
   SELECT 2
   REPLACE SALDO WITH WSALDOANT
   *** ASIGNA NUEVO SALDO
   IF WTIPOPE = "DP" .OR. WTIPOPE = "NC"
      REPLACE SALDO WITH SALDO+WMONTO
   ELSE
      REPLACE SALDO WITH SALDO-WMONTO
   ENDIF
   UNLOCK

   *** REGISTRA LA MODIFICACION
   SELECT 3
   DO RECLOC
   REPLACE FECHA  WITH WFECHA
   REPLACE TIPOPE WITH WTIPOPE
   REPLACE NUMOPE WITH WNUMOPE
   REPLACE TIPREF WITH WTIPREF
   REPLACE NUMREF WITH WNUMREF
   IF WTIPOPE = "CH" .OR. WTIPOPE = "ND"
      REPLACE BENEFI WITH WBENEFI
   ELSE
      REPLACE BENEFI WITH SPACE(12)
   ENDIF
   REPLACE MONTO  WITH WMONTO
   REPLACE DESCRI WITH WOPERADES
   REPLACE ESTATUS WITH WESTATUS
   UNLOCK
   FLUSH
   EXIT
ENDDO
SELECT 3
RESTORE SCRE FROM SCRE0200
RETURN
