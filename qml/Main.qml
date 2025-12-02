import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Effects

ApplicationWindow {
    id: window
    width: 1280
    height: 800
    visible: true
    title: "Music Manager Pro"
    
    // Modern Dark Theme with custom colors
    Material.theme: Material.Dark
    Material.accent: Material.Teal
    Material.primary: Material.Teal
    
    // Custom color palette
    property color accentColor: "#00BCD4"
    property color backgroundColor: "#121212"
    property color surfaceColor: "#1E1E1E"
    property color cardColor: "#252525"
    property color hoverColor: "#2D2D2D"

    background: Rectangle {
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0A0A0A" }
            GradientStop { position: 1.0; color: "#1A1A1A" }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.bottomMargin: playerFooter.height
        spacing: 0
        
        // Modern Sidebar Navigation
        Rectangle {
            id: sidebar
            Layout.preferredWidth: 220
            Layout.fillHeight: true
            color: window.surfaceColor
            
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#40000000"
                shadowHorizontalOffset: 2
                shadowVerticalOffset: 0
                shadowBlur: 0.4
            }
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 0
                spacing: 0
                
                // App Logo/Title
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    color: "transparent"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 12
                        
                        Rectangle {
                            width: 40
                            height: 40
                            radius: 8
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: window.accentColor }
                                GradientStop { position: 1.0; color: "#0097A7" }
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: "♪"
                                font.pixelSize: 24
                                color: "white"
                                font.bold: true
                            }
                        }
                        
                        Label {
                            text: "Music\nManager"
                            font.pixelSize: 16
                            font.bold: true
                            color: "white"
                        }
                    }
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: "#333333"
                }
                
                // Navigation Items
                Item { Layout.preferredHeight: 10 }
                
                Repeater {
                    model: [
                        { icon: "♫", text: "Songs", index: 0 },
                        { icon: "◉", text: "Albums", index: 1 },
                        { icon: "☰", text: "Playlists", index: 2 }
                    ]
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        Layout.topMargin: 2
                        Layout.bottomMargin: 2
                        
                        color: navItemArea.containsMouse ? window.hoverColor : 
                               (bar.currentIndex === modelData.index ? window.cardColor : "transparent")
                        radius: 8
                        
                        Behavior on color { ColorAnimation { duration: 150 } }
                        
                        border.color: bar.currentIndex === modelData.index ? window.accentColor : "transparent"
                        border.width: bar.currentIndex === modelData.index ? 2 : 0
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 15
                            
                            Text {
                                text: modelData.icon
                                font.pixelSize: 20
                                color: bar.currentIndex === modelData.index ? window.accentColor : "#AAAAAA"
                                Layout.preferredWidth: 30
                                horizontalAlignment: Text.AlignHCenter
                            }
                            
                            Label {
                                text: modelData.text
                                font.pixelSize: 14
                                font.bold: bar.currentIndex === modelData.index
                                color: bar.currentIndex === modelData.index ? "white" : "#CCCCCC"
                                Layout.fillWidth: true
                            }
                        }
                        
                        MouseArea {
                            id: navItemArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: bar.currentIndex = modelData.index
                        }
                    }
                }
                
                Item { Layout.fillHeight: true }
            }
        }
        
        // Main Content Area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                
                // Modern Header
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    color: window.surfaceColor
                    
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: "#30000000"
                        shadowVerticalOffset: 2
                        shadowBlur: 0.3
                    }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 15
                        
                        Label {
                            text: bar.currentIndex === 0 ? "Songs" : 
                                  bar.currentIndex === 1 ? "Albums" : "Playlists"
                            font.pixelSize: 28
                            font.bold: true
                            color: "white"
                        }
                        
                        Item { Layout.fillWidth: true }
                        
                        Rectangle {
                            Layout.preferredWidth: 300
                            Layout.preferredHeight: 40
                            radius: 20
                            color: window.cardColor
                            border.color: searchField.activeFocus ? window.accentColor : "#333333"
                            border.width: 2
                            
                            Behavior on border.color { ColorAnimation { duration: 200 } }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 10
                                
                                Text {
                                    text: "🔍"
                                    font.pixelSize: 16
                                    color: "#888888"
                                }
                                
                                TextField {
                                    id: searchField
                                    Layout.fillWidth: true
                                    placeholderText: "Search music..."
                                    background: Rectangle { color: "transparent" }
                                    color: "white"
                                    font.pixelSize: 14
                                    onTextChanged: songList.refresh(text)
                                }
                            }
                        }
                    }
                }
                
                // Hidden TabBar (controlled by sidebar)
                TabBar {
                    id: bar
                    visible: false
                    currentIndex: 0
                }
                
                // Content Area
                StackLayout {
                    currentIndex: bar.currentIndex
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    SongList { id: songList }
                    AlbumList { id: albumList }
                    PlaylistList { id: playlistList }
                }
            }
        }
    }
    
    StackView {
        id: stackView
        anchors.fill: parent
        anchors.bottomMargin: playerFooter.height
        visible: depth > 1
        
        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
    }

    footer: PlayerControls {
        id: playerFooter
    }
}
