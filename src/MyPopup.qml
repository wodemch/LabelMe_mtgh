import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
Popup {
    id:pp
    property alias tipText: msg.text

    width: 800
    height: 150

    signal buttonOKClicked
    signal buttonCancelClicked

    anchors.centerIn: parent

    contentItem: GroupBox{
        anchors.fill: parent
        GridLayout{
            rows: 2
            anchors.fill: parent
            Text {
                Layout.row: 1
                font.pointSize: 12
                id: msg
                text: "Content"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
            RowLayout {
                Layout.row: 2
                //anchors.fill: parent
                anchors.bottom:  pp.bottom
                Layout.alignment: Qt.AlignHCenter
                spacing: 20
                Button{
                    id:ok
                    text: qsTr("OK")
                    onClicked: {
                        pp.buttonOKClicked()
                        pp.close()
                    }
                }
                Button{
                    id:cancel
                    text: qsTr("Cancel")
                    onClicked: {
                        pp.buttonCancelClicked()
                        pp.close()
                    }
                }
            }
        }
    }
}
