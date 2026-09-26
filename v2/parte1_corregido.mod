# ==============================================================================
# MODELO PARTE 1 - ADAPTADO AL ESTILO Y DATOS DEL GRUPO (v2)
# ==============================================================================

# Conjuntos
set P;            # Tipos de producto (A, B)
set T ordered;    # Periodos / Meses (1..12)

# Parámetros (alineados exactamente con pt1.dat)
param demanda{P, T} >= 0;
param utilidad{P, T} >= 0;
param horas_maquina{P, T} >= 0;
param capacidad{T} >= 0;
param costo_inventario{T} >= 0;
param inventario_seguridad{T} >= 0;
param inventario_maximo{T} >= 0;
param inventario_inicial{P} >= 0;

# Variables de Decisión
var x{P, T} >= 0;   # Producción del producto p en el mes t (reemplaza a y b)
var v{P, T} >= 0;   # Ventas del producto p en el mes t
var i{P, T} >= 0;   # Inventario final del producto p en el mes t (reemplaza i_a e i_b)

# Función Objetivo: Maximizar utilidad por ventas MENOS costo de almacenamiento
maximize Utilidad_Total:
    sum {p in P, t in T} utilidad[p,t] * v[p,t]
    - sum {p in P, t in T} costo_inventario[t] * i[p,t];

# Restricciones
# 1. Cota superior de demanda (no vender más de lo que se demanda)
subject to Cota_Demanda {p in P, t in T}:
    v[p,t] <= demanda[p,t];

# 2. Capacidad de maquinaria mensual
subject to Capacidad_Maquinaria {t in T}:
    sum {p in P} horas_maquina[p,t] * x[p,t] <= capacidad[t];

# 3. Balance de inventario mensual (incluye inventario inicial en t=1)
subject to Balance_Inventario {p in P, t in T}:
    i[p,t] = (if ord(t) == 1 then inventario_inicial[p] else i[p, prev(t)]) + x[p,t] - v[p,t];

# 4. Capacidad máxima de bodega (compartida para todos los productos)
subject to Max_Inventario_Bodega {t in T}:
    sum {p in P} i[p,t] <= inventario_maximo[t];

# 5. Inventario de seguridad en bodega
subject to Inventario_Seguridad_Bodega {t in T}:
    sum {p in P} i[p,t] >= inventario_seguridad[t];
