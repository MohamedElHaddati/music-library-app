import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import MusicManager

Item {
    id: root
    
    property var model: musicController.getPlaylists()

    Connections {
        target: musicController
        function onPlaylistsChanged() {
            root.model = musicController.getPlaylists()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: AppTheme.spacing4
        spacing: AppTheme.spacing4
        
        // Modern "Create Playlist" button
        Rectangle {
            Layout.preferredWidth: 180
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
                    text: "Create Playlist"
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
                onClicked: createPlaylistDialog.open()
            }
        }

        // Playlist grid
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
                    
                    // Playlist icon
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 140
                        Layout.alignment: Qt.AlignHCenter
                        radius: AppTheme.radiusMedium
                        color: AppTheme.background
                        
                        Text {
                            anchors.centerIn: parent
                            text: "🎵"
                            font.pixelSize: 60
                        }
                    }
                    
                    // Playlist info
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
                                deleteDialog.playlistId = modelData.id
                                deleteDialog.playlistTitle = modelData.title
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
                        window.stackView.push("qrc:/qt/qml/MusicManager/qml/PlaylistDetail.qml", {
                            "playlistId": modelData.id,
                            "playlistTitle": modelData.title
                        })
                    }
                }
            }
        }
    }
    
    // Create playlist dialog
    Dialog {
        id: createPlaylistDialog
        title: "Create Playlist"
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
                id: playlistTitleField
                placeholderText: "Playlist Title"
                Layout.fillWidth: true
                background: Rectangle {
                    color: AppTheme.background
                    radius: AppTheme.radiusMedium
                    border.color: playlistTitleField.activeFocus ? AppTheme.primary : AppTheme.border
                    border.width: 1
                }
                color: AppTheme.textPrimary
            }
        }
        
        onAccepted: {
            if (playlistTitleField.text !== "") {
                musicController.createPlaylist(playlistTitleField.text)
                playlistTitleField.text = ""
            }
        }
    }
    
    // Delete confirmation dialog
    Dialog {
        id: deleteDialog
        title: "Delete Playlist"
        anchors.centerIn: parent
        width: 350  // Add explicit width
        standardButtons: Dialog.Yes | Dialog.No
        Material.theme: Material.Dark
        
        property int playlistId: -1
        property string playlistTitle: ""
        
        background: Rectangle {
            color: AppTheme.surface
            radius: AppTheme.radiusLarge
            border.color: AppTheme.border
            border.width: 1
        }
        
        Text {
            text: "Are you sure you want to delete \"" + deleteDialog.playlistTitle + "\"?"
            color: AppTheme.textPrimary
            wrapMode: Text.WordWrap
            width: parent.width - 40
        }
        
        onAccepted: {
            musicController.deletePlaylist(deleteDialog.playlistId)
        }
    }
}
