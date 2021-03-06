import QtQuick 2.0
import AsemanQml.Base 2.0

AbstractViewportType {
    id: item

    fillForeground: true
    ratio: openRatio * mouseRatio

    background.x: (LayoutMirroring.enabled? width : -width) * ratio/2

    foreground.anchors.top: headerScene.bottom
    foreground.anchors.bottom: foreground.parent.bottom
    foreground.x: (LayoutMirroring.enabled? -width : width) * (1-ratio)

    property real openRatio: open? 1 : 0
    property real mouseRatio: 1

    Behavior on openRatio {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 350 }
    }

    Rectangle {
        parent: item.backgroundScene
        anchors.fill: parent
        z: 100
        color: "#000"
        opacity: item.ratio * 0.4
    }

    NumberAnimation {
        id: mouseRatioAnim
        target: item
        property: "mouseRatio"
        easing.type: Easing.OutCubic
        duration: 300
    }

    Item {
        anchors.fill: parent
        rotation: LayoutMirroring.enabled? 180 : 0

        MouseArea {
            width: 20 * Devices.density
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            preventStealing: true
            onMouseXChanged: {
                var ratio = 1 - ((mouseX - pinX) / item.foreground.width);
                if (ratio < 0.01)
                    ratio = 0.01;
                if (ratio > 1)
                    ratio = 1;

                mouseRatio = ratio;
            }
            onPressed: pinX = mouseX
            onReleased: {
                if (mouseRatio < 0.7) {
                    open = false
                } else {
                    mouseRatioAnim.from = mouseRatio
                    mouseRatioAnim.to = 1
                    mouseRatioAnim.start()
                }
            }

            property real pinX
        }
    }

    Rectangle {
        id: headerScene
        anchors.left: item.foreground.left
        anchors.right: item.foreground.right
        anchors.top: parent.top
        height: headerItem || title.length? Devices.standardTitleBarHeight + Devices.statusBarHeight : 0
        color: "#18f"
    }
}
