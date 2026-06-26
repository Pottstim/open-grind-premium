import { browser } from "$app/environment";

import {
	type DistanceUnit,
	getDistanceUnit as readStoredUnit,
	setDistanceUnit as writeStoredUnit,
} from "$lib/utils/distance";

// Reactive state — initialised from localStorage on first access in the browser.
let unit = $state<DistanceUnit>(browser ? readStoredUnit() : "km");

export function getDistanceUnit(): DistanceUnit {
	return unit;
}

export function setDistanceUnit(newUnit: DistanceUnit): void {
	unit = newUnit;
	if (browser) {
		writeStoredUnit(newUnit);
	}
}
