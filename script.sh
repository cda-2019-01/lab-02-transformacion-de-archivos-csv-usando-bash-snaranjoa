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
tail +2 estacion2.csv >> estaciones.csv
tail +2 estacion3.csv >> estaciones.csv
tail +2 estacion4.csv >> estaciones.csv
wc -l estaciones.csv

#Actualizar nombres de campos
awk 'BEGIN{print "FECHA;HHMMSS;DIR;VEL;EST"}(NR>1){print $0}' estaciones.csv > estaciones1.csv

#Cambiar separadores
tr ',' '.' < estaciones1.csv > estaciones2.csv
tr ';' ',' < estaciones2.csv > estaciones3.csv

#Obtener titulos
csvcut -n estaciones3.csv

#Organizar datos y campos
sed 's;/\([0-9][0-9]\),;/20\1,;' estaciones3.csv > estaciones4.csv
head estaciones4.csv
