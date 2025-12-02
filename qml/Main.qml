import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import MusicManager

ApplicationWindow {
    id: window
    width: 1024
    height: 768
    visible: true
    title: "Music Manager Pro"
    
    // Global Dark Theme
    Material.theme: Material.Dark
    Material.accent: Material.Green
    
    color: Theme.background

    // Determine layout mode based on window width
    readonly property bool useBottomNav: width < Theme.breakpointSmall
    readonly property bool collapsedSidebar: width < Theme.breakpointMedium && !useBottomNav
    readonly property int currentNavIndex: useBottomNav ? bottomNav.currentIndex : sidebar.currentIndex
    
    // Main layout structure
    Item {
        anchors.fill: parent
        
        // Sidebar for desktop/tablet (hidden on mobile)
        Rectangle {
            id: sidebar
            visible: !useBottomNav
            width: collapsedSidebar ? Theme.sidebarWidthCollapsed : Theme.sidebarWidthExpanded
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: playerFooter.top
            color: Theme.surface
            
            property int currentIndex: 0
            
            Behavior on width {
                NumberAnimation { duration: Theme.durationMedium }
            }
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacing2
                spacing: Theme.spacing2
                
                // App Logo/Title
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.headerHeight
                    color: "transparent"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing3
                        spacing: Theme.spacing3
                        
                        Rectangle {
                            width: Theme.iconSizeLarge
                            height: Theme.iconSizeLarge
                            radius: Theme.radiusSmall
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: Theme.primary }
                                GradientStop { position: 1.0; color: Theme.primaryHover }
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: "♫"
                                font.pixelSize: Theme.fontSizeLarge
                                color: Theme.textPrimary
                            }
                        }
                        
                        Text {
                            visible: !collapsedSidebar
                            text: "Music Pro"
                            font.pixelSize: Theme.fontSizeLarge
                            font.bold: true
                            color: Theme.textPrimary
                            Layout.fillWidth: true
                        }
                    }
                }
                
                // Navigation Items
                Repeater {
                    model: [
                        { icon: "♪", label: "Songs" },
                        { icon: "⊞", label: "Albums" },
                        { icon: "☰", label: "Playlists" }
                    ]
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Theme.minTouchTarget
                        radius: Theme.radiusMedium
                        color: sidebar.currentIndex === index ? Theme.primary : (navMouseArea.containsMouse ? Theme.surfaceHover : "transparent")
                        
                        Behavior on color {
                            ColorAnimation { duration: Theme.durationFast }
                        }
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: Theme.spacing3
                            spacing: Theme.spacing3
                            
                            Text {
                                text: modelData.icon
                                font.pixelSize: Theme.fontSizeLarge
                                color: sidebar.currentIndex === index ? Theme.background : Theme.textPrimary
                                Layout.alignment: Qt.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                Layout.preferredWidth: Theme.iconSizeMedium
                            }
                            
                            Text {
                                visible: !collapsedSidebar
                                text: modelData.label
                                font.pixelSize: Theme.fontSizeBody
                                font.bold: sidebar.currentIndex === index
                                color: sidebar.currentIndex === index ? Theme.background : Theme.textPrimary
                                Layout.fillWidth: true
                            }
                        }
                        
                        MouseArea {
                            id: navMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: sidebar.currentIndex = index
                        }
                    }
                }
                
                Item { Layout.fillHeight: true }
            }
        }
        
        // Main content area
        Rectangle {
            anchors.left: useBottomNav ? parent.left : sidebar.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: useBottomNav ? bottomNav.top : playerFooter.top
            color: Theme.background
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                
                // Modern header with search
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.headerHeight
                    color: Theme.surface
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing4
                        spacing: Theme.spacing4
                        
                        Text {
                            text: ["Songs", "Albums", "Playlists"][currentNavIndex] || "Library"
                            font.pixelSize: Theme.fontSizeXLarge
                            font.bold: true
                            color: Theme.textPrimary
                            Layout.fillWidth: true
                        }
                        
                        // Search field
                        Rectangle {
                            Layout.preferredWidth: 300
                            Layout.preferredHeight: 40
                            radius: Theme.radiusRound
                            color: Theme.surfaceElevated
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: Theme.spacing2
                                spacing: Theme.spacing2
                                
                                Text {
                                    text: "🔍"
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.textSecondary
                                }
                                
                                TextField {
                                    id: searchField
                                    Layout.fillWidth: true
                                    placeholderText: "Search..."
                                    color: Theme.textPrimary
                                    background: Rectangle { color: "transparent" }
                                    font.pixelSize: Theme.fontSizeBody
                                    onTextChanged: {
                                        if (currentNavIndex === 0) {
                                            songList.refresh(text)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // User avatar placeholder
                        Rectangle {
                            width: 40
                            height: 40
                            radius: Theme.radiusRound
                            color: Theme.primary
                            
                            Text {
                                anchors.centerIn: parent
                                text: "U"
                                font.pixelSize: Theme.fontSizeMedium
                                font.bold: true
                                color: Theme.background
                            }
                        }
                    }
                }
                
                // Content area with smooth transitions
                StackLayout {
                    id: contentStack
                    currentIndex: currentNavIndex
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    SongList { id: songList }
                    AlbumList { id: albumList }
                    PlaylistList { id: playlistList }
                }
            }
        }
        
        // Bottom navigation for mobile
        Rectangle {
            id: bottomNav
            visible: useBottomNav
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: playerFooter.top
            height: Theme.headerHeight
            color: Theme.surface
            
            property int currentIndex: 0
            
            RowLayout {
                anchors.fill: parent
                spacing: 0
                
                Repeater {
                    model: [
                        { icon: "♪", label: "Songs" },
                        { icon: "⊞", label: "Albums" },
                        { icon: "☰", label: "Playlists" }
                    ]
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: bottomNav.currentIndex === index ? Theme.surfaceElevated : "transparent"
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: Theme.spacing1
                            
                            Text {
                                text: modelData.icon
                                font.pixelSize: Theme.fontSizeLarge
                                color: bottomNav.currentIndex === index ? Theme.primary : Theme.textSecondary
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            Text {
                                text: modelData.label
                                font.pixelSize: Theme.fontSizeXSmall
                                color: bottomNav.currentIndex === index ? Theme.primary : Theme.textSecondary
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: bottomNav.currentIndex = index
                        }
                    }
                }
            }
        }
    }
    
    // Stack view for detail pages
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: null
        
        // Smooth page transitions
        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: Theme.durationMedium
            }
            PropertyAnimation {
                property: "x"
                from: stackView.width
                to: 0
                duration: Theme.durationMedium
            }
        }
        
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: Theme.durationMedium
            }
        }
        
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: Theme.durationMedium
            }
        }
        
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: Theme.durationMedium
            }
            PropertyAnimation {
                property: "x"
                from: 0
                to: stackView.width
                duration: Theme.durationMedium
            }
        }
    }

    footer: PlayerControls {
        id: playerFooter
    }
}
