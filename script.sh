cd estaciones
#Incluir columna con estación
sed 's/;\([0-9]\),\([0-9]\)/;\1,\2;E1/' estacion1.csv > estacion_1.csv
sed 's/;\([0-9]\),\([0-9]\)/;\1,\2;E2/' estacion2.csv > estacion_2.csv
sed 's/;\([0-9]\),\([0-9]\)/;\1,\2;E3/' estacion3.csv > estacion_3.csv
sed 's/;\([0-9]\),\([0-9]\)/;\1,\2;E4/' estacion4.csv > estacion_4.csv

#Comprobar numero de filas
wc -l estacion1.csv estacion2.csv estacion3.csv estacion4.csv

#Unir las bases
cat estacion_1.csv > estaciones.csv
tail +2 estacion_2.csv >> estaciones.csv
tail +2 estacion_3.csv >> estaciones.csv
tail +2 estacion_4.csv >> estaciones.csv
wc -l estaciones.csv

#Actualizar nombres de campos
awk 'BEGIN{print "FECHA;HHMMSS;DIR;VEL;EST"}(NR>1){print $0}' estaciones.csv > estaciones1.csv

#Cambiar separadores
tr ',' '.' < estaciones1.csv > estaciones2.csv
tr ';' ',' < estaciones2.csv > estaciones3.csv

#Organizar datos y campos
sed 's;/\([0-9][0-9]\),;/20\1,;' estaciones3.csv > estaciones4.csv

#Incluir ano, mes y hora
sed 's;/\([0-9][0-9]\)/\([0-9][0-9][0-9][0-9]\),;/\1/\2,\1,\2,;' estaciones4.csv > estaciones5.csv
sed 's/,\([0-9][0-9]\):/,\1,\1:/' estaciones5.csv > estaciones6.csv
awk 'BEGIN{print "FECHA,MES,ANO,HORA,HHMMSS,DIR,VEL,EST"}(NR>1){print $0}' estaciones6.csv > finalestaciones.csv
head -n 5 finalestaciones.csv
tail -n 5 finalestaciones.csv

#Obtener titulos
csvcut -n finalestaciones.csv

#Creacion de tablas
csvsql --query 'select EST,MES,avg(VEL) as VELPROM from finalestaciones group by EST,MES' finalestaciones.csv > velocidad-por-mes.csv
csvsql --query 'select EST,ANO,avg(VEL) as VELPROM from finalestaciones group by EST,ANO' finalestaciones.csv > velocidad-por-ano.csv
csvsql --query 'select EST,HORA,avg(VEL) as VELPROM from finalestaciones group by EST,HORA' finalestaciones.csv > velocidad-por-hora.csv

#Creacion de directorio resultado
cd ..
mkdir resultado
mv ./estaciones/velocidad-por-mes.csv ./resultado/velocidad-por-mes.csv
mv ./estaciones/velocidad-por-ano.csv ./resultado/velocidad-por-ano.csv
mv ./estaciones/velocidad-por-hora.csv ./resultado/velocidad-por-hora.csv

#Borrar archivos temporales
rm ./estaciones/estacion_*.csv
rm ./estaciones/estaciones*.csv
