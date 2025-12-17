# 📦 Proyecto Inventario - Gestión de Stock iOS

Una aplicación iOS nativa desarrollada en Swift para la gestión completa de inventarios, productos y movimientos de stock en tiempo real.

## 🎯 Características Principales

- 🔐 **Autenticación de Usuarios** - Sistema de login seguro
- 📦 **Gestión de Productos** - Crear, editar, eliminar y listar productos
- 📊 **Categorización** - Organizar productos por categorías
- 📈 **Control de Stock** - Registro de entradas y salidas
- 📋 **Historial de Transacciones** - Seguimiento completo de movimientos
- 📊 **Reportes** - Dashboard con métricas y alertas de stock bajo
- 👤 **Perfil de Usuario** - Gestión de datos del usuario
- 🎨 **Interfaz Moderna** - Diseño limpio con UIKit

## 🛠️ Requisitos

- **macOS 11** o superior
- **Xcode 13** o superior
- **iOS 14** o superior (target deployment)
- **Swift 5.5+**

## 📥 Instalación

1. **Clonar el repositorio:**
```bash
git clone https://github.com/nandoxts/Appinventario.git
cd Appinventario
```

2. **Abrir en Xcode:**
```bash
open Proyecto_Inventario_Pablo_Mercado/Proyecto_Inventario_Pablo_Mercado.xcodeproj
```

3. **Seleccionar simulador o dispositivo** y presionar **Play** (Cmd + R)

## 🔑 Credenciales por Defecto

Para acceder a la aplicación usa:

```
Email:     admin@demo.com
Password:  123456
```

## 📁 Estructura del Proyecto

```
Proyecto_Inventario_Pablo_Mercado/
├── Core/
│   ├── Constants.swift         # Constantes globales
│   └── DataManager.swift       # Gestor central de datos (Singleton)
├── Models/
│   ├── User.swift              # Modelo de usuario
│   ├── Product.swift           # Modelo de producto
│   ├── ProductCategory.swift   # Categorías de productos
│   └── Transaction.swift       # Modelo de transacciones
├── Extension/
│   ├── UIButton.swift          # Componentes botón personalizados
│   ├── UITextField.swift       # Campos de texto estilizados
│   ├── DashboardButton.swift   # Botones del dashboard
│   ├── ProductCell.swift       # Celda de productos
│   ├── TransactionCell.swift   # Celda de transacciones
│   └── BaseCardCell.swift      # Celda base personalizada
├── Login/
│   ├── LoginViewController.swift
│   └── LoginViewModel.swift
├── Splash/
│   └── SplashViewController.swift
├── Home/
│   ├── HomeViewController.swift
│   └── ProfilePopupViewController.swift
├── Products/
│   ├── ProductListViewController.swift
│   ├── ProductFormViewController.swift
│   ├── ProductTableView.swift
│   └── ProductViewModel.swift
├── Transactions/
│   ├── TransactionListViewController.swift
│   ├── TransactionFormViewController.swift
│   ├── TransactionTableView.swift
│   └── TransactionViewModel.swift
├── Reporte/
│   ├── ReportsViewController.swift
│   ├── ReportsViewModel.swift
│   ├── ReportCardView.swift
│   └── LowStockTableView.swift
├── Assets.xcassets/            # Imágenes y colores
├── Base.lproj/                 # Storyboards
└── Info.plist                  # Configuración de app
```

## 🏗️ Arquitectura

El proyecto utiliza el patrón **MVVM (Model-View-ViewModel)**:

- **Models**: Estructuras de datos (`User`, `Product`, `Transaction`)
- **Views**: ViewControllers y componentes UI personalizados
- **ViewModels**: Lógica de negocio y gestión de datos
- **DataManager**: Singleton centralizado para almacenamiento en memoria

### Flujo de Datos

```
Usuario Interactúa → ViewController → ViewModel → DataManager
                                            ↓
                                    Actualiza datos
                                            ↓
                                    Notifica cambios
                                            ↓
                                    UI se actualiza
```

## 🔄 Flujo de la Aplicación

1. **Splash Screen** → Logo animado (1.5 segundos)
2. **Login** → Autenticación con credenciales
3. **Home (Dashboard)** → 3 módulos principales:
   - 📦 Productos
   - 📈 Movimientos
   - 📊 Reportes
4. **Perfil** → Gestión de datos del usuario

## 💾 Almacenamiento de Datos

- **En Memoria**: Productos, transacciones e historial
- **UserDefaults**: Datos de usuario (nombre, email)
- ⚠️ **Nota**: Los datos se pierden al cerrar la app (sin persistencia en BD)

## 🎨 Componentes Personalizados

### DashboardButton
Botones grandes del home con icono, título y subtítulo.

### UITextField Extensions
Campos de texto estilizados con validación de teclado (email, números, etc.)

### UIButton Extensions
Botones personalizados con estilo primary y configuración predefini

### ProductCell & TransactionCell
Celdas especializadas para mostrar productos y transacciones.

## 🚀 Uso de la Aplicación

### Agregar Producto
1. Home → Productos
2. Tap en el botón "+"
3. Completar formulario (nombre, precio, stock, categoría)
4. Guardar

### Registrar Movimiento
1. Home → Movimientos
2. Tap en el botón "+"
3. Seleccionar producto
4. Definir cantidad y tipo (Entrada/Salida)
5. Confirmar

### Ver Reportes
1. Home → Reportes
2. Ver resumen de productos
3. Alertas de stock bajo

## 🔧 Desarrollo

### Agregar Nuevas Funcionalidades

1. **Crear modelo** en `Models/`
2. **Agregar métodos** en `DataManager.swift`
3. **Crear ViewController** en su carpeta correspondiente
4. **Crear ViewModel** para lógica de negocio
5. **Actualizar navegación** en `SceneDelegate.swift` o controller padre

### Debugging

- Usa **Xcode Debugger** (F6 para pausar)
- Breakpoints en `DataManager` para verificar cambios de datos
- Inspecciona propiedades en la sección de Variables de Xcode

## 🐛 Problemas Comunes

### "Build Failed"
- Verifica que tengas Xcode 13+ instalado
- Limpia el build: Cmd + Shift + K

### App no inicia
- Abre los logs en Xcode Console (Cmd + Shift + C)
- Verifica `SceneDelegate.swift`

### Datos no se guardan
- Es normal - solo guarda en `UserDefaults` el nombre
- Para persistencia, necesitas implementar **Core Data** o **SQLite**

## 📝 Próximas Mejoras

- [ ] Integración con Core Data o Realm
- [ ] Sincronización con servidor backend
- [ ] Autenticación con biometría (Face ID/Touch ID)
- [ ] Exportar reportes a PDF
- [ ] Dark mode soporte completo
- [ ] Notificaciones de stock bajo
- [ ] Búsqueda y filtros avanzados

## 👨‍💻 Autor

Desarrollado por **Pablo Mercado**

## 📄 Licencia

Este proyecto está bajo licencia MIT. Ver `LICENSE` para más detalles.

## 📞 Contacto

- GitHub: [@nandoxts](https://github.com/nandoxts)
- Proyecto: [Appinventario](https://github.com/nandoxts/Appinventario)

---

**¿Dudas o sugerencias?** Abre un issue en GitHub.

**Versión:** 1.0.0  
**Última actualización:** 16 de Diciembre, 2025
