# 🔤 Cómo Instalar Fuentes Manrope en Xcode

## 📋 Paso a Paso

### 1. Descargar Manrope (si aún no lo hiciste)

Ve a Google Fonts: https://fonts.google.com/specimen/Manrope

O descarga directamente:
```bash
# Si tienes wget
wget https://fonts.google.com/download?family=Manrope -O manrope.zip
unzip manrope.zip -d Manrope
```

### 2. Copiar Archivos .ttf a este Folder

**Necesitas estos archivos específicamente:**

```
Manrope-ExtraLight.ttf
Manrope-Light.ttf
Manrope-Regular.ttf
Manrope-Medium.ttf
Manrope-SemiBold.ttf
Manrope-Bold.ttf
Manrope-ExtraBold.ttf
```

**Cómo copiarlos:**

1. Ve a donde descargaste Manrope
2. Busca la carpeta `static/` (si es variable font) o los archivos `.ttf` directos
3. Copia TODOS los pesos a esta carpeta:
   ```
   /Users/louieliet/Documents/GitHub/pantheronwellness/pantheronwellness/Shared/Fonts/
   ```

**Comando rápido (si tienes los archivos en ~/Downloads/Manrope):**
```bash
cp ~/Downloads/Manrope/static/*.ttf /Users/louieliet/Documents/GitHub/pantheronwellness/pantheronwellness/Shared/Fonts/
```

---

### 3. Agregar Fuentes a Xcode Project

**En Xcode:**

1. Click derecho en la carpeta `Shared/Fonts` en el navegador de Xcode
2. Select **"Add Files to 'pantheronwellness'..."**
3. Navega a `Shared/Fonts/` y selecciona TODOS los archivos `.ttf`
4. **IMPORTANTE:** Marca estas opciones:
   - ✅ **"Copy items if needed"**
   - ✅ **"Create groups"** (NO "Create folder references")
   - ✅ **"Add to targets: pantheronwellness"** ← MUY IMPORTANTE

---

### 4. Verificar Target Membership

Para cada archivo `.ttf`:

1. Selecciona el archivo en Xcode
2. Abre el **Inspector de Archivos** (panel derecho)
3. En la sección **"Target Membership"**:
   - ✅ Asegúrate que `pantheronwellness` esté marcado

---

### 5. Agregar Fuentes a Info.plist

**Opción A: Editar Info.plist como código**

1. Click derecho en `Info.plist` → **"Open As" → "Source Code"**
2. Agrega este bloque DENTRO de `<dict>` pero ANTES de `</dict>`:

```xml
<key>UIAppFonts</key>
<array>
    <string>Manrope-ExtraLight.ttf</string>
    <string>Manrope-Light.ttf</string>
    <string>Manrope-Regular.ttf</string>
    <string>Manrope-Medium.ttf</string>
    <string>Manrope-SemiBold.ttf</string>
    <string>Manrope-Bold.ttf</string>
    <string>Manrope-ExtraBold.ttf</string>
</array>
```

**Opción B: Editar Info.plist visualmente**

1. Abre `Info.plist` normalmente
2. Click derecho en cualquier fila → **"Add Row"**
3. Busca: **"Fonts provided by application"** (se autocompleta a `UIAppFonts`)
4. Expande el array y agrega 7 items (Item 0 → Item 6)
5. Para cada item, escribe el nombre EXACTO del archivo:
   - Item 0: `Manrope-ExtraLight.ttf`
   - Item 1: `Manrope-Light.ttf`
   - Item 2: `Manrope-Regular.ttf`
   - Item 3: `Manrope-Medium.ttf`
   - Item 4: `Manrope-SemiBold.ttf`
   - Item 5: `Manrope-Bold.ttf`
   - Item 6: `Manrope-ExtraBold.ttf`

---

### 6. Verificar que Funcionó

**Opción 1: Build y Run**
```bash
cmd + B  # Build
cmd + R  # Run
```

Si no hay errores, las fuentes están instaladas.

**Opción 2: Verificar con código**

En cualquier View, agrega temporalmente:
```swift
Text("Testing Manrope")
    .font(.custom("Manrope-Bold", size: 30))
```

Si se ve diferente a la fuente del sistema, ¡funciona!

**Opción 3: Usar el debug helper que crearé**

Ver archivo: `Shared/Fonts/FontDebugger.swift`

---

## 🚨 Troubleshooting

### Problema: "La fuente no se ve diferente"

**Soluciones:**

1. **Verifica el nombre exacto del archivo**
   ```bash
   ls -la /Users/louieliet/Documents/GitHub/pantheronwellness/pantheronwellness/Shared/Fonts/
   ```
   Los nombres en `Info.plist` deben coincidir EXACTAMENTE (incluyendo mayúsculas/minúsculas)

2. **Verifica Target Membership**
   - Cada `.ttf` debe estar en el target `pantheronwellness`

3. **Clean Build Folder**
   - En Xcode: `cmd + shift + K` (Clean)
   - Luego: `cmd + B` (Build)

4. **Verifica Info.plist**
   - Abre como "Source Code"
   - Busca `UIAppFonts` - debe existir

5. **Reinicia Xcode**
   - A veces Xcode cachea las fuentes
   - Cierra completamente y reabre

### Problema: "Build falla"

- Asegúrate que los archivos `.ttf` estén físicamente en la carpeta
- Verifica que no haya caracteres especiales en los nombres
- Asegúrate que sean archivos `.ttf` válidos (no `.otf` o `.woff`)

### Problema: "Solo algunos pesos funcionan"

- Verifica que todos los archivos estén en `Info.plist`
- Verifica Target Membership de cada archivo
- Algunos pesos pueden tener nombres diferentes - usa `FontDebugger.swift` para ver los nombres internos

---

## ✅ Checklist Final

Antes de continuar, asegúrate que:

- [ ] Los 7 archivos `.ttf` están en `Shared/Fonts/`
- [ ] Los 7 archivos están agregados al Xcode project
- [ ] Cada archivo tiene Target Membership en `pantheronwellness`
- [ ] `Info.plist` tiene la key `UIAppFonts` con los 7 nombres
- [ ] Build es exitoso (cmd + B sin errores)
- [ ] La fuente se ve diferente al correr la app

---

## 📞 Próximos Pasos

Una vez que tengas las fuentes instaladas:

1. Ejecuta `FontDebugger.swift` para verificar
2. Actualiza `AppTypography.swift` con verificación
3. Actualiza `WelcomeScreen.swift` con nuevo diseño

---

**¿Dudas?** Pregunta antes de continuar - es fácil cometer errores en este paso.

