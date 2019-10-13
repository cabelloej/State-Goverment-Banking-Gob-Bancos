*** REPROCESAR SALDOS
STORE "DESEA RECALCULAR LOS SALDOS ? (S/N) " TO TEX
STORE "NS" TO WCH
DO PREGUNTA
IF WCH = "N"
   RETURN
ENDIF
STORE "RECALCULANDO SALDOS POR SUBCUENTAS. FAVOR ESPERAR ..." TO MES
DO MENSAJE WITH MES

select 1
use bcsubcta index bcsubcta
select 2
use bcopera index bcopera1
select 1
do while .not. eof()
   store cta    to wcta
   store subcta to wsubcta
   store 0      to wsaldo
   store wcta+wsubcta to wclavecta
   select 2
   find &wclavecta
   do while .not. eof() .and. cta = wcta .and. subcta = wsubcta
      IF ESTATUS = "AN"
         SELECT 2
         SKIP
         LOOP
      ENDIF
      if tipope = "DP" .or. tipope = "NC"
         store wsaldo + monto to wsaldo
      else
         if tipope = "CH" .or. tipope = "ND"
            store wsaldo - monto to wsaldo
         endif
      endif
      select 2
      skip
   enddo
   select 1
   do recloc
   replace saldo with wsaldo
   unlock
   skip
enddo
store "OPERACION EFECTUADA SATISFACTORIAMENTE. OPRIMA <ENTER>" TO MES
DO AVISO WITH MES
CLOSE DATA
CLOSE INDEX
RETURN
