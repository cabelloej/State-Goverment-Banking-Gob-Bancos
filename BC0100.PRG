SET TALK OFF
SET ECHO OFF
if WBCARCHI  = space(1)
   return
endif
store .t. to subve3
do while subve3
   SET COLOR TO W+/BG+
   STORE T7 TO MES
   DO MENSAJE WITH MES
   @ 08,54   PROMPT "BANCOS                  "
   @ 09,54   PROMPT "SUCURSALES              "
   @ 10,54   PROMPT "TIPOS CUENTAS           "
   @ 11,54   PROMPT "CLASIFICACION DE CUENTAS"
   @ 12,54   prompt "CUENTAS                 "
   @ 13,54   prompt "SUBCUENTAS              "
   @ 14,54   prompt "REFERENCIAS DE OPERAC.  "
   @ 15,54   prompt "BENEFICIARIOS           "
   @ 16,54   prompt "OPERADORES X CUENTAS    "
   save scre to s3
   menu to WSUB0100
   do case
      case WSUB0100=1
           if WBCARCHI<>"A"
              LOOP
           endif
           do BC0101
      case WSUB0100=2
           if WBCARCHI<>"A"
              LOOP
           endif
           do BC0102
      case WSUB0100=3
           if WBCARCHI<>"A"
              LOOP
           endif
           do BC0103
      case WSUB0100=4
           if WBCARCHI<>"A"
              LOOP
           endif
           do BC0104
      case WSUB0100=5
           if WBCARCHI<>"A"
              LOOP
           endif
           do BC0105
      case WSUB0100=6
           if WBCARCHI<>"A"
              LOOP
           endif
           do BC0106
      case WSUB0100=7
           if WBCARCHI<>"A"
              LOOP
           endif
           do BC0107
      case wsub0100=8
           do BC0108
           *** PARA PODER SER LLAMADO DESDE OTRO PROGRAMA SIN CERRAR
           CLOSE DATA
           CLOSE INDEX
      case wsub0100=9
           if WBCARCHI<>"A"
              LOOP
           endif
           do BC0109
      case WSUB0100= 0
           store .f. to subve3
   endcase
   restore scre from s3
enddo
