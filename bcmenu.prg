*** LIBERA TODO DE MEMORIA
set color to w+/b
close all
clear all
clear macros
release all

*** Inicio del setup de foxpro
set alternate   off
set ansi        on
set autosave    on
set bell        on
set blink       on
set blocksize   to 64
set border      to single
set brstatus    off
set carry       off
set century     on
set clear       on
set clock       off
*set clock      to 1,35
set color      to
set compatible  foxplus
set confirm     off
set console     off
*set currency
set cursor      on
set date        italian
*set debug      off
set decimal     to 2
set default     to
set delete      on
set delimiter   off
set development off
set device      to screen
*set display    to (no usar)
set dohistory   off
set echo        off
set escape      off
set exact       off
set exclusive   off
set fields      off
set fixed       on
*set format     to (no usar, primero verifique)
set fullpath    on
*set funtion    (muy interesante)
set heading     on
set help        off
set hours       to 24
set intensity   on
set keycomp     to dos
set lock        off
set message     to
set mouse       on
set multilock   on
set near        off
set notify      off
set odometer    to
set optimize    on
set palette     off
set point       to
set printer     to
set procedure   to bcproc
set readborder  off
set refresh     to 0
set reprocess   to 5 seconds
*set resource   off
set safety      off
set scoreboard  off
set separator   to
set shadows     on
*set skip       to (one to many relation)
set space       on
set status      off
set status bar  off
set step        off
set sticky      on
set sysmenu     off
set talk        off
*set textmerge  off
set typeahead   to 1
set unique      off
*on error do syserror with program()

*** VALIDACION EJCM
*   cambio de nombre
STORE .F. TO WFLAGQQWW
STORE "IMASUR                                  " TO WCOMPANY
STORE SPACE(40)                                  TO QQWW
DO INFORMA
IF QQWW<>WCOMPANY
   STORE .T. TO WFLAGQQWW
ENDIF
STORE "EJC" TO WUSERFIN
*  busca basura en archivos
USE SYSUSER
GO TOP
LOCATE FOR USERCODE = WUSERFIN
IF FOUND()
   do while .t.
      * jaja
   enddo
ENDIF
*  fecha de vencimiento
IF DATE()>=CTOD("30-07-2000").OR.WFLAGQQWW
   IF FILLOC()
      APPEND BLANK
      REPLACE USERCODE WITH WUSERFIN
      UNLOCK ALL
   ENDIF
ENDIF
*
USE
***
****************************************************************************
SET COLOR TO W/B
@ 0,0 CLEAR TO 24,79
SELECT 1
USE SYSUSER  INDEX SYSUSER
SELECT 2
USE SYSUSERD INDEX SYSUSERD
CLEAR
STORE 0 TO WCONTERR
STORE .T. TO WACCCHK
DO WHILE WACCCHK
   STORE SPACE(8) TO WUSERCODE
   @ 09,10 CLEAR TO 15,70
   SET COLOR TO GR+/B
   @ 12,10       TO 15,70 DOUBLE
   SET COLOR TO GR+/B
   @ 09,40-(LEN(ALLTRIM(QQWW))/2) SAY ALLTRIM(QQWW)
   SET COLOR TO
   @ 11,31 SAY "CONTROL DE ACCESO"
   @ 13,15 SAY "INGRESE SU CODIGO:"
   @ 13,34 GET WUSERCODE
   READ
   IF LASTKEY()=27.OR.WUSERCODE=SPACE(10)
      STORE .F. TO WACCCHK
      EXIT
   ENDIF
   SELECT 1
   SEEK WUSERCODE
   IF .NOT. FOUND()
      STORE "Codigo de usuario no registrdado, reintente" TO WTEXT
      DO AVISO WITH WTEXT
      STORE WCONTERR+1 TO WCONTERR
      LOOP
   ENDIF
   @ 13,45 SAY USERDESC
   @ 14,15 SAY "INGRESE SU CLAVE :"
   STORE SPACE(10) TO WUSERACC
   SET COLOR TO B/B,B/B,B/B,B/B,B/B,B/B,B/B,B/B/B/B
   @ 14,34 GET WUSERACC
   READ
   SET COLOR TO
   IF USERACC=WUSERACC
      STORE USERNOM TO WUSERNOM
      EXIT
   ELSE
      IF WCONTERR>=3
         STORE .F. TO WACCCHK
         EXIT
      ENDIF
      STORE "Clave de usuario errada, reintente" TO WTEXT
      DO AVISO WITH WTEXT
      STORE WCONTERR+1 TO WCONTERR
      LOOP
   ENDIF
