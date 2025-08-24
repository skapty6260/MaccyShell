pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.modules.common.utils

Singleton {
    id: root
    property QtObject ms_colors
    property QtObject animation
    property QtObject animationCurves
    property QtObject colors
    property QtObject rounding
    property QtObject font
    property QtObject sizes
    property string syntaxHighlightingTheme

    // Transparency. The quadratic functions were derived from analysis of hand-picked transparency values.
    ColorQuantizer {
        id: wallColorQuant
        source: Qt.resolvedUrl(Config.options.background.wallpaperPath)
        depth: 0 // 2^0 = 1 color
        rescaleSize: 10
    }
    property real wallpaperVibrancy: (wallColorQuant.colors[0]?.hslSaturation + wallColorQuant.colors[0]?.hslLightness) / 2
    property real autoBackgroundTransparency: { // y = 0.5768x^2 - 0.759x + 0.2896
        let x = wallpaperVibrancy
        let y = 0.5768 * (x * x) - 0.759 * (x) + 0.2896
        return Math.max(0, Math.min(0.22, y))
    }
    property real autoContentTransparency: { // y = -10.1734x^2 + 3.4457x + 0.1872
        let x = autoBackgroundTransparency
        let y = -10.1734 * (x * x) + 3.4457 * (x) + 0.1872
        return Math.max(0, Math.min(0.6, y))
    }
    property real backgroundTransparency: Config?.options.appearance.transparency.enable ? Config?.options.appearance.transparency.automatic ? autoBackgroundTransparency : Config?.options.appearance.transparency.backgroundTransparency : 0
    property real contentTransparency: Config?.options.appearance.transparency.enable ? Config?.options.appearance.transparency.automatic ? autoContentTransparency : Config?.options.appearance.transparency.contentTransparency : 0

    ms_colors: QtObject {
        property bool darkmode: false
        property bool transparent: false
        property color ms_primary_paletteKeyColor: "#91689E"
        property color ms_secondary_paletteKeyColor: "#837186"
        property color ms_tertiary_paletteKeyColor: "#9D6A67"
        property color ms_neutral_paletteKeyColor: "#7C757B"
        property color ms_neutral_variant_paletteKeyColor: "#7D747D"
        property color ms_background: "#161217"
        property color ms_onBackground: "#EAE0E7"
        property color ms_surface: "#161217"
        property color ms_surfaceDim: "#161217"
        property color ms_surfaceBright: "#3D373D"
        property color ms_surfaceContainerLowest: "#110D12"
        property color ms_surfaceContainerLow: "#1F1A1F"
        property color ms_surfaceContainer: "#231E23"
        property color ms_surfaceContainerHigh: "#2D282E"
        property color ms_surfaceContainerHighest: "#383339"
        property color ms_onSurface: "#EAE0E7"
        property color ms_surfaceVariant: "#4C444D"
        property color ms_onSurfaceVariant: "#CFC3CD"
        property color ms_inverseSurface: "#EAE0E7"
        property color ms_inverseOnSurface: "#342F34"
        property color ms_outline: "#988E97"
        property color ms_outlineVariant: "#4C444D"
        property color ms_shadow: "#000000"
        property color ms_scrim: "#000000"
        property color ms_surfaceTint: "#E5B6F2"
        property color ms_primary: "#E5B6F2"
        property color ms_onPrimary: "#452152"
        property color ms_primaryContainer: "#5D386A"
        property color ms_onPrimaryContainer: "#F9D8FF"
        property color ms_inversePrimary: "#775084"
        property color ms_secondary: "#D5C0D7"
        property color ms_onSecondary: "#392C3D"
        property color ms_secondaryContainer: "#534457"
        property color ms_onSecondaryContainer: "#F2DCF3"
        property color ms_tertiary: "#F5B7B3"
        property color ms_onTertiary: "#4C2523"
        property color ms_tertiaryContainer: "#BA837F"
        property color ms_onTertiaryContainer: "#000000"
        property color ms_error: "#FFB4AB"
        property color ms_onError: "#690005"
        property color ms_errorContainer: "#93000A"
        property color ms_onErrorContainer: "#FFDAD6"
        property color ms_primaryFixed: "#F9D8FF"
        property color ms_primaryFixedDim: "#E5B6F2"
        property color ms_onPrimaryFixed: "#2E0A3C"
        property color ms_onPrimaryFixedVariant: "#5D386A"
        property color ms_secondaryFixed: "#F2DCF3"
        property color ms_secondaryFixedDim: "#D5C0D7"
        property color ms_onSecondaryFixed: "#241727"
        property color ms_onSecondaryFixedVariant: "#514254"
        property color ms_tertiaryFixed: "#FFDAD7"
        property color ms_tertiaryFixedDim: "#F5B7B3"
        property color ms_onTertiaryFixed: "#331110"
        property color ms_onTertiaryFixedVariant: "#663B39"
        property color ms_success: "#B5CCBA"
        property color ms_onSuccess: "#213528"
        property color ms_successContainer: "#374B3E"
        property color ms_onSuccessContainer: "#D1E9D6"
        property color term0: "#EDE4E4"
        property color term1: "#B52755"
        property color term2: "#A97363"
        property color terms_: "#AF535D"
        property color term4: "#A67F7C"
        property color term5: "#B2416B"
        property color term6: "#8D76AD"
        property color term7: "#272022"
        property color term8: "#0E0D0D"
        property color term9: "#B52755"
        property color term10: "#A97363"
        property color term11: "#AF535D"
        property color term12: "#A67F7C"
        property color term13: "#B2416B"
        property color term14: "#8D76AD"
        property color term15: "#221A1A"
    }

    colors: QtObject {
        property color colSubtext: ms_colors.ms_outline
        property color colLayer0: ColorUtils.mix(ColorUtils.transparentize(ms_colors.ms_background, root.backgroundTransparency), ms_colors.ms_primary, Config.options.appearance.extraBackgroundTint ? 0.99 : 1)
        property color colOnLayer0: ms_colors.ms_onBackground
        property color colLayer0Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer0, colOnLayer0, 0.9, root.contentTransparency))
        property color colLayer0Active: ColorUtils.transparentize(ColorUtils.mix(colLayer0, colOnLayer0, 0.8, root.contentTransparency))
        property color colLayer0Border: ColorUtils.mix(root.ms_colors.ms_outlineVariant, colLayer0, 0.4)
        property color colLayer1: ColorUtils.transparentize(ms_colors.ms_surfaceContainerLow, root.contentTransparency);
        property color colOnLayer1: ms_colors.ms_onSurfaceVariant;
        property color colOnLayer1Inactive: ColorUtils.mix(colOnLayer1, colLayer1, 0.45);
        property color colLayer2: ColorUtils.transparentize(ms_colors.ms_surfaceContainer, root.contentTransparency)
        property color colOnLayer2: ms_colors.ms_onSurface;
        property color colOnLayer2Disabled: ColorUtils.mix(colOnLayer2, ms_colors.ms_background, 0.4);
        property color colLayer1Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer1, colOnLayer1, 0.92), root.contentTransparency)
        property color colLayer1Active: ColorUtils.transparentize(ColorUtils.mix(colLayer1, colOnLayer1, 0.85), root.contentTransparency);
        property color colLayer2Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer2, colOnLayer2, 0.90), root.contentTransparency)
        property color colLayer2Active: ColorUtils.transparentize(ColorUtils.mix(colLayer2, colOnLayer2, 0.80), root.contentTransparency);
        property color colLayer2Disabled: ColorUtils.transparentize(ColorUtils.mix(colLayer2, ms_colors.ms_background, 0.8), root.contentTransparency);
        property color colLayer3: ColorUtils.transparentize(ms_colors.ms_surfaceContainerHigh, root.contentTransparency)
        property color colOnLayer3: ms_colors.ms_onSurface;
        property color colLayer3Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer3, colOnLayer3, 0.90), root.contentTransparency)
        property color colLayer3Active: ColorUtils.transparentize(ColorUtils.mix(colLayer3, colOnLayer3, 0.80), root.contentTransparency);
        property color colLayer4: ColorUtils.transparentize(ms_colors.ms_surfaceContainerHighest, root.contentTransparency)
        property color colOnLayer4: ms_colors.ms_onSurface;
        property color colLayer4Hover: ColorUtils.transparentize(ColorUtils.mix(colLayer4, colOnLayer4, 0.90), root.contentTransparency)
        property color colLayer4Active: ColorUtils.transparentize(ColorUtils.mix(colLayer4, colOnLayer4, 0.80), root.contentTransparency);
        property color colPrimary: ms_colors.ms_primary
        property color colOnPrimary: ms_colors.ms_onPrimary
        property color colPrimaryHover: ColorUtils.mix(colors.colPrimary, colLayer1Hover, 0.87)
        property color colPrimaryActive: ColorUtils.mix(colors.colPrimary, colLayer1Active, 0.7)
        property color colPrimaryContainer: ms_colors.ms_primaryContainer
        property color colPrimaryContainerHover: ColorUtils.mix(colors.colPrimaryContainer, colLayer1Hover, 0.7)
        property color colPrimaryContainerActive: ColorUtils.mix(colors.colPrimaryContainer, colLayer1Active, 0.6)
        property color colOnPrimaryContainer: ms_colors.ms_onPrimaryContainer
        property color colSecondary: ms_colors.ms_secondary
        property color colSecondaryHover: ColorUtils.mix(ms_colors.ms_secondary, colLayer1Hover, 0.85)
        property color colSecondaryActive: ColorUtils.mix(ms_colors.ms_secondary, colLayer1Active, 0.4)
        property color colSecondaryContainer: ms_colors.ms_secondaryContainer
        property color colSecondaryContainerHover: ColorUtils.mix(ms_colors.ms_secondaryContainer, ms_colors.ms_onSecondaryContainer, 0.90)
        property color colSecondaryContainerActive: ColorUtils.mix(ms_colors.ms_secondaryContainer, colLayer1Active, 0.54)
        property color colTertiary: ms_colors.ms_tertiary
        property color colTertiaryHover: ColorUtils.mix(ms_colors.ms_tertiary, colLayer1Hover, 0.85)
        property color colTertiaryActive: ColorUtils.mix(ms_colors.ms_tertiary, colLayer1Active, 0.4)
        property color colTertiaryContainer: ms_colors.ms_tertiaryContainer
        property color colTertiaryContainerHover: ColorUtils.mix(ms_colors.ms_tertiaryContainer, ms_colors.ms_onTertiaryContainer, 0.90)
        property color colTertiaryContainerActive: ColorUtils.mix(ms_colors.ms_tertiaryContainer, colLayer1Active, 0.54)
        property color colOnSecondaryContainer: ms_colors.ms_onSecondaryContainer
        property color colSurfaceContainerLow: ColorUtils.transparentize(ms_colors.ms_surfaceContainerLow, root.contentTransparency)
        property color colSurfaceContainer: ColorUtils.transparentize(ms_colors.ms_surfaceContainer, root.contentTransparency)
        property color colSurfaceContainerHigh: ColorUtils.transparentize(ms_colors.ms_surfaceContainerHigh, root.contentTransparency)
        property color colSurfaceContainerHighest: ColorUtils.transparentize(ms_colors.ms_surfaceContainerHighest, root.contentTransparency)
        property color colSurfaceContainerHighestHover: ColorUtils.mix(ms_colors.ms_surfaceContainerHighest, ms_colors.ms_onSurface, 0.95)
        property color colSurfaceContainerHighestActive: ColorUtils.mix(ms_colors.ms_surfaceContainerHighest, ms_colors.ms_onSurface, 0.85)
        property color colOnSurface: ms_colors.ms_onSurface
        property color colOnSurfaceVariant: ms_colors.ms_onSurfaceVariant
        property color colTooltip: ms_colors.ms_inverseSurface
        property color colOnTooltip: ms_colors.ms_inverseOnSurface
        property color colScrim: ColorUtils.transparentize(ms_colors.ms_scrim, 0.5)
        property color colShadow: ColorUtils.transparentize(ms_colors.ms_shadow, 0.7)
        property color colOutline: ms_colors.ms_outline
        property color colOutlineVariant: ms_colors.ms_outlineVariant
        property color colError: ms_colors.ms_error
        property color colErrorHover: ColorUtils.mix(ms_colors.ms_error, colLayer1Hover, 0.85)
        property color colErrorActive: ColorUtils.mix(ms_colors.ms_error, colLayer1Active, 0.7)
        property color colOnError: ms_colors.ms_onError
        property color colErrorContainer: ms_colors.ms_errorContainer
        property color colErrorContainerHover: ColorUtils.mix(ms_colors.ms_errorContainer, ms_colors.ms_onErrorContainer, 0.90)
        property color colErrorContainerActive: ColorUtils.mix(ms_colors.ms_errorContainer, ms_colors.ms_onErrorContainer, 0.70)
        property color colOnErrorContainer: ms_colors.ms_onErrorContainer
    }

    rounding: QtObject {
        property int unsharpen: 2
        property int unsharpenmore: 6
        property int verysmall: 8
        property int small: 12
        property int normal: 17
        property int large: 23
        property int verylarge: 30
        property int full: 9999
        property int screenRounding: large
        property int windowRounding: 18
    }

    font: QtObject {
        property QtObject family: QtObject {
            property string main: "Rubik"
            property string title: "Gabarito"
            property string iconMaterial: "Material Symbols Rounded"
            property string iconNerd: "SpaceMono NF"
            property string monospace: "JetBrains Mono NF"
            property string reading: "Readex Pro"
            property string expressive: "Space Grotesk"
        }
        property QtObject pixelSize: QtObject {
            property int smallest: 10
            property int smaller: 12
            property int small: 15
            property int normal: 16
            property int large: 17
            property int larger: 19
            property int huge: 22
            property int hugeass: 23
            property int title: huge
        }
    }

    animationCurves: QtObject {
        readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.90, 1, 1] // Default, 350ms
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1.00, 1, 1] // Default, 500ms
        readonly property list<real> expressiveSlowSpatial: [0.39, 1.29, 0.35, 0.98, 1, 1] // Default, 650ms
        readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1] // Default, 200ms
        readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedFirstHalf: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82]
        readonly property list<real> emphasizedLastHalf: [5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        readonly property real expressiveFastSpatialDuration: 350
        readonly property real expressiveDefaultSpatialDuration: 500
        readonly property real expressiveSlowSpatialDuration: 650
        readonly property real expressiveEffectsDuration: 200
    }

    animation: QtObject {
        property QtObject elementMove: QtObject {
            property int duration: animationCurves.expressiveDefaultSpatialDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
            property Component colorAnimation: Component {
                ColorAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
        }
        property QtObject elementMoveEnter: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedDecel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveEnter.duration
                    easing.type: root.animation.elementMoveEnter.type
                    easing.bezierCurve: root.animation.elementMoveEnter.bezierCurve
                }
            }
        }
        property QtObject elementMoveExit: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedAccel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveExit.duration
                    easing.type: root.animation.elementMoveExit.type
                    easing.bezierCurve: root.animation.elementMoveExit.bezierCurve
                }
            }
        }
        property QtObject elementMoveFast: QtObject {
            property int duration: animationCurves.expressiveEffectsDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveEffects
            property int velocity: 850
            property Component colorAnimation: Component { ColorAnimation {
                duration: root.animation.elementMoveFast.duration
                easing.type: root.animation.elementMoveFast.type
                easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
            }}
            property Component numberAnimation: Component { NumberAnimation {
                    duration: root.animation.elementMoveFast.duration
                    easing.type: root.animation.elementMoveFast.type
                    easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
            }}
        }
        property QtObject clickBounce: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveFastSpatial
            property int velocity: 850
            property Component numberAnimation: Component { NumberAnimation {
                    duration: root.animation.clickBounce.duration
                    easing.type: root.animation.clickBounce.type
                    easing.bezierCurve: root.animation.clickBounce.bezierCurve
            }}
        }
        property QtObject scroll: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.standardDecel
        }
        property QtObject menuDecel: QtObject {
            property int duration: 350
            property int type: Easing.OutExpo
        }
    }

    sizes: QtObject {
        property real baseBarHeight: 40
        property real barHeight: Config.options.bar.cornerStyle === 1 ? 
            (baseBarHeight + root.sizes.hyprlandGapsOut * 2) : baseBarHeight
        property real barCenterSideModuleWidth: Config.options?.bar.verbose ? 360 : 140
        property real barCenterSideModuleWidthShortened: 280
        property real barCenterSideModuleWidthHellaShortened: 190
        property real barShortenScreenWidthThreshold: 1200 // Shorten if screen width is at most this value
        property real barHellaShortenScreenWidthThreshold: 1000 // Shorten even more...
        property real elevationMargin: 10
        property real fabShadowRadius: 5
        property real fabHoveredShadowRadius: 7
        property real hyprlandGapsOut: 5
        property real mediaControlsWidth: 440
        property real mediaControlsHeight: 160
        property real notificationPopupWidth: 410
        property real osdWidth: 200
        property real searchWidthCollapsed: 260
        property real searchWidth: 450
        property real sidebarWidth: 460
        property real sidebarWidthExtended: 750
        property real baseVerticalBarWidth: 46
        property real verticalBarWidth: Config.options.bar.cornerStyle === 1 ? 
            (baseVerticalBarWidth + root.sizes.hyprlandGapsOut * 2) : baseVerticalBarWidth
    }

    syntaxHighlightingTheme: root.ms_colors.darkmode ? "Monokai" : "ayu Light"
}