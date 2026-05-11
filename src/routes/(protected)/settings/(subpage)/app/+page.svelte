<script lang="ts">
	import { CaretRightIcon } from "phosphor-svelte";
	import * as Item from "$lib/components/ui/item";
	import toast from "svelte-french-toast";
</script>

<main class="px-4 pb-18 flex flex-col gap-3">
	{#snippet item({ title }: { title: string })}
		<Item.Root variant="outline">
			{#snippet child({ props })}
				<a
					href="#/"
					{...props}
					onclick={() => toast.error("TODO: App settings not implemented yet")}
				>
					<Item.Content class="max-xxxxs:min-w-0">
						<Item.Title class="min-w-0 max-w-full truncate inline-block">
							{title}
						</Item.Title>
					</Item.Content>
					<Item.Actions class="min-w-0">
						<!-- <Item.Description class="min-w-0">{value}</Item.Description> -->
						<CaretRightIcon class="size-4 shrink-0" />
					</Item.Actions>
				</a>
			{/snippet}
		</Item.Root>
	{/snippet}
	{@render item({ title: "Notifications" })}
	{@render item({ title: "Discreet App Icon" })}
	{@render item({ title: "PIN" })}
</main>
