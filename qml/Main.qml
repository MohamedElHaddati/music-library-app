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
    
    // Global Dark AppTheme
    Material.theme: Material.Dark
    Material.accent: Material.Green
    
    color: AppTheme.background

    // Make stackView accessible to all child components
    property alias stackView: stackView

    // Determine layout mode based on window width
    readonly property bool useBottomNav: width < AppTheme.breakpointSmall
    readonly property bool collapsedSidebar: width < AppTheme.breakpointMedium && !useBottomNav
    readonly property int currentNavIndex: useBottomNav ? bottomNav.currentIndex : sidebar.currentIndex
    
    // Main layout structure
    Item {
        id: mainContent
        anchors.fill: parent
        
        // Sidebar for desktop/tablet (hidden on mobile)
        Rectangle {
            id: sidebar
            visible: !useBottomNav
            width: collapsedSidebar ? AppTheme.sidebarWidthCollapsed : AppTheme.sidebarWidthExpanded
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: AppTheme.surface
            
            property int currentIndex: 0
            
            Behavior on width {
                NumberAnimation { duration: AppTheme.durationMedium }
            }
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: AppTheme.spacing2
                spacing: AppTheme.spacing2
                
                // App Logo/Title
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: AppTheme.headerHeight
                    color: "transparent"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: AppTheme.spacing3
                        spacing: AppTheme.spacing3
                        
                        Rectangle {
                            width: AppTheme.iconSizeLarge
                            height: AppTheme.iconSizeLarge
                            radius: AppTheme.radiusSmall
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: AppTheme.primary }
                                GradientStop { position: 1.0; color: AppTheme.primaryHover }
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: "♫"
                                font.pixelSize: AppTheme.fontSizeLarge
                                color: AppTheme.textPrimary
                            }
                        }
                        
                        Text {
                            visible: !collapsedSidebar
                            text: "Music Pro"
                            font.pixelSize: AppTheme.fontSizeLarge
                            font.bold: true
                            color: AppTheme.textPrimary
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
                        Layout.preferredHeight: AppTheme.minTouchTarget
                        radius: AppTheme.radiusMedium
                        color: sidebar.currentIndex === index ? AppTheme.primary : (navMouseArea.containsMouse ? AppTheme.surfaceHover : "transparent")
                        
                        Behavior on color {
                            ColorAnimation { duration: AppTheme.durationFast }
                        }
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: AppTheme.spacing3
                            spacing: AppTheme.spacing3
                            
                            Text {
                                text: modelData.icon
                                font.pixelSize: AppTheme.fontSizeLarge
                                color: sidebar.currentIndex === index ? AppTheme.background : AppTheme.textPrimary
                                Layout.alignment: Qt.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                Layout.preferredWidth: AppTheme.iconSizeMedium
                            }
                            
                            Text {
                                visible: !collapsedSidebar
                                text: modelData.label
                                font.pixelSize: AppTheme.fontSizeBody
                                font.bold: sidebar.currentIndex === index
                                color: sidebar.currentIndex === index ? AppTheme.background : AppTheme.textPrimary
                                Layout.fillWidth: true
                            }
                        }
                        
                        MouseArea {
                            id: navMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                sidebar.currentIndex = index
                                stackView.clear()
                            }
                        }
                    }
                }
                
                Item { Layout.fillHeight: true }
            }
        }
        
        // Main content area
        Rectangle {
            id: contentArea
            anchors.left: useBottomNav ? parent.left : sidebar.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: useBottomNav ? bottomNav.top : parent.bottom
            color: AppTheme.background
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                
                // Modern header with search
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: AppTheme.headerHeight
                    color: AppTheme.surface
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: AppTheme.spacing4
                        spacing: AppTheme.spacing4
                        
                        // Back button (visible when stack has items)
                        Rectangle {
                            visible: stackView.depth > 0
                            width: 40
                            height: 40
                            radius: 20
                            color: backMouseArea.containsMouse ? AppTheme.surfaceElevated : "transparent"
                            
                            Text {
                                anchors.centerIn: parent
                                text: "←"
                                font.pixelSize: AppTheme.fontSizeLarge
                                color: AppTheme.textPrimary
                            }
                            
                            MouseArea {
                                id: backMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: stackView.pop()
                            }
                        }
                        
                        Text {
                            text: ["Songs", "Albums", "Playlists"][currentNavIndex] || "Library"
                            font.pixelSize: AppTheme.fontSizeXLarge
                            font.bold: true
                            color: AppTheme.textPrimary
                            Layout.fillWidth: true
                        }
                        
                        // Search field
                        Rectangle {
                            Layout.preferredWidth: 300
                            Layout.preferredHeight: 40
                            radius: AppTheme.radiusRound
                            color: AppTheme.surfaceElevated
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: AppTheme.spacing2
                                spacing: AppTheme.spacing2
                                
                                Text {
                                    text: "🔍"
                                    font.pixelSize: AppTheme.fontSizeMedium
                                    color: AppTheme.textSecondary
                                }
                                
                                TextField {
                                    id: searchField
                                    Layout.fillWidth: true
                                    placeholderText: "Search..."
                                    color: AppTheme.textPrimary
                                    background: Rectangle { color: "transparent" }
                                    font.pixelSize: AppTheme.fontSizeBody
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
                            radius: AppTheme.radiusRound
                            color: AppTheme.primary
                            
                            Text {
                                anchors.centerIn: parent
                                text: "U"
                                font.pixelSize: AppTheme.fontSizeMedium
                                font.bold: true
                                color: AppTheme.background
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
                    visible: stackView.depth === 0
                    
                    SongList { id: songList }
                    AlbumList { id: albumList }
                    PlaylistList { id: playlistList }
                }
                
                // Stack view for detail pages
                StackView {
                    id: stackView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: depth > 0
                    
                    pushEnter: Transition {
                        PropertyAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: AppTheme.durationMedium
                        }
                    }
                    
                    pushExit: Transition {
                        PropertyAnimation {
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: AppTheme.durationMedium
                        }
                    }
                    
                    popEnter: Transition {
                        PropertyAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: AppTheme.durationMedium
                        }
                    }
                    
                    popExit: Transition {
                        PropertyAnimation {
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: AppTheme.durationMedium
                        }
                    }
                }
            }
        }
        
        // Bottom navigation for mobile
        Rectangle {
            id: bottomNav
            visible: useBottomNav
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: AppTheme.headerHeight
            color: AppTheme.surface
            
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
                        color: bottomNav.currentIndex === index ? AppTheme.surfaceElevated : "transparent"
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: AppTheme.spacing1
                            
                            Text {
                                text: modelData.icon
                                font.pixelSize: AppTheme.fontSizeLarge
                                color: bottomNav.currentIndex === index ? AppTheme.primary : AppTheme.textSecondary
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            Text {
                                text: modelData.label
                                font.pixelSize: AppTheme.fontSizeXSmall
                                color: bottomNav.currentIndex === index ? AppTheme.primary : AppTheme.textSecondary
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                bottomNav.currentIndex = index
                                stackView.clear()
                            }
                        }
                    }
                }
            }
        }
    }

    footer: PlayerControls {
        id: playerFooter
    }
}
