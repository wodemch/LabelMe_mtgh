import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
Item {
    id: mt
    property alias text: t1.text
    property alias textInput: t2.text
    property int textInputWidth: 80
    property int pointSize: 16
    property color clr_enter: "#dcdcdc"
    property color clr_exit: "#ffffff"
    property bool btnok_visible:  false

    signal textModify(int val)
    signal okClicked(string val)

    height: pointSize+10
    RowLayout{
        spacing: 10
        anchors.fill: parent
        Text {
            id: t1
            width: 100
            height: parent.height
            text: qsTr("no set")
            font.pointSize: pointSize
        }

        Rectangle{
            id: rec
            width: textInputWidth
            height: pointSize+8
            color: "white"
            TextEdit{
                id:t2
                width: rec.width
                height: rec.height
                font.pointSize: pointSize
                inputMethodHints: Qt.ImhDigitsOnly
                selectByMouse:true
                text: qsTr("no set")
                onTextChanged: {
                    textModify(text)
                }
            }
        }
        Button{
            id:btnok
            visible: btnok_visible
            width: 40
            text:qsTr("确定")
            font.pointSize: pointSize
            onClicked: {
                okClicked(t2.text)
            }
        }
    }
}
