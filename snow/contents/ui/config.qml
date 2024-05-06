/*
    SPDX-FileCopyrightText: 2015, 2024 Ivan Safonov <safonov.ivan.s@gmail.com>
    SPDX-FileCopyrightText: 2024 Steve Storey <sstorey@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root
    twinFormLayouts: parentLayout

    // Image properties
    property string cfg_Image
    property int cfg_FillMode

    // Snowflake properties
    property string cfg_Snowflake
    property int cfg_Particles
    property int cfg_Size
    property int cfg_Velocity

    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Background")
        visible: true
    }

    Button {
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Image:")

        implicitWidth: 240
        implicitHeight: 135

        Image {
            id: backgroundImage
            anchors.margins: 4
            anchors.fill: parent
            fillMode: cfg_FillMode
            source: cfg_Image
            antialiasing: true
            MouseArea {
                anchors.fill: parent
                onClicked: fileDialog.open()
            }
        }
    }

    ComboBox {
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Positioning:")

        model: [
            {
                'label': i18nd("plasma_applet_org.kde.image", "Scaled and Cropped"),
                'fillMode': Image.PreserveAspectCrop
            },
            {
                'label': i18nd("plasma_applet_org.kde.image", "Scaled"),
                'fillMode': Image.Stretch
            },
            {
                'label': i18nd("plasma_applet_org.kde.image", "Scaled, Keep Proportions"),
                'fillMode': Image.PreserveAspectFit
            },
            {
                'label': i18nd("plasma_applet_org.kde.image", "Centered"),
                'fillMode': Image.Pad
            },
            {
                'label': i18nd("plasma_applet_org.kde.image", "Tiled"),
                'fillMode': Image.Tile
            }
        ]
        textRole: "label"
        valueRole: "fillMode"
        // Set the initial currentIndex to the value stored in the config.
        Component.onCompleted: currentIndex = indexOfValue(cfg_FillMode)
        // Update the stored condfiguration when the selected value changes
        onActivated: cfg_FillMode = currentValue
    }

    // Snow properties

    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Snow")
        visible: true
    }

    ComboBox {
        id: snowflakeSelector
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Snowflake:")
        implicitHeight: 40
        implicitWidth: 60

        model: [
            "data/snowflake1.png",
            "data/snowflake2.png",
            "data/snowflake3.png"
        ]

        Component.onCompleted: currentIndex = indexOfValue(cfg_Snowflake)
        onActivated: cfg_Snowflake = currentValue

        contentItem: Rectangle {
            color: "black"
            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: snowflakeSelector.currentValue
            }
        }

        delegate: ItemDelegate {
            width: snowflakeSelector.width
            contentItem: Rectangle {
                implicitHeight: 40
                color: "black"
                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: modelData
                }
            }
            highlighted: snowflakeSelector.highlightedIndex === index
        }
    }

    SpinBox {
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Number of snowflakes:")

        value: cfg_Particles
        from: 50
        to: 2000
        onValueChanged: cfg_Particles = value
    }

    SpinBox {
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Size of snowflake:")

        value: cfg_Size
        from: 5
        to: 50
        onValueChanged: cfg_Size = value
    }

    SpinBox {
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Speed:")

        value: cfg_Velocity
        from: 10
        to: 500
        onValueChanged: cfg_Velocity = value
    }

    // Used for choosing the background image
    FileDialog {
        id: fileDialog
        title: i18nd("plasma_applet_org.kde.snow", "Please choose an image")
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
        onAccepted: {
            cfg_Image = selectedFile
            backgroundImage.source = selectedFile
        }
    }
}
