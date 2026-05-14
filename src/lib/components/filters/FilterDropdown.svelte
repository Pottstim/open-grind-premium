<script lang="ts">
	import { CaretDownIcon } from "phosphor-svelte";
	import { expoOut } from "svelte/easing";
	import type { TransitionConfig } from "svelte/transition";

	import FilterBoolean from "./FilterBoolean.svelte";

	let {
		checked = $bindable(),
		id,
		label,
		endLabel,
		children,
		contentClass,
		class: className,
	}: {
		checked: boolean;
		id: string;
		label: string;
		endLabel?: string;
		children?: import("svelte").Snippet;
		contentClass?: import("svelte/elements").ClassValue;
		class?: import("svelte/elements").ClassValue;
	} = $props();

	let expanded = $state(false);

	const hide = (node: HTMLDivElement): TransitionConfig => {
		const height = node.scrollHeight;
		return {
			duration: 400,
			css: (t: number, u: number) =>
				`height: calc(${t} * ${height}px); opacity: ${t}; margin-top: calc(${u} * -8px)`,
			easing: expoOut,
		};
	};
</script>

{#snippet endAdornment()}
	{endLabel}
{/snippet}
<div class={["flex flex-col min-w-0 shrink-0", className]}>
	<FilterBoolean
		{id}
		endAdornment={endLabel !== undefined ? endAdornment : undefined}
		bind:checked={
			() => checked,
			(v: boolean) => {
				if (expanded && !checked) {
					expanded = false;
				} else {
					expanded = v;
					checked = v;
				}
			}
		}
	>
		{label}
		<CaretDownIcon
			class={["transition-transform", { "-rotate-180": expanded }]}
		/>
	</FilterBoolean>
	{#if expanded}
		<div
			class={["ps-6 pt-2 overflow-clip shrink-0", contentClass]}
			transition:hide
		>
			{@render children?.()}
		</div>
	{/if}
</div>