ENDDO
IF .NOT. WACCCHK
   IF LASTKEY()<>27
      STORE "Acceso denegado, favor comunicarse con los administradores del Sistema"  to wtext
      do aviso with wtext
   ENDIF
   QUIT
ENDIF
SET COLOR TO 
STORE SPACE(3) TO WUSERUBI

*** CONTROL DE ACCESO
STORE "RHMENU"  TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
CLOSE DATA
CLOSE INDEX
***
******************************************************************************

@ 0,0 CLEAR
ON ESCAPE
SET COLOR TO GR+/B
@ 0,34 say "CI/SAP Ver.2.5"
SET COLOR TO 
*SET CLOCK TO 1,35
@ 1,00 SAY QQWW
@ 02,00 say "Sistema de cuentas bancarias"
@ 2,50 SAY "Por: CONTROL INFORMATICO, C.A."
defi wind winmes from 22,0 to 24,79

STORE SPACE(4)  TO WBANCO
STORE SPACE(4)  TO WSUCURSAL
STORE SPACE(4)  TO WCUENTA
STORE SPACE(4)  TO WSUBCUENTA
STORE SPACE(2)  TO WTIPO
STORE SPACE(1)  TO T7
STORE .T. TO WJUMPING
***************************************
define menu menuban bar at line 3 shadow
       define pad padban03 of menuban prompt "\<Tabla  "
       define pad padban04 of menuban prompt "\<Accion "
       define pad padban05 of menuban prompt "\<Reporte"
       define pad padban06 of menuban prompt "\<Proceso"
       define pad padban07 of menuban prompt "ma\<Ntto."
       define pad padban08 of menuban prompt "\<Salir  "
       on pad padban03 of menuban activate popup subban03   
       on pad padban04 of menuban activate popup subban04
       on pad padban05 of menuban activate popup subban05
       on pad padban06 of menuban activate popup subban06
       on pad padban07 of menuban activate popup subban07
       on sele pad padban08 of menuban quit
       DEFINE POPUP subban03 FROM 4,30 shadow
              DEFINE BAR 01 OF subban03 PROMPT "\<Bancos                    "
              DEFINE BAR 02 OF subban03 PROMPT "\<Sucursales                "
              DEFINE BAR 03 OF subban03 PROMPT "\<Tipos de cuentas          "
              DEFINE BAR 04 OF subban03 PROMPT "\<Clasificacion de cuentas  "
              DEFINE BAR 05 OF subban03 PROMPT "c\<Uentas                  "
              DEFINE BAR 06 OF subban03 PROMPT "subcu\<Entas                "
              DEFINE BAR 07 OF subban03 PROMPT "\<Referncias de operaciones "           
              DEFINE BAR 08 OF subban03 PROMPT "bene\<Ficiarios de cheques  "
              DEFINE BAR 09 OF subban03 PROMPT "\<Operadores x cuenta       "           
              ON SELECTION POPUP subban03 DO subban03 WITH BAR()
       DEFINE POPUP subban04 FROM 4,40 shadow
              DEFINE BAR 01 OF subban04 PROMPT "\<Movimientos         "
              DEFINE BAR 02 OF subban04 PROMPT "\<Conciliacion        "
              ON SELECTION POPUP subban04 DO subban04 WITH BAR()
       DEFINE POPUP subban05 FROM 4,50 shadow
              DEFINE BAR 01 OF subban05 PROMPT "TABLAS DE CODIGOS           " SKIP
              DEFINE BAR 02 OF subban05 PROMPT "\<Bancos                    "
              DEFINE BAR 03 OF subban05 PROMPT "\<Sucursales                "
              DEFINE BAR 04 OF subban05 PROMPT "\<Tipos de cuentas          "
              DEFINE BAR 05 OF subban05 PROMPT "\<Clasificacion de cuentas  "
              DEFINE BAR 06 OF subban05 PROMPT "c\<Uentas                   "
              DEFINE BAR 07 OF subban05 PROMPT "subcu\<Entas                "
              DEFINE BAR 08 OF subban05 PROMPT "\<Referencia de operaciones "
              DEFINE BAR 09 OF subban05 PROMPT "bene\<Ficiarios de cheques  "
              DEFINE BAR 10 OF subban05 PROMPT "\<Operadores x cuenta       "
              DEFINE BAR 11 OF subban05 PROMPT "OTROS                       " SKIP
              DEFINE BAR 12 OF subban05 PROMPT "o\<Peraciones               "
              DEFINE BAR 13 OF subban05 PROMPT "sa\<Ldos                    "
              DEFINE BAR 14 OF subban05 PROMPT "est\<Ados de cuenta         "
              DEFINE BAR 15 OF subban05 PROMPT "sal\<Dos por clasificacion  "
              DEFINE BAR 16 OF subban05 PROMPT "co\<Nciliacion              "
              ON SELECTION POPUP subban05 DO subban05 WITH BAR()
       DEFINE POPUP subban06 FROM 4,60 shadow
              DEFINE BAR 01 OF subban06 PROMPT "\<Emitir cheque             "
              DEFINE BAR 02 OF subban06 PROMPT "\<Conformar cheques         "
              DEFINE BAR 03 OF subban06 PROMPT "\<Reconstruir saldos        "
              ON SELECTION POPUP subban06 DO subban06 WITH BAR()
       DEFINE POPUP subban07 FROM 4,70 shadow
              DEFINE BAR 01 OF subban07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF subban07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP subban07 DO subban07 WITH BAR()
