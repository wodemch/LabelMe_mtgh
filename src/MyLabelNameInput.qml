import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
Popup{
    id:pp
    signal okClose(string val)
    signal addOneLabel(string labelname)
    // 新增函数
    function initAddOne(labelName) {
        addOneLabel(labelName)
    }
    function clearAll() {
        listView.model.clear()
    }
    Rectangle {
        width: parent.width
        height: parent.height
        color: "#EEEEEE"

        // 1.定义header
        Component {
            id: headerView
            Item {
                width: parent.width
                height: 30
                RowLayout {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8
                    Text {
                        text: "Name"
                        font.bold: true
                        font.pixelSize: 16
                        Layout.preferredWidth: 120
                    }
                }
            }
        }

        // 2. 定义footer
        Component {
            id: footerView
            Text {
                width: parent.width
                font.italic: true
                color: "blue"
                height: 30
                verticalAlignment: Text.AlignVCenter
            }
        }

        // 3. 定义model
        Component {
            id: phoneModel            
            ListModel {
                ListElement{name: "rect"}
                ListElement{name: "polygon"}
                ListElement{name: "circle"}
            }
        }

        // 4. 定义delegate
        Component {
            id: phoneDelegate
            Item {
                id: wrapper
                width: parent.width
                height: 30

                MouseArea {
                    anchors.fill: parent
                    onClicked: wrapper.ListView.view.currentIndex = index

                    onDoubleClicked: {
                        wrapper.ListView.view.model.remove(index)
                        mouse.accepted = true
                    }
                }

                RowLayout {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8
                    Text {
                        id: col1
                        text: name
                        color: wrapper.ListView.isCurrentItem ? "red" : "black"
                        font.pixelSize: wrapper.ListView.isCurrentItem ? 18 : 14
                        Layout.preferredWidth: 120
                    }
                }
            }
        }

        // 5.定义ListView
        MyText {
            id: tlabelName
            height: 40
            text: qsTr("当前标签:")
            textInput: qsTr("")
            btnok_visible: true
            pointSize: 12
            textInputWidth: 140
            onOkClicked: {
                okClose(val)
                close()
            }
        }
        ListView {
            id: listView
            anchors.fill: parent
            anchors.topMargin: 50
            delegate: phoneDelegate
            model: phoneModel.createObject(listView)
            //header: headerView
            focus: true
            highlight: Rectangle{
                color: "lightblue"
            }

            onCurrentIndexChanged:{
                if( listView.currentIndex >=0 ){
                    var data = listView.model.get(listView.currentIndex)
                    tlabelName.textInput = data.name
                }
            }
            // 新增函数
            function insert(val) {
                var res = true
                if (count > 0){
                    for (var i = 0; i < listView.count; ++i){
                        if(val === model.get(i).name){
                            //找到后上移 至第一位
                            model.move(i, 0, 1)
                            res=false
                            break
                        }
                    }
                }
                if(res){
                    model.insert(0,{
                                     "name": val
                                 })
                }
            }
            function addOne(labelName) {
                model.append({
                                 "name": labelName
                             })
            }
            // 连接信号槽
            Component.onCompleted: {
                okClose.connect(listView.insert)
                addOneLabel.connect(listView.addOne)
            }
        }
    }
}
