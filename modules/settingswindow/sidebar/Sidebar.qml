import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: sidebar
    width: 200
    height: parent.height

    property string bgColor: "#2a2a2a"

    color: sidebar.bgColor

    SearchBar{
        id: searchbar
    }

    ScrollView {
        anchors.fill: parent
        width: parent.width
        anchors.topMargin: searchbar.height // Make space for the header
        contentHeight: columnLayout.height
        clip: true

        ColumnLayout {
            id: columnLayout
            width: parent.width
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 5

            // Navigation buttons
            SidebarDelimeter{ text: "global" }
            SidebarButton{ page: "config files" }

            SidebarDelimeter{ text: "system" }
            SidebarButton{ page: "Displays" }
            SidebarButton{ page: "Pipewire (Audio)" }
            SidebarButton{ page: "Devices" }
            SidebarButton{ page: "Autostart" }
            SidebarButton{ page: "Keybinds" }

            SidebarDelimeter{ text: "appearence" }
            SidebarButton{ page: "Appearence" }
            SidebarButton{ page: "Icons" }
            SidebarButton{ page: "Cursor" }
            SidebarButton{ page: "Wallpaper" }
            SidebarButton{ page: "Modules" }
        }
    }
}




/*
Какие должны быть разделы сайдбара:

Системные настройки

    Дисплэй и мониторы

    Устройства (Мышь, клавиатура)

    Автозапуск

    Кейбинды

    Менеджеры и daemon'ы (Менеджер обоев, менеджер локскрина, проводника и тд) Возможно перенесу в модули и в самих отделах как у обоев будет выбран daemon

    Звук

    Блютуз


Внешний вид: (Все что связано напрямую с hyprland короче и с темизацией и доп. либами для тем. Тут выбирается общий вид который будут наследовать все модули)

Курсор

Тема (gtk темы, wallbash, акцентные цвета, общая непозрачность шела и ui системы)

Окна (Внешний вид окон, непрозрачность, контроль отдельных окон индивидуально)

Обои

Рабочий стол

Анимации


Модули: (автодетект quickshell модулей и их настройка)
*/