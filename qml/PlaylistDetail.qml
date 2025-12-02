import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Page {
    id: root
    property int playlistId: -1
    property string playlistTitle: ""
    
    background: Rectangle {
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0A0A0A" }
            GradientStop { position: 1.0; color: "#1A1A1A" }
        }
    }

    header: Rectangle {
        width: parent.width
        height: 70
        color: "#1E1E1E"
        
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#30000000"
            shadowVerticalOffset: 2
            shadowBlur: 0.3
        }
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 15
            
            Button {
                id: backButton
                text: "←"
                font.pixelSize: 20
                flat: true
                
                background: Rectangle {
                    radius: 8
                    color: backButton.hovered ? "#2D2D2D" : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
                
                contentItem: Text {
                    text: backButton.text
                    font: backButton.font
                    color: backButton.hovered ? "#00BCD4" : "#CCCCCC"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
                
                onClicked: stackView.pop()
            }
            
            Label {
                text: root.playlistTitle
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
            
            Button {
                id: playPlaylistButton
                text: "▶ Play Playlist"
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
                    text: playPlaylistButton.text
                    font: playPlaylistButton.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: musicController.playPlaylist(root.playlistId)
            }
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Playlist Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            color: "transparent"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 30
                
                Rectangle {
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 140
                    radius: 12
                    
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#00BCD4" }
                        GradientStop { position: 0.5; color: "#0097A7" }
                        GradientStop { position: 1.0; color: "#00838F" }
                    }
                    
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: "#8000BCD4"
                        shadowHorizontalOffset: 0
                        shadowVerticalOffset: 4
                        shadowBlur: 0.6
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "☰"
                        color: "white"
                        font.pixelSize: 60
                        font.bold: true
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    
                    Label {
                        text: "PLAYLIST"
                        font.pixelSize: 11
                        font.bold: true
                        color: "#888888"
                        font.letterSpacing: 1
                    }
                    
                    Label {
                        text: root.playlistTitle
                        font.pixelSize: 32
                        font.bold: true
                        color: "white"
                    }
                }
            }
        }

        ListView {
            id: songListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: musicController.getPlaylistSongs(root.playlistId)
            clip: true
            spacing: 8
            
            Layout.margins: 20
            
            delegate: Rectangle {
                width: ListView.view.width
                height: 60
                color: songMouseArea.containsMouse ? "#2D2D2D" : "#252525"
                radius: 8
                
                border.color: songMouseArea.containsMouse ? "#00BCD4" : "transparent"
                border.width: 1
                
                Behavior on color { ColorAnimation { duration: 150 } }
                Behavior on border.color { ColorAnimation { duration: 150 } }
                
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#30000000"
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 2
                    shadowBlur: 0.3
                }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 15
                    
                    Text {
                        text: (index + 1).toString()
                        font.pixelSize: 14
                        font.bold: true
                        color: songMouseArea.containsMouse ? "#00BCD4" : "#666666"
                        Layout.preferredWidth: 30
                        horizontalAlignment: Text.AlignRight
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    
                    Rectangle {
                        width: 36
                        height: 36
                        radius: 6
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#333333" }
                            GradientStop { position: 1.0; color: "#222222" }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "▶"
                            font.pixelSize: 14
                            color: songMouseArea.containsMouse ? "#00BCD4" : "#888888"
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            text: modelData.title
                            font.pixelSize: 14
                            font.bold: true
                            color: "white"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: modelData.artist
                            font.pixelSize: 11
                            color: "#AAAAAA"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                }
                
                MouseArea {
                    id: songMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    
                    onClicked: musicController.playSong(modelData.id)
                }
            }
        }
    }
}
