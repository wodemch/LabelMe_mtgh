import QtQuick 2.0

Item {
    property alias color: rect.color
    Rectangle{
        id:rect
        width: 100
        height: 2
        color: "black"
    }
}
