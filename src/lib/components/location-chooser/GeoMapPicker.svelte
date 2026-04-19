<script lang="ts">
	import { Map, TileLayer, Marker, ControlAttribution } from "sveaflet";
	import type {
		Map as LeafletMap,
		LatLng,
		LeafletMouseEventHandlerFn,
	} from "leaflet";
	import { divIcon } from "leaflet";
	import Button from "../ui/button/button.svelte";
	import { GpsFixIcon } from "phosphor-svelte";
	import {
		checkPermissions,
		getCurrentPosition,
		requestPermissions,
	} from "@tauri-apps/plugin-geolocation";
	import toast from "svelte-french-toast";
	import { platform } from "@tauri-apps/plugin-os";

	let {
		pinPos = $bindable(),
	}: {
		pinPos?: LatLng;
	} = $props();

	let map: LeafletMap | undefined = $state();

	$effect(() => {
		if (map) {
			const onMapClick: LeafletMouseEventHandlerFn = (e) => {
				pinPos = e.latlng;
			};
			map.on("click", onMapClick);
			return () => {
				map?.off("click", onMapClick);
			};
		}
	});
</script>

<div class="w-[inherit] h-[inherit] relative">
	<Map
		options={{ center: [51.505, -0.09], zoom: 13, attributionControl: false }}
		bind:instance={map}
	>
		<TileLayer
			url={"https://tile.openstreetmap.org/{z}/{x}/{y}.png"}
			options={{
				maxZoom: 19,
				attribution:
					'&copy; <a href="http://www.openstreetmap.org/copyright" target="_blank" rel="noreferrer nofollow noopener">OpenStreetMap</a> &nbsp;',
				// do not enable: https://github.com/Leaflet/Leaflet/issues/6195
				// detectRetina: true,
			}}
		/>
		<ControlAttribution options={{ prefix: undefined }} />

		{#if pinPos}
			<Marker
				latLng={pinPos}
				options={{
					draggable: true,
					icon: divIcon({
						html: '<svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="#ffba20" stroke="#000000" stroke-width="8px" viewBox="0 0 256 256"><path d="M128,16a88.1,88.1,0,0,0-88,88c0,75.3,80,132.17,83.41,134.55a8,8,0,0,0,9.18,0C136,236.17,216,179.3,216,104A88.1,88.1,0,0,0,128,16Zm0,56a32,32,0,1,1-32,32A32,32,0,0,1,128,72Z"></path></svg>',
						iconAnchor: [20, 40],
						iconSize: [40, 40],
						className: "",
					}),
				}}
			/>
		{/if}
	</Map>
	{#if ["android", "ios"].includes(platform())}
		<div class="absolute bottom-6 right-2 z-1000 rounded-full">
			<Button
				size="icon-lg"
				aria-label="Locate me"
				variant="default"
				class="cursor-pointer bg-white text-black hover:bg-neutral-100 shadow-sm"
				onclick={async () => {
					if (map) {
						let permissions = await checkPermissions();
						if (
							permissions.location === "prompt" ||
							permissions.location === "prompt-with-rationale"
						) {
							permissions = await requestPermissions(["location"]);
						}
						if (permissions.location === "granted") {
							const pos = await getCurrentPosition();
							map.setView([pos.coords.latitude, pos.coords.longitude], 13);
						} else {
							toast.error(
								"Location permission denied. Change this in your system settings to use this button.",
							);
						}
					}
				}}
			>
				<GpsFixIcon weight="fill" class="size-6" />
			</Button>
		</div>
	{/if}
</div>
