<script lang="ts">
	import { onMount } from "svelte";
	import { goto } from "$app/navigation";
	import { toast } from "svelte-sonner";
	import { CaretRightIcon, CheckCircleIcon, UserCircleIcon, TrashSimpleIcon, SpinnerGap, PlusIcon, XIcon } from "phosphor-svelte";

	import { getAccounts } from "$lib/account-store.svelte";
	import * as AlertDialog from "$lib/components/ui/alert-dialog";
	import * as Item from "$lib/components/ui/item";
	import { Button } from "$lib/components/ui/button";
	import { Input } from "$lib/components/ui/input";
	import { Label } from "$lib/components/ui/label";
	import ButtonItemContent from "../../(me)/ButtonItemContent.svelte";

	let store = getAccounts();
	let removeTarget = $state<{ profileId: string; email: string } | null>(null);
	let switching = $state<Record<string, boolean>>({});

	// Add account form state
	let showAddForm = $state(false);
	let addEmail = $state("");
	let addPassword = $state("");
	let adding = $state(false);

	onMount(() => {
		store.refresh();
	});

	async function onSwitch(account: { profileId: string; email: string }) {
		if (account.profileId === store.activeAccount?.profileId) return;
		switching[account.profileId] = true;
		try {
			await store.switchAccount(account.profileId);
			toast(`Switched to ${account.email}`);
			goto("/");
		} catch (error) {
			console.error(error);
			toast("Failed to switch account");
		} finally {
			switching[account.profileId] = false;
		}
	}

	async function onRemove() {
		if (!removeTarget) return;
		try {
			await store.removeAccount(removeTarget.profileId);
			toast(`Removed ${removeTarget.email}`);
		} catch (error) {
			console.error(error);
			toast("Failed to remove account");
		} finally {
			removeTarget = null;
		}
	}

	async function onAddAccount(e: SubmitEvent) {
		e.preventDefault();
		if (!addEmail || !addPassword) return;
		adding = true;
		try {
			await store.addAccount(addEmail, addPassword);
			toast(`Added ${addEmail}`);
			addEmail = "";
			addPassword = "";
			showAddForm = false;
		} catch (error) {
			console.error(error);
			toast("Failed to add account");
		} finally {
			adding = false;
		}
	}

	function isSwitching(profileId: string): boolean {
		return switching[profileId] ?? false;
	}
</script>

<div class="flex w-full px-4">
	<main class="pb-(--content-pb) flex flex-col gap-3 w-full max-w-120 m-auto">
		{#if !store.loaded}
			<div class="flex items-center justify-center p-8">
				<SpinnerGap class="size-6 animate-spin text-muted-foreground" />
			</div>
		{:else if store.accounts.length === 0 && !showAddForm}
			<div class="flex flex-col items-center gap-4 p-8 text-center">
				<UserCircleIcon class="size-12 text-muted-foreground/40" />
				<div class="text-sm text-muted-foreground">No saved accounts</div>
				<button
					onclick={() => showAddForm = true}
					class="px-4 py-2 rounded-lg bg-accent text-accent-foreground text-sm font-medium"
				>
					Add Account
				</button>
			</div>
		{:else}
			{#each store.accounts as account (account.profileId)}
				<Item.Root variant="outline">
					{#snippet child({ props })}
						<ButtonItemContent
							{...props}
							variant="outline"
							onclick={() => onSwitch(account)}
						>
							<Item.Media>
								<UserCircleIcon weight="fill" class="size-5" />
							</Item.Media>
							<Item.Content class="min-w-0 flex-1">
								<Item.Title class="truncate min-w-0 w-full inline-block text-left">
									{account.email}
								</Item.Title>
								<Item.Description class="min-w-0 truncate text-xs">
									Profile #{account.profileId}
								</Item.Description>
							</Item.Content>
							<Item.Actions class="flex items-center gap-1">
								{#if isSwitching(account.profileId)}
									<SpinnerGap class="size-4 animate-spin" />
								{:else if account.isActive}
									<CheckCircleIcon weight="fill" class="size-5 text-green-500" />
								{/if}
								{#if !account.isActive}
									<button
										class="p-1 rounded hover:bg-destructive/10"
										onclick={(e) => {
											e.preventDefault();
											e.stopPropagation();
											removeTarget = account;
										}}
									>
										<TrashSimpleIcon class="size-4 text-muted-foreground" />
									</button>
								{/if}
							</Item.Actions>
						</ButtonItemContent>
					{/snippet}
				</Item.Root>
			{/each}

			{#if showAddForm}
				<form
					onsubmit={onAddAccount}
					class="flex flex-col gap-3 p-4 rounded-lg border border-border bg-card"
				>
					<div class="flex items-center justify-between">
						<span class="text-sm font-medium">Add Another Account</span>
						<button
							type="button"
							class="p-1 rounded hover:bg-muted"
							onclick={() => { showAddForm = false; addEmail = ""; addPassword = ""; }}
						>
							<XIcon class="size-4 text-muted-foreground" />
						</button>
					</div>
					<div class="grid gap-1.5">
						<Label for="add-email">Email</Label>
						<Input
							id="add-email"
							type="email"
							placeholder="m@example.com"
							bind:value={addEmail}
							disabled={adding}
						/>
					</div>
					<div class="grid gap-1.5">
						<Label for="add-password">Password</Label>
						<Input
							id="add-password"
							type="password"
							placeholder="••••••••"
							bind:value={addPassword}
							disabled={adding}
						/>
					</div>
					<Button type="submit" disabled={adding || !addEmail || !addPassword}>
						{#if adding}
							<SpinnerGap class="size-4 animate-spin mr-2" />
						{:else}
							<PlusIcon class="size-4 mr-2" />
						{/if}
						Add Account
					</Button>
				</form>
			{:else}
				<div class="pt-4">
					<button
						onclick={() => showAddForm = true}
						class="flex items-center justify-center gap-2 w-full px-4 py-3 rounded-lg border border-border text-sm text-muted-foreground hover:bg-card transition-colors"
					>
						+ Add Another Account
					</button>
				</div>
			{/if}
		{/if}
	</main>
</div>

<AlertDialog.Root open={removeTarget !== null}>
	<AlertDialog.Content>
		<AlertDialog.Header>
			<AlertDialog.Title>Remove account?</AlertDialog.Title>
			<AlertDialog.Description>
				Are you sure you want to remove {removeTarget?.email}? You can sign back in later.
			</AlertDialog.Description>
		</AlertDialog.Header>
		<AlertDialog.Footer>
			<AlertDialog.Cancel onclick={() => (removeTarget = null)} size="lg">Cancel</AlertDialog.Cancel>
			<AlertDialog.Action onclick={() => onRemove()} size="lg">Remove</AlertDialog.Action>
		</AlertDialog.Footer>
	</AlertDialog.Content>
</AlertDialog.Root>
