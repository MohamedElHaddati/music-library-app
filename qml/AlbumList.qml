import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
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
        anchors.margins: AppTheme.spacing4
        spacing: AppTheme.spacing4
        
        // Modern "Create Album" button
        Rectangle {
            Layout.preferredWidth: 160
            Layout.preferredHeight: 44
            radius: AppTheme.radiusRound
            gradient: Gradient {
                GradientStop { position: 0.0; color: AppTheme.primary }
                GradientStop { position: 1.0; color: AppTheme.primaryHover }
            }
            
            Behavior on opacity {
                NumberAnimation { duration: AppTheme.durationFast }
            }
            
            opacity: createButtonMouse.containsMouse ? 0.9 : 1.0
            
            RowLayout {
                anchors.centerIn: parent
                spacing: AppTheme.spacing2
                
                Text {
                    text: "+"
                    font.pixelSize: AppTheme.fontSizeLarge
                    font.bold: true
                    color: AppTheme.textPrimary
                }
                
                Text {
                    text: "Create Album"
                    font.pixelSize: AppTheme.fontSizeMedium
                    font.bold: true
                    color: AppTheme.textPrimary
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
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: 180
            cellHeight: 240
            clip: true
            
            model: root.model
            
            delegate: Rectangle {
                width: 170
                height: 230
                radius: AppTheme.radiusMedium
                color: mouseArea.containsMouse ? AppTheme.surfaceHover : AppTheme.surface
                
                Behavior on color {
                    ColorAnimation { duration: AppTheme.durationFast }
                }
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: AppTheme.spacing3
                    spacing: AppTheme.spacing3
                    
                    // Album cover with disc icon
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 140
                        Layout.alignment: Qt.AlignHCenter
                        radius: AppTheme.radiusMedium
                        color: AppTheme.background
                        
                        Text {
                            anchors.centerIn: parent
                            text: "💿"
                            font.pixelSize: 60
                        }
                    }
                    
                    // Album info
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        Text {
                            text: modelData.title
                            font.pixelSize: AppTheme.fontSizeMedium
                            font.bold: true
                            color: AppTheme.textPrimary
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: modelData.songCount + " songs"
                            font.pixelSize: AppTheme.fontSizeSmall
                            color: AppTheme.textSecondary
                        }
                    }
                    
                    // Delete button
                    Rectangle {
                        Layout.preferredWidth: 30
                        Layout.preferredHeight: 30
                        Layout.alignment: Qt.AlignRight
                        radius: AppTheme.radiusSmall
                        color: deleteMouseArea.containsMouse ? AppTheme.error : "transparent"
                        
                        Text {
                            anchors.centerIn: parent
                            text: "🗑️"
                            font.pixelSize: 16
                        }
                        
                        MouseArea {
                            id: deleteMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                deleteDialog.albumId = modelData.id
                                deleteDialog.albumTitle = modelData.title
                                deleteDialog.open()
                            }
                        }
                    }
                }
                
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        window.stackView.push("qrc:/qt/qml/MusicManager/qml/AlbumDetail.qml", {
                            "albumId": modelData.id,
                            "albumTitle": modelData.title,
                            "albumCover": modelData.coverPath || ""
                        })
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
        width: 350  // Add explicit width
        standardButtons: Dialog.Ok | Dialog.Cancel
        Material.theme: Material.Dark
        
        background: Rectangle {
            color: AppTheme.surface
            radius: AppTheme.radiusLarge
            border.color: AppTheme.border
            border.width: 1
        }
        
        ColumnLayout {
            width: parent.width
            spacing: AppTheme.spacing3
            
            TextField {
                id: albumTitleField
                placeholderText: "Album Title"
                Layout.fillWidth: true
                background: Rectangle {
                    color: AppTheme.background
                    radius: AppTheme.radiusMedium
                    border.color: albumTitleField.activeFocus ? AppTheme.primary : AppTheme.border
                    border.width: 1
                }
                color: AppTheme.textPrimary
            }
        }
        
        onAccepted: {
            if (albumTitleField.text !== "") {
                musicController.createAlbum(albumTitleField.text, "")
                albumTitleField.text = ""
            }
        }
    }
    
    // Delete confirmation dialog
    Dialog {
        id: deleteDialog
        title: "Delete Album"
        anchors.centerIn: parent
        width: 350  // Add explicit width
        standardButtons: Dialog.Yes | Dialog.No
        Material.theme: Material.Dark
        
        property int albumId: -1
        property string albumTitle: ""
        
        background: Rectangle {
            color: AppTheme.surface
            radius: AppTheme.radiusLarge
            border.color: AppTheme.border
            border.width: 1
        }
        
        Text {
            text: "Are you sure you want to delete \"" + deleteDialog.albumTitle + "\"?"
            color: AppTheme.textPrimary
            wrapMode: Text.WordWrap
            width: parent.width - 40
        }
        
        onAccepted: {
            musicController.deleteAlbum(deleteDialog.albumId)
        }
    }
}

