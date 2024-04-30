/*
    SPDX-FileCopyrightText: 2015 Ivan Safonov <safonov.ivan.s@gmail.com>
    SPDX-FileCopyrightText: 2024 Steve Storey <sstorey@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/
import QtQuick
import QtQuick.Particles

import org.kde.plasma.plasmoid

WallpaperItem {
    id: wallpaper
    Image {
        id: root
        anchors.fill: parent

        fillMode: wallpaper.configuration.FillMode
        source: wallpaper.configuration.Image

        readonly property int velocity: wallpaper.configuration.Velocity
        readonly property int numParticles: wallpaper.configuration.Particles
        readonly property int particleSize: wallpaper.configuration.Size
        readonly property int particleLifeSpan: 1.5 * height / velocity

        ParticleSystem {
            id: particles
        }

        ImageParticle {
            rotationVelocityVariation: 80
            system: particles
            source: wallpaper.configuration.Snowflake
        }

        Emitter {
            system: particles
            emitRate: root.numParticles / root.particleLifeSpan
            maximumEmitted: root.numParticles
            lifeSpan: 1000 * root.particleLifeSpan
            velocity: PointDirection {
                y: root.velocity
                yVariation: root.velocity / 2
                xVariation: root.velocity / 3
            }
            size: root.particleSize
            sizeVariation: root.particleSize / 3
            width: parent.width
            height: 10
            y: -20
        }
    }
}
