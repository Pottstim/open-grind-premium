let totalUnread = $state(0);

export function getTotalUnread(): number {
	return totalUnread;
}

export function setTotalUnread(count: number): void {
	totalUnread = count;
}
