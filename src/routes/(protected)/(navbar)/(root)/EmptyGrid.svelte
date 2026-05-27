<script lang="ts">
	import EmptyIcon from "phosphor-svelte/lib/EmptyIcon";

	import { Button } from "$lib/components/ui/button/index.js";
	import * as Empty from "$lib/components/ui/empty/index.js";

	let { onResetFilters }: { onResetFilters: () => void } = $props();
</script>

<Empty.Root class="col-span-full">
	<Empty.Header>
		<Empty.Media variant="icon">
			<EmptyIcon />
		</Empty.Media>
		<Empty.Title>No profiles found</Empty.Title>
		<Empty.Description>
			Try adjusting your filters or reset them to defaults.
		</Empty.Description>
	</Empty.Header>
	<Empty.Content>
		<div class="flex gap-2">
			<Button variant="outline" onclick={onResetFilters}>Reset filters</Button>
		</div>
	</Empty.Content>
</Empty.Root>
