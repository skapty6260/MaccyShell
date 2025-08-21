import qs.services
import QtQuick

Text {
    property string size: 'h3' // h1, h2, h3, p, s (s-span or small)
    property string fontFamily: ThemeConfig.fontFamily

    text: val
    font.family: ThemeConfig.fontFamily
    font.pointSize: ThemeConfig.fontSize
    color: ThemeConfig.windowForeground
}