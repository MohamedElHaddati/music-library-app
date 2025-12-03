pragma Singleton
import QtQuick

QtObject {
    // Color Palette - Modern Dark Theme with Spotify-inspired accent
    readonly property color background: "#0d0d0d"
    readonly property color surface: "#1a1a1a"
    readonly property color surfaceElevated: "#232323"
    readonly property color surfaceHover: "#2a2a2a"
    
    // Primary Colors
    readonly property color primary: "#1DB954"  // Spotify green
    readonly property color primaryHover: "#1ed760"
    readonly property color primaryPressed: "#169c46"
    
    // Secondary Colors
    readonly property color secondary: "#535353"
    readonly property color secondaryHover: "#6a6a6a"
    
    // Text Colors
    readonly property color textPrimary: "#ffffff"
    readonly property color textSecondary: "#b3b3b3"
    readonly property color textDisabled: "#535353"
    
    // Border and Divider
    readonly property color border: "#282828"
    readonly property color divider: "#282828"
    
    // Status Colors
    readonly property color error: "#e22134"
    readonly property color success: "#1DB954"
    readonly property color warning: "#ffa500"
    
    // Gradients
    readonly property var gradientPurplePink: ["#6b46c1", "#e94560"]
    readonly property var gradientBlueGreen: ["#1DB954", "#1ed760"]
    readonly property var gradientDarkOverlay: ["transparent", "#000000"]
    
    // Spacing System (8px base unit)
    readonly property int spacing0: 0
    readonly property int spacing1: 4
    readonly property int spacing2: 8
    readonly property int spacing3: 12
    readonly property int spacing4: 16
    readonly property int spacing5: 20
    readonly property int spacing6: 24
    readonly property int spacing7: 32
    readonly property int spacing8: 40
    readonly property int spacing9: 48
    readonly property int spacing10: 64
    
    // Border Radius
    readonly property int radiusSmall: 4
    readonly property int radiusMedium: 8
    readonly property int radiusLarge: 12
    readonly property int radiusXLarge: 16
    readonly property int radiusRound: 999
    
    // Typography - Font Sizes
    readonly property int fontSizeXSmall: 10
    readonly property int fontSizeSmall: 12
    readonly property int fontSizeBody: 14
    readonly property int fontSizeMedium: 16
    readonly property int fontSizeLarge: 18
    readonly property int fontSizeXLarge: 24
    readonly property int fontSizeXXLarge: 32
    readonly property int fontSizeXXXLarge: 48
    
    // Animation Durations
    readonly property int durationFast: 150
    readonly property int durationMedium: 250
    readonly property int durationSlow: 350
    
    // Shadows (using opacity on black rectangles)
    readonly property real shadowOpacitySmall: 0.1
    readonly property real shadowOpacityMedium: 0.2
    readonly property real shadowOpacityLarge: 0.3
    
    readonly property int shadowBlurSmall: 4
    readonly property int shadowBlurMedium: 8
    readonly property int shadowBlurLarge: 16
    
    // Layout
    readonly property int sidebarWidthExpanded: 240
    readonly property int sidebarWidthCollapsed: 80
    readonly property int playerControlsHeight: 90
    readonly property int headerHeight: 64
    
    // Breakpoints for responsive design
    readonly property int breakpointSmall: 600
    readonly property int breakpointMedium: 960
    readonly property int breakpointLarge: 1280
    
    // Touch Targets
    readonly property int minTouchTarget: 44
    readonly property int iconSizeSmall: 16
    readonly property int iconSizeMedium: 24
    readonly property int iconSizeLarge: 32
    readonly property int iconSizeXLarge: 48
    
    // Album/Card Sizes
    readonly property int albumArtSmall: 48
    readonly property int albumArtMedium: 160
    readonly property int albumArtLarge: 200
    readonly property int albumArtXLarge: 280
}
