/*
    SPDX-FileCopyrightText: 2015 Ivan Safonov <safonov.ivan.s@gmail.com>
    SPDX-FileCopyrightText: 2024 Steve Storey <sstorey@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/
import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs as QQD2

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
        id: backgroundSeparator
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Background")
        visible: true
    }

    QQC2.Button {
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Image:")

        // These realign the Image component up a bit
        // to fix the default alignment
        anchors.top: backgroundSeparator.top
        anchors.topMargin: 6

        width: 240
        height: 135

        // Causes the width property to be honoured by the looks of things
        text: "                                                    "
        Image {
            id: backgroundImage
            anchors.margins: 2
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

    QQC2.ComboBox {
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
        id: snowSeparator
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Snow")
        visible: true
    }

    QQC2.ComboBox {
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Snowflake:")

        textRole: "name"
        valueRole: 'filePath'
        model: [{
            name: "Snwoball",
            filePath: "data/snowflake1.png"
        },{
            name: "Small",
            filePath: "data/snowflake2.png"
        },{
            name: "Large",
            filePath: "data/snowflake3.png"
        }]

        Component.onCompleted: currentIndex = indexOfValue(cfg_Snowflake)
        onActivated: cfg_Snowflake = currentValue
    }

    QQC2.SpinBox {
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Number of snowflakes:")

        value: cfg_Particles
        from: 50
        to: 2000
        onValueChanged: cfg_Particles = value
    }

    QQC2.SpinBox {
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Size of snowflake:")

        value: cfg_Size
        from: 5
        to: 50
        onValueChanged: cfg_Size = value
    }

    QQC2.SpinBox {
        Kirigami.FormData.label: i18nd("plasma_applet_org.kde.snow", "Speed:")

        value: cfg_Velocity
        textFromValue: function(value) {
            return value + " " + i18nd("plasma_applet_org.kde.snow", " pixels/sec")
        }
        from: 10
        to: 500
        onValueChanged: cfg_Velocity = value
    }

    // Used for choosing the background image
    QQD2.FileDialog {
        id: fileDialog
        title: i18nd("plasma_applet_org.kde.snow", "Please choose an image")
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
        onAccepted: {
            cfg_Image = selectedFile
            backgroundImage.source = selectedFile
        }
    }
}
