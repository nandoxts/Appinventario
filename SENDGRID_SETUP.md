# Implementación de SendGrid en tu Proyecto

## ✅ Status: CONFIGURADO

Tu API Key ya está guardada en `Constants.swift`:
```swift
static let sendGridApiKey = "SG.2oNZoKtcR5K2i7S01zuQ_S2_4Zw41cxhvhvx3Er1I003e1uGUAU3Yz2IFIags"
static let sendGridFromEmail = "aplinventario@gmail.com"
static let sendGridFromName = "Sistema de Inventario"
```

## 📧 EMAILS SOLO PARA TRANSACCIONES IMPORTANTES

El sistema **NO envía emails para cualquier cosa**. Solo envía cuando:

### 1️⃣ **VENTA GRANDE** (Salida ≥ 50 unidades)
- Se registra una alerta cuando sacas 50 o más unidades
- Includes: producto, cantidad, stock anterior y actual
- Ejemplo: Vendiste 75 camisetas → Se envía email

### 2️⃣ **STOCK CRÍTICO** (Después de salida, stock ≤ 5 unidades)
- Se registra una alerta cuando el stock queda muy bajo
- Ejemplo: Vendiste 20 unidades y solo quedan 3 → Se envía email

### 3️⃣ **REABASTECIMIENTO GRANDE** (Entrada ≥ 50 unidades)
- Se registra una alerta cuando compras grandes cantidades
- Ejemplo: Compraste 100 unidades nuevas → Se envía email

## 🔧 Cómo funciona internamente

### Flujo automático:

```
1. Usuario crea una transacción en TransactionFormViewController
   ↓
2. TransactionViewModel.createTransaction() se ejecuta
   ↓
3. Se valida y se guarda la transacción en DataManager
   ↓
4. TransactionEmailService.processTransaction() decide automáticamente
   si es importante según los umbrales
   ↓
5. Si es importante → Se envía email a través de EmailService
   ↓
6. Si NO es importante → NO se envía nada (silencioso)
```

### Umbrales configurables:

En `Core/TransactionEmailService.swift`:
```swift
private let largeQuantityThreshold = 50      // Cantidad grande
private let criticalStockThreshold = 5       // Stock crítico
```

Si quieres cambiar estos valores, edita esos números.

## 📱 Ejemplo: Cómo se ve en tu app

**Escenario 1: Venta normal de 5 unidades**
```
Usuario → Crea transacción (5 unidades) → ✅ Transacción guardada
                                         → ❌ NO envía email (es pequeña)
```

**Escenario 2: Venta grande de 75 unidades**
```
Usuario → Crea transacción (75 unidades) → ✅ Transacción guardada
                                          → ✅ ENVÍA EMAIL (es grande)
                                          → Admin recibe alerta
```

**Escenario 3: Stock queda en 3 unidades**
```
Usuario → Crea transacción (salida) → Stock queda en 3
                                    → ✅ ENVÍA EMAIL (crítico)
                                    → Admin recibe alerta
```

## 🎨 Emails que recibe el Admin

### Alerta de Venta Grande 🚨
```
Asunto: 🚨 Venta Grande: Camiseta XL - 75 unidades

Incluye:
- Nombre del producto
- Cantidad vendida
- Stock anterior y actual
- Fecha y hora
```

### Alerta de Stock Crítico ⚠️
```
Asunto: ⚠️ Stock Crítico: Camiseta XL - Solo 3 unidades

Incluye:
- Producto con stock bajo
- Stock actual
- Recomendación de hacer pedido
```

### Alerta de Reabastecimiento 📦
```
Asunto: 📦 Reabastecimiento: Camiseta XL - 100 unidades

Incluye:
- Producto reabastecido
- Cantidad comprada
- Stock anterior y nuevo
- Fecha
```

## ⚙️ Archivos Modificados

1. ✅ **Constants.swift** - API Key y config de SendGrid
2. ✅ **EmailService.swift** - Servicio base para enviar emails (ya existía)
3. ✅ **TransactionEmailService.swift** - Lógica de transacciones importantes (NUEVO)
4. ✅ **TransactionViewModel.swift** - Integración con transacciones (ACTUALIZADO)

## 🧪 Testing

Para probar en el simulador:

1. Abre tu app
2. Crea una transacción de **60 unidades** (salida)
3. Revisa tu email → Deberías recibir alerta de "Venta Grande"
4. Crea una transacción de **5 unidades** (salida)
5. NO recibirás email (es pequeña, silencioso)

## ⚠️ Importante

- **El email del admin** se obtiene de `UserManager.shared.currentUser?.email`
- Si no hay usuario logeado, **no se envía email** (seguridad)
- Los emails se envían en background, **no bloquean la app**
- Límite gratuito: 100 emails/día en SendGrid

## 🔒 Seguridad

Tu API Key está guardada en `Constants.swift`. Para producción considera:
1. Guardar en un archivo `.plist` que no se versionee
2. Usar un backend que maneje los emails
3. No subir `Constants.swift` a GitHub si tiene datos sensibles

## 📞 Support

Si no reciben emails:
1. Verifica que el usuario tenga email guardado
2. Revisa que tengas una transacción > 50 unidades
3. Chequea la consola (Xcode) para mensajes de error
4. Verifica tu API Key es válida en SendGrid

