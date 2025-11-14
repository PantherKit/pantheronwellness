# 🌟 Pantheron Wellness - Plan de Desarrollo

> **Duolingo para Wellness 2.0**
> 
> Una app de bienestar que instala identidades a través de micro-acciones diarias de 2 minutos, usando gamificación inteligente y personalización basada en las 7 dimensiones del wellness.

---

## 📋 Tabla de Contenidos

1. [Visión General](#visión-general)
2. [Arquitectura Técnica](#arquitectura-técnica)
3. [Progreso Actual](#progreso-actual)
4. [Sistema de Gamificación](#sistema-de-gamificación)
5. [Flujo de Usuario](#flujo-de-usuario)
6. [Roadmap](#roadmap)
7. [Decisiones de Diseño](#decisiones-de-diseño)

---

## 🎯 Visión General

### Concepto Central

Pantheron Wellness es una aplicación que ayuda a las personas a **instalar una identidad de bienestar** a través de micro-acciones de 2 minutos, personalizadas por dimensión del wellness, y reforzadas por feedback emocional inmediato.

**No es una app de pasos ni calorías.**  
Es una app que responde: _"¿Quién quiero ser hoy?"_ y te da **una sola acción atómica** para reforzarlo.

### Wellness 2.0

Las apps de wellness actuales fallan porque:
- Dan datos → pero no cambian comportamiento
- Dan métricas → pero no cambian identidad
- Dan listas de tareas → pero no cambian autoimagen

**Pantheron cambia la autoimagen del usuario con una sola micro-acción diaria, ultra fácil y ultra satisfactoria.**

### Las 7 Dimensiones del Wellness

1. **Física** 💪 - "Soy alguien que cuida mi cuerpo"
2. **Emocional** ❤️ - "Soy alguien que escucha mis emociones"
3. **Mental** 🧠 - "Soy alguien que construye mi calma"
4. **Social** 👥 - "Soy alguien que conecta con otros"
5. **Espiritual** ✨ - "Soy alguien que honra mi interior"
6. **Profesional** 💼 - "Soy alguien que crece cada día"
7. **Ambiental** 🌱 - "Soy alguien que cuida su entorno"

---

## 🏗️ Arquitectura Técnica

### Stack Tecnológico

- **Framework**: SwiftUI
- **Lenguaje**: Swift
- **Arquitectura**: MVVM + Coordinator Pattern
- **Persistencia**: UserDefaults (fase MVP)
- **Animaciones**: SwiftUI Animations + Rive (próximamente)
- **Tipografía**: Poppins (Regular, Medium, Semibold, Bold)

### Estructura de Carpetas

```
pantheronwellness/
├── App/
│   ├── mainApp.swift                    # Entry point
│   └── AppCoordinator.swift             # Navegación y lógica central
│
├── Entities/
│   ├── Assessment/
│   │   ├── AssessmentQuestion.swift     # Preguntas de assessment
│   │   └── WellnessAssessment.swift     # Sistema de evaluación
│   ├── Identity/
│   │   └── AdaptiveMicroAction.swift    # Acciones personalizadas
│   ├── Journey/
│   │   └── WellnessJourney.swift        # Sistema de journey
│   ├── User/
│   │   ├── DailySession.swift           # Check-ins y perfil
│   │   └── UserProgress.swift           # XP, niveles, challenges ✨
│   └── WellnessDimension/
│       └── WellnessDimension.swift      # Las 7 dimensiones
│
├── Pages/
│   ├── Welcome/
│   │   └── WelcomeScreen.swift          # Pantalla inicial
│   ├── Onboarding/
│   │   ├── OnboardingView.swift         # Selección de dimensiones (2-3) ✨
│   │   └── ConfirmationView.swift       # Confirmación de selección ✨
│   ├── Home/
│   │   └── HomePage.swift               # Home estilo Duolingo ✨
│   ├── Action/
│   │   └── ActionTimerView.swift        # Timer + checklist ✨
│   ├── Feedback/
│   │   └── FeedbackCompletionView.swift # Celebración + confetti ✨
│   ├── Progress/
│   │   └── ProgressView.swift           # Vista de progreso
│   └── Assessment/                      # Sistema legacy (opcional)
│
├── Widgets/
│   ├── Home/                            # Componentes del home ✨
│   │   ├── HomeHeader.swift
│   │   ├── ActionHeroCard.swift
│   │   ├── StatsRow.swift
│   │   ├── JourneyProgressSection.swift
│   │   └── DailyChallengeCard.swift
│   ├── TabBar/
│   │   └── MainTabView.swift            # Tab bar custom ✨
│   ├── IdentityCard.swift               # Cards de dimensiones (compact/full)
│   ├── AnimatedButton.swift
│   └── SparkleEffect.swift
│
├── Shared/
│   ├── UI/
│   │   ├── AppTheme.swift
│   │   ├── AppColors.swift
│   │   ├── AppTypography.swift
│   │   └── Color+Hex.swift
│   └── API/
│       └── UserDataService.swift
│
└── Features/
    └── PersonalizationEngine/
        └── PersonalizationService.swift
```

### Modelos de Datos Clave

#### UserProfile
```swift
struct UserProfile: Codable {
    var name: String
    let startDate: Date
    var identities: [WellnessDimension: Identity]
    var selectedWellnessFocus: [WellnessDimension]  // 2-3 dimensiones elegidas
    
    // Gamificación
    var totalXP: Int
    var currentStreak: Int
    var longestStreak: Int
    var lastActionDate: Date?
    var dailyProgressHistory: [DailyProgress]
    var todaysDimensionCompleted: [WellnessDimension]
    var currentDailyChallenge: DailyChallenge?
}
```

#### WellnessDimension
```swift
enum WellnessDimension: String, CaseIterable, Codable {
    case physical, emotional, mental, social, 
         spiritual, professional, environmental
    
    var identityStatement: String       // "Soy alguien que..."
    var aspirationalCopy: String        // "Más energía y vitalidad"
    var microAction: String             // "Haz 2 min de estiramiento"
    var primaryColor: Color             // Color único por dimensión
    var checklistSteps: [String]        // Pasos para completar acción
}
```

#### XP & Rewards
```swift
enum XPReward: Int {
    case dailyActionComplete = 10
    case streakBonus5Days = 20
    case streakBonus7Days = 50
    case streakBonus14Days = 100
    case dailyChallengeComplete = 30
    case perfectWeek = 150
    case secondDimensionSameDay = 15
}
```

---

## ✅ Progreso Actual

### Fase 1: Onboarding & Identity Selection ✅

**Implementado:**
- ✅ WelcomeScreen con hero animation
- ✅ OnboardingView con selección de 2-3 dimensiones
- ✅ IdentityCard con modo compact y full
- ✅ Colores diferenciados por dimensión
- ✅ Copy aspiracional por dimensión
- ✅ ConfirmationView con chips animados
- ✅ Validación min 2, max 3 dimensiones
- ✅ Persistencia de selección en UserProfile

**Características:**
- Grid 2x4 minimalista
- Animaciones escalonadas (stagger)
- Checkmark animado en selección
- Matched geometry effects
- Copy alineado con Wellness 2.0

---

### Fase 2: Home Estilo Duolingo ✅

**Implementado:**
- ✅ HomePage completo con scroll
- ✅ HomeHeader con avatar + streak badge
- ✅ ActionHeroCard (pendiente/completado)
- ✅ StatsRow con 4 métricas (streak, goal, XP, level)
- ✅ JourneyProgressSection con progress bars
- ✅ DailyChallengeCard con tipos variados
- ✅ Sugerencia automática de dimensión diaria
- ✅ MainTabView con 3 tabs (Home, Progress, Profile)

**Características destacadas:**
- **Streak Badge prominente** (🔥 como Duolingo)
- **Hero Card adaptativo**:
  - No completado → muestra acción + CTA "Comenzar"
  - Completado → celebración + opción de hacer más (+15 XP)
- **Stats horizontales** con scroll
- **Progress bars** solo de dimensiones elegidas (2-3)
- **Daily Challenge** generado automáticamente

---

### Fase 3: Action Flow Completo ✅

**Implementado:**
- ✅ ActionTimerView con timer circular
- ✅ Checklist interactivo (3-4 pasos por dimensión)
- ✅ Botones play/pause/complete
- ✅ Validación: timer + checklist completos
- ✅ FeedbackCompletionView con confetti
- ✅ Animación de celebración
- ✅ Display de XP ganados (base + bonuses)
- ✅ Display de streak actual
- ✅ Haptic feedback

**Flujo:**
```
Home → Tap "Comenzar" 
  ↓
ActionTimer (2 min) 
  ↓ Timer completo + checklist ✓
FeedbackCompletion (confetti 🎉)
  ↓
Home (actualizado)
```

---

### Fase 4: Sistema de Gamificación ✅

**Implementado:**
- ✅ Sistema de XP con múltiples fuentes
- ✅ Sistema de niveles (4 niveles)
- ✅ Sistema de streaks con cálculo automático
- ✅ Daily challenges (3 tipos)
- ✅ Bonuses por streak (5, 7, 14 días)
- ✅ Bonus por segunda acción del día
- ✅ Weekly goal tracking
- ✅ DailyProgress history

**Niveles:**
| Nivel | Nombre | XP Requerido | Emoji |
|-------|--------|--------------|-------|
| 1 | Principiante | 0-99 | 🌱 |
| 2 | En Construcción | 100-499 | 🔨 |
| 3 | Comprometido | 500-1499 | 💪 |
| 4 | Maestro | 1500+ | ⭐ |

**Daily Challenges:**
- ✅ Completa antes de las 8pm (+20 XP)
- ✅ Completa 2 dimensiones hoy (+30 XP)
- ✅ Mantén tu racha (+20 XP)

---

## 🎮 Sistema de Gamificación

### Cálculo de XP

```swift
func completeAction(for dimension: WellnessDimension) {
    var xpEarned = 10  // Base
    
    // Bonuses
    if isSecondActionToday { xpEarned += 15 }
    if streak == 5 { xpEarned += 20 }
    if streak == 7 { xpEarned += 50 }
    if streak == 14 { xpEarned += 100 }
    if dailyChallengeCompleted { xpEarned += 20-30 }
    
    totalXP += xpEarned
}
```

### Cálculo de Streak

```swift
func updateStreak() {
    let daysDifference = lastActionDate vs today
    
    if daysDifference == 0:
        // Ya completó hoy, no cambiar
    else if daysDifference == 1:
        streak += 1  // Consecutivo ✅
    else:
        streak = 1   // Rompió racha ❌
}
```

### Sugerencia Automática de Dimensión

```swift
func getSuggestedDimensionForToday() -> WellnessDimension? {
    // 1. Filtrar las que ya completó hoy
    let available = selectedFocus.filter { !completedToday.contains($0) }
    
    // 2. Si ya completó todas, retornar cualquiera (para bonus)
    guard !available.isEmpty else { return selectedFocus.first }
    
    // 3. Sugerir la que tenga menos evidencias recientes
    return available.sorted { 
        identities[$0].evidenceCount < identities[$1].evidenceCount 
    }.first
}
```

---

## 🔄 Flujo de Usuario

### Primera Vez

```
1. WelcomeScreen
   "Instala tu próxima versión"
   [Comenzar]
   
2. OnboardingView
   "¿Qué áreas de tu bienestar quieres mejorar?"
   [Grid 2x4 con 7 dimensiones]
   Selecciona 2-3
   [Continuar (2/3)]
   
3. ConfirmationView
   "Perfecto, vamos a enfocarnos en:"
   [Chips: Mental, Física, Emocional]
   [Comenzar mi viaje]
   
4. MainTabView → HomePage
   Header: Hola Usuario | 🔥 0
   Hero Card: "Soy alguien que construye mi calma"
   Acción: "Haz respiración 4-4-4"
   [Comenzar]
```

### Uso Diario

```
1. Abrir app
   → Home muestra dimensión sugerida del día
   → Si ya completó: muestra celebración
   
2. Tap "Comenzar"
   → ActionTimerView
   → Timer 2:00 + checklist
   
3. Completar timer + checklist
   → FeedbackCompletionView
   → Confetti 🎉
   → "+25 XP" (10 base + 15 streak bonus)
   → "🔥 8 días"
   
4. [Continuar]
   → Home actualizado
   → Stats refrescadas
   → Progress bars +1
   → Opción de hacer otra dimensión
```

### Regreso al Día Siguiente

```
1. Sistema detecta nuevo día
   → Resetea todaysDimensionCompleted
   → Genera nuevo daily challenge
   → Verifica streak (consecutivo o roto)
   
2. Home muestra nueva dimensión sugerida
   (automáticamente la que tenga menos evidencias)
```

---

## 🗺️ Roadmap

### ✅ MVP Completado (Hackathon Ready)

- [x] **Welcome Screen premium** con Manrope, headline potente, value props
- [x] Onboarding con selección de dimensiones
- [x] Home estilo Duolingo
- [x] Action flow completo (timer + feedback)
- [x] Sistema de gamificación (XP, streak, levels)
- [x] Tab bar con 3 tabs
- [x] Daily challenges
- [x] Sugerencia automática de dimensión
- [x] Persistencia básica (UserDefaults)
- [x] **Tipografía Manrope** instalada (7 pesos) con fallback inteligente

### 🚧 Post-MVP (Iteraciones Futuras)

#### Fase 5: Notificaciones Push
- [ ] Recordatorio diario (hora personalizable)
- [ ] Notificación de streak en riesgo
- [ ] Celebración de milestones (5, 7, 14 días)
- [ ] Daily challenge reminder

#### Fase 6: Progress Tab Completo
- [ ] Calendario con días completados
- [ ] Gráficas de progreso por dimensión
- [ ] Insights semanales/mensuales
- [ ] Heatmap de actividad
- [ ] Comparación vs semanas anteriores

#### Fase 7: Social Features
- [ ] Ver friends' streaks (leaderboard)
- [ ] Compartir achievements
- [ ] Challenges grupales
- [ ] Motivación entre amigos

#### Fase 8: Personalización Avanzada
- [ ] IA para generar micro-acciones personalizadas
- [ ] Adaptive difficulty basado en completions
- [ ] Cambiar dimensiones focus
- [ ] Crear micro-acciones custom

#### Fase 9: Wellness Journal
- [ ] Reflexiones post-acción
- [ ] Estado emocional tracking
- [ ] Notas por dimensión
- [ ] Export de datos

#### Fase 10: Premium Features
- [ ] Animaciones Rive custom
- [ ] Sonidos ambientales
- [ ] Guided meditations
- [ ] Modo oscuro avanzado
- [ ] Widgets de iOS

---

## 🎨 Decisiones de Diseño

### Paleta de Colores

**Background:**
- Primary: `#F4ECE3` (crema cálido)
- Surface: `#FFFFFF` (blanco)

**Dimensiones:**
| Dimensión | Color | Hex |
|-----------|-------|-----|
| Física | Verde bosque | `#1A5A53` |
| Emocional | Amarillo cálido | `#E6C88B` |
| Mental | Menta suave | `#B6E2D3` |
| Social | Coral suave | `#FF8B7B` |
| Spiritual | Lavanda | `#B8A4E5` |
| Professional | Azul profundo | `#4A7C8C` |
| Environmental | Verde lima | `#A8C686` |

**Gamificación:**
- Streak: Orange `#FF9500`
- XP: Yellow `#FFD60A`
- Level: Purple `#BF5AF2`
- Success: Green `#34C759`

### Tipografía (Poppins)

```swift
Display: 40pt Bold        // Títulos principales
Headline: 28pt Semibold   // Sección headers
Title1: 22pt Semibold     // Card titles
Title2: 20pt Medium       // Subtitles
Title3: 18pt Medium       // Small headers
Body1: 17pt Regular       // Body principal
Body2: 15pt Regular       // Body secundario
Caption: 13pt Regular     // Hints y labels
Overline: 12pt Medium     // Stats labels
Button: 16pt Semibold     // Botones
```

### Animaciones

**Timing Curves:**
- Principal: `cubic-bezier(0.4, 0.0, 0.2, 1)` - 0.35s
- Spring: `response: 0.6, dampingFraction: 0.7`
- Stagger delay: `0.08s` entre elementos

**Estados:**
- Entrada: fade + slide from bottom (20pt)
- Selección: scale 1.0 → 1.03 + shadow expand
- Transición: matched geometry + directional slide

### Corner Radius

```
Hero Cards: 24pt
Regular Cards: 16-20pt
Buttons: 16pt
Pills/Badges: 12-20pt
Progress bars: 4pt
```

### Shadows

```swift
Light:  color: .black.opacity(0.04), radius: 8, y: 2
Medium: color: .black.opacity(0.06), radius: 12, y: 4
Heavy:  color: primary.opacity(0.3), radius: 12, y: 6
```

---

## 📊 Métricas de Éxito (Post-Launch)

### Engagement
- **DAU (Daily Active Users)**: % de usuarios que abren la app diariamente
- **Completion Rate**: % de acciones completadas vs iniciadas
- **Avg Streak**: Promedio de días consecutivos
- **Return Rate D7**: % que regresa después de 7 días

### Wellness Impact
- **Dimensions Balanced**: % de usuarios que completan las 3 dimensiones semanalmente
- **21-Day Completion**: % que completa una dimensión por 21 días (hábito formado)
- **Self-Reported Wellness**: Score de bienestar auto-reportado (1-10)

### Growth
- **Viral Coefficient**: Invitaciones por usuario
- **App Store Rating**: Target 4.5+
- **NPS (Net Promoter Score)**: Target 40+

---

## 🛠️ Comandos Útiles

### Desarrollo
```bash
# Abrir proyecto
open pantheronwellness.xcodeproj

# Limpiar build
cmd + shift + K

# Build
cmd + B

# Run
cmd + R
```

### Testing
```bash
# Limpiar UserDefaults (en debug)
UserDefaults.standard.removeObject(forKey: "user_profile")
UserDefaults.standard.removeObject(forKey: "today_checkin")
UserDefaults.standard.removeObject(forKey: "wellness_assessment")
```

---

## 🤝 Contribución

### Principios de Código

1. **Clean Code**: Funciones pequeñas, responsabilidad única
2. **SOLID**: Especialmente Single Responsibility y Dependency Injection
3. **SwiftUI Best Practices**: @State local, @ObservedObject para coordinadores
4. **Comentarios**: Solo cuando la lógica no es obvia
5. **No try-catch genéricos**: Solo para comunicación con servicios externos

### Convenciones de Naming

```swift
// Views
struct HomePage: View { }
struct ActionHeroCard: View { }

// Models
struct UserProfile: Codable { }
enum WellnessDimension: String, CaseIterable { }

// Coordinators
class AppCoordinator: ObservableObject { }

// Services
class PersonalizationService { }
```

---

## 📝 Notas Técnicas

### Persistencia Actual (UserDefaults)

```swift
// Keys
private let profileKey = "user_profile"
private let checkInKey = "today_checkin"
private let assessmentKey = "wellness_assessment"

// Para futuro: migrar a CoreData o Realm
// cuando tengamos features offline-first avanzadas
```

### Estado de Navegación

```swift
enum AppView: Equatable {
    case welcome
    case onboarding
    case confirmation
    case mainTab
    case actionTimer(WellnessDimension)
    case feedbackCompletion(WellnessDimension, Int, Int)
    // ... legacy cases
}
```

### Cálculos Importantes

**Weekly Goal:**
```swift
var weeklyGoalProgress: Double {
    let weekStart = calendar.startOfWeek
    let completedThisWeek = dailyProgressHistory.filter { 
        $0.date >= weekStart 
    }
    return Double(completedThisWeek.count) / 7.0
}
```

**Progress to Next Level:**
```swift
func progressToNext(currentXP: Int) -> Double {
    switch level {
    case .beginner: 
        return Double(currentXP) / 100.0
    case .building: 
        return Double(currentXP - 100) / 400.0
    case .committed: 
        return Double(currentXP - 500) / 1000.0
    case .master: 
        return 1.0
    }
}
```

---

## 🎯 Vision a Largo Plazo

### Año 1: Establecer Hábitos
- 10K usuarios activos
- Avg streak: 7+ días
- 50% completion rate de acciones

### Año 2: Comunidad & Social
- 100K usuarios
- Features sociales completas
- Integración con Apple Health

### Año 3: AI Personalización
- 500K usuarios
- IA generativa de micro-acciones
- Integración con wearables
- Wellness coaches certificados

---

## 📚 Referencias

### Inspiraciones de Producto
- **Duolingo**: Gamificación, streaks, simple daily action
- **Opal**: Onboarding research, honest questions
- **Finch**: Emotional feedback, soft rewards
- **Headspace**: Wellness tracking, guided actions

### Framework de Wellness
- Wellness 2.0: identidad → acción → evidencia
- Atomic Habits (James Clear): micro-acciones de 2 min
- 7 Dimensiones del Wellness (modelo estándar)

### Diseño
- Family Wallet: Matched geometry, fluid transitions
- Material Design 3: Animation timing curves
- iOS HIG: Native patterns, haptics

---

## ✨ Créditos

**Desarrollado para Hackathon**  
Stack: SwiftUI + Combine  
Tipografía: Poppins  
Iconos: SF Symbols  
Animaciones: SwiftUI Animations (Rive próximamente)

**Filosofía:**  
Wellness 2.0 - Cambiando identidades, no solo métricas.

---

**Última actualización:** Noviembre 2024  
**Versión:** MVP 1.0 - Hackathon Ready 🚀

