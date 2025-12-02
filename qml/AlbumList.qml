import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MusicManager

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
        anchors.margins: Theme.spacing4
        spacing: Theme.spacing4
        
        // Modern "Create Album" button
        Rectangle {
            Layout.preferredWidth: 160
            Layout.preferredHeight: 44
            radius: Theme.radiusRound
            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.primary }
                GradientStop { position: 1.0; color: Theme.primaryHover }
            }
            
            Behavior on opacity {
                NumberAnimation { duration: Theme.durationFast }
            }
            
            opacity: createButtonMouse.containsMouse ? 0.9 : 1.0
            
            RowLayout {
                anchors.centerIn: parent
                spacing: Theme.spacing2
                
                Text {
                    text: "+"
                    font.pixelSize: Theme.fontSizeLarge
                    font.bold: true
                    color: Theme.background
                }
                
                Text {
                    text: "Create Album"
                    font.pixelSize: Theme.fontSizeBody
                    font.bold: true
                    color: Theme.background
                }
            }
            
            MouseArea {
                id: createButtonMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: createAlbumDialog.open()
            }
        }

        // Responsive grid layout
        GridView {
            id: gridView
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: Math.max(160, Math.floor(width / Math.max(1, Math.floor(width / 200))))
            cellHeight: cellWidth + 60
            model: root.model
            clip: true

            delegate: Item {
                width: gridView.cellWidth
                height: gridView.cellHeight

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing3
                    color: "transparent"

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: Theme.spacing3
                        
                        // Album art card with shadow and hover effect
                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: Math.min(parent.width, 180)
                            Layout.preferredHeight: Layout.preferredWidth
                            radius: Theme.radiusMedium
                            color: Theme.surfaceElevated
                            
                            Behavior on scale {
                                NumberAnimation { duration: Theme.durationMedium }
                            }
                            
                            scale: albumMouseArea.containsMouse ? 1.05 : 1.0
                            
                            // Shadow effect
                            layer.enabled: true
                            layer.effect: Item {
                                Rectangle {
                                    anchors.fill: parent
                                    anchors.margins: -Theme.spacing2
                                    radius: Theme.radiusMedium
                                    color: "black"
                                    opacity: Theme.shadowOpacityMedium
                                    z: -1
                                }
                            }
                            
                            // Album art placeholder
                            Text {
                                anchors.centerIn: parent
                                text: "♫"
                                color: Theme.textSecondary
                                font.pixelSize: Theme.fontSizeXXXLarge
                                opacity: albumMouseArea.containsMouse ? 0.3 : 1
                                
                                Behavior on opacity {
                                    NumberAnimation { duration: Theme.durationFast }
                                }
                            }
                            
                            // Play button overlay on hover
                            Rectangle {
                                anchors.centerIn: parent
                                width: Theme.iconSizeXLarge + Theme.spacing4
                                height: width
                                radius: width / 2
                                color: Theme.primary
                                opacity: albumMouseArea.containsMouse ? 1 : 0
                                scale: albumMouseArea.containsMouse ? 1 : 0.8
                                
                                Behavior on opacity {
                                    NumberAnimation { duration: Theme.durationFast }
                                }
                                
                                Behavior on scale {
                                    NumberAnimation { duration: Theme.durationFast }
                                }
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "▶"
                                    font.pixelSize: Theme.fontSizeLarge
                                    color: Theme.background
                                }
                            }
                        }
                        
                        // Album title
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: modelData.title
                            font.pixelSize: Theme.fontSizeBody
                            font.bold: true
                            color: Theme.textPrimary
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
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
    
    // Modern styled dialog
    Dialog {
        id: createAlbumDialog
        title: "Create Album"
        anchors.centerIn: parent
        standardButtons: Dialog.Ok | Dialog.Cancel
        Material.theme: Material.Dark
        
        background: Rectangle {
            color: Theme.surface
            radius: Theme.radiusLarge
        }
        
        ColumnLayout {
            spacing: Theme.spacing3
            
            TextField {
                id: albumTitleField
                placeholderText: "Album Title"
                Layout.preferredWidth: 300
                font.pixelSize: Theme.fontSizeBody
                color: Theme.textPrimary
                
                background: Rectangle {
                    color: Theme.surfaceElevated
                    radius: Theme.radiusMedium
                }
            }
        }
        
        onAccepted: {
            if (albumTitleField.text !== "") {
                musicController.createAlbum(albumTitleField.text)
                albumTitleField.text = ""
            }
        }
    }
}

