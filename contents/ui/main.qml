/*
This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see <https://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

PlasmoidItem {
	anchors.fill: parent
//	Plasmoid.constraintHints: PlasmaCore.Types.CanFillArea
	Plasmoid.constraintHints: Plasmoid.CanFillArea
	Layout.preferredWidth: 5000
	Layout.fillWidth: true
	Layout.fillHeight: true
	
	
	fullRepresentation: FullRepresentation {}
	compactRepresentation: FullRepresentation {}
}
