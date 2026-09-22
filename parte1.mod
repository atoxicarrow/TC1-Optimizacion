# ==============================================================================
# MODELO PARTE 1: PLANIFICACIÓN DE LA PRODUCCIÓN (BASE)
# Tarea Computacional 1 - Optimización
# Universidad Diego Portales - Escuela de Ingeniería Industrial
# ==============================================================================

# CONJUNTOS
set PERIODOS ordered;
set PRODUCTOS;

# PARÁMETROS
param Demanda{PRODUCTOS, PERIODOS} >= 0;
param Utilidad{PRODUCTOS, PERIODOS} >= 0;
param HorasMaq{PRODUCTOS, PERIODOS} >= 0;
param CapacidadMaq{PERIODOS} >= 0;
param CostoInv{PERIODOS} >= 0;
param InvSeg{PERIODOS} >= 0;
param InvMax{PERIODOS} >= 0;
param InvInicial{PRODUCTOS} >= 0;

# VARIABLES DE DECISIÓN
var X{PRODUCTOS, PERIODOS} >= 0;    # Unidades a producir
var V{PRODUCTOS, PERIODOS} >= 0;    # Unidades a vender
var I{PRODUCTOS, PERIODOS} >= 0;    # Unidades en inventario al final del periodo

# FUNCIÓN OBJETIVO: Maximizar utilidad anual menos costos de inventario
maximize Beneficio_Neto:
    sum {p in PRODUCTOS, t in PERIODOS} Utilidad[p,t] * V[p,t]
    - sum {p in PRODUCTOS, t in PERIODOS} CostoInv[t] * I[p,t];

# RESTRICCIONES
# 1. Balance de Inventario mensual
subject to Balance_Inv {p in PRODUCTOS, t in PERIODOS}:
    I[p,t] = (if ord(t) == 1 then InvInicial[p] else I[p, prev(t)]) + X[p,t] - V[p,t];

# 2. Cota de Demanda Máxima (desigualdad para evitar infactibilidad)
subject to Cota_Demanda {p in PRODUCTOS, t in PERIODOS}:
    V[p,t] <= Demanda[p,t];

# 3. Capacidad de Maquinaria
subject to Capacidad_Maquinaria {t in PERIODOS}:
    sum {p in PRODUCTOS} HorasMaq[p,t] * X[p,t] <= CapacidadMaq[t];

# 4. Capacidad Máxima de Bodega Compartida
subject to Capacidad_Bodega {t in PERIODOS}:
    sum {p in PRODUCTOS} I[p,t] <= InvMax[t];

# 5. Inventario de Seguridad Compartido en Bodega
subject to Inventario_Seguridad {t in PERIODOS}:
    sum {p in PRODUCTOS} I[p,t] >= InvSeg[t];
