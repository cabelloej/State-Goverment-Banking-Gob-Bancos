SELECT PRBENEF
STORE .T. TO CLIEN
DO WHILE CLIEN
   STORE SPACE(12) TO WCODPRO
   @ 4,0 CLEAR
   @ 4,0 SAY  "  BENEFICIARIOS"
   @ 5,0 SAY  "+-----------------------+---------------------------------------+--------------+"
   @ 6,0 SAY  "|CODIGO :               |NOMBRE :                               |GRUPO :       |"
   @ 7,0 SAY  "+-----------------------+---------------------------+-----------+--------------+"
   @ 8,0 SAY  "|DIRECCION :                              |TELEFONOS :                         |"
   @ 9,0 SAY  "|                                         |                                    |"
   @ 10,0 SAY "+-----------------------------------------+------------------------------------+"
   STORE "INGRESE RIF, CEDULA, ETC. DEL BENEFICIARIO (?)=VER BENEFICIARIOS" TO MES
   DO MENSAJE WITH MES
   @ 6,9 GET WCODPRO
   READ
   IF WCODPRO = SPACE(12) .OR. READKEY() = 12 .OR. READKEY() = 268
      RETURN
   ENDIF
   IF AT("?",WCODPRO)>0
      SAVE SCRE TO WSC0108
      DO BC0309
      RESTORE SCRE FROM WSC0108
      LOOP
   ENDIF
   FIND &WCODPRO
   IF EOF()
      STORE "CODIGO DE PROVEEDOR NO EXISTE. INGRESAR? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         LOOP
      ENDIF
      STORE SPACE(30) TO WDESPRO
      STORE SPACE(1)  TO WGRUPO
      STORE SPACE(30) TO WDIRPRO1
      STORE SPACE(30) TO WDIRPRO2
      STORE SPACE(10) TO WTELPRO1
      STORE SPACE(10) TO WTELPRO2
      @ 6,33 GET WDESPRO
      @ 6,75 GET WGRUPO
      @ 8,12 GET WDIRPRO1
      @ 9,12 GET WDIRPRO2
      @ 8,54 GET WTELPRO1
      @ 9,54 GET WTELPRO2
      READ
      STORE "CONFORME? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         LOOP
      ENDIF
      IF FILLOC()
         APPEND BLANK
         REPLACE CODIGO     WITH WCODPRO
         REPLACE DESCRI     WITH WDESPRO
         REPLACE DIRECCION1 WITH WDIRPRO1
         REPLACE DIRECCION2 WITH WDIRPRO2
         REPLACE TIPO       WITH WGRUPO
         REPLACE TELEFONOS1 WITH WTELPRO1
         REPLACE TELEFONOS2 WITH WTELPRO2
         REPLACE USERNAME   WITH WUSERCODE
         REPLACE USERDATE   WITH DATE()
         FLUSH
         UNLOCK ALL
      ENDIF
   ELSE
      @ 6,33 SAY DESCRI
      @ 6,75 SAY TIPO
      @ 8,12 SAY DIRECCION1
      @ 9,12 SAY DIRECCION2
      @ 8,54 SAY TELEFONOS1
      @ 9,54 SAY TELEFONOS2
      STORE "OPCIONES: (M)ODIFICAR, (E)LIMINAR, (S)ALIR" TO TEX
      STORE "SME" TO WCH
      DO PREGUNTA
      STORE WCH TO WRES
      IF WRES = "S"
         LOOP
      ENDIF
      IF WRES = "E"
         STORE "ESTA USTED SEGURO ? (N/S)" TO TEX
         STORE "NS" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            LOOP
         ELSE
            IF FILLOC()
               DELETE
               FLUSH
               UNLOCK ALL
            ENDIF
            LOOP
         ENDIF
      ENDIF
      IF WRES = "M"
         STORE CODIGO     TO WCODPRO
         STORE DESCRI     TO WDESPRO
         STORE TIPO       TO WGRUPO
         STORE DIRECCION1 TO WDIRPRO1
         STORE DIRECCION2 TO WDIRPRO2
         STORE TELEFONOS1 TO WTELPRO1
         STORE TELEFONOS2 TO WTELPRO2
         @ 6,33 GET WDESPRO
         @ 6,75 GET WGRUPO
         @ 8,12 GET WDIRPRO1
         @ 9,12 GET WDIRPRO2
         @ 8,54 GET WTELPRO1
         @ 9,54 GET WTELPRO2
         READ
         STORE "CONFORME? (S/N)" TO TEX
         STORE "SN" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            LOOP
         ENDIF
         IF RECLOC()
            REPLACE CODIGO     WITH WCODPRO
            REPLACE DESCRI     WITH WDESPRO
            REPLACE TIPO       WITH WGRUPO
            REPLACE DIRECCION1 WITH WDIRPRO1
            REPLACE DIRECCION2 WITH WDIRPRO2
            REPLACE TELEFONOS1 WITH WTELPRO1
            REPLACE TELEFONOS2 WITH WTELPRO2
            REPLACE USERNAME   WITH WUSERCODE
            REPLACE USERDATE   WITH DATE()
            FLUSH
            UNLOCK ALL
         ENDIF
      ENDIF
   ENDIF
ENDDO
RETURN

