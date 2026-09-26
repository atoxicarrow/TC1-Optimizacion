# pt2 mod

# conjuntos
set PERIODOS ordered;
set PRODUCTOS;

# parametros productivos
param Demanda{PRODUCTOS, PERIODOS} >= 0;
param Utilidad{PRODUCTOS, PERIODOS} >= 0;
param HorasMaq{PRODUCTOS, PERIODOS} >= 0;
param CapacidadMaq{PERIODOS} >= 0;
param CostoInv{PERIODOS} >= 0;
param InvSeg{PERIODOS} >= 0;
param InvMax{PERIODOS} >= 0;
param InvInicial{PRODUCTOS} >= 0;

# recursos humanso parametros
param CostoReg{PERIODOS} >= 0;     
param CostoExt{PERIODOS} >= 0;     
param CostoContr{PERIODOS} >= 0;   
param CostoDesp{PERIODOS} >= 0;    
param RequerimientoHH >= 0;        
param DotacionInicial >= 0;        

# variables de decision productivas
var X{PRODUCTOS, PERIODOS} >= 0;    #unidades a producir
var V{PRODUCTOS, PERIODOS} >= 0;    #unidades a vender
var I{PRODUCTOS, PERIODOS} >= 0;    #inventario final

#variables de decision de rrhh
var W{PERIODOS} >= 0;               #dotación de fuerza laboral disponible (hh)
var H{PERIODOS} >= 0;               #horas hombre contratadas
var F{PERIODOS} >= 0;               #horas hombre despedidas
var O{PERIODOS} >= 0;               #horas extra utilizadas

# FO (ingresos - costos inventario - costos RRHH)
maximize Beneficio_Neto:
    sum {p in PRODUCTOS, t in PERIODOS} Utilidad[p,t] * V[p,t]
    - sum {p in PRODUCTOS, t in PERIODOS} CostoInv[t] * I[p,t]
    - sum {t in PERIODOS} (
        CostoReg[t] * W[t] + 
        CostoExt[t] * O[t] + 
        CostoContr[t] * H[t] + 
        CostoDesp[t] * F[t]
    );

# restricciones en productividada
# balance de inventario
subject to Balance_Inv {p in PRODUCTOS, t in PERIODOS}:
    I[p,t] = (if ord(t) == 1 then InvInicial[p] else I[p, prev(t)]) + X[p,t] - V[p,t];

# cota de demanda maxima
subject to Cota_Demanda {p in PRODUCTOS, t in PERIODOS}:
    V[p,t] <= Demanda[p,t];

# capacidad maxima de maquinaria
subject to Capacidad_Maquinaria {t in PERIODOS}:
    sum {p in PRODUCTOS} HorasMaq[p,t] * X[p,t] <= CapacidadMaq[t];

# capacidad maxima de bodega compartida
subject to Capacidad_Bodega {t in PERIODOS}:
    sum {p in PRODUCTOS} I[p,t] <= InvMax[t];

# inventario de seguridad compartida en bodega 
subject to Inventario_Seguridad {t in PERIODOS}:
    sum {p in PRODUCTOS} I[p,t] >= InvSeg[t];

# resticciones en recursos humanso
#  balance de fuerza laboral
subject to Balance_Dotacion {t in PERIODOS}:
    W[t] = (if ord(t) == 1 then DotacionInicial else W[prev(t)]) + H[t] - F[t];

# requerimiento de mano de obra para produccion
subject to Requerimiento_Mano_Obra {t in PERIODOS}:
    RequerimientoHH * (sum {p in PRODUCTOS} X[p,t]) <= W[t] + O[t];
