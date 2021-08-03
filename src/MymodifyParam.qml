import QtQuick 2.0
import QtQuick.Window 2.3
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import Qt.labs.platform 1.1
Rectangle
{
    width: 500
    height: 300

    visible: true
    property int gPointSize: 14
    color: "darkgrey"
    //title: qsTr("参数配置")

    ColorDialog {
        id: colorDialog
        currentColor: gg === null?"red":gg.lineColor
        onColorChanged: {
            gg.lineColor=color
            rectColor.color = color
        }
    }
    ColumnLayout{
        spacing: 10
        x:10
        y:10
        anchors.fill: parent
        MyText {
            id: tSizeW
            text: qsTr("窗口宽度:")
            textInput: qsTr(gg === null?"5000":gg.size.width.toString())
            pointSize: gPointSize
            textInputWidth: 80
            onTextModify: {
                gg.size.width = val;
            }
        }
        MyText {
            id: tSizeH
            text: qsTr("窗口高度:")
            textInput: qsTr(gg === null?"5000":gg.size.height.toString())
            pointSize: gPointSize
            textInputWidth: 80
            onTextModify: {
                gg.size.height = val;
            }
        }
        RowLayout{
            spacing: 10
            MyText {
                id: tlineW
                text: qsTr("轮廓线宽:")
                textInput: qsTr(gg === null?"2":gg.lineWidth.toString())
                pointSize: gPointSize
                textInputWidth: 80
                onTextModify: {
                    gg.lineWidth = val;
                }
            }
            Rectangle{
                id:rectColor
                Layout.leftMargin: 185
                width: 25
                height: 25
                color:gg === null?"red":gg.lineColor
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        colorDialog.open()
                    }
                }
            }
        }

        RowLayout{
            spacing: 10
            Text {
                text: qsTr("json保存格式")
                font.pointSize: gPointSize
            }
            ComboBox{
                id:combox
                width: 80
                currentIndex: gg === null?0:gg.saveFormt
                model: [ "LabelMeWin"]//, "labelme"
                onCurrentIndexChanged: {
                    gg.saveFormt = currentIndex
                }
            }
            CheckBox{
                id:ckAutosave
                font.pointSize: gPointSize
                checked: gg === null?true:gg.autoSave
                text: qsTr("自动保存json")
                onClicked: {
                    gg.autoSave = checked
                }
            }
        }

        RowLayout{
            Layout.topMargin: 50
            spacing: 100
            Layout.alignment: Qt.AlignCenter
            Button{
                id:cancel
                height: 20
                text: qsTr("取消")
                onClicked: {
                    gg.updataParams(false)
                }
            }
            Button{
                id:ok
                height: 20
                text: qsTr("确定")
                onClicked: {
                    gg.updataParams(true)
                }
            }
        }
    }
}
