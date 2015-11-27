/*
 *  Copyright 2015 Ivan Safonov <safonov.ivan.s@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */
import QtQuick 2.0
import QtQuick.Particles 2.0
import org.kde.plasma.core 2.0 as Plasmacore

Image {
   id: root

   fillMode: wallpaper.configuration.FillMode
   source: wallpaper.configuration.Image
   readonly property int velocity: wallpaper.configuration.Velocity
   readonly property int particles: wallpaper.configuration.Particles
   readonly property int size: wallpaper.configuration.Size
   readonly property int lifeSpan: 1.5 * height / velocity

   ParticleSystem { id: particles }

   ImageParticle {
       rotationVelocityVariation: 80
       system: particles
       source: wallpaper.configuration.Snowflake
   }

   Emitter {
       system: particles
       emitRate: root.particles / root.lifeSpan
       maximumEmitted: root.particles
       lifeSpan: 1000 * root.lifeSpan
       velocity: PointDirection { y:root.velocity; yVariation: root.velocity/2; xVariation: root.velocity/3}
       size: root.size
       sizeVariation: root.size / 3
       width: parent.width
       height: 10
       y:-20
   }
}