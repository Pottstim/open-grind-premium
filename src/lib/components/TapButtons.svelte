<script lang="ts">
	import { sendTap } from "$lib/api/interest/taps";
	import { tapTypes, type TapType } from "$lib/model/interest/taps";

	let {
		profileId,
		disabled = false,
	}: {
		profileId: number;
		disabled?: boolean;
	} = $props();

	const taps: TapType[] = [0, 1, 2];
	const icons: Record<TapType, string> = {
		0: "🍪",
		1: "🔥",
		2: "😈",
	};

	let pending = $state(false);
	let lastResult = $state<{ mutual: boolean } | null>(null);
	let error = $state<string | null>(null);

	async function tap(tapType: TapType) {
		if (pending) return;
		pending = true;
		error = null;
		lastResult = null;
		try {
			const res = await sendTap({ recipientId: profileId, tapType });
			lastResult = { mutual: res.isMutual };
		} catch (e) {
			error = e instanceof Error ? e.message : "Failed to send tap";
		} finally {
			pending = false;
		}
	}
</script>

<div class="flex items-center gap-1.5">
	{#each taps as t (t)}
		<button
			type="button"
			class="flex items-center gap-1 rounded-full border border-white/10 bg-popover/40 px-2.5 py-1 text-sm backdrop-blur-2xl transition hover:bg-popover/70 disabled:opacity-50"
			{disabled}
			onclick={() => tap(t)}
		>
			<span aria-hidden="true">{icons[t]}</span>
			<span>{tapTypes[t]}</span>
		</button>
	{/each}
	{#if pending}
		<span class="text-xs text-muted-foreground">…</span>
	{:else if lastResult}
		<span class="text-xs text-muted-foreground">
			{lastResult.mutual ? "Mutual!" : "Sent"}
		</span>
	{:else if error}
		<span class="text-xs text-red-400">{error}</span>
	{/if}
</div>