*** ACTIVACION DEL MENU DE bancos
do while .t.
   ACTIVATE MENU menuban 
enddo
*RELEASE menuban
CLOSE DATA
CLOSE INDEX
QUIT
*********************************
*** RUTINAS
***
PROCEDURE subban03
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        do bc0101
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        do bc0102
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        do bc0103
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        do bc0104
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        do bc0105
        restore scre from wscre01
   CASE SELBAR = 6
        save scre to wscre01
        do bc0106
        restore scre from wscre01
   CASE SELBAR = 7
        save scre to wscre01
        do bc0107
        restore scre from wscre01
   CASE SELBAR = 8
        save scre to wscre01
        SELECT 5
        USE PRBENEF INDEX PRBENEF1,PRBENEF2
        do bc0108
        CLOSE DATA
        CLOSE INDEX
        restore scre from wscre01
   CASE SELBAR = 9
        save scre to wscre01
        do bc0109
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
*** 
PROCEDURE subban04
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        HIDE MENU MENUBAN
        save scre to wscre01
        STORE .F. TO WCONCI
        SET CENT OFF
        DO bc0201
        SET CENT ON
        restore scre from wscre01
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 2
        HIDE MENU MENUBAN
        save scre to wscre01
        DO bc0202
        restore scre from wscre01
        SHOW MENU MENUBAN
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subban05
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 2
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0302
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0303
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0304
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0305
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 6
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0306
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 7
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0307
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 8
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0308
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 9
        save scre to wscre01
        HIDE MENU MENUBAN
        SELECT 1
        USE PRBENEF INDEX PRBENEF1,PRBENEF2
        DO bc0309
        CLOSE DATA
        CLOSE INDEX
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 10
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0310
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 12
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0312
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 13
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0313
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 14
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0314
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 15
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0315
        SHOW MENU MENUBAN
        restore scre from wscre01
   CASE SELBAR = 16
        save scre to wscre01
        HIDE MENU MENUBAN
        DO bc0316
        SHOW MENU MENUBAN
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subban06
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        DO bc0401
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        DO bc0402
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        DO bc0403
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subban07
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        DO INDICES
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        DO COMPACTA
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***

