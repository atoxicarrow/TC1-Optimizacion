#Conjuntos
set P; #Tipos de producto
set M; #Meses 

#parametros
param d_max{p in P, m in M}; #Demanda maxima por producto en el mes M
param u{p in P, m in M}; #Utilidad por producto
param h{p in P, m in M}; #Horas necesarias de maquina por producto
param ch{m in M}; #Horas de maquinaria disponible en m 
param c{p in P, m in M}; #Costo inventario
#param i{p in P, m in M} == 10; #inventario inicial
param is{p in P, m in M}; #Inventario seguridad
param imax{p in P, m in M};
#variables

#var a{p in P, m in M} >= 0, integer; #numero producto A producidos en mes m
#var b{p in P, m in M} >= 0, integer; #numero producto B producidos en mes m
var i_a{p in P, m in M} >= 0, integer; #inventario final A
var i_b{p in P, m in M} >= 0, integer; #inventario final B
var v{p in P, m in M} >= 0, integer; #ventas 

#Funcion objetivo

maximize U:
 sum {p in P, m in M} u[p,m]v[p,m];

#restricciones

subject to max_productos{p in P, m in M}: 
v[p,m] <= d_max[p,m];

subject to capacidad{m in M}:
    sum {p in P} (h[p,m]a[p,m] + h[p,m]*b[p,m]) <= ch[m];  #basicamente las horas de produccion de a+b no puede superar las horas disponibles en total

subject to inventario_I_A{p in p}:
    10+a[p,1] - v[p,1]=i_a[p,1];
subject to inventario_I_B{p in p}:
    10+b[p,1] - v[p,1]=i_b[p,1];   # inventario inicial producto a y b 

subject to balance_a{p in P, m in M: m>1}:
    i_a[p,m-1]+ a[p,m] - v[p,m]=i_a[p,m];
subject to balance_b{p in P, m in M: m>1}:
    i_b[p,m-1]+ b[p,m] - v[p,m]=i_b[p,m];
subject to seguridad_a{p in P, m in M}:
    i_a[p,m] >= is[p,m];
subject to seguridad_b{p in P, m in M}:
    i_b[p,m] >= is[p,m];
subject to max_inventario_a{p in P, m in M}:
    i_a[p,m] <= imax[p,m];
subject to max_inventario_b{p in P, m in M}:
    i_b[p,m] <= imax[p,m]