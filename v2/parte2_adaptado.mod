# ==============================================================================
# MODELO PARTE 2: PLANIFICACIÓN INTEGRADA CON RECURSOS HUMANOS
# Adaptado a la nomenclatura y estilo del grupo (v2)
# ==============================================================================

# Conjuntos
set P;            # Tipos de producto (A, B)
set T ordered;    # Periodos / Meses (1..12)

# Parámetros Productivos (idénticos a pt1.dat)
param demanda{P, T} >= 0;
param utilidad{P, T} >= 0;
param horas_maquina{P, T} >= 0;
param capacidad{T} >= 0;
param costo_inventario{T} >= 0;
param inventario_seguridad{T} >= 0;
param inventario_maximo{T} >= 0;
param inventario_inicial{P} >= 0;

# Parámetros de Recursos Humanos (Tabla 5 y enunciados)
param costo_regular{T} >= 0;        # Costo por 1 hh en horario regular ($/hh)
param costo_horas_extras{T} >= 0;   # Costo por 1 hh de sobretiempo ($/hh)
param costo_contratacion{T} >= 0;   # Costo de incrementar dotación en 1 hh ($/hh)
param costo_despido{T} >= 0;        # Costo de reducir dotación en 1 hh ($/hh)
param dotacion_inicial >= 0;        # Dotación inicial de personal (300 hh)
param requerimiento_hh >= 0;        # Horas-hombre necesarias por unidad (3 hh)

# Variables de Decisión Productivas
var x{P, T} >= 0;   # Unidades a producir del producto p en mes t
var v{P, T} >= 0;   # Unidades a vender del producto p en mes t
var i{P, T} >= 0;   # Unidades en inventario final de p en mes t

# Variables de Decisión de Recursos Humanos
var w{T} >= 0;      # Dotación regular disponible en mes t (hh)
var h{T} >= 0;      # Horas contratadas al inicio del mes t (hh)
var f{T} >= 0;      # Horas desvinculadas/despedidas al inicio de mes t (hh)
var o{T} >= 0;      # Horas extras (sobretiempo) utilizadas en mes t (hh)

# Función Objetivo: Maximizar ventas MENOS costos de almacenamiento MENOS costos de RRHH
maximize Utilidad_Total:
    sum {p in P, t in T} utilidad[p,t] * v[p,t]
    - sum {p in P, t in T} costo_inventario[t] * i[p,t]
    - sum {t in T} (
        costo_regular[t] * w[t] + 
        costo_horas_extras[t] * o[t] + 
        costo_contratacion[t] * h[t] + 
        costo_despido[t] * f[t]
    );

# Restricciones Productivas
# 1. Cota superior de demanda
subject to Cota_Demanda {p in P, t in T}:
    v[p,t] <= demanda[p,t];

# 2. Capacidad de maquinaria mensual
subject to Capacidad_Maquinaria {t in T}:
    sum {p in P} horas_maquina[p,t] * x[p,t] <= capacidad[t];

# 3. Balance de inventario mensual
subject to Balance_Inventario {p in P, t in T}:
    i[p,t] = (if ord(t) == 1 then inventario_inicial[p] else i[p, prev(t)]) + x[p,t] - v[p,t];

# 4. Capacidad máxima de bodega compartida
subject to Max_Inventario_Bodega {t in T}:
    sum {p in P} i[p,t] <= inventario_maximo[t];

# 5. Inventario de seguridad en bodega
subject to Inventario_Seguridad_Bodega {t in T}:
    sum {p in P} i[p,t] >= inventario_seguridad[t];

# Restricciones de Recursos Humanos
# 6. Balance de dotación de personal
subject to Balance_Dotacion {t in T}:
    w[t] = (if ord(t) == 1 then dotacion_inicial else w[prev(t)]) + h[t] - f[t];

# 7. Requerimiento de mano de obra para producción
subject to Requerimiento_Mano_Obra {t in T}:
    requerimiento_hh * (sum {p in P} x[p,t]) <= w[t] + o[t];
