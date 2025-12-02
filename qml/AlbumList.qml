import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    
    property var model: musicController.getAlbums()

    Connections {
        target: musicController
        function onAlbumsChanged() {
            root.model = musicController.getAlbums()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15
        
        RowLayout {
            spacing: 10
            
            Button {
                id: createButton
                text: "+ Create Album"
                font.pixelSize: 14
                font.bold: true
                
                background: Rectangle {
                    radius: 8
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#00BCD4" }
                        GradientStop { position: 1.0; color: "#0097A7" }
                    }
                    
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: "#6000BCD4"
                        shadowHorizontalOffset: 0
                        shadowVerticalOffset: 2
                        shadowBlur: 0.4
                    }
                }
                
                contentItem: Text {
                    text: createButton.text
                    font: createButton.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: createAlbumDialog.open()
            }
            
            Item { Layout.fillWidth: true }
            
            Label {
                text: gridView.count + " album" + (gridView.count !== 1 ? "s" : "")
                font.pixelSize: 14
                color: "#888888"
            }
        }

        GridView {
            id: gridView
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: 200
            cellHeight: 240
            model: root.model
            clip: true

            delegate: Item {
                width: gridView.cellWidth
                height: gridView.cellHeight

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 10
                    color: albumMouseArea.containsMouse ? "#2D2D2D" : "#252525"
                    radius: 12
                    
                    border.color: albumMouseArea.containsMouse ? "#00BCD4" : "transparent"
                    border.width: 2
                    
                    Behavior on color { ColorAnimation { duration: 200 } }
                    Behavior on border.color { ColorAnimation { duration: 200 } }
                    
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: albumMouseArea.containsMouse ? "#6000BCD4" : "#40000000"
                        shadowHorizontalOffset: 0
                        shadowVerticalOffset: 4
                        shadowBlur: albumMouseArea.containsMouse ? 0.6 : 0.4
                        
                        Behavior on shadowColor { ColorAnimation { duration: 200 } }
                        Behavior on shadowBlur { NumberAnimation { duration: 200 } }
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 12
                        
                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: 140
                            Layout.preferredHeight: 140
                            radius: 8
                            
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#444444" }
                                GradientStop { position: 0.5; color: "#333333" }
                                GradientStop { position: 1.0; color: "#222222" }
                            }
                            
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                shadowEnabled: true
                                shadowColor: "#30000000"
                                shadowHorizontalOffset: 0
                                shadowVerticalOffset: 2
                                shadowBlur: 0.3
                            }
                            
                            // Album icon overlay
                            Rectangle {
                                anchors.centerIn: parent
                                width: 60
                                height: 60
                                radius: 30
                                color: "#00000040"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "◉"
                                    color: albumMouseArea.containsMouse ? "#00BCD4" : "#888888"
                                    font.pixelSize: 40
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            Text {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                text: modelData.title
                                font.pixelSize: 14
                                font.bold: true
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight
                                maximumLineCount: 2
                                wrapMode: Text.WordWrap
                            }
                            
                            Text {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                text: "Album"
                                font.pixelSize: 11
                                color: "#888888"
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                    
                    MouseArea {
                        id: albumMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        
                        onClicked: {
                            stackView.push("qrc:/qt/qml/MusicManager/qml/AlbumDetail.qml", {
                                "albumId": modelData.id,
                                "albumTitle": modelData.title
                            })
                        }
                    }
                }
            }
        }
    }
    
    Dialog {
        id: createAlbumDialog
        title: "Create Album"
        anchors.centerIn: parent
        width: 350
        
        background: Rectangle {
            color: "#2D2D2D"
            radius: 12
            border.color: "#444444"
            border.width: 1
            
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#80000000"
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 4
                shadowBlur: 0.6
            }
        }
        
        header: Rectangle {
            width: parent.width
            height: 50
            color: "transparent"
            
            Label {
                anchors.centerIn: parent
                text: "Create Album"
                font.pixelSize: 18
                font.bold: true
                color: "white"
            }
        }
        
        ColumnLayout {
            width: parent.width
            spacing: 15
            
            TextField {
                id: albumTitleField
                Layout.fillWidth: true
                placeholderText: "Album Title"
                font.pixelSize: 14
                
                background: Rectangle {
                    radius: 8
                    color: "#333333"
                    border.color: albumTitleField.activeFocus ? "#00BCD4" : "#444444"
                    border.width: 2
                    Behavior on border.color { ColorAnimation { duration: 200 } }
                }
                
                color: "white"
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                Button {
                    Layout.fillWidth: true
                    text: "Cancel"
                    
                    background: Rectangle {
                        radius: 8
                        color: parent.hovered ? "#444444" : "#3A3A3A"
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        color: "#AAAAAA"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: createAlbumDialog.close()
                }
                
                Button {
                    Layout.fillWidth: true
                    text: "Create"
                    
                    background: Rectangle {
                        radius: 8
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#00BCD4" }
                            GradientStop { position: 1.0; color: "#0097A7" }
                        }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        font.bold: true
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        if (albumTitleField.text !== "") {
                            musicController.createAlbum(albumTitleField.text)
                            albumTitleField.text = ""
                            createAlbumDialog.close()
                        }
                    }
                }
            }
        }
    }
}

